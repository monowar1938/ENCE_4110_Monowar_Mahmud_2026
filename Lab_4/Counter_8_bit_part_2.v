module Counter_8_bit_part_2(
	input ena,
	input clk,
	input clear,
	output reg [7:0] count
);

	always @(posedge clk) begin
		if(clear) count <= 0;
		else begin
			if (ena) begin
				count <= count + 1;
				if (count == 8'd255) count <= 0;
				end
			end
	end

endmodule