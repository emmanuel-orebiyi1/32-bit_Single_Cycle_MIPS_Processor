//=============================================================================
// input_peripheral.v
// Subgroup C - Memory + Peripherals + FPGA
//
// Frozen address: 0xFFFF0010
//
// Exposes the DE2 slide switches SW[17:0] as a 32-bit, zero-extended value
// so a normal `lw` at 0xFFFF0010 returns the current switch state.
// Purely combinational - switches are live physical input, no clocking
// or storage needed here.
//=============================================================================
module input_peripheral (
    input  [17:0] SW,
    output [31:0] switch_data   // = {14'b0, SW[17:0]}
);

    assign switch_data = {14'b0, SW};

endmodule
