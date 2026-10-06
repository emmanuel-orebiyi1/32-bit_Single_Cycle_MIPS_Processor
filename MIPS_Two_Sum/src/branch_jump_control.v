// =====================================================================
// branch_jump_control.v
// Subgroup B - Control
// 32-bit Single-Cycle MIPS Processor
//
// Resolves the final PC-source decision for beq and j, combining the
// Branch/Jump signals from control_unit.v with the Zero flag produced
// by the ALU (Subgroup A). Kept in Subgroup B per the project spec's
// allowance for "associated branch/jump control logic."
//
// Priority: Jump (j) always overrides Branch, matching the standard
// single-cycle MIPS datapath where the jump mux is the final stage
// before the PC register.
//
//   PCSrc  = Branch & Zero   -> select branch target (PC + 4 + offset<<2)
//   PCJump = Jump             -> select jump target   ({PC+4[31:28], instr[25:0], 2'b00})
// =====================================================================

module branch_jump_control (
    input  wire Branch,
    input  wire Jump,
    input  wire Zero,        // from ALU, Subgroup A

    output wire PCSrc,       // 1 => branch target selected (unless overridden by PCJump)
    output wire PCJump       // 1 => jump target selected (highest priority)
);

    assign PCSrc  = Branch & Zero;
    assign PCJump = Jump;

endmodule
