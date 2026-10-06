`timescale 1ns/1ps

module tb_output_peripheral;

    // Testbench signals
    reg         clk;
    reg         led_write;
    reg         hex_write;
    reg  [31:0] write_data;

    wire [17:0] led_reg;
    wire [31:0] hex_reg;

    // Instantiate the Unit Under Test
    output_peripheral uut (
        .clk       (clk),
        .led_write (led_write),
        .hex_write (hex_write),
        .write_data(write_data),
        .led_reg   (led_reg),
        .hex_reg   (hex_reg)
    );

    //===========================================================
    // Clock generation
    // 10 ns clock period
    //===========================================================
    initial begin
        clk = 1'b0;

        forever #5 clk = ~clk;
    end

    //===========================================================
    // Test procedure
    //===========================================================
    initial begin

        $display("========================================");
        $display("OUTPUT PERIPHERAL TEST START");
        $display("========================================");

        // Initial conditions
        led_write  = 1'b0;
        hex_write  = 1'b0;
        write_data = 32'h00000000;

        #10;

        //=======================================================
        // TEST 1: Initial values
        //=======================================================
        if (led_reg === 18'b0)
            $display("PASS: Initial LED register = 0x%05h", led_reg);
        else
            $display("FAIL: Initial LED register = 0x%05h", led_reg);

        if (hex_reg === 32'h00000000)
            $display("PASS: Initial HEX register = 0x%08h", hex_reg);
        else
            $display("FAIL: Initial HEX register = 0x%08h", hex_reg);


        //=======================================================
        // TEST 2: Write to LED register
        //=======================================================
        write_data = 32'h12345678;
        led_write  = 1'b1;
        hex_write  = 1'b0;

        @(posedge clk);
        #1;

        if (led_reg === 18'h05678)
            $display("PASS: LED write -> LED register = 0x%05h", led_reg);
        else
            $display("FAIL: LED write -> LED register = 0x%05h", led_reg);

        // HEX register should remain unchanged
        if (hex_reg === 32'h00000000)
            $display("PASS: HEX register unchanged during LED write");
        else
            $display("FAIL: HEX register changed during LED write");


        // Disable LED write
        led_write = 1'b0;


        //=======================================================
        // TEST 3: Write to HEX register
        //=======================================================
        write_data = 32'hABCDEF12;
        hex_write  = 1'b1;
        led_write  = 1'b0;

        @(posedge clk);
        #1;

        if (hex_reg === 32'hABCDEF12)
            $display("PASS: HEX write -> HEX register = 0x%08h", hex_reg);
        else
            $display("FAIL: HEX write -> HEX register = 0x%08h", hex_reg);

        // LED register should remain unchanged
        if (led_reg === 18'h05678)
            $display("PASS: LED register unchanged during HEX write");
        else
            $display("FAIL: LED register changed during HEX write");


        // Disable HEX write
        hex_write = 1'b0;


        //=======================================================
        // TEST 4: LED register uses only lower 18 bits
        //=======================================================
        write_data = 32'hFFFF0000;
        led_write  = 1'b1;
        hex_write  = 1'b0;

        @(posedge clk);
        #1;

        if (led_reg === 18'h30000)
            $display("PASS: LED captures lower 18 bits = 0x%05h", led_reg);
        else
            $display("FAIL: LED captures lower 18 bits = 0x%05h", led_reg);

        led_write = 1'b0;


        //=======================================================
        // TEST 5: HEX register captures all 32 bits
        //=======================================================
        write_data = 32'hDEADBEEF;
        hex_write  = 1'b1;
        led_write  = 1'b0;

        @(posedge clk);
        #1;

        if (hex_reg === 32'hDEADBEEF)
            $display("PASS: HEX captures full 32-bit value = 0x%08h",
                     hex_reg);
        else
            $display("FAIL: HEX captures full 32-bit value = 0x%08h",
                     hex_reg);

        hex_write = 1'b0;


        //=======================================================
        // TEST 6: No write -> registers hold previous values
        //=======================================================
        write_data = 32'h11111111;
        led_write  = 1'b0;
        hex_write  = 1'b0;

        @(posedge clk);
        #1;

        if (led_reg === 18'h30000)
            $display("PASS: LED holds value when led_write = 0");
        else
            $display("FAIL: LED changed when led_write = 0");

        if (hex_reg === 32'hDEADBEEF)
            $display("PASS: HEX holds value when hex_write = 0");
        else
            $display("FAIL: HEX changed when hex_write = 0");


        //=======================================================
        // TEST 7: Both writes asserted simultaneously
        //=======================================================
        write_data = 32'hCAFEBABE;
        led_write  = 1'b1;
        hex_write  = 1'b1;

        @(posedge clk);
        #1;

        if (led_reg === 18'h2BABE)
            $display("PASS: Simultaneous LED write = 0x%05h", led_reg);
        else
            $display("FAIL: Simultaneous LED write = 0x%05h", led_reg);

        if (hex_reg === 32'hCAFEBABE)
            $display("PASS: Simultaneous HEX write = 0x%08h", hex_reg);
        else
            $display("FAIL: Simultaneous HEX write = 0x%08h", hex_reg);


        //=======================================================
        // TEST COMPLETE
        //=======================================================
        led_write  = 1'b0;
        hex_write  = 1'b0;

        #10;

        $display("========================================");
        $display("OUTPUT PERIPHERAL TEST COMPLETE");
        $display("========================================");

        $stop;
    end

endmodule