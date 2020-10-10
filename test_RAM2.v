/**************************************************************************
/* Psude RAM for  COMET II CPU Test
/*
/*
/**************************************************************************/

module test_RAM2(
    input mclk,

    input we,
    input [15:0] waddr,
    input [15:0] wdata,

    input re,
    input [15:0] raddr,
    output [15:0] rdata
);

    reg [15:0] mem_area[255:0] ;  //255 word (adresses  0000h to 00ff  are available)
    wire [15:0] HiZs;


     assign rdata = re ? mem_area[ raddr[7:0] ] : HiZs;


    always @(negedge mclk) begin
        if(we)mem_area[ waddr[7:0]] <= wdata;
    end 

    // Test program
    initial begin
        //Main Program Area : 0000h - 004fh
        //Sub-routin Area   : 0060h - 006fh
        //data Area         : 0070h - 00B9h
        //Stack Area        : 00C0h - 00ffh

              //[ 　Addr ]   Data　　　　//
        //Main Program Area : 0000h - 004fh
        mem_area[16'h0000] = 16'h0000;  // NOP
        mem_area[16'h0001] = 16'h0000;  // NOP
        mem_area[16'h0002] = 16'h0000;  // NOP
        mem_area[16'h0003] = 16'h0000;  // NOP
        mem_area[16'h0004] = 16'h0000;  // NOP
        mem_area[16'h0005] = 16'h0000;  // NOP
        mem_area[16'h0006] = 16'h0000;  // NOP
        mem_area[16'h0007] = 16'h0000;  // NOP
        mem_area[16'h0008] = 16'h0000;  // NOP
        mem_area[16'h0009] = 16'h0000;  // NOP
        mem_area[16'h000a] = 16'h0000;  // NOP
        mem_area[16'h000b] = 16'h0000;  // NOP
        mem_area[16'h000c] = 16'h0000;  // NOP
        mem_area[16'h000d] = 16'h0000;  // NOP
        mem_area[16'h000e] = 16'h0000;  // NOP
        mem_area[16'h000f] = 16'h0000;  // NOP
        mem_area[16'h0010] = 16'h0000;  // NOP
        mem_area[16'h0011] = 16'h0000;  // NOP
        mem_area[16'h0012] = 16'h0000;  // NOP
        mem_area[16'h0013] = 16'h0000;  // NOP
        mem_area[16'h0014] = 16'h0000;  // NOP
        mem_area[16'h0015] = 16'h0000;  // NOP
        mem_area[16'h0016] = 16'h0000;  // NOP
        mem_area[16'h0017] = 16'h0000;  // NOP
        mem_area[16'h0018] = 16'h0000;  // NOP
        mem_area[16'h0019] = 16'h0000;  // NOP
        mem_area[16'h001a] = 16'h0000;  // NOP
        mem_area[16'h001b] = 16'h0000;  // NOP
        mem_area[16'h001c] = 16'h0000;  // NOP
        mem_area[16'h001d] = 16'h0000;  // NOP
        mem_area[16'h001e] = 16'h0000;  // NOP
        mem_area[16'h001f] = 16'h0000;  // NOP
        mem_area[16'h0020] = 16'h0000;  // NOP
        mem_area[16'h0021] = 16'h0000;  // NOP
        mem_area[16'h0022] = 16'h0000;  // NOP
        mem_area[16'h0023] = 16'h0000;  // NOP
        mem_area[16'h0024] = 16'h0000;  // NOP
        mem_area[16'h0025] = 16'h0000;  // NOP
        mem_area[16'h0026] = 16'h0000;  // NOP
        mem_area[16'h0027] = 16'h0000;  // NOP
        mem_area[16'h0028] = 16'h0000;  // NOP
        mem_area[16'h0029] = 16'h0000;  // NOP
        mem_area[16'h002a] = 16'h0000;  // NOP
        mem_area[16'h002b] = 16'h0000;  // NOP
        mem_area[16'h002c] = 16'h0000;  // NOP
        mem_area[16'h002d] = 16'h0000;  // NOP
        mem_area[16'h002e] = 16'h0000;  // NOP
        mem_area[16'h002f] = 16'h0000;  // NOP
        mem_area[16'h0030] = 16'h0000;  // NOP
        mem_area[16'h0031] = 16'h0000;  // NOP
        mem_area[16'h0032] = 16'h0000;  // NOP
        mem_area[16'h0033] = 16'h0000;  // NOP
        mem_area[16'h0034] = 16'h0000;  // NOP
        mem_area[16'h0035] = 16'h0000;  // NOP
        mem_area[16'h0036] = 16'h0000;  // NOP
        mem_area[16'h0037] = 16'h0000;  // NOP
        mem_area[16'h0038] = 16'h0000;  // NOP
        mem_area[16'h0039] = 16'h0000;  // NOP
        mem_area[16'h003a] = 16'h0000;  // NOP
        mem_area[16'h003b] = 16'h0000;  // NOP
        mem_area[16'h003c] = 16'h0000;  // NOP
        mem_area[16'h003d] = 16'h0000;  // NOP
        mem_area[16'h003e] = 16'h0000;  // NOP
        mem_area[16'h003f] = 16'h0000;  // NOP
        mem_area[16'h0040] = 16'h0000;  // NOP
        mem_area[16'h0041] = 16'h0000;  // NOP
        mem_area[16'h0042] = 16'h0000;  // NOP
        mem_area[16'h0043] = 16'h0000;  // NOP
        mem_area[16'h0044] = 16'h0000;  // NOP
        mem_area[16'h0045] = 16'h0000;  // NOP
        mem_area[16'h0046] = 16'h0000;  // NOP
        mem_area[16'h0047] = 16'h0000;  // NOP
        mem_area[16'h0048] = 16'h0000;  // NOP
        mem_area[16'h0049] = 16'h0000;  // NOP
        mem_area[16'h004a] = 16'h0000;  // NOP
        mem_area[16'h004b] = 16'h0000;  // NOP
        mem_area[16'h004c] = 16'h0000;  // NOP
        mem_area[16'h004d] = 16'h0000;  // NOP
        mem_area[16'h004e] = 16'h0000;  // NOP
        mem_area[16'h004f] = 16'h0000;  // NOP
        mem_area[16'h0050] = 16'h0000;  // NOP
        mem_area[16'h0051] = 16'h0000;  // NOP
        mem_area[16'h0052] = 16'h0000;  // NOP
        mem_area[16'h0053] = 16'h0000;  // NOP
        mem_area[16'h0054] = 16'h0000;  // NOP
        mem_area[16'h0055] = 16'h0000;  // NOP
        mem_area[16'h0056] = 16'h0000;  // NOP
        mem_area[16'h0057] = 16'h0000;  // NOP
        mem_area[16'h0058] = 16'h0000;  // NOP
        mem_area[16'h0059] = 16'h0000;  // NOP
        mem_area[16'h005a] = 16'h0000;  // NOP
        mem_area[16'h005b] = 16'h0000;  // NOP
        mem_area[16'h005c] = 16'h0000;  // NOP
        mem_area[16'h005d] = 16'h0000;  // NOP
        mem_area[16'h005e] = 16'h0000;  // NOP
        mem_area[16'h005f] = 16'h0000;  // NOP

        //Sub-routin Area   : 0060h - 006fh
        mem_area[16'h0060] = 16'h0000;  // NOP
        mem_area[16'h0061] = 16'h0000;  // NOP
        mem_area[16'h0062] = 16'h0000;  // NOP
        mem_area[16'h0063] = 16'h0000;  // NOP
        mem_area[16'h0064] = 16'h0000;  // NOP
        mem_area[16'h0065] = 16'h0000;  // NOP
        mem_area[16'h0066] = 16'h0000;  // NOP
        mem_area[16'h0067] = 16'h0000;  // NOP
        mem_area[16'h0068] = 16'h0000;  // NOP
        mem_area[16'h0069] = 16'h0000;  // NOP
        mem_area[16'h006a] = 16'h0000;  // NOP
        mem_area[16'h006b] = 16'h0000;  // NOP
        mem_area[16'h006c] = 16'h0000;  // NOP
        mem_area[16'h006d] = 16'h0000;  // NOP
        mem_area[16'h006e] = 16'h0000;  // NOP
        mem_area[16'h006f] = 16'h0000;  // NOP
    end


endmodule