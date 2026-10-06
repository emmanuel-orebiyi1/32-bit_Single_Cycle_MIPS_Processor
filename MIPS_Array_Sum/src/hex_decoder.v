//=============================================================================
// hex_decoder.v
// Active-low 7-segment HEX decoder for DE2 board
//=============================================================================

module hex_decoder (
    input  wire [31:0] value,

    output reg [6:0] HEX0,
    output reg [6:0] HEX1,
    output reg [6:0] HEX2,
    output reg [6:0] HEX3,
    output reg [6:0] HEX4,
    output reg [6:0] HEX5,
    output reg [6:0] HEX6,
    output reg [6:0] HEX7
);

    function [6:0] decode_hex;
        input [3:0] digit;

        begin
            case (digit)
                4'h0: decode_hex = 7'b1000000;
                4'h1: decode_hex = 7'b1111001;
                4'h2: decode_hex = 7'b0100100;
                4'h3: decode_hex = 7'b0110000;
                4'h4: decode_hex = 7'b0011001;
                4'h5: decode_hex = 7'b0010010;
                4'h6: decode_hex = 7'b0000010;
                4'h7: decode_hex = 7'b1111000;
                4'h8: decode_hex = 7'b0000000;
                4'h9: decode_hex = 7'b0010000;
                4'hA: decode_hex = 7'b0001000;
                4'hB: decode_hex = 7'b0000011;
                4'hC: decode_hex = 7'b1000110;
                4'hD: decode_hex = 7'b0100001;
                4'hE: decode_hex = 7'b0000110;
                4'hF: decode_hex = 7'b0001110;

                default: decode_hex = 7'b1111111;
            endcase
        end
    endfunction

    always @(*) begin

        HEX0 = decode_hex(value[3:0]);
        HEX1 = decode_hex(value[7:4]);
        HEX2 = decode_hex(value[11:8]);
        HEX3 = decode_hex(value[15:12]);
        HEX4 = decode_hex(value[19:16]);
        HEX5 = decode_hex(value[23:20]);
        HEX6 = decode_hex(value[27:24]);
        HEX7 = decode_hex(value[31:28]);

    end

endmodule