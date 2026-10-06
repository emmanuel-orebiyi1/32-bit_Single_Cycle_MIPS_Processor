`timescale 1ns / 1ps

module tb_sign_extend;

    reg  [15:0] immediate_in;
    wire [31:0] sign_extended_out;

    sign_extend uut (
        .immediate_in(immediate_in),
        .sign_extended_out(sign_extended_out)
    );

    task check_result;
        input [31:0] expected;
        input [127:0] test_name;

        begin
            #1;

            if (sign_extended_out === expected)
                $display("PASS: %s", test_name);
            else
                $display("FAIL: %s | Expected=%h Got=%h",
                         test_name, expected, sign_extended_out);
        end
    endtask

    initial begin

        $display("=== SIGN EXTEND TEST ===");

        // Positive value: 5
        immediate_in = 16'h0005;
        check_result(32'h00000005, "Positive 5");

        // Positive value: 0
        immediate_in = 16'h0000;
        check_result(32'h00000000, "Zero");

        // Maximum positive 16-bit value: 32767
        immediate_in = 16'h7FFF;
        check_result(32'h00007FFF, "Maximum positive");

        // Negative value: -1
        immediate_in = 16'hFFFF;
        check_result(32'hFFFFFFFF, "Negative -1");

        // Negative value: -2
        immediate_in = 16'hFFFE;
        check_result(32'hFFFFFFFE, "Negative -2");

        // Negative value: -32768
        immediate_in = 16'h8000;
        check_result(32'hFFFF8000, "Minimum negative");

        // General negative value
        immediate_in = 16'hF234;
        check_result(32'hFFFFF234, "General negative");

        $display("=== SIGN EXTEND TEST COMPLETE ===");

        $stop;
    end

endmodule