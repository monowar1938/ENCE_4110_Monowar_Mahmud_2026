module main (
    input  [9:0] SW,       
    output [9:0] LEDR
);
	
	BCD_Adder Adder1(
		.A(SW[3:0]),
		.B(SW[7:4]), 
		.cin(SW[9]),
		.Sum(LEDR[3:0]), 
		.cout(LEDR[9])
	);


endmodule