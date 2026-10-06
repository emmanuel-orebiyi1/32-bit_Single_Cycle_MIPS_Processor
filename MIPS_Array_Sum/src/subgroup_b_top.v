// =====================================================================
// subgroup_b_top.v
// Subgroup B - Control (integration wrapper)
// 32-bit Single-Cycle MIPS Processor
//
// Instantiates control_unit, alu_control, and branch_jump_control and
// exposes the full Subgroup B interface:
//
//   Inputs from Subgroup A (Datapath):
//     opcode, funct  <- instruction fields
//     Zero           <- ALU zero flag
//
//   Outputs to Subgroup A (Datapath):
//     RegDst, ALUSrc, MemToReg, RegWrite, ALUCtrl, PCSrc, PCJump
//
//   Outputs to Subgroup C (Memory/I-O) - fixed interface per spec (B5):
//     MemRead, MemWrite
// =====================================================================

module subgroup_b_top (
    input  wire [5:0] opcode,
    input  wire [5:0] funct,
    input  wire       Zero,        // from ALU, Subgroup A

    output wire        RegDst,
    output wire        ALUSrc,
    output wire        MemToReg,
    output wire        RegWrite,
    output wire        MemRead,    // -> Subgroup C
    output wire        MemWrite,   // -> Subgroup C
    output wire        Branch,
    output wire        Jump,
    output wire        PCSrc,
    output wire        PCJump,
    output wire [3:0]  ALUCtrl     // -> Subgroup A (ALU)
);

    wire [1:0] ALUOp;

    control_unit u_control_unit (
        .opcode   (opcode),
        .RegDst   (RegDst),
        .ALUSrc   (ALUSrc),
        .MemToReg (MemToReg),
        .RegWrite (RegWrite),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .Branch   (Branch),
        .Jump     (Jump),
        .ALUOp    (ALUOp)
    );

    alu_control u_alu_control (
        .ALUOp   (ALUOp),
        .funct   (funct),
        .ALUCtrl (ALUCtrl)
    );

    branch_jump_control u_branch_jump_control (
        .Branch (Branch),
        .Jump   (Jump),
        .Zero   (Zero),
        .PCSrc  (PCSrc),
        .PCJump (PCJump)
    );

endmodule
