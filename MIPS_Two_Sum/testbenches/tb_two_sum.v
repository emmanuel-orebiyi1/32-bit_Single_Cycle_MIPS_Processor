`timescale 1ns/1ps

//=============================================================================
// tb_two_sum.v
// Testbench for MIPS-Based Two Sum Solver
//
// Array:
// [2, 7, 11, 15, 3, 6, 8, 10]
//
// Peripheral mapping:
// FFFF0010 -> Target input
// FFFF0008 -> Result i
// FFFF000C -> Result j
// FFFF0000 -> Success LED
//
// Expected FIRST matching pairs:
// Target 9  -> [0,1]   => 2 + 7  = 9
// Target 17 -> [0,3]   => 2 + 15 = 17
// Target 14 -> [2,4]   => 11 + 3 = 14
// Target 21 -> [2,7]   => 11 + 10 = 21
//=============================================================================

module tb_two_sum;

    //=========================================================================
    // CLOCK AND RESET
    //=========================================================================

    reg CLOCK_50;
    reg KEY0;
    reg [17:0] SW;

    //=========================================================================
    // OUTPUTS
    //=========================================================================

    wire [17:0] LEDR;

    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;
    wire [6:0] HEX6;
    wire [6:0] HEX7;

    //=========================================================================
    // DEVICE UNDER TEST
    //=========================================================================

    fpga_top dut (
        .CLOCK_50(CLOCK_50),
        .KEY0(KEY0),
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

    //=========================================================================
    // CLOCK
    //=========================================================================

    initial begin
        CLOCK_50 = 1'b0;

        forever #10 CLOCK_50 = ~CLOCK_50;
    end

    //=========================================================================
    // TEST VARIABLES
    //=========================================================================

    integer pass_count;
    integer fail_count;
    integer tests_executed;

    integer expected_i;
    integer expected_j;

    integer actual_i;
    integer actual_j;

    integer array_value_i;
    integer array_value_j;
    integer calculated_sum;

    //=========================================================================
    // ARRAY USED BY THE TESTBENCH FOR MATHEMATICAL VALIDATION
    //=========================================================================

    integer test_array [0:7];

    //=========================================================================
    // INITIALIZATION
    //=========================================================================

    initial begin

        // Initialize counters
        pass_count   = 0;
        fail_count   = 0;
        tests_executed = 0;

        // Initialize array
        test_array[0] = 2;
        test_array[1] = 7;
        test_array[2] = 11;
        test_array[3] = 15;
        test_array[4] = 3;
        test_array[5] = 6;
        test_array[6] = 8;
        test_array[7] = 10;

        // Initialize switches
        SW = 18'b0;

        // Hold processor in reset
        KEY0 = 1'b0;

        $display("");
        $display("==============================================================");
        $display("        MIPS TWO SUM FPGA TESTBENCH");
        $display("==============================================================");

        #100;

        // Release reset
        KEY0 = 1'b1;

        #100;

        display_array;

        //=====================================================================
        // TEST 1
        //=====================================================================

        $display("");
        $display("--------------------------------------------------------------");
        $display("TEST 1: TARGET = 9");
        $display("Expected pair = [0,1]");
        $display("2 + 7 = 9");
        $display("--------------------------------------------------------------");

        set_target(9);

        #20_000;

        check_result(9, 0, 1);
        check_pair_sum(0, 1, 9);

        //=====================================================================
        // TEST 2
        //=====================================================================

        $display("");
        $display("--------------------------------------------------------------");
        $display("TEST 2: TARGET = 17");
        $display("Expected pair = [0,3]");
        $display("2 + 15 = 17");
        $display("--------------------------------------------------------------");

        set_target(17);

        #20_000;

        check_result(17, 0, 3);
        check_pair_sum(0, 3, 17);

        //=====================================================================
        // TEST 3
        //=====================================================================

        $display("");
        $display("--------------------------------------------------------------");
        $display("TEST 3: TARGET = 14");
        $display("Expected pair = [2,4]");
        $display("11 + 3 = 14");
        $display("--------------------------------------------------------------");

        set_target(14);

        #20_000;

        check_result(14, 2, 4);
        check_pair_sum(2, 4, 14);

        //=====================================================================
        // TEST 4
        //=====================================================================

        $display("");
        $display("--------------------------------------------------------------");
        $display("TEST 4: TARGET = 21");
        $display("Expected pair = [2,7]");
        $display("11 + 10 = 21");
        $display("--------------------------------------------------------------");

        set_target(21);

        #20_000;

        check_result(21, 2, 7);
        check_pair_sum(2, 7, 21);

        //=====================================================================
        // FINAL SUMMARY
        //=====================================================================

        #1000;

        $display("");
        $display("==============================================================");
        $display("                  TWO SUM TEST SUMMARY");
        $display("==============================================================");

        $display("");
        $display("Tests executed = %0d", tests_executed);
        $display("PASS count     = %0d", pass_count);
        $display("FAIL count     = %0d", fail_count);

        $display("");
        $display("Expected array:");
        $display("[2, 7, 11, 15, 3, 6, 8, 10]");

        $display("");
        $display("Test cases:");
        $display("9  -> [0,1]");
        $display("17 -> [0,3]");
        $display("14 -> [2,4]");
        $display("21 -> [2,7]");

        $display("");

        if (fail_count == 0) begin
            $display("==============================================================");
            $display("             TWO SUM TEST PASSED");
            $display("==============================================================");
        end
        else begin
            $display("==============================================================");
            $display("             TWO SUM TEST FAILED");
            $display("==============================================================");
        end

        $display("");

        #1000;

        $stop;

    end

    //=========================================================================
    // TASK: RESET PROCESSOR
    //=========================================================================

    task reset_processor;
    begin

        $display("");
        $display("[RESET] Resetting processor...");

        KEY0 = 1'b0;

        #200;

        KEY0 = 1'b1;

        #200;

        $display("[RESET] Processor released from reset.");

    end
    endtask

    //=========================================================================
    // TASK: SET TARGET
    //=========================================================================

    task set_target;
        input integer target;

        begin

            $display("");
            $display("[INPUT] Setting target = %0d", target);

            // Target uses SW[7:0]
            SW[7:0] = target[7:0];

            // Clear unused switches
            SW[17:8] = 10'b0;

            // Reset processor so program reads the new target
            KEY0 = 1'b0;

            #200;

            KEY0 = 1'b1;

            $display("[INPUT] Target %0d loaded.", target);

        end
    endtask

    //=========================================================================
    // TASK: DISPLAY ARRAY
    //=========================================================================

    task display_array;
    begin

        $display("");
        $display("[ARRAY] Preloaded data memory:");
        $display("array[0] = %0d", test_array[0]);
        $display("array[1] = %0d", test_array[1]);
        $display("array[2] = %0d", test_array[2]);
        $display("array[3] = %0d", test_array[3]);
        $display("array[4] = %0d", test_array[4]);
        $display("array[5] = %0d", test_array[5]);
        $display("array[6] = %0d", test_array[6]);
        $display("array[7] = %0d", test_array[7]);

    end
    endtask

    //=========================================================================
    // TASK: CHECK RESULT
    //
    // Result registers:
    // FFFF0008 -> i
    // FFFF000C -> j
    //
    // The current implementation stores the final result in:
    // $t6 = register 14
    // $t7 = register 15
    //=========================================================================

    task check_result;
        input integer target;
        input integer exp_i;
        input integer exp_j;

        begin

            tests_executed = tests_executed + 1;

            // Read result registers
            actual_i = dut.u_mips_core.DATAPATH.REG_FILE.registers[14];
            actual_j = dut.u_mips_core.DATAPATH.REG_FILE.registers[15];

            expected_i = exp_i;
            expected_j = exp_j;

            $display("");
            $display("[RESULT CHECK]");
            $display("Target       = %0d", target);
            $display("Expected i   = %0d", expected_i);
            $display("Actual i     = %0d", actual_i);
            $display("Expected j   = %0d", expected_j);
            $display("Actual j     = %0d", actual_j);

            if ((actual_i == expected_i) &&
                (actual_j == expected_j)) begin

                $display("RESULT CHECK : PASS");

                pass_count = pass_count + 1;

            end
            else begin

                $display("RESULT CHECK : FAIL");

                fail_count = fail_count + 1;

            end

        end
    endtask

    //=========================================================================
    // TASK: CHECK PAIR SUM
    //=========================================================================

    task check_pair_sum;
        input integer index_i;
        input integer index_j;
        input integer target;

        begin

            array_value_i = test_array[index_i];
            array_value_j = test_array[index_j];

            calculated_sum = array_value_i + array_value_j;

            $display("");
            $display("[PAIR CHECK]");
            $display("array[%0d] = %0d", index_i, array_value_i);
            $display("array[%0d] = %0d", index_j, array_value_j);
            $display("%0d + %0d = %0d",
                     array_value_i,
                     array_value_j,
                     calculated_sum);
            $display("Target = %0d", target);

            if (calculated_sum == target) begin

                $display("PAIR MATHEMATICAL CHECK : PASS");

                pass_count = pass_count + 1;

            end
            else begin

                $display("PAIR MATHEMATICAL CHECK : FAIL");

                fail_count = fail_count + 1;

            end

        end
    endtask

    //=========================================================================
    // TASK: DISPLAY HEX OUTPUT
    //=========================================================================

    task display_hex_output;
    begin

        $display("");
        $display("[HEX OUTPUT]");
        $display("HEX7 = %b", HEX7);
        $display("HEX6 = %b", HEX6);
        $display("HEX5 = %b", HEX5);
        $display("HEX4 = %b", HEX4);
        $display("HEX3 = %b", HEX3);
        $display("HEX2 = %b", HEX2);
        $display("HEX1 = %b", HEX1);
        $display("HEX0 = %b", HEX0);

    end
    endtask

    //=========================================================================
    // OPTIONAL PROCESSOR MONITOR
    //
    // This displays useful MIPS state periodically.
    //=========================================================================

    always @(posedge CLOCK_50) begin

        if (KEY0) begin

            if ((dut.u_mips_core.DATAPATH.pc % 4) == 0) begin

                // Uncomment if detailed monitoring is required:
                //
                // $display("[STATE] PC = 0x%08h | i = %0d | j = %0d",
                //          dut.u_mips_core.DATAPATH.pc,
                //          dut.u_mips_core.DATAPATH.REG_FILE.registers[19],
                //          dut.u_mips_core.DATAPATH.REG_FILE.registers[20]);

            end

        end

    end

endmodule