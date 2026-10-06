`timescale 1ns/1ps

module tb_branch_logic;

    reg  [31:0] pc_plus_4;
    reg  [31:0] sign_extended_offset;
    reg         branch_ctrl;
    reg         zero;

    wire [31:0] branch_target;
    wire        branch_taken;

    branch_logic uut (
        .pc_plus_4(pc_plus_4),
        .sign_extended_offset(sign_extended_offset),
        .branch_ctrl(branch_ctrl),
        .zero(zero),
        .branch_target(branch_target),
        .branch_taken(branch_taken)
    );

    initial begin

        $display("==============================================");
        $display("        BRANCH LOGIC MODULE TEST START");
        $display("==============================================");

        // --------------------------------------------------
        // Test 1:
        // Branch disabled
        // --------------------------------------------------
        pc_plus_4           = 32'h00001004;
        sign_extended_offset = 32'h00000004;
        branch_ctrl         = 1'b0;
        zero                = 1'b1;

        #10;

        if (branch_taken === 1'b0)
            $display("PASS: Branch disabled -> branch_taken = 0");
        else
            $display("ERROR: Branch disabled -> expected 0, got %b",
                     branch_taken);


        // --------------------------------------------------
        // Test 2:
        // Branch enabled + Zero = 1
        // Branch should be taken
        // --------------------------------------------------
        pc_plus_4            = 32'h00001004;
        sign_extended_offset = 32'h00000004;
        branch_ctrl          = 1'b1;
        zero                 = 1'b1;

        #10;

        if (branch_taken === 1'b1)
            $display("PASS: Branch enabled + Zero -> branch_taken = 1");
        else
            $display("ERROR: Expected branch_taken = 1, got %b",
                     branch_taken);


        // --------------------------------------------------
        // Test 3:
        // Branch enabled + Zero = 0
        // Branch should NOT be taken
        // --------------------------------------------------
        pc_plus_4            = 32'h00001004;
        sign_extended_offset = 32'h00000004;
        branch_ctrl          = 1'b1;
        zero                 = 1'b0;

        #10;

        if (branch_taken === 1'b0)
            $display("PASS: Branch enabled + Zero = 0 -> branch_taken = 0");
        else
            $display("ERROR: Expected branch_taken = 0, got %b",
                     branch_taken);


        // --------------------------------------------------
        // Test 4:
        // Check branch target calculation
        //
        // target = PC + 4 + (offset << 2)
        //
        // 0x1004 + (4 << 2)
        // = 0x1004 + 0x10
        // = 0x1014
        // --------------------------------------------------
        pc_plus_4            = 32'h00001004;
        sign_extended_offset = 32'h00000004;
        branch_ctrl          = 1'b1;
        zero                 = 1'b1;

        #10;

        if (branch_target === 32'h00001014)
            $display("PASS: Branch target = 00001014");
        else
            $display("ERROR: Expected branch target 00001014, got %h",
                     branch_target);


        // --------------------------------------------------
        // Test 5:
        // Another branch target
        //
        // PC+4 = 0x00002004
        // offset = 2
        // offset << 2 = 8
        // target = 0x200C
        // --------------------------------------------------
        pc_plus_4            = 32'h00002004;
        sign_extended_offset = 32'h00000002;
        branch_ctrl          = 1'b1;
        zero                 = 1'b1;

        #10;

        if (branch_target === 32'h0000200C)
            $display("PASS: Branch target = 0000200C");
        else
            $display("ERROR: Expected branch target 0000200C, got %h",
                     branch_target);


        $display("==============================================");
        $display("        BRANCH LOGIC MODULE TEST COMPLETE");
        $display("==============================================");

        $stop;
    end

endmodule