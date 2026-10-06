// =====================================================================
// mux.v
// Subgroup A - Datapath
//
// Generic, parameterized multiplexers used throughout the datapath:
//   mux2 - 2-to-1 mux   (e.g. ALU second operand, next-PC selection)
//   mux3 - 3-to-1 mux   (e.g. write-back data: ALU result / mem data
//                         / PC+4 for jal)
//   mux4 - 4-to-1 mux   (spare, for future expansion)
//
// All muxes are purely combinational. WIDTH defaults to 32 bits but
// is overridden where needed (e.g. WIDTH=5 for register-destination
// selection between rt/rd/$31).
//
// Fixed interface (do not change without revising the full spec):
//   sel = 0 selects in0
//   sel = 1 selects in1
//   sel = 2 selects in2 (mux3/mux4 only)
//   sel = 3 selects in3 (mux4 only)
// =====================================================================

module mux2 #(
    parameter WIDTH = 32
) (
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire              sel,
    output wire [WIDTH-1:0] out
);

    assign out = sel ? in1 : in0;

endmodule


module mux3 #(
    parameter WIDTH = 32
) (
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire [WIDTH-1:0] in2,
    input  wire [1:0]        sel,
    output reg  [WIDTH-1:0] out
);

    always @(*) begin
        case (sel)
            2'b00:   out = in0;
            2'b01:   out = in1;
            2'b10:   out = in2;
            default: out = in0;
        endcase
    end

endmodule


module mux4 #(
    parameter WIDTH = 32
) (
    input  wire [WIDTH-1:0] in0,
    input  wire [WIDTH-1:0] in1,
    input  wire [WIDTH-1:0] in2,
    input  wire [WIDTH-1:0] in3,
    input  wire [1:0]        sel,
    output reg  [WIDTH-1:0] out
);

    always @(*) begin
        case (sel)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            2'b11: out = in3;
        endcase
    end

endmodule
