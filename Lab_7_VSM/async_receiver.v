
`default_nettype none

module async_receiver #(
    parameter ClkFrequency = 50000000,
    parameter Baud = 115200,
    parameter Oversampling = 8
)(
    input clk,
    input RxD,

    output reg RxD_data_ready = 1'b0,
    output reg [7:0] RxD_data = 8'd0,

    output wire RxD_idle,
    output reg RxD_endofpacket = 1'b0
);

    // ----------------------------------------
    // UART TIMING
    // ----------------------------------------

    localparam integer CLKS_PER_BIT =
        ClkFrequency / Baud;

    localparam integer HALF_BIT =
        CLKS_PER_BIT / 2;

    localparam integer COUNT_WIDTH =
        $clog2(CLKS_PER_BIT + 1);

    // ----------------------------------------
    // UART STATES
    // ----------------------------------------

    localparam [1:0]
        IDLE  = 2'd0,
        START = 2'd1,
        DATA  = 2'd2,
        STOP  = 2'd3;

    reg [1:0] state = IDLE;

    // ----------------------------------------
    // SYNCHRONIZE RX INPUT
    // ----------------------------------------

    reg rx_sync1 = 1'b1;
    reg rx_sync2 = 1'b1;

    always @(posedge clk) begin
        rx_sync1 <= RxD;
        rx_sync2 <= rx_sync1;
    end

    // ----------------------------------------
    // INTERNAL REGISTERS
    // ----------------------------------------

    reg [COUNT_WIDTH-1:0] clk_count = 0;

    reg [2:0] bit_index = 0;

    reg [7:0] rx_shift = 0;

    // ----------------------------------------
    // IDLE / END OF PACKET DETECTION
    // ----------------------------------------

    localparam integer GAP_BITS = 4;

    localparam integer GAP_CLKS =
        CLKS_PER_BIT * GAP_BITS;

    localparam integer GAP_WIDTH =
        $clog2(GAP_CLKS + 1);

    reg [GAP_WIDTH-1:0] gap_count = 0;
    reg idle_flag = 1'b0;

    assign RxD_idle = idle_flag;

    always @(posedge clk) begin

        RxD_endofpacket <= 1'b0;

        if (state != IDLE || rx_sync2 == 1'b0) begin
            gap_count <= 0;
            idle_flag <= 1'b0;
        end

        else if (gap_count < GAP_CLKS) begin
            gap_count <= gap_count + 1'b1;

            if (gap_count == GAP_CLKS - 1) begin
                idle_flag <= 1'b1;
                RxD_endofpacket <= 1'b1;
            end
        end

    end

    // ----------------------------------------
    // UART RECEIVER STATE MACHINE
    // ----------------------------------------

    always @(posedge clk) begin

        // Default: data-ready is a one-clock pulse
        RxD_data_ready <= 1'b0;

        case (state)

            // -------------------------------
            // WAIT FOR START BIT
            // -------------------------------

            IDLE: begin

                clk_count <= 0;
                bit_index <= 0;

                if (rx_sync2 == 1'b0)
                    state <= START;

            end

            // -------------------------------
            // VERIFY START BIT
            // -------------------------------

            START: begin

                if (clk_count == HALF_BIT - 1) begin

                    clk_count <= 0;

                    if (rx_sync2 == 1'b0)
                        state <= DATA;
                    else
                        state <= IDLE;

                end

                else begin
                    clk_count <= clk_count + 1'b1;
                end

            end

            // -------------------------------
            // RECEIVE 8 DATA BITS
            // -------------------------------

            DATA: begin

                if (clk_count == CLKS_PER_BIT - 1) begin

                    clk_count <= 0;

                    rx_shift[bit_index] <= rx_sync2;

                    if (bit_index == 3'd7) begin
                        bit_index <= 0;
                        state <= STOP;
                    end

                    else begin
                        bit_index <= bit_index + 1'b1;
                    end

                end

                else begin
                    clk_count <= clk_count + 1'b1;
                end

            end

            // -------------------------------
            // VERIFY STOP BIT
            // -------------------------------

            STOP: begin

                if (clk_count == CLKS_PER_BIT - 1) begin

                    clk_count <= 0;
                    state <= IDLE;

                    if (rx_sync2 == 1'b1) begin

                        RxD_data <= rx_shift;

                        RxD_data_ready <= 1'b1;

                    end

                end

                else begin
                    clk_count <= clk_count + 1'b1;
                end

            end

            default: begin

                state <= IDLE;
                clk_count <= 0;

            end

        endcase

    end

endmodule

`default_nettype wire
