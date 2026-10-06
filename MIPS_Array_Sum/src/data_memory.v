//=============================================================================
// data_memory.v
// Subgroup C - Memory + Peripherals + FPGA
//
// General-purpose data RAM. Only accessed when the I/O Address Decoder
// determines the current address is NOT a peripheral address (see
// io_address_decoder.v). 256 x 32-bit words = 1024 bytes, word aligned.
//=============================================================================
module data_memory (
    input         clk,
    input         MemRead,      // qualified (already AND-ed with ~is_io)
    input         MemWrite,     // qualified (already AND-ed with ~is_io)
    input  [31:0] address,
    input  [31:0] write_data,

    output [31:0] read_data
);

    parameter MEM_DEPTH  = 256;
    parameter ADDR_WIDTH = 8;   // log2(MEM_DEPTH) word-address bits

    reg [31:0] mem [0:MEM_DEPTH-1];

    // Word index: address[1:0] assumed 00 (word aligned)
    wire [ADDR_WIDTH-1:0] word_index = address[ADDR_WIDTH+1:2];

    // Combinational read (address decoder chooses this vs. peripheral data)
    assign read_data = mem[word_index];

    // Synchronous write
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[word_index] <= write_data;
        end
    end

    // Optional: zero-initialize for simulation cleanliness
    integer i;
    initial begin
        for (i = 0; i < MEM_DEPTH; i = i + 1)
            mem[i] = 32'h0;
    end

endmodule
