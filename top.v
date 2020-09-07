// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    
    output LED,    // User/boot LED next to power LED
    output USBPU  // USB pull-up resistor
);
    // drive USB pull-up resistor to '0' to disable USB comunication
    assign USBPU = 0;

    // set the on board LED continious on to indicate user program mode
    assign LED = 1;

endmodule

