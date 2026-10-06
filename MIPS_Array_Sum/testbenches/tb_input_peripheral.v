`timescale 1ns/1ps

module tb_input_peripheral;

    // Testbench signals
    reg  [17:0] SW;
    wire [31:0] switch_data;

    // Instantiate the actual input_peripheral
    input_peripheral uut (
        .SW(SW),
        .switch_data(switch_data)
    );

    initial begin
        $display("========================================");
        $display("INPUT PERIPHERAL TEST START");
        $display("========================================");

        // Test 1: All switches OFF
        SW = 18'b0;
        #10;

        if (switch_data === 32'h00000000)
            $display("PASS: SW = 0x00000 -> switch_data = 0x%08h",
                     switch_data);
        else
            $display("FAIL: SW = 0x00000 -> switch_data = 0x%08h",
                     switch_data);


        // Test 2: Lowest switch ON
        SW = 18'b000000000000000001;
        #10;

        if (switch_data === 32'h00000001)
            $display("PASS: SW = 0x00001 -> switch_data = 0x%08h",
                     switch_data);
        else
            $display("FAIL: SW = 0x00001 -> switch_data = 0x%08h",
                     switch_data);


        // Test 3: Highest switch ON
        SW = 18'b100000000000000000;
        #10;

        if (switch_data === 32'h00020000)
            $display("PASS: SW = 0x20000 -> switch_data = 0x%08h",
                     switch_data);
        else
            $display("FAIL: SW = 0x20000 -> switch_data = 0x%08h",
                     switch_data);


        // Test 4: Several switches ON
        SW = 18'b101010101010101010;
        #10;

        if (switch_data === 32'h0002AAAA)
            $display("PASS: SW = 0x2AAAA -> switch_data = 0x%08h",
                     switch_data);
        else
            $display("FAIL: SW = 0x2AAAA -> switch_data = 0x%08h",
                     switch_data);


        // Test 5: All switches ON
        SW = 18'b111111111111111111;
        #10;

        if (switch_data === 32'h0003FFFF)
            $display("PASS: SW = 0x3FFFF -> switch_data = 0x%08h",
                     switch_data);
        else
            $display("FAIL: SW = 0x3FFFF -> switch_data = 0x%08h",
                     switch_data);


        // Test 6: Another arbitrary pattern
        SW = 18'b000011110000111100;
        #10;

        if (switch_data === 32'h00003C3C)
            $display("PASS: SW = 0x03C3C -> switch_data = 0x%08h",
                     switch_data);
        else
            $display("FAIL: SW = 0x03C3C -> switch_data = 0x%08h",
                     switch_data);


        $display("========================================");
        $display("INPUT PERIPHERAL TEST COMPLETE");
        $display("========================================");

        $stop;
    end

endmodule