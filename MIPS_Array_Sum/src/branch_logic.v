// =====================================================================
// branch_logic.v
// Subgroup A - Datapath
//
// Computes the branch target address and whether the branch is taken,
// for beq:
//
//   branch_target = (PC + 4) + (sign_extended_offset << 2)
//   branch_taken  = branch_ctrl & zero
//
// branch_ctrl comes from Subgroup B's Control Unit (asserted for the
// beq opcode); zero comes from the ALU (asserted when rs - rt == 0,
// i.e. rs == rt). This module contains its own internal shift-left-2
// and adder so it can be dropped into the datapath as a single block;
// if the team prefers to reuse the shared adder.v / shift_left2.v
// instances instead, wire pc_plus_4 and sign_extended_offset directly
// to those modules and feed the results in here unchanged.
// =====================================================================

module branch_logic (
    input  wire [31:0] pc_plus_4,
    input  wire [31:0] sign_extended_offset,
    input  wire         branch_ctrl,   // from Control Unit: opcode == beq
    input  wire         zero,          // from ALU
    output wire [31:0] branch_target,
    output wire         branch_taken
);

    wire [31:0] offset_shifted;
    wire [31:0] target;

    shift_left2 sl2 (
        .in  (sign_extended_offset),
        .out (offset_shifted)
    );

    adder branch_adder (
        .in0 (pc_plus_4),
        .in1 (offset_shifted),
        .out (target)
    );

    assign branch_target = target;
    assign branch_taken  = branch_ctrl & zero;

endmodule
