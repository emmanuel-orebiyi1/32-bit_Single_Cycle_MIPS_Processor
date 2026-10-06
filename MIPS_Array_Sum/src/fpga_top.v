`timescale 1ns/1ps

module fpga_top (
    input         CLOCK_50,
    input         KEY0,
    input  [17:0] SW,

    output [17:0] LEDR,

    output [6:0] HEX0,
    output [6:0] HEX1,
    output [6:0] HEX2,
    output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5,
    output [6:0] HEX6,
    output [6:0] HEX7
);

    wire clk;
    wire reset;

    assign clk   = CLOCK_50;
    assign reset = ~KEY0;

    // =========================================================
    // INSTRUCTION MEMORY INTERFACE
    // =========================================================

    wire [31:0] imem_address;
    wire [31:0] imem_instruction;

    instruction_memory u_imem (
        .address     (imem_address),
        .instruction (imem_instruction)
    );

    // =========================================================
    // DATA MEMORY / I/O INTERFACE
    // =========================================================

    wire [31:0] dmem_address;
    wire [31:0] dmem_write_data;
    wire [31:0] dmem_read_data;

    wire MemRead;
    wire MemWrite;

    // =========================================================
    // MIPS CORE
    // =========================================================

    mips_core u_mips_core (
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
    // MEMORY + I/O PERIPHERALS
    // =========================================================

    memory_peripherals u_memory_peripherals (
        .clk        (clk),
        .reset      (reset),

        .address    (dmem_address),
        .MemRead    (MemRead),
        .MemWrite   (MemWrite),
        .write_data (dmem_write_data),
        .read_data  (dmem_read_data),

        .SW         (SW),
        .LEDR       (LEDR),

        .HEX0       (HEX0),
        .HEX1       (HEX1),
        .HEX2       (HEX2),
        .HEX3       (HEX3),
        .HEX4       (HEX4),
        .HEX5       (HEX5),
        .HEX6       (HEX6),
        .HEX7       (HEX7)
    );

endmodule