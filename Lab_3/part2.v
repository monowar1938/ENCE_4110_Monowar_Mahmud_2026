// Gated D Latch
module part2(D, Clk, Q);

    input D, Clk;
    output Q;

    wire R, S_g, R_g, Qa, Qb /* synthesis keep */;

    // Generate S and R from D
    assign R = ~D;

    // Gated active-low S and R signals
    assign S_g = ~(D & Clk);
    assign R_g = ~(R & Clk);

    // Cross-coupled NAND latch
    assign Qa = ~(S_g & Qb);
    assign Qb = ~(R_g & Qa);

    // Output
    assign Q = Qa;

endmodule