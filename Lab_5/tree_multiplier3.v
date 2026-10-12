module tree_multiplier3 (
    input  [2:0] A,
    input  [2:0] B,
    output [5:0] P
);

    wire [5:0] row0;
    wire [5:0] row1;
    wire [5:0] row2;
    wire [5:0] sum01;

    // Extend to 6 bits before shifting.
    assign row0 = {3'b000, (A & {3{B[0]}})};
    assign row1 = {3'b000, (A & {3{B[1]}})} << 1;
    assign row2 = {3'b000, (A & {3{B[2]}})} << 2;

    // Two levels of addition
    assign sum01 = row0 + row1;
    assign P     = sum01 + row2;

endmodule