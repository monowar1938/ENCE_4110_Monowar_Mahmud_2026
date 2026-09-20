module main(
	// pinout assignment
	input		[9:0] SW,
	output	[9:0] LEDR
);
	wire c0, c1, c2;
	
	Full_Adder FA0(
		.a(SW[0]), .b(SW[4]), .cin(1'b0),
		.s(LEDR[0]), .cout(c0)
	);
	
	Full_Adder FA1(
		.a(SW[1]), .b(SW[5]), .cin(c0),
		.s(LEDR[1]), .cout(c1)
	);
	
	Full_Adder FA2(
		.a(SW[2]), .b(SW[6]), .cin(c1),
		.s(LEDR[2]), .cout(c2)
	);
	
	Full_Adder FA3(
		.a(SW[3]), .b(SW[7]), .cin(c2),
		.s(LEDR[3]), .cout(LEDR[9])
	);
	
endmodule