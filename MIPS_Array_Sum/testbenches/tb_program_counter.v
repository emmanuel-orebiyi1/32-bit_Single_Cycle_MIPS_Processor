`timescale 1ns / 1ps

module tb_program_counter;

    reg clk;
    reg reset;
    reg [31:0] next_pc;
    wire [31:0] pc;

    program_counter uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        $display("=== PROGRAM COUNTER TEST ===");

        // Initial values
        clk = 0;
        reset = 1;
        next_pc = 32'h00000000;

        // First rising edge: reset must clear PC
        #5;
        #1;

        if (pc === 32'h00000000)
            $display("PASS: Reset sets PC to 0");
        else
            $display("FAIL: Reset PC = %h", pc);

        // Release reset AFTER the rising edge
        reset = 0;

        // Set next PC before next rising edge
        next_pc = 32'h00000004;

        #9;
        #1;

        if (pc === 32'h00000004)
            $display("PASS: PC updated to 0x00000004");
        else
            $display("FAIL: PC = %h", pc);

        // Next value
        next_pc = 32'h00000008;

        #10;
        #1;

        if (pc === 32'h00000008)
            $display("PASS: PC updated to 0x00000008");
        else
            $display("FAIL: PC = %h", pc);

        // Next value
        next_pc = 32'h00000020;

        #10;
        #1;

        if (pc === 32'h00000020)
            $display("PASS: PC updated to 0x00000020");
        else
            $display("FAIL: PC = %h", pc);

        $display("=== PROGRAM COUNTER TEST COMPLETE ===");

        $stop;
    end

endmodule