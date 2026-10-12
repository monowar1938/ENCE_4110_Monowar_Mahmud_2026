module registered_multiplier #(
    parameter N = 3
)(
    input                Clock,
    input                Reset,
    input  [N-1:0]       A_in,
    input  [N-1:0]       B_in,
    output [2*N-1:0]     P_out
);

    wire [N-1:0]   A;
    wire [N-1:0]   B;
    wire [2*N-1:0] P;

    register #(
        .N(N)
    ) A_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(A_in),
        .Q(A)
    );

    register #(
        .N(N)
    ) B_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(B_in),
        .Q(B)
    );

    // Your existing multiplier
    multiplier #(
        .N(N)
    ) mult1 (
        .A(A),
        .B(B),
        .P(P)
    );

    register #(
        .N(2*N)
    ) P_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(P),
        .Q(P_out)
    );

endmodule