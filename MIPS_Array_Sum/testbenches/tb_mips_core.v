`timescale 1ns/1ps

module tb_mips_core;

    // =========================================================
    // CLOCK AND RESET
    // =========================================================

    reg clk;
    reg reset;


    // =========================================================
    // INSTRUCTION MEMORY INTERFACE
    // =========================================================

    wire [31:0] imem_address;
    wire [31:0] imem_instruction;


    // =========================================================
    // DATA MEMORY INTERFACE
    // =========================================================

    wire [31:0] dmem_address;
    wire [31:0] dmem_write_data;
    reg  [31:0] dmem_read_data;

    wire MemRead;
    wire MemWrite;


    // =========================================================
    // MIPS CORE
    // =========================================================

    mips_core DUT (
        .clk              (clk),
        .reset            (reset),

        .imem_address     (imem_address),
        .imem_instruction (imem_instruction),

        .dmem_address     (dmem_address),
        .dmem_write_data  (dmem_write_data),
        .dmem_read_data   (dmem_read_data),

        .MemRead          (MemRead),
        .MemWrite         (MemWrite)
    );


    // =========================================================
    // SIMPLE INSTRUCTION MEMORY FOR TESTING
    // =========================================================

    reg [31:0] instruction_memory [0:31];

    assign imem_instruction = instruction_memory[imem_address[6:2]];


    // =========================================================
    // SIMPLE DATA MEMORY FOR TESTING
    // =========================================================

    reg [31:0] data_memory [0:31];

    integer i;

    always @(*) begin

        if (MemRead)
            dmem_read_data = data_memory[dmem_address[6:2]];
        else
            dmem_read_data = 32'h00000000;

    end


    always @(posedge clk) begin

        if (MemWrite)
            data_memory[dmem_address[6:2]] <= dmem_write_data;

    end


    // =========================================================
    // CLOCK GENERATION
    // 20 ns period = 50 MHz
    // =========================================================

    initial begin
        clk = 1'b0;

        forever #10 clk = ~clk;
    end


    // =========================================================
    // TEST PROGRAM
    // =========================================================

    initial begin

        // Initialize memories
        for (i = 0; i < 32; i = i + 1) begin
            instruction_memory[i] = 32'h00000000;
            data_memory[i] = 32'h00000000;
        end


        // -----------------------------------------------------
        // Program
        //
        // addi $t0, $zero, 5
        // addi $t1, $zero, 10
        // add  $t2, $t0, $t1
        // sw   $t2, 0($zero)
        // lw   $t3, 0($zero)
        // -----------------------------------------------------

        instruction_memory[0] = 32'h20080005;
        instruction_memory[1] = 32'h2009000A;
        instruction_memory[2] = 32'h01095020;
        instruction_memory[3] = 32'hAC0A0000;
        instruction_memory[4] = 32'h8C0B0000;

        // NOP
        instruction_memory[5] = 32'h00000000;


        // -----------------------------------------------------
        // RESET
        // -----------------------------------------------------

        reset = 1'b1;

        #25;

        reset = 1'b0;


        // -----------------------------------------------------
        // RUN PROGRAM
        // -----------------------------------------------------

        #150;


        // -----------------------------------------------------
        // DISPLAY RESULTS
        // -----------------------------------------------------

        $display("==============================================");
        $display("       MIPS CORE TESTBENCH RESULTS");
        $display("==============================================");

        $display("Register $t0 = %h", DUT.DATAPATH.REGFILE.registers[8]);
        $display("Register $t1 = %h", DUT.DATAPATH.REGFILE.registers[9]);
        $display("Register $t2 = %h", DUT.DATAPATH.REGFILE.registers[10]);
        $display("Register $t3 = %h", DUT.DATAPATH.REGFILE.registers[11]);

        $display("Memory[0]   = %h", data_memory[0]);

        $display("==============================================");


        // -----------------------------------------------------
        // CHECK EXPECTED RESULTS
        // -----------------------------------------------------

        if (DUT.DATAPATH.REGFILE.registers[8] == 32'd5)
            $display("PASS: ADDI $t0 = 5");
        else
            $display("FAIL: ADDI $t0");

        if (DUT.DATAPATH.REGFILE.registers[9] == 32'd10)
            $display("PASS: ADDI $t1 = 10");
        else
            $display("FAIL: ADDI $t1");

        if (DUT.DATAPATH.REGFILE.registers[10] == 32'd15)
            $display("PASS: ADD $t2 = 15");
        else
            $display("FAIL: ADD $t2");

        if (data_memory[0] == 32'd15)
            $display("PASS: SW stored 15");
        else
            $display("FAIL: SW");

        if (DUT.DATAPATH.REGFILE.registers[11] == 32'd15)
            $display("PASS: LW loaded 15");
        else
            $display("FAIL: LW");


        $display("==============================================");

        #20;

        $stop;

    end

endmodule