//=============================================================================
// output_peripheral.v
// Subgroup C - Memory + Peripherals + FPGA
//
// Frozen addresses:
//   LED : 0xFFFF0000
//   HEX : 0xFFFF0004
//
// Captures data from normal `sw` instructions issued by the MIPS core.
// led_write / hex_write are pre-qualified by the I/O Address Decoder
// (already AND-ed with MemWrite and the matching address compare), so
// this module just latches on clk when told to.
//=============================================================================
module output_peripheral (
    input         clk,
    input         led_write,     // pulse: sw to 0xFFFF0000
    input         hex_write,     // pulse: sw to 0xFFFF0004
    input  [31:0] write_data,

    output reg [17:0] led_reg,   // drives LEDR[17:0]
    output reg [31:0] hex_reg    // drives the 8 HEX digits via hex_decoder
);

    initial begin
        led_reg = 18'b0;
        hex_reg = 32'b0;
    end

    always @(posedge clk) begin
        if (led_write)
            led_reg <= write_data[17:0];

        if (hex_write)
            hex_reg <= write_data;
    end

endmodule
