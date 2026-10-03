module part2_part4(
    input        MAX10_CLK1_50,   // Built-in 50 MHz clock
    input  [9:0] SW,
    output [9:0] LEDR,
	 output [7:0] HEX0,
	 output [7:0] HEX1
);
	wire [7:0] count;
	
	wire slow_clk, clear, w_and, w_or;
	
	assign clear = SW[9];
	
	assign w_and = clear & MAX10_CLK1_50;
	
	assign w_or = w_and | slow_clk;
	
	Counter_1Hz clock1(
		.in_clk(MAX10_CLK1_50),
		.clear(clear),
		.slow_clk(slow_clk)
	);
	
	/* Counter_8_bit_part_2 counter1(
		.ena(SW[0]),
		.clk(w_or),
		.clear(clear),
		.count(count)
	); */

   /*Counter_8bit counter1(
        .ena   (SW[0]),
        .clk   (w_or),
        .clear (clear),
        .count (count)
    ); */
	 
	 /* Counter_part_3 #(
		 .N(8)
	 )  counter1 (
		 .ena   (SW[0]),
		 .clk   (w_or),
		 .clear (clear),
		 .count (count)
	 );
	 
	 seg7_display(
		.bin_number(count[3:0]), 
		.seg_display(HEX0)
	);
	
	seg7_display(
		.bin_number(count[7:4]), 
		.seg_display(HEX1)
	); */

endmodule