module main(
	// pinout assignment
	input		[9:0] SW,
	output	[9:0] LEDR,
	
	input 	MAX10_CLK1_50,
	output 	[6:0] HEX0,
	output 	[6:0] HEX1,
	output 	[6:0] HEX2,
	output 	[6:0] HEX3,
	output 	[6:0] HEX4,
	output 	[6:0] HEX5
);
	
	//PART I
	// assign LEDR = SW;
	
	// PART II
	/* mux_2_1 MUX0(
		.s(SW[0]),
		.x(SW[1]),
		.y(SW[2]),
		.m(LEDR[0])
	); */

	//PART III
	
	/* mux_5to1_3bit MUX0(
		.S(SW[2:0]),
		.U(SW[5:3]),
		.V(SW[8:6]),
		.W(3'b101),
		.X(3'b010),
		.Y(3'b111),
		.M(LEDR[2:0])
	); */
	/* mux_2_1_8_bit MUX0(
		.s(SW[0]),
		.x(SW[8:1]),
		.y(8'd170),
		.m(LEDR[7:0])
	); */
	
	// PART IV
	/* seven_seg Display1(
	.s(SW[2:0]), 
	.disp(HEX0[6:0])
	); */
	
	// PART V
	// HEX4
	/* mux_5to1_3bit MUX4 (
		.S(SW[2:0]),
		.U(U),
		.V(V),
		.W(W),
		.X(X),
		.Y(Y),
		.M(M4)
	);

	seven_seg DISP4 (
		.s(M4),
		.disp(HEX4[6:0])
	);


	// HEX3
	mux_5to1_3bit MUX3 (
		.S(SW[2:0]),
		.U(V),
		.V(W),
		.W(X),
		.X(Y),
		.Y(U),
		.M(M3)
	);

	seven_seg DISP3 (
		.s(M3),
		.disp(HEX3[6:0])
	);


	// HEX2
	mux_5to1_3bit MUX2 (
		.S(SW[2:0]),
		.U(W),
		.V(X),
		.W(Y),
		.X(U),
		.Y(V),
		.M(M2)
	);

	seven_seg DISP2 (
		.s(M2),
		.disp(HEX2[6:0])
	);


	// HEX1
	mux_5to1_3bit MUX1 (
		.S(SW[2:0]),
		.U(X),
		.V(Y),
		.W(U),
		.X(V),
		.Y(W),
		.M(M1)
	);

	seven_seg DISP1 (
		.s(M1),
		.disp(HEX1[6:0])
	);


	// HEX0
	mux_5to1_3bit MUX0 (
    .S(SW[2:0]),
		.U(Y),
		.V(U),
		.W(V),
		.X(W),
		.Y(X),
		.M(M0)
	);

	seven_seg DISP0 (
		.s(M0),
		.disp(HEX0[6:0])
	); */
	
	//PART VI
	
	/* wire [2:0] U;
	wire [2:0] V;
	wire [2:0] W;
	wire [2:0] X;
	wire [2:0] Y;
	wire [2:0] BLANK;

	assign U     = 3'b000;   // H
	assign V     = 3'b001;   // E
	assign W     = 3'b010;   // L
	assign X     = 3'b010;   // L
	assign Y     = 3'b011;   // O
	assign BLANK = 3'b100;
	
	wire [2:0] M0;
   wire [2:0] M1;
   wire [2:0] M2;
   wire [2:0] M3;
   wire [2:0] M4;
	wire [2:0] M5;
	
	// HEX5: U V W X Y B
	mux_3bit_6to1 MUX5 (
		SW[2:0],
		U,
		V,
		W,
		X,
		Y,
		BLANK,
		M5
	);

	seven_seg Disp_5 (
		.s(M5),
		.disp(HEX5[6:0])
	);


	// HEX4: V W X Y B U
	mux_3bit_6to1 MUX4 (
		SW[2:0],
		V,
		W,
		X,
		Y,
		BLANK,
		U,
		M4
	);

	seven_seg Disp_4 (
		.s(M4),
		.disp(HEX4[6:0])
	);


	// HEX3: W X Y B U V
	mux_3bit_6to1 MUX3 (
		SW[2:0],
		W,
		X,
		Y,
		BLANK,
		U,
		V,
		M3
	);

	seven_seg Disp_3 (
		.s(M3),
		.disp(HEX3[6:0])
	);


	// HEX2: X Y B U V W
	mux_3bit_6to1 MUX2 (
		SW[2:0],
		X,
		Y,
		BLANK,
		U,
		V,
		W,
		M2
	);

	seven_seg Disp_2 (
		.s(M2),
		.disp(HEX2[6:0])
	);


	// HEX1: Y B U V W X
	mux_3bit_6to1 MUX1 (
		SW[2:0],
		Y,
		BLANK,
		U,
		V,
		W,
		X,
		M1
	);

	seven_seg Disp_1 (
		.s(M1),
		.disp(HEX1[6:0])
	);


	// HEX0: B U V W X Y
	mux_3bit_6to1 MUX0 (
		SW[2:0],
		BLANK,
		U,
		V,
		W,
		X,
		Y,
		M0
	);

	seven_seg Disp_0 (
		.s(M0),
		.disp(HEX0[6:0])
	); */
	
	part6_test (
		MAX10_CLK1_50,
		SW,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5
	);
	
endmodule