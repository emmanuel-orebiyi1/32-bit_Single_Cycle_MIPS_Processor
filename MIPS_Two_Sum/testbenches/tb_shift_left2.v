`timescale 1ns/1ps

module tb_shift_left2;

    reg  [31:0] in;
    wire [31:0] out;

    shift_left2 uut (
        .in(in),
        .out(out)
    );

    initial begin
        $display("======================================");
        $display("      SHIFT LEFT 2 MODULE TEST START");
        $display("======================================");

        // Test 1: 1 << 2 = 4
        in = 32'h00000001;
        #10;

        if (out === 32'h00000004)
            $display("PASS: 00000001 << 2 = 00000004");
        else
            $display("ERROR: Expected 00000004, got %h", out);


        // Test 2: 4 << 2 = 16
        in = 32'h00000004;
        #10;

        if (out === 32'h00000010)
            $display("PASS: 00000004 << 2 = 00000010");
        else
            $display("ERROR: Expected 00000010, got %h", out);


        // Test 3: 0x0000000F << 2 = 0x0000003C
        in = 32'h0000000F;
        #10;

        if (out === 32'h0000003C)
            $display("PASS: 0000000F << 2 = 0000003C");
        else
            $display("ERROR: Expected 0000003C, got %h", out);


        // Test 4: Test a typical branch offset
        in = 32'h00000010;
        #10;

        if (out === 32'h00000040)
            $display("PASS: 00000010 << 2 = 00000040");
        else
            $display("ERROR: Expected 00000040, got %h", out);


        // Test 5: Upper bits / 32-bit behavior
        in = 32'h40000000;
        #10;

        if (out === 32'h00000000)
            $display("PASS: 40000000 << 2 = 00000000 (32-bit wraparound)");
        else
            $display("ERROR: Expected 00000000, got %h", out);


        $display("======================================");
        $display("      SHIFT LEFT 2 MODULE TEST COMPLETE");
        $display("======================================");

        $stop;
    end

endmodule