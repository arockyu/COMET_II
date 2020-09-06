/************************************************************************
* BUS_interface 
*
*************************************************************************
* inout bus_pack    : Assignment to  BUS Package Pin
* input bus_out     : Writing BUS signal input
* input bus_oe      : BUS output enable (OE - high active) signal input
* output bus_in     : Reading BUS_input signal output
***************************************************************************
*
****************************************************************************/


module BUS_interface(
    inout bus_pack,  

    input bus_out,
    input bus_oe,
    output bus_in);


    SB_IO DIO_bus(
        .PACKAGE_PIN(bus_pack),
        .LATCH_INPUT_VALUE(),
        .CLOCK_ENABLE(),
        .INPUT_CLK(),
        .OUTPUT_CLK(),
        .OUTPUT_ENABLE(bus_oe),
        .D_OUT_0(bus_out),         
        .D_OUT_1(),
        .D_IN_0(bus_in),
        .D_IN_1());
    defparam DIO_bus.PIN_TYPE = 6'b1010_01; // Simple input and Simple Tristate output
    defparam DIO_bus.IO_STANDARD = "SB_LVCMOS";


endmodule