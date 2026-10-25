`default_nettype none

module blink_counter (
    input wire clk,
    input wire reset,
    input wire counter_en,

    output wire counter_done,
    output reg blink
);

    parameter CLK_FREQ = 50000000;

    localparam TOTAL_COUNT = 3 * CLK_FREQ;
    localparam BLINK_COUNT = CLK_FREQ / 4;

    reg [27:0] total_counter;
    reg [23:0] blink_counter_reg;

    // Total 3-second counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            total_counter <= 28'd0;

        else if (!counter_en)
            total_counter <= 28'd0;

        else if (total_counter < TOTAL_COUNT - 1)
            total_counter <= total_counter + 1'b1;
    end

    // 0.25-second blink counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            blink_counter_reg <= 24'd0;
            blink <= 1'b1;
        end

        else if (!counter_en) begin
            blink_counter_reg <= 24'd0;
            blink <= 1'b1;
        end

        else if (blink_counter_reg == BLINK_COUNT - 1) begin
            blink_counter_reg <= 24'd0;
            blink <= ~blink;
        end

        else
            blink_counter_reg <= blink_counter_reg + 1'b1;
    end

    // Completion signal
    assign counter_done =
        counter_en && (total_counter == TOTAL_COUNT - 1);

endmodule

`default_nettype wire