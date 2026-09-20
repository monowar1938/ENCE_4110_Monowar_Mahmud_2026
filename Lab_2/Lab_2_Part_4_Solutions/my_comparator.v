module my_comparator(
    input  [3:0] V, 
	 input	k,
    output 	z
);

    // V > 9
    assign z = k | (V[3] & V[2]) | (V[3] & V[1]);

endmodule