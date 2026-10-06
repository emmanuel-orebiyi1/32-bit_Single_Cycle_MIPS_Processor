module datapath (
    input wire clk,
    input wire reset,

    input wire [31:0] instruction,
    input wire [31:0] mem_read_data,

    input wire reg_dst,
    input wire alu_src,
    input wire mem_to_reg,
    input wire reg_write,
    input wire branch_ctrl,
    input wire jump_ctrl,

    input wire [3:0] alu_control,

    output wire [31:0] pc,
    output wire [31:0] alu_result,
    output wire [31:0] write_data_mem,
    output wire zero
);

    // ============================================================
    // Instruction fields
    // ============================================================

    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] shamt;
    wire [5:0] funct;
    wire [15:0] immediate;
    wire [25:0] jump_index;

    assign opcode     = instruction[31:26];
    assign rs         = instruction[25:21];
    assign rt         = instruction[20:16];
    assign rd         = instruction[15:11];
    assign shamt      = instruction[10:6];
    assign funct      = instruction[5:0];
    assign immediate  = instruction[15:0];
    assign jump_index = instruction[25:0];


    // ============================================================
    // PC logic
    // ============================================================

    wire [31:0] next_pc;
    wire [31:0] pc_plus_4;

    program_counter PC_REG (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    adder PC_ADDER (
        .in0(pc),
        .in1(32'd4),
        .out(pc_plus_4)
    );


    // ============================================================
    // Register file
    // ============================================================

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_back_data;

    wire [4:0] write_register;

    mux2 #(.WIDTH(5)) DEST_REG_MUX (
        .in0(rt),
        .in1(rd),
        .sel(reg_dst),
        .out(write_register)
    );

    register_file REG_FILE (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(rs),
        .read_reg2(rt),
        .write_reg(write_register),
        .write_data(write_back_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );


    // ============================================================
    // Immediate extension
    // ============================================================

    wire [31:0] sign_extended_immediate;
    wire [31:0] zero_extended_immediate;
    wire [31:0] immediate_extended;

    sign_extend SIGN_EXT (
        .immediate_in(immediate),
        .sign_extended_out(sign_extended_immediate)
    );

    assign zero_extended_immediate = {16'b0, immediate};

    // ORI uses zero extension.
    // Other immediate instructions use sign extension.
    assign immediate_extended =
        (opcode == 6'b001101) ?
        zero_extended_immediate :
        sign_extended_immediate;


    // ============================================================
    // ALU input B
    // ============================================================

    wire [31:0] alu_operand_b;

    mux2 #(.WIDTH(32)) ALU_SRC_MUX (
        .in0(read_data2),
        .in1(immediate_extended),
        .sel(alu_src),
        .out(alu_operand_b)
    );


    // ============================================================
    // ALU input A
    //
    // IMPORTANT:
    // For SLL/SRL, MIPS uses instruction[10:6] = shamt.
    // The ALU implementation performs:
    //     SLL: B << A[4:0]
    //     SRL: B >> A[4:0]
    //
    // Therefore, for shift operations, A must contain shamt.
    // For all other operations, A = register rs.
    // ============================================================

    wire [31:0] alu_operand_a;

    assign alu_operand_a =
        ((alu_control == 4'b0111) ||   // SLL
         (alu_control == 4'b1000))     // SRL
        ? {27'b0, shamt}
        : read_data1;


    // ============================================================
    // ALU
    // ============================================================

    wire [31:0] alu_result_raw;
    wire alu_zero;

    alu ALU (
        .A(alu_operand_a),
        .B(alu_operand_b),
        .ALUControl(alu_control),
        .Result(alu_result_raw),
        .Zero(alu_zero)
    );


    // ============================================================
    // LUI
    // ============================================================

    wire is_lui;
    wire [31:0] lui_result;

    assign is_lui = (opcode == 6'b001111);

    assign lui_result = {
        immediate,
        16'b0
    };

    assign alu_result =
        is_lui ?
        lui_result :
        alu_result_raw;

    assign zero = alu_zero;


    // ============================================================
    // Data memory write data
    // ============================================================

    assign write_data_mem = read_data2;


    // ============================================================
    // Write-back MUX
    //
    // 0 = ALU result
    // 1 = memory result
    // ============================================================

    mux2 #(.WIDTH(32)) MEM_TO_REG_MUX (
        .in0(alu_result),
        .in1(mem_read_data),
        .sel(mem_to_reg),
        .out(write_back_data)
    );


    // ============================================================
    // Branch logic
    // ============================================================

    wire [31:0] branch_target;
    wire branch_taken;

    branch_logic BRANCH_LOGIC (
        .pc_plus_4(pc_plus_4),
        .sign_extended_offset(sign_extended_immediate),
        .branch_ctrl(branch_ctrl),
        .zero(zero),
        .branch_target(branch_target),
        .branch_taken(branch_taken)
    );


    // ============================================================
    // Jump logic
    // ============================================================

    wire [31:0] jump_target;
    wire jump_taken;

    jump_logic JUMP_LOGIC (
        .pc_plus_4(pc_plus_4),
        .jump_index(jump_index),
        .jump_ctrl(jump_ctrl),
        .jump_target(jump_target),
        .jump_taken(jump_taken)
    );


    // ============================================================
    // Next PC selection
    //
    // Priority:
    // 1. Normal PC + 4
    // 2. Branch target
    // 3. Jump target
    // ============================================================

    wire [31:0] pc_after_branch;

    mux2 #(.WIDTH(32)) BRANCH_MUX (
        .in0(pc_plus_4),
        .in1(branch_target),
        .sel(branch_taken),
        .out(pc_after_branch)
    );

    mux2 #(.WIDTH(32)) JUMP_MUX (
        .in0(pc_after_branch),
        .in1(jump_target),
        .sel(jump_taken),
        .out(next_pc)
    );

endmodule 