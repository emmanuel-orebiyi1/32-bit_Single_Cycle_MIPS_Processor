`timescale 1ns/1ps

module tb_data_memory;

    //=========================================================
    // Testbench signals
    //=========================================================
    reg         clk;
    reg         MemRead;
    reg         MemWrite;
    reg  [31:0] address;
    reg  [31:0] write_data;

    wire [31:0] read_data;

    //=========================================================
    // Instantiate Data Memory
    //=========================================================
    data_memory uut (
        .clk       (clk),
        .MemRead   (MemRead),
        .MemWrite  (MemWrite),
        .address   (address),
        .write_data(write_data),
        .read_data (read_data)
    );

    //=========================================================
    // Clock generation
    // 10 ns clock period
    //=========================================================
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    //=========================================================
    // Task: Write data to memory
    //=========================================================
    task write_memory;
        input [31:0] addr;
        input [31:0] data;

        begin
            address    = addr;
            write_data = data;
            MemWrite   = 1'b1;
            MemRead    = 1'b0;

            // Wait for rising edge
            @(posedge clk);
            #1;

            $display("WRITE: Address 0x%08h <- 0x%08h",
                     addr, data);

            MemWrite = 1'b0;
        end
    endtask

    //=========================================================
    // Task: Read and check memory
    //=========================================================
    task check_memory;
        input [31:0] addr;
        input [31:0] expected;

        begin
            address  = addr;
            MemRead  = 1'b1;
            MemWrite = 1'b0;

            #1;

            if (read_data === expected)
                $display("PASS: Address 0x%08h returned 0x%08h",
                         addr, read_data);
            else
                $display("ERROR: Address 0x%08h returned 0x%08h, expected 0x%08h",
                         addr, read_data, expected);
        end
    endtask

    //=========================================================
    // Main test
    //=========================================================
    initial begin

        $display("==============================================");
        $display("          DATA MEMORY TEST START");
        $display("==============================================");

        // Initial values
        address    = 32'h00000000;
        write_data = 32'h00000000;
        MemRead    = 1'b0;
        MemWrite   = 1'b0;

        #10;

        //=====================================================
        // TEST 1: Write values
        //=====================================================

        write_memory(32'h00000000, 32'h12345678);
        write_memory(32'h00000004, 32'hAABBCCDD);
        write_memory(32'h00000008, 32'hDEADBEEF);
        write_memory(32'h0000000C, 32'hCAFEBABE);

        //=====================================================
        // TEST 2: Read values back
        //=====================================================

        check_memory(32'h00000000, 32'h12345678);
        check_memory(32'h00000004, 32'hAABBCCDD);
        check_memory(32'h00000008, 32'hDEADBEEF);
        check_memory(32'h0000000C, 32'hCAFEBABE);

        //=====================================================
        // TEST 3: Check another unused address
        // It should still contain zero because of initialization
        //=====================================================

        check_memory(32'h00000010, 32'h00000000);

        //=====================================================
        // TEST COMPLETE
        //=====================================================

        $display("==============================================");
        $display("          DATA MEMORY TEST COMPLETE");
        $display("==============================================");

        $stop;
    end

endmodule