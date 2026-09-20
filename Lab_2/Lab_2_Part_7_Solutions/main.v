module main (
    input  [9:0] SW,
	 output  [9:0] LEDR,
    output [7:0] HEX0,
    output [7:0] HEX1
);

    // BCD digits
    wire [3:0] tens;
    wire [3:0] ones;

    // 6-bit Binary to BCD Converter
    BCD_Converter BCD0 (
        .v5(SW[5]),
        .v4(SW[4]),
        .v3(SW[3]),
        .v2(SW[2]),
        .v1(SW[1]),
        .v0(SW[0]),

        .d13(tens[3]),
        .d12(tens[2]),
        .d11(tens[1]),
        .d10(tens[0]),

        .d03(ones[3]),
        .d02(ones[2]),
        .d01(ones[1]),
        .d00(ones[0])
    );

    // Tens digit -> HEX1
    Seg7_Decoder D1 (
        .m(tens),
        .out(HEX1)
    );

    // Ones digit -> HEX0
    Seg7_Decoder D0 (
        .m(ones),
        .out(HEX0)
    );

endmodule