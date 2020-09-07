module test_RAM (
    input mclk,

    input we,
    input [15:0] waddr,
    input [15:0] wdata,

    input re,
    input [15:0] raddr,
    output [15:0] rdata
);

    reg [15:0] program_aree[127:0] ;
    wire [15:0] HiZs;


     assign rdata = re ? program_aree[ raddr[6:0] ] : HiZs;


    always @(negedge mclk) begin
        if(we)program_aree[ waddr[6:0]] <= wdata;
    end 

    // Test program
    initial begin
        program_aree[16'h0000] = 16'h1210;  // LAD GR1, x = no reg
        program_aree[16'h0001] = 16'h0003;  // adr = 0003h
        program_aree[16'h0002] = 16'h1200;  // LAD GR0, x = no reg
        program_aree[16'h0003] = 16'h8000;  // adr = 8000h
        program_aree[16'h0004] = 16'h1100;  // ST GR0, x = no reg 
        program_aree[16'h0005] = 16'h0040;  // adr = 0040h
        program_aree[16'h0006] = 16'h1200;  // LAD GR1,x = nno reg
        program_aree[16'h0007] = 16'hffff;  // adr = ffffh
        program_aree[16'h0008] = 16'h1100;  // ST GR0, x = no reg 
        program_aree[16'h0009] = 16'h0041;  // adr = 0041h
        program_aree[16'h000a] = 16'h1201;  // LAD GR0,x = nno reg
        program_aree[16'h000b] = 16'hfffd;  // adr = fffdh
        program_aree[16'h000c] = 16'h1101;  // ST GR0, x = GR1 
        program_aree[16'h000d] = 16'h003f;  // adr = 003fh
        program_aree[16'h000e] = 16'h1220;  // LAD GR2,x = no reg
        program_aree[16'h000f] = 16'h0001;  // adr = 0001H
        program_aree[16'h0010] = 16'h1120;  // ST GR2, x = no reg 
        program_aree[16'h0011] = 16'h0043;  // adr = 0043H
        program_aree[16'h0012] = 16'h1230;  // LAD GR3,x = GR2
        program_aree[16'h0013] = 16'h7ffe;  // adr = 7ffeH
        program_aree[16'h0014] = 16'h1130;  // ST GR3, x = no reg 
        program_aree[16'h0015] = 16'h0044;  // adr = 0044H
        program_aree[16'h0016] = 16'h1443;  // LD GR4,GR3
        program_aree[16'h0017] = 16'h1404;  // LD GR0,GR4
        program_aree[16'h0018] = 16'h1000;  // LD GR0,x=no reg
        program_aree[16'h0019] = 16'h0040;  // adr = 0040h
        program_aree[16'h001a] = 16'h1002;  // LD GR0,x=GR2
        program_aree[16'h001b] = 16'h0040;  // adr = 0040h
        program_aree[16'h001c] = 16'h1000;  // LD GR0,x=no reg
        program_aree[16'h001d] = 16'h0042;  // adr = 0042h
        program_aree[16'h001e] = 16'h1001;  // LD GR0,x=GR1
        program_aree[16'h001f] = 16'h0040;  // adr = 0040h
        program_aree[16'h0020] = 16'h1000;  // LD GR0,x=no reg
        program_aree[16'h0021] = 16'h0044;  // adr = 0044h
        program_aree[16'h0022] = 16'h5001;  // SLA GR0 ,x = GR1
        program_aree[16'h0023] = 16'h0001;  // adr = 0001h
        program_aree[16'h0024] = 16'h5200;  // SLL GR0 ,x =no reg
        program_aree[16'h0025] = 16'h0001;  // adr 0001h
        program_aree[16'h0026] = 16'h4502;  // CPL GR5,GR1
        program_aree[16'h0027] = 16'h4402;  // CPA GR5,GR1
        program_aree[16'h0028] = 16'h1000;  // LD GR0,x=no reg
        program_aree[16'h0029] = 16'h0042;  // 0043h
        program_aree[16'h002a] = 16'h6100;  // JMI x = no reg
        program_aree[16'h002b] = 16'h003b;  // adr = 003bh
        program_aree[16'h002c] = 16'h2100;  // SUBA GR0,x= no reg
        program_aree[16'h002d] = 16'h0043;  // adr =  0043
        program_aree[16'h002e] = 16'h6401;  // JUMP x = GR1
        program_aree[16'h002f] = 16'h0027;  // adr =0027h
        program_aree[16'h0030] = 16'h8001;  // CALL x = GER1
        program_aree[16'h0031] = 16'h0030;  // adr 0030h
        program_aree[16'h0032] = 16'h8100;  // RET
        program_aree[16'h0033] = 16'h7001;  // PUSH x = GR1
        program_aree[16'h0034] = 16'h0000;  // adr 0001h
        program_aree[16'h0035] = 16'h7000;  // PUSH x = no reg
        program_aree[16'h0036] = 16'h0000;  // adr a5a5
        program_aree[16'h0037] = 16'h7100;  // POP GR0
        program_aree[16'h0038] = 16'h7100;  // POP GR0
        program_aree[16'h0039] = 16'h0000;  // NOP
        program_aree[16'h003a] = 16'h8100;  // RET 
        program_aree[16'h003b] = 16'h8000;  // CALL x= no reg
        program_aree[16'h003c] = 16'h0030;  // 0030h
        program_aree[16'h003d] = 16'h6400;  // JUMP x=no reg
        program_aree[16'h003e] = 16'h0028;  // adr = 0028h
        program_aree[16'h003f] = 16'h0000;  // NOP
    end


endmodule