/**************************************************************************
/* Test Bench for  COMET II CPU
/*
/*
/**************************************************************************/

`timescale 1ns/1ps

`define TEST_RAM1


module top_tb();

    initial begin
        $dumpfile("top_tb.vcd"); //simulation output
        $dumpvars(0,U101,U102);  //
   end

    reg ck = 1'b0;

    always begin
        #31 ck = ~ck;     
    end


    reg init;

    //Master clock
    initial begin
        init = 1'b0;
        #10  init = 1'b1;
        #100000 $finish;
    end

    wire re,we;
    wire [15:0] raddr,rdata,waddr,wdata;

    //Test target module
    COMET_II_top U101(
        .mclk(ck),
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

    
    `ifdef TEST_RAM1

    test_RAM1 U102(
        .mclk(ck),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .re(re),
        .raddr(raddr),
        .rdata(rdata) );

    `elsif TEST_RAM2

    test_RAM2 U102(
        .mclk(ck),
        .we(we),
        .waddr(waddr),
        .wdata(wdata),
        .re(re),
        .raddr(raddr),
        .rdata(rdata) );

    `endif

endmodule