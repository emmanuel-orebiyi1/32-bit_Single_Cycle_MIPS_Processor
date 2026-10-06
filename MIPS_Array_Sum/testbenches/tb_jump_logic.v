`timescale 1ns/1ps

module tb_jump_logic;

    reg  [31:0] pc_plus_4;
    reg  [25:0] jump_index;
    reg         jump_ctrl;

    wire [31:0] jump_target;
    wire        jump_taken;

    jump_logic uut (
        .pc_plus_4(pc_plus_4),
        .jump_index(jump_index),
        .jump_ctrl(jump_ctrl),
        .jump_target(jump_target),
        .jump_taken(jump_taken)
    );

    initial begin

        $display("==============================================");
        $display("         JUMP LOGIC MODULE TEST START");
        $display("==============================================");

        // --------------------------------------------------
        // Test 1:
        // Jump disabled
        // --------------------------------------------------
        pc_plus_4  = 32'h00400004;
        jump_index = 26'h0000001;
        jump_ctrl  = 1'b0;

        #10;

        if (jump_taken === 1'b0)
            $display("PASS: Jump disabled -> jump_taken = 0");
        else
            $display("ERROR: Expected jump_taken = 0, got %b",
                     jump_taken);


        // --------------------------------------------------
        // Test 2:
        // Jump enabled
        //
        // PC+4 upper bits = 0000
        // index = 1
        // target = 00000004
        // --------------------------------------------------
        pc_plus_4  = 32'h00400004;
        jump_index = 26'h0000001;
        jump_ctrl  = 1'b1;

        #10;

        if (jump_taken === 1'b1)
            $display("PASS: Jump enabled -> jump_taken = 1");
        else
            $display("ERROR: Expected jump_taken = 1, got %b",
                     jump_taken);

        if (jump_target === 32'h00000004)
            $display("PASS: Jump target = 00000004");
        else
            $display("ERROR: Expected jump target 00000004, got %h",
                     jump_target);


        // --------------------------------------------------
        // Test 3:
        // Verify lower 2 bits are always 00
        //
        // jump_index = 0x123456
        // target = {0000, 123456, 00}
        //        = 0x0048D158
        // --------------------------------------------------
        pc_plus_4  = 32'h00400004;
        jump_index = 26'h123456;
        jump_ctrl  = 1'b1;

        #10;

        if (jump_target === 32'h0048D158)
            $display("PASS: Jump target = 0048D158");
        else
            $display("ERROR: Expected jump target 0048D158, got %h",
                     jump_target);


        // --------------------------------------------------
        // Test 4:
        // Verify upper 4 bits come from PC+4
        //
        // PC+4 upper nibble = 8
        // jump_index = 0
        // target = 80000000
        // --------------------------------------------------
        pc_plus_4  = 32'h80000004;
        jump_index = 26'h0000000;
        jump_ctrl  = 1'b1;

        #10;

        if (jump_target === 32'h80000000)
            $display("PASS: Upper 4 bits from PC+4 -> 80000000");
        else
            $display("ERROR: Expected 80000000, got %h",
                     jump_target);


        // --------------------------------------------------
        // Test 5:
        // Verify another complete jump address
        // --------------------------------------------------
        pc_plus_4  = 32'hF0001004;
        jump_index = 26'h1555555;
        jump_ctrl  = 1'b1;

        #10;

        if (jump_target === 32'hF5555554)
            $display("PASS: Jump target = F5555554");
        else
            $display("ERROR: Expected jump target F5555554, got %h",
                     jump_target);


        $display("==============================================");
        $display("         JUMP LOGIC MODULE TEST COMPLETE");
        $display("==============================================");

        $stop;
    end

endmodule