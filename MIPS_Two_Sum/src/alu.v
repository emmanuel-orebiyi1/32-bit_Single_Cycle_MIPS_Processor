// =====================================================================
// alu.v
// Subgroup A - Datapath
//
// 32-bit ALU. Also used to compute the effective (byte) address for
// lw / sw as A + B (ALUControl = ADD).
//
// ALUControl encoding (agreed interface with Subgroup B / ALU Control):
//   3'b000 : ADD    Result = A + B
//   3'b001 : SUB    Result = A - B
//   3'b010 : AND    Result = A & B
//   3'b011 : OR     Result = A | B
//   3'b100 : XOR    Result = A ^ B
//   3'b101 : SLT    Result = (A < B) ? 1 : 0   (signed)
//   3'b110 : NOR    Result = ~(A | B)
//   3'b111 : SHIFT  SLL/SRL, selected by ALUControl2 (see below)
//
// SLL and SRL both use amounts >5 bits (0-31), which does not fit in
// the 3-bit ALUControl code above without growing the field. To keep
// the control interface at a clean, fixed width, shifts are selected
// with a 4-bit ALUControl bus instead:
//
//   4'b0000 : ADD
//   4'b0001 : SUB
//   4'b0010 : AND
//   4'b0011 : OR
//   4'b0100 : XOR
//   4'b0101 : SLT   (signed)
//   4'b0110 : NOR
//   4'b0111 : SLL   Result = B << shamt   (shamt = A[4:0])
//   4'b1000 : SRL   Result = B >> shamt   (shamt = A[4:0])
//
// For SLL/SRL, by MIPS convention the shift amount comes from the
// instruction's shamt field (instruction[10:6]) and the value being
// shifted is rt (the B operand); the datapath is responsible for
// routing shamt into A[4:0] for these operations.
//
// Zero flag: asserted whenever Result == 0 (used by beq).
// =====================================================================

module alu (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  ALUControl,
    output reg  [31:0] Result,
    output wire        Zero
);

    always @(*) begin
        case (ALUControl)

            4'b0000: Result = A + B;                         // ADD
            4'b0001: Result = A - B;                         // SUB
            4'b0010: Result = A & B;                         // AND
            4'b0011: Result = A | B;                         // OR
            4'b0100: Result = A ^ B;                         // XOR
            4'b0101: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLT
            4'b0110: Result = ~(A | B);                      // NOR
            4'b0111: Result = B << A[4:0];                  // SLL
            4'b1000: Result = B >> A[4:0];                  // SRL

            default: Result = 32'b0;

        endcase
    end

    assign Zero = (Result == 32'b0);

endmodule