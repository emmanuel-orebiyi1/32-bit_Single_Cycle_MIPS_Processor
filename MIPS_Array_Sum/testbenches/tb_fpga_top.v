`timescale 1ns/1ps

module tb_fpga_top;

    // ============================================================
    // FPGA TOP TESTBENCH
    // Tests:
    // 1. Reset
    // 2. Instruction fetch
    // 3. Switch/array reads
    // 4. ADD operation
    // 5. Six loop iterations
    // 6. Branch operation
    // 7. Final result
    // 8. HEX output write
    // ============================================================

    reg CLOCK_50;
    reg KEY0;
    reg [17:0] SW;

    wire [17:0] LEDR;

    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;
    wire [6:0] HEX6;
    wire [6:0] HEX7;


    // ============================================================
    // DEVICE UNDER TEST
    // ============================================================

    fpga_top dut (
        .CLOCK_50 (CLOCK_50),
        .KEY0     (KEY0),
        .SW       (SW),

        .LEDR     (LEDR),

        .HEX0     (HEX0),
        .HEX1     (HEX1),
        .HEX2     (HEX2),
        .HEX3     (HEX3),
        .HEX4     (HEX4),
        .HEX5     (HEX5),
        .HEX6     (HEX6),
        .HEX7     (HEX7)
    );


    // ============================================================
    // CLOCK
    // 50 MHz clock
    // Period = 20 ns
    // ============================================================

    initial begin
        CLOCK_50 = 1'b0;

        forever #10 CLOCK_50 = ~CLOCK_50;
    end


    // ============================================================
    // TEST VARIABLES
    // ============================================================

    integer expected_sum;
    integer read_count;
    integer add_count;
    integer pass_count;
    integer fail_count;

    reg [31:0] previous_sum;


    // ============================================================
    // TEST INPUT
    // ============================================================

    initial begin

        // --------------------------------------------------------
        // Initial values
        // --------------------------------------------------------

        SW = 18'b0;

        read_count  = 0;
        add_count   = 0;
        pass_count  = 0;
        fail_count  = 0;

        previous_sum = 32'd0;

        expected_sum = 1 + 2 + 3 + 4 + 5 + 6;


        // --------------------------------------------------------
        // Six array values
        // --------------------------------------------------------

        SW[2:0]   = 3'd1;
        SW[5:3]   = 3'd2;
        SW[8:6]   = 3'd3;
        SW[11:9]  = 3'd4;
        SW[14:12] = 3'd5;
        SW[17:15] = 3'd6;


        // --------------------------------------------------------
        // Apply reset
        // KEY0 is active-low
        // --------------------------------------------------------

        KEY0 = 1'b0;


        // ========================================================
        // TEST HEADER
        // ========================================================

        $display("");
        $display("============================================================");
        $display("                 MIPS FPGA TESTBENCH");
        $display("============================================================");

        $display("");
        $display("INPUT VALUES");
        $display("------------");

        $display("Array[0] = %0d", SW[2:0]);
        $display("Array[1] = %0d", SW[5:3]);
        $display("Array[2] = %0d", SW[8:6]);
        $display("Array[3] = %0d", SW[11:9]);
        $display("Array[4] = %0d", SW[14:12]);
        $display("Array[5] = %0d", SW[17:15]);

        $display("");
        $display("Expected total = %0d", expected_sum);
        $display("Expected HEX   = 0x%02h", expected_sum);

        $display("");
        $display("RESET: ACTIVE");


        // --------------------------------------------------------
        // Hold reset for 3 clock cycles
        // --------------------------------------------------------

        repeat (3) @(posedge CLOCK_50);

        KEY0 = 1'b1;

        $display("");
        $display("RESET: RELEASED");
        $display("PROCESSOR: RUNNING");

        $display("");
        $display("============================================================");
        $display("                 PROCESSOR EXECUTION");
        $display("============================================================");
        $display("");


        // --------------------------------------------------------
        // Allow processor to execute
        // --------------------------------------------------------

        repeat (150) @(posedge CLOCK_50);


        // ========================================================
        // FINAL CHECK
        // ========================================================

        $display("");
        $display("============================================================");
        $display("                  FINAL RESULT CHECK");
        $display("============================================================");


        // --------------------------------------------------------
        // Check $t2
        // --------------------------------------------------------

        $display("");
        $display("$t2 = %0d (0x%08h)",
                 dut.u_mips_core.DATAPATH.REG_FILE.registers[10],
                 dut.u_mips_core.DATAPATH.REG_FILE.registers[10]);


        if (dut.u_mips_core.DATAPATH.REG_FILE.registers[10]
            == expected_sum) begin

            $display("FINAL SUM CHECK : PASS");

            pass_count = pass_count + 1;

        end
        else begin

            $display("FINAL SUM CHECK : FAIL");

            $display("Expected = %0d", expected_sum);

            $display("Actual   = %0d",
                     dut.u_mips_core.DATAPATH.REG_FILE.registers[10]);

            fail_count = fail_count + 1;

        end


        // ========================================================
        // CHECK HEX OUTPUT
        // ========================================================

        $display("");
        $display("HEX OUTPUT");
        $display("----------");

        $display("HEX0 = %b", HEX0);
        $display("HEX1 = %b", HEX1);


        // --------------------------------------------------------
        // For result 21 = 0x15:
        //
        // HEX0 should display 5
        // HEX1 should display 1
        //
        // Active-low seven-segment:
        //
        // 5 = 0100100
        // 1 = 1111001
        // --------------------------------------------------------

		if (HEX0 == 7'b0010010 &&
			HEX1 == 7'b1111001) begin

			$display("HEX OUTPUT CHECK : PASS");
			$display("HEX1 HEX0 = 15");

			pass_count = pass_count + 1;

		end
		else begin

			$display("HEX OUTPUT CHECK : FAIL");
			$display("Expected HEX1 HEX0 = 15");
			$display("Actual HEX0 = %b", HEX0);
			$display("Actual HEX1 = %b", HEX1);

			fail_count = fail_count + 1;

		end



        // ========================================================
        // SUMMARY
        // ========================================================

        $display("");
        $display("============================================================");
        $display("                    TEST SUMMARY");
        $display("============================================================");

        $display("Array reads detected = %0d", read_count);

        $display("ADD operations detected = %0d", add_count);

        $display("PASS count = %0d", pass_count);

        $display("FAIL count = %0d", fail_count);


        if (fail_count == 0) begin

            $display("");
            $display("****************************************************");
            $display("*                                                  *");
            $display("*              ALL TESTS PASSED                   *");
            $display("*                                                  *");
            $display("*       1 + 2 + 3 + 4 + 5 + 6 = 21               *");
            $display("*                                                  *");
            $display("****************************************************");

        end
        else begin

            $display("");
            $display("****************************************************");
            $display("*                                                  *");
            $display("*              TEST FAILED                        *");
            $display("*                                                  *");
            $display("****************************************************");

        end


        $display("");

        $stop;

    end


    // ============================================================
    // INSTRUCTION MONITOR
    // ============================================================

    always @(posedge CLOCK_50) begin

        if (KEY0 == 1'b1) begin

            #1;

            case (dut.u_mips_core.DATAPATH.pc)

                // ------------------------------------------------
                // Program initialization
                // ------------------------------------------------

                32'h00000000:
                    $display(
                        "[FETCH] PC=0x00000000  LUI  $t0,0xFFFF"
                    );

                32'h00000004:
                    $display(
                        "[FETCH] PC=0x00000004  ORI  $t0,$t0,0x0020"
                    );

                32'h00000008:
                    $display(
                        "[FETCH] PC=0x00000008  ADDI $t2,$zero,0"
                    );

                32'h0000000C:
                    $display(
                        "[FETCH] PC=0x0000000C  ADDI $t3,$zero,6"
                    );


                // ------------------------------------------------
                // Array read
                // ------------------------------------------------

                32'h00000010: begin

                    $display("");
                    $display(
                        "[LOOP] PC=0x00000010  LW $t4,0($t0)"
                    );

                    $display(
                        "       Address = 0x%08h",
                        dut.u_mips_core.dmem_address
                    );

                    $display(
                        "       Read Data = %0d",
                        dut.u_mips_core.dmem_read_data
                    );

                end


                // ------------------------------------------------
                // ADD
                // ------------------------------------------------

                32'h00000014: begin

                    add_count = add_count + 1;

                    $display(
                        "[ADD] PC=0x00000014  ADD $t2,$t2,$t4"
                    );

                    $display(
                        "      Previous Sum = %0d",
                        previous_sum
                    );

                    $display(
                        "      Read Value   = %0d",
                        dut.u_mips_core.DATAPATH.REG_FILE.registers[12]
                    );

                    $display(
                        "      New Sum      = %0d",
                        dut.u_mips_core.DATAPATH.REG_FILE.registers[10]
                    );

                    previous_sum =
                        dut.u_mips_core.DATAPATH.REG_FILE.registers[10];

                end


                // ------------------------------------------------
                // Increment address
                // ------------------------------------------------

                32'h00000018:

                    $display(
                        "[FETCH] PC=0x00000018  ADDI $t0,$t0,4"
                    );


                // ------------------------------------------------
                // Decrement counter
                // ------------------------------------------------

                32'h0000001C:

                    $display(
                        "[FETCH] PC=0x0000001C  ADDI $t3,$t3,-1"
                    );


                // ------------------------------------------------
                // Branch
                // ------------------------------------------------

                32'h00000020: begin

                    $display("");
                    $display(
                        "[BRANCH] PC=0x00000020  BEQ $t3,$zero,2"
                    );

                    $display(
                        "         $t3 = %0d",
                        dut.u_mips_core.DATAPATH.REG_FILE.registers[11]
                    );

                    if (dut.u_mips_core.DATAPATH.REG_FILE.registers[11]
                        == 0) begin

                        $display(
                            "         Branch condition = TRUE"
                        );

                        $display(
                            "         Loop completed"
                        );

                    end
                    else begin

                        $display(
                            "         Branch condition = FALSE"
                        );

                        $display(
                            "         Continue loop"
                        );

                    end

                end


                // ------------------------------------------------
                // Jump back to array read
                // ------------------------------------------------

                32'h00000024:

                    $display(
                        "[JUMP] PC=0x00000024  J 0x00000010"
                    );


                // ------------------------------------------------
                // Build HEX output address
                // ------------------------------------------------

                32'h00000028:

                    $display(
                        "[OUTPUT] PC=0x00000028  LUI $t0,0xFFFF"
                    );


                32'h0000002C:

                    $display(
                        "[OUTPUT] PC=0x0000002C  ORI $t0,$t0,0x0004"
                    );


                // ------------------------------------------------
                // Write final result
                // ------------------------------------------------

                32'h00000030: begin

                    $display("");
                    $display(
                        "[FINAL WRITE] PC=0x00000030  SW $t2,0($t0)"
                    );

                    $display(
                        "              Address = 0x%08h",
                        dut.u_mips_core.dmem_address
                    );

                    $display(
                        "              Data    = %0d",
                        dut.u_mips_core.dmem_write_data
                    );

                end


                // ------------------------------------------------
                // Infinite loop
                // ------------------------------------------------

                32'h00000034:

                    $display(
                        "[HALT] PC=0x00000034  J 0x00000034"
                    );

            endcase

        end

    end


    // ============================================================
    // ARRAY READ MONITOR
    // ============================================================

    always @(posedge CLOCK_50) begin

        if (KEY0 == 1'b1) begin

            #1;

            if (dut.u_mips_core.MemRead) begin

                if (
                    dut.u_mips_core.dmem_address == 32'hFFFF0020 ||
                    dut.u_mips_core.dmem_address == 32'hFFFF0024 ||
                    dut.u_mips_core.dmem_address == 32'hFFFF0028 ||
                    dut.u_mips_core.dmem_address == 32'hFFFF002C ||
                    dut.u_mips_core.dmem_address == 32'hFFFF0030 ||
                    dut.u_mips_core.dmem_address == 32'hFFFF0034
                ) begin

                    read_count = read_count + 1;

                    $display("");
                    $display(
                        "[ARRAY READ %0d]",
                        read_count
                    );

                    $display(
                        "Address = 0x%08h",
                        dut.u_mips_core.dmem_address
                    );

                    $display(
                        "Value   = %0d",
                        dut.u_mips_core.dmem_read_data
                    );


                    // --------------------------------------------
                    // Validate expected values
                    // --------------------------------------------

                    case (read_count)

                        1: begin
                            if (dut.u_mips_core.dmem_read_data == 1)
                                $display("Value CHECK: PASS");
                            else
                                $display("Value CHECK: FAIL");
                        end

                        2: begin
                            if (dut.u_mips_core.dmem_read_data == 2)
                                $display("Value CHECK: PASS");
                            else
                                $display("Value CHECK: FAIL");
                        end

                        3: begin
                            if (dut.u_mips_core.dmem_read_data == 3)
                                $display("Value CHECK: PASS");
                            else
                                $display("Value CHECK: FAIL");
                        end

                        4: begin
                            if (dut.u_mips_core.dmem_read_data == 4)
                                $display("Value CHECK: PASS");
                            else
                                $display("Value CHECK: FAIL");
                        end

                        5: begin
                            if (dut.u_mips_core.dmem_read_data == 5)
                                $display("Value CHECK: PASS");
                            else
                                $display("Value CHECK: FAIL");
                        end

                        6: begin

                            if (dut.u_mips_core.dmem_read_data == 6)
                                $display("Value CHECK: PASS");
                            else
                                $display("Value CHECK: FAIL");

                            $display("");
                            $display(
                                "=================================================="
                            );
                            $display(
                                "          FIRST ARRAY LOOP COMPLETED"
                            );
                            $display(
                                "=================================================="
                            );

                            $display(
                                "Six array values have been successfully read."
                            );

                        end

                    endcase

                end

            end

        end

    end


    // ============================================================
    // MEMORY WRITE MONITOR
    // ============================================================

    always @(posedge CLOCK_50) begin

        if (KEY0 == 1'b1) begin

            #1;

            if (dut.u_mips_core.MemWrite) begin

                $display("");
                $display(
                    "[MEM WRITE]"
                );

                $display(
                    "Address = 0x%08h",
                    dut.u_mips_core.dmem_address
                );

                $display(
                    "Data    = %0d",
                    dut.u_mips_core.dmem_write_data
                );


                if (
                    dut.u_mips_core.dmem_address
                    == 32'hFFFF0004
                ) begin

                    $display(
                        "HEX ADDRESS CHECK: PASS"
                    );


                    if (
                        dut.u_mips_core.dmem_write_data
                        == expected_sum
                    ) begin

                        $display(
                            "FINAL RESULT WRITE CHECK: PASS"
                        );

                    end
                    else begin

                        $display(
                            "FINAL RESULT WRITE CHECK: FAIL"
                        );

                    end

                end

            end

        end

    end

endmodule 