module seven_seg (
	input 	[2:0]	s, 
	output	[6:0] disp
	);

    assign disp[0] = s[2] | ~s[0];
    assign disp[1] = s[2] | (s[1] ^ s[0]);
    assign disp[2] = s[2] | (s[1] ^ s[0]);
    assign disp[3] = s[2] | (~s[1] & ~s[0]);
    assign disp[4] = s[2];
    assign disp[5] = s[2];
    assign disp[6] = s[2] | s[1];

endmodule