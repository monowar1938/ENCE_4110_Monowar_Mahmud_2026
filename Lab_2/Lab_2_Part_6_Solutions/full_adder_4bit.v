module full_adder_4bit(
    input  [3:0] A,
    input  [3:0] B,
    input  cin,
    output [3:0] S,
    output cout
);

    wire c0, c1, c2;

    Full_Adder FA0 (
        .a(A[0]), .b(B[0]), .cin(cin),
        .s(S[0]), .cout(c0)
    );

    Full_Adder FA1 (
        .a(A[1]), .b(B[1]), .cin(c0),
        .s(S[1]), .cout(c1)
    );

    Full_Adder FA2 (
        .a(A[2]), .b(B[2]), .cin(c1),
        .s(S[2]), .cout(c2)
    );

    Full_Adder FA3 (
        .a(A[3]), .b(B[3]), .cin(c2),
        .s(S[3]), .cout(cout)
    );

endmodule