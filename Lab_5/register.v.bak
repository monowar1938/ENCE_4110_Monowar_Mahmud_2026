module register #(
    parameter N = 4
)(
    input              Clock,
    input              Reset,
    input      [N-1:0] D,
    output reg [N-1:0] Q
);

    always @(posedge Clock or negedge Reset) begin
        if (!Reset)
            Q <= {N{1'b0}};
        else
            Q <= D;
    end

endmodule