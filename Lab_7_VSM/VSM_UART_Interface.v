`default_nettype none

module VSM_UART_Interface (
    input clk,
    input reset,

    input uart_rx,
    output uart_tx,

    output reg [3:0] uart_input,

    input [3:0] vsm_output,
    input vsm_enable_out
);

    // -----------------------------------
    // UART RECEIVER
    // -----------------------------------

    wire [7:0] rx_data;
    wire rx_ready;
    wire rx_idle;
    wire rx_endofpacket;

    async_receiver #(
        .ClkFrequency(50000000),
        .Baud(115200)
    ) UART_RX (
        .clk(clk),
        .RxD(uart_rx),
        .RxD_data_ready(rx_ready),
        .RxD_data(rx_data),
        .RxD_idle(rx_idle),
        .RxD_endofpacket(rx_endofpacket)
    );

    // -----------------------------------
    // ASCII HEX TO 4-BIT DATA
    // -----------------------------------

    initial uart_input = 4'd0;

    always @(posedge clk) begin
        if (reset)
            uart_input <= 4'd0;
        else if (rx_ready) begin
            if (rx_data >= 8'h30 &&
                rx_data <= 8'h39)
                uart_input <= rx_data[3:0];

            else if (rx_data >= 8'h41 &&
                     rx_data <= 8'h46)
                uart_input <= rx_data[3:0] + 4'd9;

            else if (rx_data >= 8'h61 &&
                     rx_data <= 8'h66)
                uart_input <= rx_data[3:0] + 4'd9;
        end
    end

    // -----------------------------------
    // UART TRANSMITTER
    // -----------------------------------

    reg tx_start = 1'b0;
    reg [7:0] tx_data = 8'h30;
    wire tx_busy;

    async_transmitter #(
        .ClkFrequency(50000000),
        .Baud(115200)
    ) UART_TX (
        .clk(clk),
        .TxD_start(tx_start),
        .TxD_data(tx_data),
        .TxD(uart_tx),
        .TxD_busy(tx_busy)
    );

    // -----------------------------------
    // SYNCHRONIZE OUTPUT CONTROL
    // -----------------------------------

    reg out_sync1 = 1'b0;
    reg out_sync2 = 1'b0;
    reg out_previous = 1'b0;

    always @(posedge clk) begin
        if (reset) begin
            out_sync1 <= 1'b0;
            out_sync2 <= 1'b0;
            out_previous <= 1'b0;
        end
        else begin
            out_sync1 <= vsm_enable_out;
            out_sync2 <= out_sync1;
            out_previous <= out_sync2;
        end
    end

    // Falling edge indicates the OUT
    // register load has completed.
    wire out_complete =
        out_previous && !out_sync2;

    // -----------------------------------
    // HEX TO ASCII CONVERSION
    // -----------------------------------

    function [7:0] hex_to_ascii;
        input [3:0] value;
        begin
            if (value < 4'd10)
                hex_to_ascii = 8'h30 + {4'b0, value};
            else
                hex_to_ascii = 8'h41 +
                               {4'b0, (value - 4'd10)};
        end
    endfunction

    // -----------------------------------
    // TRANSMIT CONTROL
    // Send one character for each OUT.
    // -----------------------------------

    localparam TX_IDLE = 2'd0;
    localparam TX_START = 2'd1;
    localparam TX_WAIT = 2'd2;

    reg [1:0] tx_state = TX_IDLE;

    always @(posedge clk) begin
        if (reset) begin
            tx_start <= 1'b0;
            tx_data <= 8'h30;
            tx_state <= TX_IDLE;
        end
        else begin
            tx_start <= 1'b0;

            case (tx_state)

                TX_IDLE: begin
                    if (out_complete && !tx_busy) begin
                        tx_data <= hex_to_ascii(vsm_output);
                        tx_state <= TX_START;
                    end
                end

                TX_START: begin
                    tx_start <= 1'b1;
                    tx_state <= TX_WAIT;
                end

                TX_WAIT: begin
                    if (tx_busy)
                        tx_state <= TX_IDLE;
                end

                default:
                    tx_state <= TX_IDLE;

            endcase
        end
    end

endmodule

`default_nettype wire