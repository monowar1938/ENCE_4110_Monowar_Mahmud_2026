module BCD_Adder (
    input  [3:0] A,
    input  [3:0] B,
    input  cin,
    output [3:0] Sum,
    output cout
);

    wire [3:0] raw_sum;
    wire       k;
    wire       comp_z;
    wire [3:0] correction_vector;
    wire       dummy_cout;

    full_adder_4bit FA_STAGE1 (
        .A(A[3:0]),
        .B(B[3:0]),
        .cin(cin),
        .S(raw_sum),
        .cout(k)
    );

    my_comparator COMP_INST (
        .V(raw_sum),
        .k(k),
        .z(comp_z)
    );

    assign cout = comp_z;

    mux_2to1_4bit MUX_INST (
        .s(comp_z),
        .x(4'b0000),          
        .y(4'b0110),          
        .m(correction_vector)
    );

    full_adder_4bit FA_STAGE2 (
        .A(raw_sum),
        .B(correction_vector),
        .cin(1'b0),
        .S(Sum),
        .cout(dummy_cout)
    );   

endmodule