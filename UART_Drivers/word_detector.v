
`default_nettype none

module word_detector (
    input wire clk,
    input wire reset,
    input wire [7:0] ascii_in,
    input wire data_valid,
    input wire counter_done,

    output wire counter_en,
    output wire hello_detected
);

    localparam S0 = 3'd0; // Idle
    localparam S1 = 3'd1; // H
    localparam S2 = 3'd2; // HE
    localparam S3 = 3'd3; // HEL
    localparam S4 = 3'd4; // HELL
    localparam S5 = 3'd5; // HELLO detected

    reg [2:0] state, next_state;

    wire [7:0] lower_char;

    // Convert uppercase to lowercase
    assign lower_char =
        (ascii_in >= 8'd65 && ascii_in <= 8'd90)
        ? ascii_in + 8'd32 : ascii_in;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;

        case (state)
            S0: if (data_valid) begin
                if (lower_char == "h")
                    next_state = S1;
            end

            S1: if (data_valid) begin
                if (lower_char == "e")
                    next_state = S2;
                else if (lower_char == "h")
                    next_state = S1;
                else
                    next_state = S0;
            end

            S2: if (data_valid) begin
                if (lower_char == "l")
                    next_state = S3;
                else if (lower_char == "h")
                    next_state = S1;
                else
                    next_state = S0;
            end

            S3: if (data_valid) begin
                if (lower_char == "l")
                    next_state = S4;
                else if (lower_char == "h")
                    next_state = S1;
                else
                    next_state = S0;
            end

            S4: if (data_valid) begin
                if (lower_char == "o")
                    next_state = S5;
                else if (lower_char == "h")
                    next_state = S1;
                else
                    next_state = S0;
            end

            S5: begin
                if (counter_done)
                    next_state = S0;
            end

            default: next_state = S0;
        endcase
    end

    // Moore outputs
    assign hello_detected = (state == S5);
    assign counter_en = (state == S5);

endmodule

`default_nettype wire
