module alu_control (
    input wire [1:0] ALUOp,
    input wire [5:0] funct,
    output reg [3:0] ALUCtrl
);

    // R-type function codes
    localparam FUNCT_SLL = 6'b000000;
    localparam FUNCT_SRL = 6'b000010;
    localparam FUNCT_ADD = 6'b100000;
    localparam FUNCT_SUB = 6'b100010;
    localparam FUNCT_AND = 6'b100100;
    localparam FUNCT_OR  = 6'b100101;
    localparam FUNCT_NOR = 6'b100111;
    localparam FUNCT_SLT = 6'b101010;

    // ALU control codes
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;
    localparam ALU_NOR = 4'b0110;
    localparam ALU_SLL = 4'b0111;
    localparam ALU_SRL = 4'b1000;

    always @(*) begin

        case (ALUOp)

            // LW, SW, ADDI, LUI
            2'b00:
                ALUCtrl = ALU_ADD;

            // BEQ
            2'b01:
                ALUCtrl = ALU_SUB;

            // R-type
            2'b10: begin
                case (funct)

                    FUNCT_SLL:
                        ALUCtrl = ALU_SLL;

                    FUNCT_SRL:
                        ALUCtrl = ALU_SRL;

                    FUNCT_ADD:
                        ALUCtrl = ALU_ADD;

                    FUNCT_SUB:
                        ALUCtrl = ALU_SUB;

                    FUNCT_AND:
                        ALUCtrl = ALU_AND;

                    FUNCT_OR:
                        ALUCtrl = ALU_OR;

                    FUNCT_NOR:
                        ALUCtrl = ALU_NOR;

                    FUNCT_SLT:
                        ALUCtrl = ALU_SLT;

                    default:
                        ALUCtrl = ALU_ADD;

                endcase
            end

            // ORI
            2'b11:
                ALUCtrl = ALU_OR;

            default:
                ALUCtrl = ALU_ADD;

        endcase
    end

endmodule 