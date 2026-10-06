// =====================================================================
// tb_subgroup_b.v
// Testbench for Subgroup B - Control
// 32-bit Single-Cycle MIPS Processor
//
// Drives opcode/funct/Zero for every instruction in the frozen set
// (add, sub, and, or, slt, nor, addi, lw, sw, beq, j) and prints the
// resulting control word so it can be checked against the truth table
// in the specification (B3) and the ALU control table (B4).
// =====================================================================

`timescale 1ns/1ps

module tb_subgroup_b;

    reg  [5:0] opcode;
    reg  [5:0] funct;
    reg        Zero;

    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite;
    wire Branch, Jump, PCSrc, PCJump;
    wire [3:0] ALUCtrl;

    subgroup_b_top DUT (
        .opcode   (opcode),
        .funct    (funct),
        .Zero     (Zero),
        .RegDst   (RegDst),
        .ALUSrc   (ALUSrc),
        .MemToReg (MemToReg),
        .RegWrite (RegWrite),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .Branch   (Branch),
        .Jump     (Jump),
        .PCSrc    (PCSrc),
        .PCJump   (PCJump),
        .ALUCtrl  (ALUCtrl)
    );

    task show(input [63:0] name);
        begin
            #1;
            $display("%-6s | opcode=%b funct=%b Zero=%b || RegDst=%b ALUSrc=%b MemToReg=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b Jump=%b PCSrc=%b PCJump=%b ALUCtrl=%b",
                       name, opcode, funct, Zero,
                       RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite,
                       Branch, Jump, PCSrc, PCJump, ALUCtrl);
            if (MemRead && MemWrite)
                $display("  ** VIOLATION: MemRead and MemWrite both high **");
        end
    endtask

    initial begin
        $display("instr  | inputs                        || control outputs");
        $display("-------+-------------------------------++----------------------------------------------------------------");

        Zero = 1'b0;

        // ---- R-type instructions ----
        opcode = 6'b000000; funct = 6'b100000; show("add");
        opcode = 6'b000000; funct = 6'b100010; show("sub");
        opcode = 6'b000000; funct = 6'b100100; show("and");
        opcode = 6'b000000; funct = 6'b100101; show("or");
        opcode = 6'b000000; funct = 6'b101010; show("slt");
        opcode = 6'b000000; funct = 6'b100111; show("nor");

        // ---- Immediate ----
        opcode = 6'b001000; funct = 6'bxxxxxx; show("addi");

        // ---- Memory ----
        opcode = 6'b100011; funct = 6'bxxxxxx; show("lw");
        opcode = 6'b101011; funct = 6'bxxxxxx; show("sw");

        // ---- Branch: check both Zero=0 (not taken) and Zero=1 (taken) ----
        opcode = 6'b000100; funct = 6'bxxxxxx; Zero = 1'b0; show("beq(0)");
        opcode = 6'b000100; funct = 6'bxxxxxx; Zero = 1'b1; show("beq(1)");
        Zero = 1'b0;

        // ---- Jump ----
        opcode = 6'b000010; funct = 6'bxxxxxx; show("j");

        // ---- Unrecognized opcode: confirm all signals stay safely low ----
        opcode = 6'b111111; funct = 6'bxxxxxx; show("bad_op");

        $display("-------+-------------------------------++----------------------------------------------------------------");
        $display("Testbench complete.");
        $finish;
    end

endmodule
