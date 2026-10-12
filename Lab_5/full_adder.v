module full_adder (
    input  A,
    input  B,
    input  Cin,
    output Sum,
    output Cout
);

    assign {Cout, Sum} =
        {1'b0, A} + {1'b0, B} + {1'b0, Cin};

endmodule