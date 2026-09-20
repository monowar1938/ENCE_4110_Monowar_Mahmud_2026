module main (
    input  [9:0] SW,
    output [9:0] LEDR,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX4,
    output [7:0] HEX5 
);


    wire [3:0] A0 = SW[3:0];
    wire [3:0] B0 = SW[7:4];
    wire [3:0] A1 = 4'b0000;
    wire [3:0] B1 = 4'b0000;
    wire       cin;
	 
	 assign cin = SW[9];

    reg [4:0] T0;
    reg [4:0] T1;
    reg [3:0] Z0;
    reg [3:0] Z1;
    reg       c1;
    reg       c2;
    
    reg [3:0] S0;
    reg [3:0] S1;
    wire [3:0] S2;

    always @(*) begin
        T0 = A0 + B0 + cin;

        if (T0 > 5'd9) begin
            Z0 = 4'd10;
            c1 = 1'b1;
        end else begin
            Z0 = 4'd0;
            c1 = 1'b0;
        end

        S0 = T0 - Z0;

        T1 = A1 + B1 + c1;

        if (T1 > 5'd9) begin
            Z1 = 4'd10;
            c2 = 1'b1;
        end else begin
            Z1 = 4'd0;
            c2 = 1'b0;
        end

        S1 = T1 - Z1;
    end

    assign S2 = {3'b000, c2};

    // LED Status Outputs
    assign LEDR[3:0] = S0;
    assign LEDR[7:4] = S1;
    assign LEDR[8]   = c1;
    assign LEDR[9]   = c2;


    Seg7_Decoder DISPLAY_IN_A0 (.m(A0), .out(HEX5));
    Seg7_Decoder DISPLAY_IN_B0 (.m(B0), .out(HEX4));

    Seg7_Decoder DISPLAY_S2    (.m(S2), .out(HEX2));
    Seg7_Decoder DISPLAY_S1    (.m(S1), .out(HEX1));
    Seg7_Decoder DISPLAY_S0    (.m(S0), .out(HEX0));

endmodule