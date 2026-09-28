// Gated SR Latch

module part1(
    input  Clk,
    input  R,
    input  S,
    output Q
);

    wire R_g, S_g;
    wire Qa, Qb /* synthesis keep */;

    // Gate the R and S inputs with Clk
    assign R_g = R & Clk;
    assign S_g = S & Clk;

    // Cross-coupled NOR gates
    assign Qa = ~(R_g | Qb);
    assign Qb = ~(S_g | Qa);

    // Latch output
    assign Q = Qa;

endmodule