module multiplier #(
    parameter N = 4
)(
    input  [N-1:0]   A,
    input  [N-1:0]   B,
    output [2*N-1:0] P
);

    wire [N-1:0] partial [0:N-1];
    wire [N:0]   stage   [0:N-1];
    wire [N:0]   carry   [0:N-2];

    genvar r, c;

    generate
        // N partial-product rows
        for (r = 0; r < N; r = r + 1) begin : partial_rows
            assign partial[r] = A & {N{B[r]}};
        end
    endgenerate

    assign stage[0] = {1'b0, partial[0]};
    assign P[0] = stage[0][0];

    generate
        // N-1 rows of N full adders
        for (r = 0; r < N-1; r = r + 1) begin : adder_rows

            assign carry[r][0] = 1'b0;

            for (c = 0; c < N; c = c + 1) begin : adder_bits

                full_adder fa (
                    .A(stage[r][c+1]),
                    .B(partial[r+1][c]),
                    .Cin(carry[r][c]),
                    .Sum(stage[r+1][c]),
                    .Cout(carry[r][c+1])
                );

            end

            assign stage[r+1][N] = carry[r][N];
            assign P[r+1] = stage[r+1][0];

        end
    endgenerate

    assign P[2*N-1:N] = stage[N-1][N:1];

endmodule