module main(
    input        MAX10_CLK1_50,
    input  [9:0] SW,

    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3,
    output [7:0] HEX4,
    output [7:0] HEX5
);

    wire clear;
    wire slow_clk;
    wire [3:0] count;

    wire [3:0] char0;
    wire [3:0] char1;
    wire [3:0] char2;
    wire [3:0] char3;
    wire [3:0] char4;
    wire [3:0] char5;

    assign clear = SW[9];


    // ---------------------------------
    // 1 Hz timing pulse
    // ---------------------------------
    Counter_1Hz clock1 (
        .in_clk   (MAX10_CLK1_50),
        .clear    (clear),
        .slow_clk (slow_clk)
    );


    // ---------------------------------
    // HELLO state counter
    // 0,1,2,...,9,4,5,...,9,4,...
    // ---------------------------------
    HELLO_Counter counter1 (
        .clk    (MAX10_CLK1_50),
        .enable (slow_clk & SW[0]),
        .clear  (clear),
        .count  (count)
    );


    // ---------------------------------
    // Character encoder
    // ---------------------------------
    character_encoder encoder1 (
        .state (count),

        .char5 (char5),
        .char4 (char4),
        .char3 (char3),
        .char2 (char2),
        .char1 (char1),
        .char0 (char0)
    );


    // ---------------------------------
    // Seven-segment decoders
    // ---------------------------------
    seven_segment_display display5 (
        .character   (char5),
        .seg_display (HEX5)
    );

    seven_segment_display display4 (
        .character   (char4),
        .seg_display (HEX4)
    );

    seven_segment_display display3 (
        .character   (char3),
        .seg_display (HEX3)
    );

    seven_segment_display display2 (
        .character   (char2),
        .seg_display (HEX2)
    );

    seven_segment_display display1 (
        .character   (char1),
        .seg_display (HEX1)
    );

    seven_segment_display display0 (
        .character   (char0),
        .seg_display (HEX0)
    );

endmodule