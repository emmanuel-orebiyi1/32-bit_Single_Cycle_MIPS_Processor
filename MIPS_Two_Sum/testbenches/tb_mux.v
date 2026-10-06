`timescale 1ns/1ps

module tb_mux;

    // ============================================================
    // MUX2 signals
    // ============================================================
    reg  [31:0] mux2_in0;
    reg  [31:0] mux2_in1;
    reg         mux2_sel;
    wire [31:0] mux2_out;

    mux2 #(.WIDTH(32)) uut_mux2 (
        .in0(mux2_in0),
        .in1(mux2_in1),
        .sel(mux2_sel),
        .out(mux2_out)
    );


    // ============================================================
    // MUX3 signals
    // ============================================================
    reg  [31:0] mux3_in0;
    reg  [31:0] mux3_in1;
    reg  [31:0] mux3_in2;
    reg  [1:0]  mux3_sel;
    wire [31:0] mux3_out;

    mux3 #(.WIDTH(32)) uut_mux3 (
        .in0(mux3_in0),
        .in1(mux3_in1),
        .in2(mux3_in2),
        .sel(mux3_sel),
        .out(mux3_out)
    );


    // ============================================================
    // MUX4 signals
    // ============================================================
    reg  [31:0] mux4_in0;
    reg  [31:0] mux4_in1;
    reg  [31:0] mux4_in2;
    reg  [31:0] mux4_in3;
    reg  [1:0]  mux4_sel;
    wire [31:0] mux4_out;

    mux4 #(.WIDTH(32)) uut_mux4 (
        .in0(mux4_in0),
        .in1(mux4_in1),
        .in2(mux4_in2),
        .in3(mux4_in3),
        .sel(mux4_sel),
        .out(mux4_out)
    );


    // ============================================================
    // TESTS
    // ============================================================
    initial begin

        $display("======================================");
        $display("        MUX MODULE TEST START");
        $display("======================================");


        // --------------------------------------------------------
        // MUX2 TEST
        // --------------------------------------------------------
        $display("\nTesting mux2...");

        mux2_in0 = 32'hAAAAAAAA;
        mux2_in1 = 32'hBBBBBBBB;

        mux2_sel = 1'b0;
        #10;

        if (mux2_out === mux2_in0)
            $display("PASS: mux2 sel=0 -> in0");
        else
            $display("ERROR: mux2 sel=0 -> expected %h, got %h",
                     mux2_in0, mux2_out);

        mux2_sel = 1'b1;
        #10;

        if (mux2_out === mux2_in1)
            $display("PASS: mux2 sel=1 -> in1");
        else
            $display("ERROR: mux2 sel=1 -> expected %h, got %h",
                     mux2_in1, mux2_out);


        // --------------------------------------------------------
        // MUX3 TEST
        // --------------------------------------------------------
        $display("\nTesting mux3...");

        mux3_in0 = 32'h11111111;
        mux3_in1 = 32'h22222222;
        mux3_in2 = 32'h33333333;

        mux3_sel = 2'b00;
        #10;

        if (mux3_out === mux3_in0)
            $display("PASS: mux3 sel=00 -> in0");
        else
            $display("ERROR: mux3 sel=00 -> expected %h, got %h",
                     mux3_in0, mux3_out);

        mux3_sel = 2'b01;
        #10;

        if (mux3_out === mux3_in1)
            $display("PASS: mux3 sel=01 -> in1");
        else
            $display("ERROR: mux3 sel=01 -> expected %h, got %h",
                     mux3_in1, mux3_out);

        mux3_sel = 2'b10;
        #10;

        if (mux3_out === mux3_in2)
            $display("PASS: mux3 sel=10 -> in2");
        else
            $display("ERROR: mux3 sel=10 -> expected %h, got %h",
                     mux3_in2, mux3_out);

        // 11 is not a valid mux3 selection.
        // Your design specifies that it defaults to in0.
        mux3_sel = 2'b11;
        #10;

        if (mux3_out === mux3_in0)
            $display("PASS: mux3 sel=11 -> default in0");
        else
            $display("ERROR: mux3 sel=11 -> expected default %h, got %h",
                     mux3_in0, mux3_out);


        // --------------------------------------------------------
        // MUX4 TEST
        // --------------------------------------------------------
        $display("\nTesting mux4...");

        mux4_in0 = 32'hAAAAAAAA;
        mux4_in1 = 32'hBBBBBBBB;
        mux4_in2 = 32'hCCCCCCCC;
        mux4_in3 = 32'hDDDDDDDD;

        mux4_sel = 2'b00;
        #10;

        if (mux4_out === mux4_in0)
            $display("PASS: mux4 sel=00 -> in0");
        else
            $display("ERROR: mux4 sel=00 -> expected %h, got %h",
                     mux4_in0, mux4_out);

        mux4_sel = 2'b01;
        #10;

        if (mux4_out === mux4_in1)
            $display("PASS: mux4 sel=01 -> in1");
        else
            $display("ERROR: mux4 sel=01 -> expected %h, got %h",
                     mux4_in1, mux4_out);

        mux4_sel = 2'b10;
        #10;

        if (mux4_out === mux4_in2)
            $display("PASS: mux4 sel=10 -> in2");
        else
            $display("ERROR: mux4 sel=10 -> expected %h, got %h",
                     mux4_in2, mux4_out);

        mux4_sel = 2'b11;
        #10;

        if (mux4_out === mux4_in3)
            $display("PASS: mux4 sel=11 -> in3");
        else
            $display("ERROR: mux4 sel=11 -> expected %h, got %h",
                     mux4_in3, mux4_out);


        // --------------------------------------------------------
        // FINISH
        // --------------------------------------------------------
        $display("\n======================================");
        $display("        MUX MODULE TEST COMPLETE");
        $display("======================================");

        $stop;
    end

endmodule