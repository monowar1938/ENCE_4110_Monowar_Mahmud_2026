module accumulator #(
    parameter N = 4
)(
    input  signed [N-1:0] A_in,
    input                 Clock,
    input                 Reset,

    output signed [N-1:0] S_out,
    output                Overflow_out
);

    wire signed [N-1:0] A;
    wire signed [N-1:0] S;
    wire signed [N-1:0] Sum;

    wire Overflow;
    wire Cout;


    // A Register
    register #(
        .N(N)
    ) A_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(A_in),
        .Q(A)
    );


    // Adder
    adder #(
        .N(N)
    ) add1 (
        .A(A),
        .B(S),
        .Cin(1'b0),
        .Sum(Sum),
        .Overflow(Overflow),
        .Cout(Cout)
    );


    // S Register
    register #(
        .N(N)
    ) S_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(Sum),
        .Q(S)
    );


    // Overflow Register
    register #(
        .N(1)
    ) Overflow_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(Overflow),
        .Q(Overflow_out)
    );


    // Accumulator output
    assign S_out = S;

endmodule