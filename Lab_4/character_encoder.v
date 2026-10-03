module character_encoder(
    input      [3:0] state,

    output reg [3:0] char5,
    output reg [3:0] char4,
    output reg [3:0] char3,
    output reg [3:0] char2,
    output reg [3:0] char1,
    output reg [3:0] char0
);

    // Character codes
    localparam BLANK = 4'b0000;
    localparam H     = 4'b0001;
    localparam E     = 4'b0010;
    localparam L     = 4'b0011;
    localparam O     = 4'b0100;

    always @(*) begin

        // Default: all displays blank
        char5 = BLANK;
        char4 = BLANK;
        char3 = BLANK;
        char2 = BLANK;
        char1 = BLANK;
        char0 = BLANK;

        case (state)

            // _ _ _ _ _ H
            4'd0: begin
                char0 = H;
            end

            // _ _ _ _ H E
            4'd1: begin
                char1 = H;
                char0 = E;
            end

            // _ _ _ H E L
            4'd2: begin
                char2 = H;
                char1 = E;
                char0 = L;
            end

            // _ _ H E L L
            4'd3: begin
                char3 = H;
                char2 = E;
                char1 = L;
                char0 = L;
            end

            // _ H E L L O
            4'd4: begin
                char4 = H;
                char3 = E;
                char2 = L;
                char1 = L;
                char0 = O;
            end

            // H E L L O _
            4'd5: begin
                char5 = H;
                char4 = E;
                char3 = L;
                char2 = L;
                char1 = O;
            end

            // E L L O _ H
            4'd6: begin
                char5 = E;
                char4 = L;
                char3 = L;
                char2 = O;
                char0 = H;
            end

            // L L O _ H E
            4'd7: begin
                char5 = L;
                char4 = L;
                char3 = O;
                char1 = H;
                char0 = E;
            end

            // L O _ H E L
            4'd8: begin
                char5 = L;
                char4 = O;
                char2 = H;
                char1 = E;
                char0 = L;
            end

            // O _ H E L L
            4'd9: begin
                char5 = O;
                char3 = H;
                char2 = E;
                char1 = L;
                char0 = L;
            end

            default: begin
                // Defaults above keep all displays blank
            end

        endcase
    end

endmodule