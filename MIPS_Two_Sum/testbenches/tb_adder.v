`timescale 1ns/1ps

module tb_adder;

    reg  [31:0] in0;
    reg  [31:0] in1;
    wire [31:0] out;

    // Instantiate the adder
    adder uut (
        .in0(in0),
        .in1(in1),
        .out(out)
    );

    initial begin
        $display("======================================");
        $display("        ADDER MODULE TEST START");
        $display("======================================");

        // Test 1
        in0 = 32'd10;
        in1 = 32'd20;
        #10;

        if (out === 32'd30)
            $display("PASS: 10 + 20 = %d", out);
        else
            $display("ERROR: 10 + 20 = %d", out);

        // Test 2
        in0 = 32'h00000004;
        in1 = 32'h00000004;
        #10;

        if (out === 32'h00000008)
            $display("PASS: 0x00000004 + 0x00000004 = %h", out);
        else
            $display("ERROR: Expected 00000008, got %h", out);

        // Test 3
        in0 = 32'hFFFFFFFF;
        in1 = 32'h00000001;
        #10;

        if (out === 32'h00000000)
            $display("PASS: FFFFFFFF + 1 = 00000000 (32-bit wraparound)");
        else
            $display("ERROR: Expected 00000000, got %h", out);

        // Test 4
        in0 = 32'h12345678;
        in1 = 32'h11111111;
        #10;

        if (out === 32'h23456789)
            $display("PASS: 12345678 + 11111111 = 23456789");
        else
            $display("ERROR: Expected 23456789, got %h", out);

        $display("======================================");
        $display("        ADDER MODULE TEST COMPLETE");
        $display("======================================");

        $stop;
    end

endmodule