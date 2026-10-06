// =====================================================================
// register_file.v
// Subgroup A - Datapath
//
// 32 x 32-bit MIPS register file ($0 - $31).
//   - $zero ($0) always reads as 32'h00000000 and cannot be written.
//   - Two asynchronous (combinational) read ports.
//   - One synchronous write port, active on the rising clock edge
//     when reg_write = 1.
//   - reset clears all registers to 0 (synchronous), useful for
//     simulation / FPGA bring-up.
// =====================================================================

module register_file (
    input  wire        clk,
    input  wire        reset,
    input  wire        reg_write,
    input  wire [4:0]  read_reg1,
    input  wire [4:0]  read_reg2,
    input  wire [4:0]  write_reg,
    input  wire [31:0] write_data,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

    reg [31:0] registers [0:31];

    integer i;

    // ------------------------------------------------------------
    // Write port (synchronous)
    // ------------------------------------------------------------
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'h00000000;
        end
        else if (reg_write && (write_reg != 5'd0)) begin
            registers[write_reg] <= write_data;
        end
    end

    // ------------------------------------------------------------
    // Read ports (combinational, $0 hardwired to zero)
    // ------------------------------------------------------------
    assign read_data1 = (read_reg1 == 5'd0) ? 32'h00000000 : registers[read_reg1];
    assign read_data2 = (read_reg2 == 5'd0) ? 32'h00000000 : registers[read_reg2];

endmodule
