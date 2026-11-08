
`default_nettype none

module InstructionReg #
(
    parameter N = 4
)
(
    input MainClock,
    input ClearInstr,
    input LatchInstr,
    input EnableInstr,
    input [N-1:0] Data,
    input [N-1:0] Instr,
    output reg [N-1:0] ToInstr,
    output [N-1:0] IB_BUS
);

    reg [N-1:0] DataReg;

    always @(posedge MainClock)
    begin
        if (ClearInstr)
        begin
            ToInstr <= {N{1'b0}};
            DataReg <= {N{1'b0}};
        end
        else if (LatchInstr)
        begin
            ToInstr <= Instr;
            DataReg <= Data;
        end
    end

    assign IB_BUS = EnableInstr ?
                    DataReg : {N{1'bz}};

endmodule

`default_nettype wire
