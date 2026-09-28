module main (
    input  [7:0] SW,
    input  [1:0] KEY,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX3
);

    reg [7:0] A;

    // Store A
    // KEY0: active-low asynchronous reset
    // KEY1: clock
    always @(posedge KEY[1] or negedge KEY[0]) begin
        if (!KEY[0])
            A <= 8'b00000000;
        else
            A <= SW[7:0];
    end

    // Stored A -> HEX3 and HEX2
    seg7_display display_A_high (
        .bin_number(A[7:4]),
        .seg_display(HEX3)
    );

    seg7_display display_A_low (
        .bin_number(A[3:0]),
        .seg_display(HEX2)
    );

    // Current switch value B -> HEX1 and HEX0
    seg7_display display_B_high (
        .bin_number(SW[7:4]),
        .seg_display(HEX1)
    );

    seg7_display display_B_low (
        .bin_number(SW[3:0]),
        .seg_display(HEX0)
    );

endmodule