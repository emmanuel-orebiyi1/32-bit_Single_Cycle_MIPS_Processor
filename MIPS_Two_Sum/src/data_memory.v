//=============================================================================
// data_memory.v
// MIPS Two Sum Project
//
// Preloaded array:
//   index 0 = 2
//   index 1 = 7
//   index 2 = 11
//   index 3 = 15
//   index 4 = 3
//   index 5 = 6
//   index 6 = 8
//   index 7 = 10
//
// Memory addresses:
//   0x00 = 2
//   0x04 = 7
//   0x08 = 11
//   0x0C = 15
//   0x10 = 3
//   0x14 = 6
//   0x18 = 8
//   0x1C = 10
//=============================================================================

module data_memory (
    input         clk,
    input         MemRead,
    input         MemWrite,
    input  [31:0] address,
    input  [31:0] write_data,

    output [31:0] read_data
);

    parameter MEM_DEPTH  = 256;
    parameter ADDR_WIDTH = 8;

    reg [31:0] mem [0:MEM_DEPTH-1];

    // Word-aligned memory addressing
    wire [ADDR_WIDTH-1:0] word_index;

    assign word_index = address[ADDR_WIDTH+1:2];

    // Read
    assign read_data = mem[word_index];

    // Write
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[word_index] <= write_data;
        end
    end

    //-------------------------------------------------------------------------
    // Initial memory contents
    //-------------------------------------------------------------------------
    integer i;

    initial begin

        // Clear entire memory
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            mem[i] = 32'h00000000;

        // Two Sum array
        mem[0] = 32'd2;      // array[0]
        mem[1] = 32'd7;      // array[1]
        mem[2] = 32'd11;     // array[2]
        mem[3] = 32'd15;     // array[3]
        mem[4] = 32'd3;      // array[4]
        mem[5] = 32'd6;      // array[5]
        mem[6] = 32'd8;      // array[6]
        mem[7] = 32'd10;     // array[7]
    end

endmodule