
`default_nettype none

module main (
    input wire MAX10_CLK1_50,
    input wire [9:0] SW,
    input wire [1:0] KEY,
    output wire [9:0] LEDR,
    inout wire [35:0] GPIO,

    output wire [7:0] HEX0,
    output wire [7:0] HEX1,
    output wire [7:0] HEX2,
    output wire [7:0] HEX3,
    output wire [7:0] HEX4
);

    wire w_clk = MAX10_CLK1_50;
    wire w_reset = SW[9];

    wire RxD_data_ready;
    wire [7:0] RxD_data;
    reg [7:0] GPout;

    wire counter_in;
    wire counter_out;
    wire blink;
    wire hello_detected;

    wire show_hello;

    // UART receiver
    async_receiver RX (
        .clk(w_clk),
        .RxD(GPIO[35]),
        .RxD_data_ready(RxD_data_ready),
        .RxD_data(RxD_data)
    );

    // Store latest UART character
    always @(posedge w_clk or posedge w_reset) begin
        if (w_reset)
            GPout <= 8'h20;
        else if (RxD_data_ready)
            GPout <= RxD_data;
    end

    // UART transmitter (echo)
    async_transmitter TX (
        .clk(w_clk),
        .TxD(GPIO[33]),
        .TxD_start(RxD_data_ready),
        .TxD_data(RxD_data)
    );

    // HELLO sequence detector
    word_detector Detector00 (
        .clk(w_clk),
        .reset(w_reset),
        .ascii_in(RxD_data),
        .data_valid(RxD_data_ready),
        .counter_done(counter_out),
        .counter_en(counter_in),
        .hello_detected(hello_detected)
    );

    // Existing counter: unchanged
    blink_counter Counter00 (
        .clk(w_clk),
        .reset(w_reset),
        .counter_en(counter_in),
        .counter_done(counter_out),
        .blink(blink)
    );

    // Enable HELLO display during ON interval
    assign show_hello = hello_detected && blink;

    // Normal display or HELLO display
    wire [7:0] char0;
    wire [7:0] char1;
    wire [7:0] char2;
    wire [7:0] char3;
    wire [7:0] char4;

    assign char0 = hello_detected ?
                   (blink ? "o" : " ") : GPout;

    assign char1 = show_hello ? "l" : " ";
    assign char2 = show_hello ? "l" : " ";
    assign char3 = show_hello ? "e" : " ";
    assign char4 = show_hello ? "h" : " ";

    // Seven-segment decoders
    char2seg Display0 (.char(char0), .HEX0(HEX0));
    char2seg Display1 (.char(char1), .HEX0(HEX1));
    char2seg Display2 (.char(char2), .HEX0(HEX2));
    char2seg Display3 (.char(char3), .HEX0(HEX3));
    char2seg Display4 (.char(char4), .HEX0(HEX4));

    // LEDs show latest UART ASCII value
    assign LEDR[7:0] = GPout;
    assign LEDR[8] = hello_detected;
    assign LEDR[9] = blink && hello_detected;

endmodule

`default_nettype wire
