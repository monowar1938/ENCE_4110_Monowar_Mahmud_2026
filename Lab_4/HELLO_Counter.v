module HELLO_Counter(
    input        clk,
    input        enable,
    input        clear,
    output reg [3:0] count
);

    always @(posedge clk, posedge clear) begin

        if (clear)
            count <= 4'd0;

        else if (enable) begin

            if (count == 4'd9)
                count <= 4'd4;
            else
                count <= count + 1'b1;

        end

    end

endmodule