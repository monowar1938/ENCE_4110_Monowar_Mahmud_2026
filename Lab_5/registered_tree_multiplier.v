module registered_tree_multiplier (
    input        Clock,
    input        Reset,
    input  [2:0] A_in,
    input  [2:0] B_in,
    output [5:0] P_out
);

    wire [2:0] A;
    wire [2:0] B;
    wire [5:0] P;

    register #(
        .N(3)
    ) A_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(A_in),
        .Q(A)
    );

    register #(
        .N(3)
    ) B_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(B_in),
        .Q(B)
    );

    tree_multiplier3 mult1 (
        .A(A),
        .B(B),
        .P(P)
    );

    register #(
        .N(6)
    ) P_reg (
        .Clock(Clock),
        .Reset(Reset),
        .D(P),
        .Q(P_out)
    );

endmodule