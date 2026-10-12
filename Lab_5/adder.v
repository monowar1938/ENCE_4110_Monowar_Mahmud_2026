module adder #(
    parameter N = 4
)(
    input  signed [N-1:0] A,
    input  signed [N-1:0] B,
    input                 Cin,

    output signed [N-1:0] Sum,
    output                Overflow,
    output                Cout
);

    assign {Cout, Sum} = A + B + Cin;

    assign Overflow = ~(A[N-1] ^ B[N-1]) &
                       (A[N-1] ^ Sum[N-1]);

endmodule