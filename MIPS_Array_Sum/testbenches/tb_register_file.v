`timescale 1ns / 1ps

module tb_register_file;

    reg clk;
    reg reset;
    reg reg_write;
    reg [4:0] read_reg1;
    reg [4:0] read_reg2;
    reg [4:0] write_reg;
    reg [31:0] write_data;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    register_file uut (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        reset = 1;
        reg_write = 0;
        read_reg1 = 0;
        read_reg2 = 0;
        write_reg = 0;
        write_data = 0;

        $display("=== REGISTER FILE TEST ===");

        #10;

        reset = 0;

        // Write 25 to register 8
        write_reg = 5'd8;
        write_data = 32'd25;
        reg_write = 1;

        #10;

        reg_write = 0;
        read_reg1 = 5'd8;

        #1;

        if (read_data1 == 32'd25)
            $display("PASS: Register 8 contains 25");
        else
            $display("FAIL: Register 8 = %d", read_data1);

        // Write 50 to register 9
        write_reg = 5'd9;
        write_data = 32'd50;
        reg_write = 1;

        #10;

        reg_write = 0;
        read_reg1 = 5'd8;
        read_reg2 = 5'd9;

        #1;

        if (read_data1 == 32'd25 && read_data2 == 32'd50)
            $display("PASS: Dual register read successful");
        else
            $display("FAIL: R1=%d R2=%d", read_data1, read_data2);

        // Test $zero
        read_reg1 = 5'd0;
        #1;

        if (read_data1 == 32'd0)
            $display("PASS: $zero reads as 0");
        else
            $display("FAIL: $zero = %h", read_data1);

        // Attempt to write to $zero
        write_reg = 5'd0;
        write_data = 32'hFFFFFFFF;
        reg_write = 1;

        #10;

        reg_write = 0;
        read_reg1 = 5'd0;

        #1;

        if (read_data1 == 32'd0)
            $display("PASS: $zero cannot be modified");
        else
            $display("FAIL: $zero changed to %h", read_data1);

        $display("=== REGISTER FILE TEST COMPLETE ===");

        $stop;
    end

endmodule