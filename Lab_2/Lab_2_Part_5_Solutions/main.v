module main (
    input  [9:0] SW,
	 output [9:0] LEDR,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
	 output [7:0] HEX4,
	 output [7:0] HEX5
);

    wire [3:0] w0;
    wire [3:0] w1;
    wire [3:0] w2;
    wire       c1;
    wire       c2;

    // Stage 1: Units BCD Adder
    BCD_Adder Adder_1 (
        .A(SW[3:0]),
        .B(SW[7:4]),
        .cin(1'b0),
        .Sum(w0),
        .cout(c1)
    );
    
    // Stage 2: Tens BCD Adder
    BCD_Adder Adder_2 (
        .A(4'b0000),
        .B(4'b0000),
        .cin(c1),
        .Sum(w1),
        .cout(c2)
    );
  
    assign w2 = {3'b000, c2};
	 assign LEDR[9] = c2;
	 
	 
	 //Inputs
	 Seg7_Decoder DISPLAY_IN2 (.m(SW[3:0]), .out(HEX4));
    Seg7_Decoder DISPLAY_IN1 (.m(SW[7:4]), .out(HEX5));

    // Seg7 Decoders (Outputs mapped to active-low 7-bit displays)
    Seg7_Decoder DISPLAY_S2 (.m(w2), .out(HEX2));
    Seg7_Decoder DISPLAY_S1 (.m(w1), .out(HEX1));
    Seg7_Decoder DISPLAY_S0 (.m(w0), .out(HEX0));

endmodule