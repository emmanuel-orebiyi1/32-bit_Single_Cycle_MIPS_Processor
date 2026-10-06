//=============================================================================
// memory_peripherals.v
// MIPS Two Sum Project
//
// Memory + FPGA peripherals
//
// Address map:
//
//   0xFFFF0000 -> LED output
//   0xFFFF0004 -> General HEX output
//   0xFFFF0008 -> Two Sum index i
//   0xFFFF000C -> Two Sum index j
//   0xFFFF0010 -> Target input from SW[7:0]
//
// Two Sum result display:
//
//   HEX7 HEX6 HEX5 HEX4 | HEX3 HEX2 HEX1 HEX0
//      index i           |       index j
//
// Example:
//   i = 1, j = 7
//   Display = 0001 0007
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

    //-------------------------------------------------------------------------
    // Normal data memory control
    //-------------------------------------------------------------------------

    wire mem_MemRead;
    wire mem_MemWrite;

    wire [31:0] mem_read_data;

    //-------------------------------------------------------------------------
    // Switch input
    //-------------------------------------------------------------------------

    wire [31:0] switch_data;

    //-------------------------------------------------------------------------
    // Output registers
    //-------------------------------------------------------------------------

    reg [17:0] led_reg;

    reg [31:0] hex_reg;

    reg [31:0] result_i_reg;
    reg [31:0] result_j_reg;

    //-------------------------------------------------------------------------
    // Peripheral write enables
    //-------------------------------------------------------------------------

    wire led_write;
    wire hex_write;
    wire result_i_write;
    wire result_j_write;

    //-------------------------------------------------------------------------
    // FPGA switch input
    //-------------------------------------------------------------------------

    input_peripheral switch_input (
        .SW          (SW),
        .switch_data (switch_data)
    );

    //-------------------------------------------------------------------------
    // Data memory
    //-------------------------------------------------------------------------

    data_memory data_ram (
        .clk        (clk),
        .MemRead    (mem_MemRead),
        .MemWrite   (mem_MemWrite),
        .address    (address),
        .write_data (write_data),
        .read_data  (mem_read_data)
    );

    //-------------------------------------------------------------------------
    // Address decoder
    //-------------------------------------------------------------------------

    io_address_decoder decoder (
        .MemRead       (MemRead),
        .MemWrite      (MemWrite),
        .address       (address),

        .mem_read_data (mem_read_data),
        .switch_data   (switch_data),

        .led_reg       (led_reg),
        .hex_reg       (hex_reg),

        .result_i_reg  (result_i_reg),
        .result_j_reg  (result_j_reg),

        .mem_MemRead   (mem_MemRead),
        .mem_MemWrite  (mem_MemWrite),

        .led_write     (led_write),
        .hex_write     (hex_write),
        .result_i_write(result_i_write),
        .result_j_write(result_j_write),

        .read_data     (read_data)
    );

    //-------------------------------------------------------------------------
    // Output registers
    //-------------------------------------------------------------------------

    always @(posedge clk) begin

        if (reset) begin

            led_reg      <= 18'b0;
            hex_reg      <= 32'b0;
            result_i_reg <= 32'b0;
            result_j_reg <= 32'b0;

        end
        else begin

            // LED output
            if (led_write)
                led_reg <= write_data[17:0];

            // General HEX output
            if (hex_write)
                hex_reg <= write_data;

            // Two Sum result index i
            if (result_i_write)
                result_i_reg <= write_data;

            // Two Sum result index j
            if (result_j_write)
                result_j_reg <= write_data;

        end

    end

    //-------------------------------------------------------------------------
    // Combine Two Sum indices for HEX display
    //
    // Upper 16 bits = index i
    // Lower 16 bits = index j
    //-------------------------------------------------------------------------

    wire [31:0] two_sum_display;

    assign two_sum_display = {
        result_i_reg[15:0],
        result_j_reg[15:0]
    };

    //-------------------------------------------------------------------------
    // LED output
    //-------------------------------------------------------------------------

    assign LEDR = led_reg;

    //-------------------------------------------------------------------------
    // HEX display
    //
    // The Two Sum result is displayed by default.
    //-------------------------------------------------------------------------

    hex_decoder hex_display (
        .value (two_sum_display),

        .HEX0  (HEX0),
        .HEX1  (HEX1),
        .HEX2  (HEX2),
        .HEX3  (HEX3),
        .HEX4  (HEX4),
        .HEX5  (HEX5),
        .HEX6  (HEX6),
        .HEX7  (HEX7)
    );

endmodule