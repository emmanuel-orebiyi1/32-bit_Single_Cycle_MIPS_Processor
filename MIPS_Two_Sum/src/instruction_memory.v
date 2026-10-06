`timescale 1ns/1ps

module instruction_memory #(
    parameter DEPTH = 256
)(
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    reg [31:0] memory [0:DEPTH-1];

    integer i;

    initial begin
        // Clear memory
        for (i = 0; i < DEPTH; i = i + 1)
            memory[i] = 32'h00000000;

        // Load program
        $readmemh("programs/program.mem", memory);
    end

    // Word-aligned address
    assign instruction = memory[address[9:2]];

endmodule