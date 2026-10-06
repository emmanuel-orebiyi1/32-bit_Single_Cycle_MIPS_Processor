//=============================================================================
// memory_peripherals.v
// Subgroup C - Memory + Peripherals + FPGA
//=============================================================================

module memory_peripherals (
    input         clk,
    input         reset,

    input  [31:0] address,
    input         MemRead,
    input         MemWrite,
    input  [31:0] write_data,
    output [31:0] read_data,

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

    wire        mem_MemRead;
    wire        mem_MemWrite;

    wire        led_write;
    wire        hex_write;

    wire [31:0] mem_read_data;
    wire [31:0] switch_data;

    wire [17:0] led_reg;
    wire [31:0] hex_reg;

    input_peripheral switch_input (
        .SW(SW),
        .switch_data(switch_data)
    );

    data_memory data_ram (
        .clk(clk),
        .MemRead(mem_MemRead),
        .MemWrite(mem_MemWrite),
        .address(address),
        .write_data(write_data),
        .read_data(mem_read_data)
    );

    output_peripheral outputs (
        .clk(clk),
        .led_write(led_write),
        .hex_write(hex_write),
        .write_data(write_data),
        .led_reg(led_reg),
        .hex_reg(hex_reg)
    );

    io_address_decoder decoder (
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(address),

        .mem_read_data(mem_read_data),
        .switch_data(switch_data),
        .led_reg(led_reg),
        .hex_reg(hex_reg),

        .mem_MemRead(mem_MemRead),
        .mem_MemWrite(mem_MemWrite),
        .led_write(led_write),
        .hex_write(hex_write),

        .read_data(read_data)
    );

    assign LEDR = led_reg;

    hex_decoder hex_display (
        .value(hex_reg),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5),
        .HEX6(HEX6),
        .HEX7(HEX7)
    );

endmodule