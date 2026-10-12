module add_sub_accumulator #(
    parameter N = 4
)(
    input                 Clock,
    input                 Reset,
    input signed [N-1:0]  A,
    input                 add_sub,
    output signed [N-1:0] S,
    output                Overflow
);

    wire signed [N-1:0] A_modified;

    assign A_modified = add_sub ? -A : A;

    accumulator #(
        .N(N)
    ) accumulator_inst (
        .A_in(A_modified),
        .Clock(Clock),
        .Reset(Reset),
        .S_out(S),
        .Overflow_out(Overflow)
    );

endmodule