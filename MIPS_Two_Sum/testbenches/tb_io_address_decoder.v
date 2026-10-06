`timescale 1ns/1ps

//=============================================================================
// tb_io_address_decoder.v
// Testbench for Subgroup C I/O Address Decoder
//=============================================================================

module tb_io_address_decoder;

    //--------------------------------------------------------------------------
    // Inputs to DUT
    //--------------------------------------------------------------------------

    reg         MemRead;
    reg         MemWrite;
    reg  [31:0] address;

    reg  [31:0] mem_read_data;
    reg  [31:0] switch_data;
    reg  [17:0] led_reg;
    reg  [31:0] hex_reg;

    //--------------------------------------------------------------------------
    // Outputs from DUT
    //--------------------------------------------------------------------------

    wire        mem_MemRead;
    wire        mem_MemWrite;
    wire        led_write;
    wire        hex_write;

    wire [31:0] read_data;

    //--------------------------------------------------------------------------
    // Instantiate Device Under Test
    //--------------------------------------------------------------------------

    io_address_decoder uut (
        .MemRead      (MemRead),
        .MemWrite     (MemWrite),
        .address      (address),

        .mem_read_data(mem_read_data),
        .switch_data  (switch_data),
        .led_reg      (led_reg),
        .hex_reg      (hex_reg),

        .mem_MemRead  (mem_MemRead),
        .mem_MemWrite (mem_MemWrite),
        .led_write    (led_write),
        .hex_write    (hex_write),

        .read_data    (read_data)
    );

    //--------------------------------------------------------------------------
    // Test procedure
    //--------------------------------------------------------------------------

    initial begin

        $display("====================================================");
        $display("       I/O ADDRESS DECODER TEST START");
        $display("====================================================");

        // ---------------------------------------------------------------
        // Initial values
        // ---------------------------------------------------------------

        MemRead       = 1'b0;
        MemWrite      = 1'b0;
        address       = 32'h00000000;

        mem_read_data = 32'h12345678;
        switch_data   = 32'h0002AAAA;
        led_reg       = 18'b101010101010101010;
        hex_reg       = 32'h89ABCDEF;

        #10;

        // ===============================================================
        // TEST 1: SWITCH INPUT
        // Address = 0xFFFF0010
        // Operation = lw
        // ===============================================================

        address  = 32'hFFFF0010;
        MemRead  = 1'b1;
        MemWrite = 1'b0;

        #1;

        if (mem_MemRead === 1'b0 &&
            mem_MemWrite === 1'b0 &&
            led_write === 1'b0 &&
            hex_write === 1'b0 &&
            read_data === switch_data) begin

            $display("PASS: SWITCH READ");
            $display("      Address    = 0x%08h", address);
            $display("      Read Data  = 0x%08h", read_data);

        end
        else begin

            $display("ERROR: SWITCH READ");
            $display("      mem_MemRead  = %b", mem_MemRead);
            $display("      mem_MemWrite = %b", mem_MemWrite);
            $display("      led_write    = %b", led_write);
            $display("      hex_write    = %b", hex_write);
            $display("      read_data    = 0x%08h", read_data);

        end


        // ===============================================================
        // TEST 2: LED OUTPUT
        // Address = 0xFFFF0000
        // Operation = sw
        // ===============================================================

        address  = 32'hFFFF0000;
        MemRead  = 1'b0;
        MemWrite = 1'b1;

        #1;

        if (mem_MemRead === 1'b0 &&
            mem_MemWrite === 1'b0 &&
            led_write === 1'b1 &&
            hex_write === 1'b0 &&
            read_data === {14'b0, led_reg}) begin

            $display("PASS: LED WRITE");
            $display("      Address    = 0x%08h", address);
            $display("      LED Write  = %b", led_write);

        end
        else begin

            $display("ERROR: LED WRITE");
            $display("      mem_MemRead  = %b", mem_MemRead);
            $display("      mem_MemWrite = %b", mem_MemWrite);
            $display("      led_write    = %b", led_write);
            $display("      hex_write    = %b", hex_write);

        end


        // ===============================================================
        // TEST 3: HEX OUTPUT
        // Address = 0xFFFF0004
        // Operation = sw
        // ===============================================================

        address  = 32'hFFFF0004;
        MemRead  = 1'b0;
        MemWrite = 1'b1;

        #1;

        if (mem_MemRead === 1'b0 &&
            mem_MemWrite === 1'b0 &&
            led_write === 1'b0 &&
            hex_write === 1'b1 &&
            read_data === hex_reg) begin

            $display("PASS: HEX WRITE");
            $display("      Address    = 0x%08h", address);
            $display("      HEX Write  = %b", hex_write);

        end
        else begin

            $display("ERROR: HEX WRITE");
            $display("      mem_MemRead  = %b", mem_MemRead);
            $display("      mem_MemWrite = %b", mem_MemWrite);
            $display("      led_write    = %b", led_write);
            $display("      hex_write    = %b", hex_write);

        end


        // ===============================================================
        // TEST 4: NORMAL DATA MEMORY READ
        // Address = 0x00000000
        // Operation = lw
        // ===============================================================

        address  = 32'h00000000;
        MemRead  = 1'b1;
        MemWrite = 1'b0;

        #1;

        if (mem_MemRead === 1'b1 &&
            mem_MemWrite === 1'b0 &&
            led_write === 1'b0 &&
            hex_write === 1'b0 &&
            read_data === mem_read_data) begin

            $display("PASS: DATA MEMORY READ");
            $display("      Address    = 0x%08h", address);
            $display("      Read Data  = 0x%08h", read_data);

        end
        else begin

            $display("ERROR: DATA MEMORY READ");
            $display("      mem_MemRead  = %b", mem_MemRead);
            $display("      mem_MemWrite = %b", mem_MemWrite);
            $display("      read_data    = 0x%08h", read_data);

        end


        // ===============================================================
        // TEST 5: NORMAL DATA MEMORY WRITE
        // Address = 0x00000004
        // Operation = sw
        // ===============================================================

        address  = 32'h00000004;
        MemRead  = 1'b0;
        MemWrite = 1'b1;

        #1;

        if (mem_MemRead === 1'b0 &&
            mem_MemWrite === 1'b1 &&
            led_write === 1'b0 &&
            hex_write === 1'b0) begin

            $display("PASS: DATA MEMORY WRITE");
            $display("      Address      = 0x%08h", address);
            $display("      mem_MemWrite = %b", mem_MemWrite);

        end
        else begin

            $display("ERROR: DATA MEMORY WRITE");
            $display("      mem_MemRead  = %b", mem_MemRead);
            $display("      mem_MemWrite = %b", mem_MemWrite);
            $display("      led_write    = %b", led_write);
            $display("      hex_write    = %b", hex_write);

        end


        // ===============================================================
        // TEST 6: INVALID I/O ADDRESS
        // Address = 0xFFFF0020
        // Operation = lw
        //
        // This is still inside the I/O page, so RAM must NOT be enabled.
        // ===============================================================

        address  = 32'hFFFF0020;
        MemRead  = 1'b1;
        MemWrite = 1'b0;

        #1;

        if (mem_MemRead === 1'b0 &&
            mem_MemWrite === 1'b0 &&
            led_write === 1'b0 &&
            hex_write === 1'b0) begin

            $display("PASS: INVALID I/O ADDRESS BLOCKS RAM");
            $display("      Address = 0x%08h", address);

        end
        else begin

            $display("ERROR: INVALID I/O ADDRESS");
            $display("      mem_MemRead  = %b", mem_MemRead);
            $display("      mem_MemWrite = %b", mem_MemWrite);
            $display("      led_write    = %b", led_write);
            $display("      hex_write    = %b", hex_write);

        end


        // ===============================================================
        // TEST 7: NO READ / NO WRITE
        // Normal memory address but both enables are LOW.
        // ===============================================================

        address  = 32'h00000008;
        MemRead  = 1'b0;
        MemWrite = 1'b0;

        #1;

        if (mem_MemRead === 1'b0 &&
            mem_MemWrite === 1'b0 &&
            led_write === 1'b0 &&
            hex_write === 1'b0) begin

            $display("PASS: NO MEMORY OR I/O OPERATION");

        end
        else begin

            $display("ERROR: NO-OP TEST FAILED");

        end


        // ===============================================================
        // TEST 8: READ FROM LED REGISTER
        // ===============================================================

        address  = 32'hFFFF0000;
        MemRead  = 1'b1;
        MemWrite = 1'b0;

        #1;

        if (read_data === {14'b0, led_reg}) begin

            $display("PASS: LED READBACK");
            $display("      Read Data = 0x%08h", read_data);

        end
        else begin

            $display("ERROR: LED READBACK");
            $display("      Read Data = 0x%08h", read_data);
            $display("      Expected  = 0x%08h", {14'b0, led_reg});

        end


        // ===============================================================
        // TEST 9: READ FROM HEX REGISTER
        // ===============================================================

        address  = 32'hFFFF0004;
        MemRead  = 1'b1;
        MemWrite = 1'b0;

        #1;

        if (read_data === hex_reg) begin

            $display("PASS: HEX READBACK");
            $display("      Read Data = 0x%08h", read_data);

        end
        else begin

            $display("ERROR: HEX READBACK");
            $display("      Read Data = 0x%08h", read_data);
            $display("      Expected  = 0x%08h", hex_reg);

        end


        // ===============================================================
        // TEST COMPLETE
        // ===============================================================

        $display("====================================================");
        $display("       I/O ADDRESS DECODER TEST COMPLETE");
        $display("====================================================");

        $stop;

    end

endmodule