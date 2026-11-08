
`default_nettype none

module Arithmetic_Unit #
(
    parameter N = 4
)
(
    input EnableALU,
    input AddSub,
    input [N-1:0] A,
    input [N-1:0] B,
    output wire Carry,
    output wire [N-1:0] IB_ALU
);

    wire [N:0] sum;

    // AddSub = 0: Addition (A + B)
    // AddSub = 1: Subtraction (B - A)

    assign sum = AddSub ?
                 ({1'b0, B} - {1'b0, A}) :
                 ({1'b0, A} + {1'b0, B});

    assign Carry = sum[N];

    assign IB_ALU = EnableALU ?
                    sum[N-1:0] : {N{1'bz}};

endmodule

`default_nettype wire
