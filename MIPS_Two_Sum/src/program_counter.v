// =====================================================================
// program_counter.v
// Subgroup A - Datapath
//
// 32-bit Program Counter register.
// On reset, PC is cleared to 0. Otherwise, on every rising clock edge,
// PC is loaded with next_pc (computed externally by the datapath /
// adder / branch / jump logic).
// =====================================================================

module program_counter (
    input  wire        clk,
    input  wire         reset,
    input  wire [31:0]  next_pc,
    output reg  [31:0]  pc
);

    always @(posedge clk) begin
        if (reset)
            pc <= 32'h00000000;
        else
            pc <= next_pc;
    end

endmodule
