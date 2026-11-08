
module Counter_1Hz(
    input in_clk,
    input clear,
    output reg slow_clk
);

    reg [27:0] clk_count;

    // Clock divider: 50 MHz --> One pulse every 4 seconds
    // Synchronous reset

    always @(posedge in_clk) begin
        if (clear) begin
            slow_clk <= 0;
            clk_count <= 28'd0;
        end
        else begin
            if (clk_count == 28'd199_999_999) begin
                clk_count <= 28'd0;
                slow_clk <= 1;
            end
            else begin
                clk_count <= clk_count + 1'b1;
                slow_clk <= 0;
            end
        end
    end

endmodule
