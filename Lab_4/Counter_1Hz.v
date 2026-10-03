module Counter_1Hz(
	input in_clk,
	input clear,
	output reg slow_clk
);

	 reg [25:0] clk_count;
	 
    // Clock divider: 50 MHz --> 1 Hz
    always @(posedge in_clk, posedge clear) begin
        if (clear) begin
				slow_clk <= 0;
				clk_count <= 26'd0;
		  end
		  else begin
				if (clk_count == 26'd49_999_999) begin
					clk_count <= 26'd0;
					slow_clk <= 1;
				end
				else begin
					clk_count <= clk_count + 1;
					slow_clk <= 0;
				end
		  end
    end
	 
endmodule