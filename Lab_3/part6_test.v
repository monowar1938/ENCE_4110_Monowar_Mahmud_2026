module part6_test (
    input MAX10_CLK1_50,
    input [9:0] SW,
    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5
);

    // Character codes
    wire [2:0] U, V, W, X, Y, BLANK;

    assign U     = 3'b000;   // H
    assign V     = 3'b001;   // E
    assign W     = 3'b010;   // L
    assign X     = 3'b010;   // L
    assign Y     = 3'b011;   // O
    assign BLANK = 3'b100;

    // Clock divider
    reg [25:0] clock_count;
    reg slow_tick;

    always @(posedge MAX10_CLK1_50)
    begin
        if (SW[9])
        begin
            clock_count <= 26'd0;
            slow_tick   <= 1'b0;
        end
        else
        begin
            if (clock_count == 26'd49_999_999)
            begin
                clock_count <= 26'd0;
                slow_tick   <= 1'b1;
            end
            else
            begin
                clock_count <= clock_count + 1'b1;
                slow_tick   <= 1'b0;
            end
        end
    end

    // Rotation counter
    reg [2:0] rotation_count;

    always @(posedge MAX10_CLK1_50)
    begin
        if (SW[9])
            rotation_count <= 3'b000;

        else if (slow_tick)
        begin
            if (rotation_count == 3'b101)
                rotation_count <= 3'b000;
            else
                rotation_count <= rotation_count + 1'b1;
        end
    end

    // MUX outputs
    wire [2:0] M0, M1, M2, M3, M4, M5;

    // HEX5
    mux_3bit_6to1 MUX5 (
        rotation_count,
        U, V, W, X, Y, BLANK,
        M5
    );

    seven_seg Disp_5 (
        .s(M5),
        .disp(HEX5)
    );

    // HEX4
    mux_3bit_6to1 MUX4 (
        rotation_count,
        V, W, X, Y, BLANK, U,
        M4
    );

    seven_seg Disp_4 (
        .s(M4),
        .disp(HEX4)
    );

    // HEX3
    mux_3bit_6to1 MUX3 (
        rotation_count,
        W, X, Y, BLANK, U, V,
        M3
    );

    seven_seg Disp_3 (
        .s(M3),
        .disp(HEX3)
    );

    // HEX2
    mux_3bit_6to1 MUX2 (
        rotation_count,
        X, Y, BLANK, U, V, W,
        M2
    );

    seven_seg Disp_2 (
        .s(M2),
        .disp(HEX2)
    );

    // HEX1
    mux_3bit_6to1 MUX1 (
        rotation_count,
        Y, BLANK, U, V, W, X,
        M1
    );

    seven_seg Disp_1 (
        .s(M1),
        .disp(HEX1)
    );

    // HEX0
    mux_3bit_6to1 MUX0 (
        rotation_count,
        BLANK, U, V, W, X, Y,
        M0
    );

    seven_seg Disp_0 (
        .s(M0),
        .disp(HEX0)
    );

endmodule