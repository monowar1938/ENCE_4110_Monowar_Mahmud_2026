module mux_3bit_6to1(
    input [2:0] S,
    input [2:0] A,
    input [2:0] B,
    input [2:0] C,
    input [2:0] D,
    input [2:0] E,
    input [2:0] F,
    output [2:0] M
);

    assign M = (S == 3'b000) ? A :
               (S == 3'b001) ? B :
               (S == 3'b010) ? C :
               (S == 3'b011) ? D :
               (S == 3'b100) ? E :
               (S == 3'b101) ? F :
                               3'b100;   // blank for 110/111

endmodule