// =====================================================================
// jump_logic.v
// Subgroup A - Datapath
//
// Computes the jump target address for j:
//
//   jump_target = { (PC+4)[31:28], instruction[25:0], 2'b00 }
//
// jump_ctrl (from the Control Unit, asserted for the j opcode) is
// passed through as jump_taken so the top-level next-PC mux can be
// driven directly by this module.
// =====================================================================

module jump_logic (
    input  wire [31:0] pc_plus_4,
    input  wire [25:0] jump_index,      // instruction[25:0]
    input  wire         jump_ctrl,       // from Control Unit: opcode == j
    output wire [31:0] jump_target,
    output wire         jump_taken
);

    assign jump_target = { pc_plus_4[31:28], jump_index, 2'b00 };
    assign jump_taken  = jump_ctrl;

endmodule
