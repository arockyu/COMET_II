/**************************************************************************
/* Psude RAM for  COMET II CPU Test
/*
/*
/**************************************************************************/

module test_RAM (
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

              //[ 　Addr ]   Data　　　　//

        mem_area[16'h0000] = 16'h1210;  // LAD GR1, x = no reg
        mem_area[16'h0001] = 16'h0003;  // adr = 0003h
        mem_area[16'h0002] = 16'h1200;  // LAD GR0, x = no reg
        mem_area[16'h0003] = 16'h8000;  // adr = 8000h
        mem_area[16'h0004] = 16'h1100;  // ST GR0, x = no reg 
        mem_area[16'h0005] = 16'h0040;  // adr = 0040h
        mem_area[16'h0006] = 16'h1200;  // LAD GR1,x = nno reg
        mem_area[16'h0007] = 16'hffff;  // adr = ffffh
        mem_area[16'h0008] = 16'h1100;  // ST GR0, x = no reg 
        mem_area[16'h0009] = 16'h0041;  // adr = 0041h
        mem_area[16'h000a] = 16'h1201;  // LAD GR0,x = nno reg
        mem_area[16'h000b] = 16'hfffd;  // adr = fffdh
        mem_area[16'h000c] = 16'h1101;  // ST GR0, x = GR1 
        mem_area[16'h000d] = 16'h003f;  // adr = 003fh
        mem_area[16'h000e] = 16'h1220;  // LAD GR2,x = no reg
        mem_area[16'h000f] = 16'h0001;  // adr = 0001H
        mem_area[16'h0010] = 16'h1120;  // ST GR2, x = no reg 
        mem_area[16'h0011] = 16'h0043;  // adr = 0043H
        mem_area[16'h0012] = 16'h1230;  // LAD GR3,x = GR2
        mem_area[16'h0013] = 16'h7ffe;  // adr = 7ffeH
        mem_area[16'h0014] = 16'h1130;  // ST GR3, x = no reg 
        mem_area[16'h0015] = 16'h0044;  // adr = 0044H
        mem_area[16'h0016] = 16'h1443;  // LD GR4,GR3
        mem_area[16'h0017] = 16'h1404;  // LD GR0,GR4
        mem_area[16'h0018] = 16'h1000;  // LD GR0,x=no reg
        mem_area[16'h0019] = 16'h0040;  // adr = 0040h
        mem_area[16'h001a] = 16'h1002;  // LD GR0,x=GR2
        mem_area[16'h001b] = 16'h0040;  // adr = 0040h
        mem_area[16'h001c] = 16'h1000;  // LD GR0,x=no reg
        mem_area[16'h001d] = 16'h0042;  // adr = 0042h
        mem_area[16'h001e] = 16'h1001;  // LD GR0,x=GR1
        mem_area[16'h001f] = 16'h0040;  // adr = 0040h
        mem_area[16'h0020] = 16'h1000;  // LD GR0,x=no reg
        mem_area[16'h0021] = 16'h0044;  // adr = 0044h
        mem_area[16'h0022] = 16'h5001;  // SLA GR0 ,x = GR1
        mem_area[16'h0023] = 16'h0001;  // adr = 0001h
        mem_area[16'h0024] = 16'h5200;  // SLL GR0 ,x =no reg
        mem_area[16'h0025] = 16'h0001;  // adr 0001h
        mem_area[16'h0026] = 16'h4502;  // CPL GR5,GR1
        mem_area[16'h0027] = 16'h4402;  // CPA GR5,GR1
        mem_area[16'h0028] = 16'h1000;  // LD GR0,x=no reg
        mem_area[16'h0029] = 16'h0042;  // 0043h
        mem_area[16'h002a] = 16'h6100;  // JMI x = no reg
        mem_area[16'h002b] = 16'h003b;  // adr = 003bh
        mem_area[16'h002c] = 16'h2100;  // SUBA GR0,x= no reg
        mem_area[16'h002d] = 16'h0043;  // adr =  0043
        mem_area[16'h002e] = 16'h6401;  // JUMP x = GR1
        mem_area[16'h002f] = 16'h0027;  // adr =0027h
        mem_area[16'h0030] = 16'h8001;  // CALL x = GER1
        mem_area[16'h0031] = 16'h0030;  // adr 0030h
        mem_area[16'h0032] = 16'h8100;  // RET
        mem_area[16'h0033] = 16'h7001;  // PUSH x = GR1
        mem_area[16'h0034] = 16'h0000;  // adr 0001h
        mem_area[16'h0035] = 16'h7000;  // PUSH x = no reg
        mem_area[16'h0036] = 16'h0000;  // adr a5a5
        mem_area[16'h0037] = 16'h7100;  // POP GR0
        mem_area[16'h0038] = 16'h7100;  // POP GR0
        mem_area[16'h0039] = 16'h0000;  // NOP
        mem_area[16'h003a] = 16'h8100;  // RET 
        mem_area[16'h003b] = 16'h8000;  // CALL x= no reg
        mem_area[16'h003c] = 16'h0030;  // 0030h
        mem_area[16'h003d] = 16'h6400;  // JUMP x=no reg
        mem_area[16'h003e] = 16'h0020;  // adr = 0020h
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