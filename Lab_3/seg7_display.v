module seg7_display(
	input 	[3:0]	bin_number, 
	output 	reg [7:0] seg_display
);
	// assign seg_display = 8'b01000000;
	always @(*) begin
    case (bin_number)
        4'd0  : seg_display = 8'b11000000; // 0
        4'd1  : seg_display = 8'b11111001; // 1
        4'd2  : seg_display = 8'b10100100; // 2
        4'd3  : seg_display = 8'b10110000; // 3
        4'd4  : seg_display = 8'b10011001; // 4
        4'd5  : seg_display = 8'b10010010; // 5
        4'd6  : seg_display = 8'b10000010; // 6
        4'd7  : seg_display = 8'b11111000; // 7
        4'd8  : seg_display = 8'b10000000; // 8
        4'd9  : seg_display = 8'b10010000; // 9

        4'd10 : seg_display = 8'b10001000; // A
        4'd11 : seg_display = 8'b10000011; // b
        4'd12 : seg_display = 8'b11000110; // C
        4'd13 : seg_display = 8'b10100001; // d
        4'd14 : seg_display = 8'b10000110; // E
        4'd15 : seg_display = 8'b10001110; // F

        default: seg_display = 8'b11111111;
		endcase
	end

endmodule