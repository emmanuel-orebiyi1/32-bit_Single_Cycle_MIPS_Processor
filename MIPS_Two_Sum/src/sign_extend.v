// =====================================================================
// sign_extend.v
// Subgroup A - Datapath
//
// Sign-extends the 16-bit MIPS immediate field (instruction[15:0])
// to a 32-bit signed value by replicating the sign bit (bit 15)
// into bits [31:16].
// =====================================================================

module sign_extend (
    input  wire [15:0] immediate_in,
    output wire [31:0] sign_extended_out
);

    assign sign_extended_out = { {16{immediate_in[15]}}, immediate_in };

endmodule
