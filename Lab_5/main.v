module main (
    input         MAX10_CLK1_50,
    input  [9:0]  SW,
    input  [1:0]  KEY,

    output [9:0]  LEDR,
    output [6:0]  HEX0,
    output [6:0]  HEX1,
    output [6:0]  HEX2,
    output [6:0]  HEX3,
    output [6:0]  HEX4,
    output [6:0]  HEX5
);

    wire [2:0] A;
    wire [2:0] B;
    wire [5:0] P;

    wire [3:0] tens;
    wire [3:0] ones;

    assign A = SW[5:3];
    assign B = SW[2:0];

	 registered_tree_multiplier mult1 (
		 .Clock(MAX10_CLK1_50),
		 .Reset(KEY[0]),
		 .A_in(A),
		 .B_in(B),
		 .P_out(P)
	 );

    // Display input switch values in binary.
    assign LEDR[5:3] = A;
    assign LEDR[2:0] = B;
    assign LEDR[9:6] = 4'b0000;

    // Convert product to decimal digits.
    assign tens = P / 6'd10;
    assign ones = P % 6'd10;

    seven_segment_decoder display_tens (
        .digit(tens),
        .HEX(HEX1)
    );

    seven_segment_decoder display_ones (
        .digit(ones),
        .HEX(HEX0)
    );

    // Blank unused displays.
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1111111;

endmodule