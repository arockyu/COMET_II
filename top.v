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


    
    wire clk_double = CLK;

    divider D1(
        .clk(CLK),
        .out(mclk));
    defparam D1.divide_num=1;// N : Div parameter N+1 Divide

    reg init = 1'b1;
    wire re,we;
    wire [15:0] raddr,rdata,waddr,wdata;

    //Test target module
    COMET_II_top U101(
        .mclk(mclk),
        .init(init),
        .rst(1'b0),
        .PR_init(),
        .SP_init(),
        .re(re),
        .raddr(raddr),
        .rdata(rdata),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .stage()
    );
    defparam U101.initial_SP = 16'h0100;  //Force SP to 0100h for fit to test RAM size



    //Main Program Area : 0000h - 004fh
    //Sub-routin Area   : 0060h - 006fh
    //data Area         : 0070h - 00B9h

    Program_RAM R101(
        .mclk(mclk),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .re(re),
        .raddr(raddr),
        .rdata(rdata) );

endmodule

