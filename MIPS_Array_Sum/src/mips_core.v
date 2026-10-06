// =====================================================================
// mips_core.v
// 32-bit Single-Cycle MIPS Processor
//
// Board-independent processor core.
// Instruction memory and data/peripheral memory are external.
//
// Supported instructions:
//   R-type: add, sub, and, or, slt, nor
//   addi
//   lw
//   sw
//   beq
//   j
// =====================================================================

module mips_core (

    input wire clk,
    input wire reset,

    // ------------------------------------------------------------
    // Instruction memory interface
    // ------------------------------------------------------------
    output wire [31:0] imem_address,
    input  wire [31:0] imem_instruction,

    // ------------------------------------------------------------
    // Data memory / I/O interface
    // ------------------------------------------------------------
    output wire [31:0] dmem_address,
    output wire [31:0] dmem_write_data,
    input  wire [31:0] dmem_read_data,

    output wire MemRead,
    output wire MemWrite
);

    // ============================================================
    // Instruction fields
    // ============================================================

    wire [5:0] opcode;
    wire [5:0] funct;

    assign opcode = imem_instruction[31:26];
    assign funct  = imem_instruction[5:0];

    // ============================================================
    // CONTROL SIGNALS
    // ============================================================

    wire       RegDst;
    wire       ALUSrc;
    wire       MemToReg;
    wire       RegWrite;
    wire       Branch;
    wire       Jump;
    wire [1:0] ALUOp;

    control_unit CONTROL_UNIT (
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

    // ============================================================
    // ALU CONTROL
    // ============================================================

    wire [3:0] ALUControl;

    alu_control ALU_CONTROL (
        .ALUOp   (ALUOp),
        .funct   (funct),
        .ALUCtrl (ALUControl)
    );

    // ============================================================
    // DATAPATH
    // ============================================================

    wire [31:0] pc;
    wire [31:0] alu_result;
    wire [31:0] write_data_mem;
    wire        zero;

    datapath DATAPATH (
        .clk             (clk),
        .reset           (reset),

        .instruction     (imem_instruction),
        .mem_read_data   (dmem_read_data),

        .reg_dst         (RegDst),
        .alu_src         (ALUSrc),
        .mem_to_reg      (MemToReg),
        .reg_write       (RegWrite),
        .branch_ctrl     (Branch),
        .jump_ctrl       (Jump),
        .alu_control     (ALUControl),

        .pc              (pc),
        .alu_result      (alu_result),
        .write_data_mem  (write_data_mem),
        .zero            (zero)
    );

    // ============================================================
    // DATA MEMORY INTERFACE
    // ============================================================

    assign imem_address    = pc;
    assign dmem_address    = alu_result;
    assign dmem_write_data = write_data_mem;

endmodule 