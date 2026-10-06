`timescale 1ns / 1ps

module tb_alu;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUControl;

    wire [31:0] Result;
    wire Zero;

    alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Zero(Zero)
    );

    task check_result;
        input [31:0] expected;
        input [127:0] test_name;

        begin
            #1;

            if (Result === expected)
                $display("PASS: %s", test_name);
            else
                $display("FAIL: %s | Expected=%h Got=%h",
                         test_name, expected, Result);
        end
    endtask

    initial begin

        $display("=== ALU TEST ===");

        // ADD: 5 + 3 = 8
        A = 32'd5;
        B = 32'd3;
        ALUControl = 4'b0000;
        check_result(32'd8, "ADD");

        // SUB: 5 - 3 = 2
        A = 32'd5;
        B = 32'd3;
        ALUControl = 4'b0001;
        check_result(32'd2, "SUB");

        // AND
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        ALUControl = 4'b0010;
        check_result(32'h00000000, "AND");

        // OR
        A = 32'hF0F00000;
        B = 32'h00000F0F;
        ALUControl = 4'b0011;
        check_result(32'hF0F00F0F, "OR");

        // XOR
        A = 32'hAAAAAAAA;
        B = 32'hFFFFFFFF;
        ALUControl = 4'b0100;
        check_result(32'h55555555, "XOR");

        // SLL: 4 << 2 = 16
        A = 32'd2;
        B = 32'd4;
        ALUControl = 4'b0111;
        check_result(32'd16, "SLL");

        // SRL: 16 >> 2 = 4
        A = 32'd2;
        B = 32'd16;
        ALUControl = 4'b1000;
        check_result(32'd4, "SRL");

        // SLT: 3 < 5 = 1
        A = 32'd3;
        B = 32'd5;
        ALUControl = 4'b0101;
        check_result(32'd1, "SLT");

        // SLT false: 5 < 3 = 0
        A = 32'd5;
        B = 32'd3;
        ALUControl = 4'b0101;
        check_result(32'd0, "SLT false");

        // NOR
        A = 32'hFFFFFFFF;
        B = 32'h00000000;
        ALUControl = 4'b0110;
        check_result(32'h00000000, "NOR");

        // Zero flag: 5 - 5 = 0
        A = 32'd5;
        B = 32'd5;
        ALUControl = 4'b0001;

        #1;

        if (Zero === 1'b1)
            $display("PASS: Zero flag");
        else
            $display("FAIL: Zero flag");

        $display("=== ALU TEST COMPLETE ===");

        $stop;
    end

endmodule