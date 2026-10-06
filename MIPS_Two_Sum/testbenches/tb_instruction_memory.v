`timescale 1ns/1ps

module tb_instruction_memory;

    reg  [31:0] address;
    wire [31:0] instruction;

    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    task check_instruction;
        input [31:0] addr;
        input [31:0] expected;
        begin
            address = addr;
            #10;

            if (instruction === expected)
                $display("PASS: Address 0x%08h returned %08h",
                         addr, instruction);
            else
                $display("ERROR: Address 0x%08h returned %08h, expected %08h",
                         addr, instruction, expected);
        end
    endtask

    initial begin

        $display("==============================================");
        $display("       INSTRUCTION MEMORY TEST START");
        $display("==============================================");

        check_instruction(32'h00000000, 32'h20080005);
        check_instruction(32'h00000004, 32'h2009000A);
        check_instruction(32'h00000008, 32'h01095020);
        check_instruction(32'h0000000C, 32'h00000000);

        $display("==============================================");
        $display("       INSTRUCTION MEMORY TEST COMPLETE");
        $display("==============================================");

        $stop;
    end

endmodule