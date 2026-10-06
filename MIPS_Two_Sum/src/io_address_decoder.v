//=============================================================================
// io_address_decoder.v
// MIPS Two Sum Project
//
// Memory-mapped I/O:
//
//   0xFFFF0000 -> LED output
//   0xFFFF0004 -> General HEX output
//   0xFFFF0008 -> Two Sum result index i
//   0xFFFF000C -> Two Sum result index j
//   0xFFFF0010 -> Target input from SW[7:0]
//
// Normal data memory is used for the Two Sum array.
//=============================================================================

module io_address_decoder (
    input         MemRead,
    input         MemWrite,
    input  [31:0] address,

    input  [31:0] mem_read_data,
    input  [31:0] switch_data,

    input  [17:0] led_reg,
    input  [31:0] hex_reg,

    input  [31:0] result_i_reg,
    input  [31:0] result_j_reg,

    output        mem_MemRead,
    output        mem_MemWrite,

    output        led_write,
    output        hex_write,
    output        result_i_write,
    output        result_j_write,

    output [31:0] read_data
);

    //-------------------------------------------------------------------------
    // Address detection
    //-------------------------------------------------------------------------

    wire is_led;
    wire is_hex;
    wire is_result_i;
    wire is_result_j;
    wire is_switch;

    assign is_led      = (address == 32'hFFFF0000);
    assign is_hex      = (address == 32'hFFFF0004);
    assign is_result_i = (address == 32'hFFFF0008);
    assign is_result_j = (address == 32'hFFFF000C);
    assign is_switch   = (address == 32'hFFFF0010);

    //-------------------------------------------------------------------------
    // Detect any I/O address
    //-------------------------------------------------------------------------

    wire is_io;

    assign is_io =
           is_led
         | is_hex
         | is_result_i
         | is_result_j
         | is_switch;

    //-------------------------------------------------------------------------
    // Normal data-memory control
    //-------------------------------------------------------------------------

    assign mem_MemRead  = MemRead  & ~is_io;
    assign mem_MemWrite = MemWrite & ~is_io;

    //-------------------------------------------------------------------------
    // Peripheral write enables
    //-------------------------------------------------------------------------

    assign led_write      = MemWrite & is_led;
    assign hex_write      = MemWrite & is_hex;
    assign result_i_write = MemWrite & is_result_i;
    assign result_j_write = MemWrite & is_result_j;

    //-------------------------------------------------------------------------
    // Read-data multiplexer
    //
    // SW[7:0] is the Two Sum target.
    //-------------------------------------------------------------------------

    assign read_data =
           is_switch   ? {24'b0, switch_data[7:0]} :
           is_led      ? {14'b0, led_reg} :
           is_hex      ? hex_reg :
           is_result_i ? result_i_reg :
           is_result_j ? result_j_reg :
                         mem_read_data;

endmodule