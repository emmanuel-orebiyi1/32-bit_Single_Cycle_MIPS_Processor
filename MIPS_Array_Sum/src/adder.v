// =====================================================================
// adder.v
// Subgroup A - Datapath
//
// Simple 32-bit combinational adder. Reused for:
//   - PC + 4           (sequential next-instruction address)
//   - PC+4 + (offset<<2)  (branch target address)
// =====================================================================

module adder (
    input  wire [31:0] in0,
    input  wire [31:0] in1,
    output wire [31:0] out
);

    assign out = in0 + in1;

endmodule
