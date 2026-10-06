module io_address_decoder (
    input         MemRead,
    input         MemWrite,
    input  [31:0] address,

    input  [31:0] mem_read_data,
    input  [31:0] switch_data,
    input  [17:0] led_reg,
    input  [31:0] hex_reg,

    output        mem_MemRead,
    output        mem_MemWrite,
    output        led_write,
    output        hex_write,

    output [31:0] read_data
);

    // ============================================================
    // I/O ADDRESS MAP
    // ============================================================
    //
    // 0xFFFF0000 -> LED output
    // 0xFFFF0004 -> HEX display output
    // 0xFFFF0010 -> Complete switch input
    //
    // Array inputs:
    // 0xFFFF0020 -> Array[0] = SW[2:0]
    // 0xFFFF0024 -> Array[1] = SW[5:3]
    // 0xFFFF0028 -> Array[2] = SW[8:6]
    // 0xFFFF002C -> Array[3] = SW[11:9]
    // 0xFFFF0030 -> Array[4] = SW[14:12]
    // 0xFFFF0034 -> Array[5] = SW[17:15]
    //
    // ============================================================


    // ------------------------------------------------------------
    // Existing I/O addresses
    // ------------------------------------------------------------

    wire is_led;
    wire is_hex;
    wire is_switch;

    assign is_led    = (address == 32'hFFFF0000);
    assign is_hex    = (address == 32'hFFFF0004);
    assign is_switch = (address == 32'hFFFF0010);


    // ------------------------------------------------------------
    // New array addresses
    // ------------------------------------------------------------

    wire is_array0;
    wire is_array1;
    wire is_array2;
    wire is_array3;
    wire is_array4;
    wire is_array5;

    assign is_array0 = (address == 32'hFFFF0020);
    assign is_array1 = (address == 32'hFFFF0024);
    assign is_array2 = (address == 32'hFFFF0028);
    assign is_array3 = (address == 32'hFFFF002C);
    assign is_array4 = (address == 32'hFFFF0030);
    assign is_array5 = (address == 32'hFFFF0034);


    // ------------------------------------------------------------
    // Detect all I/O addresses
    // ------------------------------------------------------------

    wire is_io;

    assign is_io =
           is_led
         | is_hex
         | is_switch
         | is_array0
         | is_array1
         | is_array2
         | is_array3
         | is_array4
         | is_array5;


    // ------------------------------------------------------------
    // Prevent normal data memory from responding to I/O addresses
    // ------------------------------------------------------------

    assign mem_MemRead  = MemRead  & ~is_io;
    assign mem_MemWrite = MemWrite & ~is_io;


    // ------------------------------------------------------------
    // Existing output peripheral write signals
    // ------------------------------------------------------------

    assign led_write = MemWrite & is_led;
    assign hex_write = MemWrite & is_hex;


    // ------------------------------------------------------------
    // Convert each 3-bit switch group into a 32-bit value
    //
    // SW[2:0]   -> Array[0]
    // SW[5:3]   -> Array[1]
    // SW[8:6]   -> Array[2]
    // SW[11:9]  -> Array[3]
    // SW[14:12] -> Array[4]
    // SW[17:15] -> Array[5]
    //
    // The upper 29 bits are zero.
    // Therefore each array element has a value from 0 to 7.
    // ------------------------------------------------------------

    wire [31:0] array0_data;
    wire [31:0] array1_data;
    wire [31:0] array2_data;
    wire [31:0] array3_data;
    wire [31:0] array4_data;
    wire [31:0] array5_data;

    assign array0_data = {29'b0, switch_data[2:0]};
    assign array1_data = {29'b0, switch_data[5:3]};
    assign array2_data = {29'b0, switch_data[8:6]};
    assign array3_data = {29'b0, switch_data[11:9]};
    assign array4_data = {29'b0, switch_data[14:12]};
    assign array5_data = {29'b0, switch_data[17:15]};


    // ------------------------------------------------------------
    // Read-data multiplexer
    //
    // Depending on the address requested by the MIPS processor,
    // return the appropriate peripheral/data-memory value.
    // ------------------------------------------------------------

    assign read_data =
           is_array0 ? array0_data :
           is_array1 ? array1_data :
           is_array2 ? array2_data :
           is_array3 ? array3_data :
           is_array4 ? array4_data :
           is_array5 ? array5_data :
           is_switch ? switch_data :
           is_led    ? {14'b0, led_reg} :
           is_hex    ? hex_reg :
                       mem_read_data;

endmodule 