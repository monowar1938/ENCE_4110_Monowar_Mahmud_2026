module part_iv(
    input  wire D,
    input  wire Clock,
    output reg  Qa,
    output reg  Qb,
    output reg  Qc
);

    // Gated D latch
    // Transparent when Clock = 1
    always @ (D or Clock)
    begin
        if (Clock)
            Qa = D;
    end

    // Positive-edge-triggered D flip-flop
    always @ (posedge Clock)
    begin
        Qb <= D;
    end

    // Negative-edge-triggered D flip-flop
    always @ (negedge Clock)
    begin
        Qc <= D;
    end

endmodule