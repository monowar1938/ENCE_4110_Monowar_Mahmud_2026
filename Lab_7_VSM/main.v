
`default_nettype none

module main(
    input MAX10_CLK1_50,
    input [1:0] KEY,
    input [9:0] SW,
    inout [35:0] GPIO,
    output [9:0] LEDR,
    output [7:0] HEX0,
    output [7:0] HEX1,
    output [7:0] HEX2,
    output [7:0] HEX4,
    output [7:0] HEX5
);

    localparam N = 4;

    // -----------------------------------
    // CLOCK AND RESET
    // -----------------------------------

    wire w_reset = SW[8];
    wire w_slow_clock;
    wire w_clock;

    Counter_1Hz divider (
        .in_clk(MAX10_CLK1_50),
        .clear(w_reset),
        .slow_clk(w_slow_clock)
    );

    // Provide a reset clock edge for the
    // existing synchronous-reset VSM.
    reg r_reset_clock = 1'b0;

    always @(posedge MAX10_CLK1_50)
        r_reset_clock <= w_reset;

    assign w_clock = w_slow_clock | r_reset_clock;

    // -----------------------------------
    // UART GPIO CONNECTIONS
    // -----------------------------------

    wire w_uart_rx = GPIO[33];
    wire w_uart_tx;

    assign GPIO[35] = w_uart_tx;

    // -----------------------------------
    // UART INPUT SELECTION
    // -----------------------------------

    wire [N-1:0] w_user_input;
    wire [N-1:0] w_uart_input;

    assign w_user_input =
        SW[7] ? w_uart_input : SW[3:0];

    // -----------------------------------
    // INTERNAL VSM WIRES
    // -----------------------------------

    wire [N-1:0] w_IB_BUS;
    wire [N-1:0] w_AluA;
    wire [N-1:0] w_AluB;

    wire [N-1:0] w_counter;
    wire [N-1:0] w_data;
    wire [N-1:0] w_instruction;
    wire [N-1:0] w_ToInstr;
    wire [N-1:0] w_rOut;

    wire w_carry;

    // -----------------------------------
    // FSM CONTROL WIRES
    // -----------------------------------

    wire w_LatchA;
    wire w_EnableA;
    wire w_LatchB;
    wire w_EnableALU;
    wire w_AddSub;
    wire w_EnableIN;
    wire w_EnableOut;
    wire w_LoadInstr;
    wire w_EnableInstr;
    wire w_EnableCount;

    // -----------------------------------
    // LED DEBUG OUTPUTS
    // -----------------------------------

    assign LEDR[9]   = w_carry;
    assign LEDR[8]   = SW[7];
    assign LEDR[7:4] = w_counter;
    assign LEDR[3:0] = w_rOut;

    // -----------------------------------
    // ACCUMULATOR A
    // -----------------------------------

    Accumulator_A AccA (
        .MainClock(w_clock),
        .ClearA(w_reset),
        .LatchA(w_LatchA),
        .EnableA(w_EnableA),
        .A(w_IB_BUS),
        .IB_BUS(w_IB_BUS),
        .AluA(w_AluA)
    );

    seg7Decoder SEG1 (
        .i_bin(w_AluA),
        .o_HEX(HEX1)
    );

    // -----------------------------------
    // ACCUMULATOR B
    // -----------------------------------

    Accumulator_B AccB (
        .MainClock(w_clock),
        .ClearB(w_reset),
        .LatchB(w_LatchB),
        .B(w_IB_BUS),
        .AluB(w_AluB)
    );

    seg7Decoder SEG2 (
        .i_bin(w_AluB),
        .o_HEX(HEX2)
    );

    // -----------------------------------
    // ARITHMETIC UNIT
    // -----------------------------------

    Arithmetic_Unit ALU (
        .EnableALU(w_EnableALU),
        .AddSub(w_AddSub),
        .A(w_AluA),
        .B(w_AluB),
        .Carry(w_carry),
        .IB_ALU(w_IB_BUS)
    );

    seg7Decoder SEG0 (
        .i_bin(w_IB_BUS),
        .o_HEX(HEX0)
    );

    // -----------------------------------
    // INPUT REGISTER
    // -----------------------------------

    InRegister InReg (
        .EnableIN(w_EnableIN),
        .DataIn(w_user_input),
        .IB_BUS(w_IB_BUS)
    );

    seg7Decoder SEG4 (
        .i_bin(w_user_input),
        .o_HEX(HEX4)
    );

    // -----------------------------------
    // OUTPUT REGISTER
    // -----------------------------------

    OutRegister OutReg (
        .MainClock(w_clock),
        .MainReset(w_reset),
        .EnableOut(w_EnableOut),
        .IB_BUS(w_IB_BUS),
        .rOut(w_rOut)
    );

    seg7Decoder SEG5 (
        .i_bin(w_rOut),
        .o_HEX(HEX5)
    );

    // -----------------------------------
    // INSTRUCTION REGISTER
    // -----------------------------------

    InstructionReg InstrReg (
        .MainClock(w_clock),
        .ClearInstr(w_reset),
        .LatchInstr(w_LoadInstr),
        .EnableInstr(w_EnableInstr),
        .Data(w_data),
        .Instr(w_instruction),
        .ToInstr(w_ToInstr),
        .IB_BUS(w_IB_BUS)
    );

    // -----------------------------------
    // PROGRAM COUNTER
    // -----------------------------------

    ProgramCounter ProgCounter (
        .MainClock(w_clock),
        .EnableCount(w_EnableCount),
        .ClearCounter(w_reset),
        .Counter(w_counter)
    );

    // -----------------------------------
    // PROGRAM ROM
    // -----------------------------------

    wire [7:0] w_rom_data;

    ROM_Nx8 ROM (
        .address(w_counter[2:0]),
        .data(w_rom_data)
    );

    assign {w_instruction, w_data} = w_rom_data;

    // -----------------------------------
    // MICROINSTRUCTION FSM
    // -----------------------------------

    FSM_MicroInstr Controller (
        .clk(w_clock),
        .reset(w_reset),
        .IB_BUS(w_IB_BUS),
        .LatchA(w_LatchA),
        .EnableA(w_EnableA),
        .LatchB(w_LatchB),
        .EnableALU(w_EnableALU),
        .AddSub(w_AddSub),
        .EnableIN(w_EnableIN),
        .EnableOut(w_EnableOut),
        .LoadInstr(w_LoadInstr),
        .EnableInstr(w_EnableInstr),
        .ToInstr(w_ToInstr),
        .EnableCount(w_EnableCount)
    );

    // -----------------------------------
    // UART INTERFACE
    // -----------------------------------

    VSM_UART_Interface UART_Interface (
        .clk(MAX10_CLK1_50),
        .reset(w_reset),
        .uart_rx(w_uart_rx),
        .uart_tx(w_uart_tx),
        .uart_input(w_uart_input),
        .vsm_output(w_rOut),
        .vsm_enable_out(w_EnableOut)
    );

endmodule

`default_nettype wire
