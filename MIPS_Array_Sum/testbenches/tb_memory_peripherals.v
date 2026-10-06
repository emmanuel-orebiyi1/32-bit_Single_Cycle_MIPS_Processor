`timescale 1ns/1ps

//=============================================================================
// memory_peripherals_tb.v
// Testbench for Subgroup C memory + peripheral integration
//=============================================================================

module tb_memory_peripherals;

    reg         clk;
    reg         reset;

    reg  [31:0] address;
    reg         MemRead;
    reg         MemWrite;
    reg  [31:0] write_data;

    wire [31:0] read_data;

    reg  [17:0] SW;
    wire [17:0] LEDR;

    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;
    wire [6:0] HEX6;
    wire [6:0] HEX7;

    memory_peripherals DUT (
        .clk(clk),
        .reset(reset),

        .address(address),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .write_data(write_data),
        .read_data(read_data),

        .SW(SW),

        .LEDR(LEDR),

        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7)
    );

    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    initial begin

        reset      = 1'b0;
        address    = 32'h00000000;
        MemRead    = 1'b0;
        MemWrite   = 1'b0;
        write_data = 32'h00000000;
        SW         = 18'b0;

        $display("==============================================");
        $display("SUBGROUP C MEMORY + PERIPHERALS TEST START");
        $display("==============================================");

        #10;

        if (LEDR === 18'b0)
            $display("PASS: Initial LEDs are OFF");
        else
            $display("FAIL: Initial LEDs = %h", LEDR);

        $display("");
        $display("TEST 2: Data RAM WRITE");

        address    = 32'h00000000;
        write_data = 32'h12345678;
        MemWrite   = 1'b1;

        #10;

        MemWrite = 1'b0;

        $display("RAM WRITE: Address = 0x00000000");
        $display("           Data    = 0x12345678");

        $display("");
        $display("TEST 3: Data RAM READ");

        address = 32'h00000000;
        MemRead = 1'b1;

        #1;

        if (read_data === 32'h12345678)
            $display("PASS: RAM read returned 0x12345678");
        else
            $display("FAIL: RAM read returned 0x%h", read_data);

        MemRead = 1'b0;

        $display("");
        $display("TEST 4: Multiple RAM locations");

        address    = 32'h00000004;
        write_data = 32'hAABBCCDD;
        MemWrite   = 1'b1;

        #10;

        address    = 32'h00000008;
        write_data = 32'hDEADBEEF;

        #10;

        MemWrite = 1'b0;

        address = 32'h00000004;
        MemRead = 1'b1;

        #1;

        if (read_data === 32'hAABBCCDD)
            $display("PASS: RAM[0x04] = 0xAABBCCDD");
        else
            $display("FAIL: RAM[0x04] = 0x%h", read_data);

        address = 32'h00000008;

        #1;

        if (read_data === 32'hDEADBEEF)
            $display("PASS: RAM[0x08] = 0xDEADBEEF");
        else
            $display("FAIL: RAM[0x08] = 0x%h", read_data);

        MemRead = 1'b0;

        $display("");
        $display("TEST 5: SWITCH INPUT PERIPHERAL");

        SW = 18'b101010101010101010;

        address = 32'hFFFF0010;
        MemRead = 1'b1;

        #1;

        if (read_data === 32'h0002AAAA)
            $display("PASS: SW read = 0x%08h", read_data);
        else
            $display("FAIL: SW read = 0x%08h", read_data);

        MemRead = 1'b0;

        $display("");
        $display("TEST 6: LED OUTPUT PERIPHERAL");

        address    = 32'hFFFF0000;
        write_data = 32'h00015555;
        MemWrite   = 1'b1;

        #10;

        MemWrite = 1'b0;

        if (LEDR === 18'h15555)
            $display("PASS: LEDR = 0x%05h", LEDR);
        else
            $display("FAIL: LEDR = 0x%05h", LEDR);

        $display("");
        $display("TEST 7: LED READBACK");

        address = 32'hFFFF0000;
        MemRead = 1'b1;

        #1;

        if (read_data === 32'h00015555)
            $display("PASS: LED readback = 0x%08h", read_data);
        else
            $display("FAIL: LED readback = 0x%08h", read_data);

        MemRead = 1'b0;

        $display("");
        $display("TEST 8: HEX OUTPUT PERIPHERAL");

        address    = 32'hFFFF0004;
        write_data = 32'h1234ABCD;
        MemWrite   = 1'b1;

        #10;

        MemWrite = 1'b0;

        $display("HEX register written with 0x1234ABCD");

        $display("");
        $display("TEST 9: HEX READBACK");

        address = 32'hFFFF0004;
        MemRead = 1'b1;

        #1;

        if (read_data === 32'h1234ABCD)
            $display("PASS: HEX readback = 0x%08h", read_data);
        else
            $display("FAIL: HEX readback = 0x%08h", read_data);

        MemRead = 1'b0;

        $display("");
        $display("TEST 10: INVALID I/O ADDRESS");

        address    = 32'hFFFF0020;
        write_data = 32'hCAFEBABE;
        MemWrite   = 1'b1;

        #10;

        MemWrite = 1'b0;

        address = 32'h00000000;
        MemRead = 1'b1;

        #1;

        if (read_data === 32'h12345678)
            $display("PASS: Invalid I/O address did not corrupt RAM");
        else
            $display("FAIL: RAM corrupted = 0x%08h", read_data);

        MemRead = 1'b0;

        $display("");
        $display("TEST 11: NO-WRITE CONDITION");

        address    = 32'hFFFF0000;
        write_data = 32'h00000000;
        MemWrite   = 1'b0;

        #10;

        if (LEDR === 18'h15555)
            $display("PASS: LED value held when MemWrite = 0");
        else
            $display("FAIL: LED changed unexpectedly = 0x%05h", LEDR);

        $display("");
        $display("TEST 12: SWITCH INPUT CHANGE");

        SW = 18'b111111111111111111;

        address = 32'hFFFF0010;
        MemRead = 1'b1;

        #1;

        if (read_data === 32'h0003FFFF)
            $display("PASS: All switches ON -> 0x%08h", read_data);
        else
            $display("FAIL: Switch read = 0x%08h", read_data);

        MemRead = 1'b0;

        $display("");
        $display("==============================================");
        $display("SUBGROUP C MEMORY + PERIPHERALS TEST COMPLETE");
        $display("==============================================");

        #10;

        $stop;

    end

endmodule