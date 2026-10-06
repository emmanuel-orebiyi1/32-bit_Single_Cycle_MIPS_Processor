// =====================================================================
// shift_left2.v
// Subgroup A - Datapath
//
// Shifts a 32-bit value left by 2 bits (multiply by 4), used to
// convert the sign-extended branch offset from words to bytes:
//   sign_extended_offset << 2
// =====================================================================

module shift_left2 (
    input  wire [31:0] in,
    output wire [31:0] out
);

    assign out = in << 2;

endmodule
