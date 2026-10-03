module TFlipFlop(
	input T,
	input clk,
	input clear,
	output Qt
);

	wire d;
	reg q;
	
	//Edge Trigger Flip Flop
	always @(posedge clk) begin
		if (clear) q <= 0;
		else begin
			q <= d;
		end
	end
	
	assign d = (T & ~q) | (~T & q);
	
	assign Qt = q;

endmodule