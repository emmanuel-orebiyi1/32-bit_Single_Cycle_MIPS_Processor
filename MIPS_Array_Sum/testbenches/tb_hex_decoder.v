`timescale 1ns/1ps

module tb_hex_decoder;

    reg  [31:0] value;

    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;
    wire [6:0] HEX6;
    wire [6:0] HEX7;

    // Instantiate HEX decoder
    hex_decoder DUT (
        .value(value),

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

        $display("====================================");
        $display("HEX DECODER TEST START");
        $display("====================================");

        // Test 1: All zeros
        value = 32'h00000000;
        #10;

        $display("TEST 1: value = %h", value);
        $display("HEX7 HEX6 HEX5 HEX4 HEX3 HEX2 HEX1 HEX0");
        $display(" %h   %h   %h   %h   %h   %h   %h   %h",
                 HEX7, HEX6, HEX5, HEX4,
                 HEX3, HEX2, HEX1, HEX0);

        // Test 2: 12345678
        value = 32'h12345678;
        #10;

        $display("");
        $display("TEST 2: value = %h", value);
        $display("Expected digits: 1 2 3 4 5 6 7 8");
        $display("HEX7 HEX6 HEX5 HEX4 HEX3 HEX2 HEX1 HEX0");
        $display(" %h   %h   %h   %h   %h   %h   %h   %h",
                 HEX7, HEX6, HEX5, HEX4,
                 HEX3, HEX2, HEX1, HEX0);

        // Test 3: ABCDEF01
        value = 32'hABCDEF01;
        #10;

        $display("");
        $display("TEST 3: value = %h", value);
        $display("Expected digits: A B C D E F 0 1");
        $display("HEX7 HEX6 HEX5 HEX4 HEX3 HEX2 HEX1 HEX0");
        $display(" %h   %h   %h   %h   %h   %h   %h   %h",
                 HEX7, HEX6, HEX5, HEX4,
                 HEX3, HEX2, HEX1, HEX0);

        // Test 4: FFFFFFFF
        value = 32'hFFFFFFFF;
        #10;

        $display("");
        $display("TEST 4: value = %h", value);
        $display("Expected digits: F F F F F F F F");
        $display("HEX7 HEX6 HEX5 HEX4 HEX3 HEX2 HEX1 HEX0");
        $display(" %h   %h   %h   %h   %h   %h   %h   %h",
                 HEX7, HEX6, HEX5, HEX4,
                 HEX3, HEX2, HEX1, HEX0);

        // Test 5: 00000001
        value = 32'h00000001;
        #10;

        $display("");
        $display("TEST 5: value = %h", value);
        $display("Expected digits: 0 0 0 0 0 0 0 1");
        $display("HEX7 HEX6 HEX5 HEX4 HEX3 HEX2 HEX1 HEX0");
        $display(" %h   %h   %h   %h   %h   %h   %h   %h",
                 HEX7, HEX6, HEX5, HEX4,
                 HEX3, HEX2, HEX1, HEX0);

        $display("");
        $display("====================================");
        $display("HEX DECODER TEST COMPLETE");
        $display("====================================");

        #10;
        $stop;

    end

endmodule