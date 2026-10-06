module control_unit (
    input  wire [5:0] opcode,

    output reg RegDst,
    output reg ALUSrc,
    output reg MemToReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg Jump,
    output reg [1:0] ALUOp
);

    // ================================================================
    // MIPS OPCODES
    // ================================================================
    localparam OPCODE_RTYPE = 6'b000000;
    localparam OPCODE_ADDI  = 6'b001000;
    localparam OPCODE_LW    = 6'b100011;
    localparam OPCODE_SW    = 6'b101011;
    localparam OPCODE_BEQ   = 6'b000100;
    localparam OPCODE_J     = 6'b000010;

    // Newly supported instructions
    localparam OPCODE_ORI   = 6'b001101;
    localparam OPCODE_LUI   = 6'b001111;


    // ================================================================
    // CONTROL LOGIC
    // ================================================================
    always @(*) begin

        // Default values
        RegDst   = 1'b0;
        ALUSrc   = 1'b0;
        MemToReg = 1'b0;
        RegWrite = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        Jump     = 1'b0;
        ALUOp    = 2'b00;

        case (opcode)

            // ========================================================
            // R-TYPE
            // add, sub, and, or, slt, nor
            // ========================================================
            OPCODE_RTYPE: begin
                RegDst   = 1'b1;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ALUOp    = 2'b10;
            end


            // ========================================================
            // ADDI
            // ========================================================
            OPCODE_ADDI: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ALUOp    = 2'b00;
            end


            // ========================================================
            // LW
            // ========================================================
            OPCODE_LW: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemToReg = 1'b1;
                RegWrite = 1'b1;
                MemRead  = 1'b1;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ALUOp    = 2'b00;
            end


            // ========================================================
            // SW
            // ========================================================
            OPCODE_SW: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemToReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b1;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ALUOp    = 2'b00;
            end


            // ========================================================
            // BEQ
            // ========================================================
            OPCODE_BEQ: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b1;
                Jump     = 1'b0;
                ALUOp    = 2'b01;
            end


            // ========================================================
            // JUMP
            // ========================================================
            OPCODE_J: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b1;
                ALUOp    = 2'b00;
            end


            // ========================================================
            // ORI
            //
            // OR immediate is a logical operation.
            // ALUOp = 11 is reserved for ORI.
            // ========================================================
            OPCODE_ORI: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ALUOp    = 2'b11;
            end


            // ========================================================
            // LUI
            //
            // LUI writes the immediate into the upper 16 bits:
            //
            // LUI $t4,FFFF
            //
            // gives:
            //
            // $t4 = FFFF0000
            //
            // The datapath handles the actual shift.
            // ========================================================
            OPCODE_LUI: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b1;
                MemToReg = 1'b0;
                RegWrite = 1'b1;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;

                // LUI does not need a special ALU operation because
                // the datapath generates the LUI result directly.
                ALUOp    = 2'b00;
            end


            // ========================================================
            // DEFAULT
            // ========================================================
            default: begin
                RegDst   = 1'b0;
                ALUSrc   = 1'b0;
                MemToReg = 1'b0;
                RegWrite = 1'b0;
                MemRead  = 1'b0;
                MemWrite = 1'b0;
                Branch   = 1'b0;
                Jump     = 1'b0;
                ALUOp    = 2'b00;
            end

        endcase
    end


    // ================================================================
    // SAFETY CHECK
    // ================================================================
    // synthesis translate_off
    always @(*) begin
        if (MemRead && MemWrite)
            $display(
                "ERROR (control_unit): MemRead and MemWrite asserted simultaneously at time %0t",
                $time
            );
    end
    // synthesis translate_on

endmodule 