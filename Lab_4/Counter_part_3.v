module Counter_part_3 #(
    parameter N = 8
)(
    input ena,
    input clk,
    input clear,
    output reg [N-1:0] count
);

    always @(posedge clk) begin
        if (clear)
            count <= 0;
        else begin
            if (ena) begin
                count <= count + 1;
            end
        end
    end

endmodule