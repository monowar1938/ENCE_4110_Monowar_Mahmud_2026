
`default_nettype none

module ProgramCounter #
(
	parameter N = 4
)
(
	input MainClock,
	input EnableCount,
	input ClearCounter,
	output reg [N-1:0] Counter
);

	always @(posedge MainClock)
    begin
        if (ClearCounter)
        begin
            Counter <= {N{1'b0}};
        end
        else if (EnableCount)
        begin
            Counter <= Counter + 1'b1;
        end
    end

endmodule

`default_nettype wire
