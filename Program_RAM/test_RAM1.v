/**************************************************************************
/* Psude RAM for  COMET II CPU Test No.１
/*
/* Basic Instruction And Alithmetic Instruction test
/*
/**************************************************************************/

module test_RAM1 (
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
        mem_area[16'h0000] = 16'h1200;  // LAD  r = GR0, x= No Reg
        mem_area[16'h0001] = 16'h0000;  // adr = 0000h
        mem_area[16'h0002] = 16'h1210;  // LAD  r = GR1, x= No Reg
        mem_area[16'h0003] = 16'h0001;  // adr = 0001h
        mem_area[16'h0004] = 16'h1221;  // LAD  r = GR2, x = GR1
        mem_area[16'h0005] = 16'h7ffe;  // adr = 7ffeh              (ffff)
        mem_area[16'h0006] = 16'h1230;  // LAD  r = GR3, x = No Reg
        mem_area[16'h0007] = 16'hffff;  // adr = ffffh
        mem_area[16'h0008] = 16'h1240;  // LAD  r = GR4, x = No Reg
        mem_area[16'h0009] = 16'h8000;  // adr = 8000h
        mem_area[16'h000a] = 16'h1250;  // LAD  r = GR5, x = No Reg
        mem_area[16'h000b] = 16'h0a50;  // adr = 0a50h
        mem_area[16'h000c] = 16'h1260;  // LAD  r = GR6, x = No Reg 
        mem_area[16'h000d] = 16'hf5a0;  // adr = f5a0h
        mem_area[16'h000e] = 16'h1270;  // LAD  r = GR7, x = No Reg 
        mem_area[16'h000f] = 16'h0070;  // adr = 0070h
        mem_area[16'h0010] = 16'h1107;  // ST   r = GR0, x = GR7
        mem_area[16'h0011] = 16'h0000;  // adr = 0000h
        mem_area[16'h0012] = 16'h1401;  // LD   r1 = GR0, r2 = GR1
        mem_area[16'h0013] = 16'h1107;  // ST   r = GR0, x = GR7
        mem_area[16'h0014] = 16'h0001;  // adr = 0001h
        mem_area[16'h0015] = 16'h1127;  // ST   r = GR2, x = GR7
        mem_area[16'h0016] = 16'h0002;  // adr = 0002h
        mem_area[16'h0017] = 16'h1137;  // ST   r = GR3, x = GR7
        mem_area[16'h0018] = 16'h0003;  // adr = 0003h
        mem_area[16'h0019] = 16'h1147;  // ST   r = GR4, x = GR7
        mem_area[16'h001a] = 16'h0004;  // adr = 0004h
        mem_area[16'h001b] = 16'h1157;  // ST   r = GR5, x = GR7
        mem_area[16'h001c] = 16'h0005;  // adr = 0005h
        mem_area[16'h001d] = 16'h1167;  // ST   r = GR6, x = GR7
        mem_area[16'h001e] = 16'h0006;  // adr = 0006h
        mem_area[16'h001f] = 16'h1007;  // LD   r = GR0, x = GR7
        mem_area[16'h0020] = 16'h0000;  // adr = 0000h
        mem_area[16'h0021] = 16'h2401;  // ADDA r1 = GR0, r2 = GR1
        mem_area[16'h0022] = 16'h2000;  // ADDA r0 = GR0, x = No Reg
        mem_area[16'h0023] = 16'h0072;  // adr = 0072h
        mem_area[16'h0024] = 16'h2007;  // ADDA r = GR0, x = GR7
        mem_area[16'h0025] = 16'h0002;  // adr = 0002h
        mem_area[16'h0026] = 16'h2403;  // ADDA r1 = GR0, r2 = GR3
        mem_area[16'h0027] = 16'h2207;  // ADDL r = GR0, x = GR7
        mem_area[16'h0028] = 16'h0002;  // adr = 0002h
        mem_area[16'h0029] = 16'h2601;  // ADDL r1 = GR0, r2 = GR1
        mem_area[16'h002a] = 16'h2501;  // SUBA r1 = GR0, r2 = GR1
        mem_area[16'h002b] = 16'h2107;  // SUBA r = GR0, x = GR7
        mem_area[16'h002c] = 16'h0002;  // adr = 0002h
        mem_area[16'h002d] = 16'h2501;  // SUBA r1 = GR0, r2 = GR1
        mem_area[16'h002e] = 16'h2503;  // SUBA r1 = GR0, r2 = GR3
        mem_area[16'h002f] = 16'h2307;  // SUBL r = GR0, x = GR77
        mem_area[16'h0030] = 16'h0002;  // adr = 0002h
        mem_area[16'h0031] = 16'h2701;  // SUBL r1 = GR0, r2 = GR1
        mem_area[16'h0032] = 16'h2701;  // SUBL r1 = GR0, r2 = GR1
        mem_area[16'h0033] = 16'h3406;  // AND  r1 = GR0, r2 = GR6
        mem_area[16'h0034] = 16'h3007;  // AND  r = GR0, x = GR7
        mem_area[16'h0035] = 16'h0000;  // adr = 0000h
        mem_area[16'h0036] = 16'h3556;  // OR   r1 = GR5, r2 = GR6
        mem_area[16'h0037] = 16'h3157;  // OR   r = GR5, x = GR7
        mem_area[16'h0038] = 16'h0001;  // adr = 0001h
        mem_area[16'h0039] = 16'h1057;  // LD   r = GR5, x = GR7
        mem_area[16'h003a] = 16'h0005;  // adr = 0005h 
        mem_area[16'h003b] = 16'h3636;  // XOR  r1 = GR3, r2 = GR6
        mem_area[16'h003c] = 16'h3237;  // XOR  r = GR3, x = GR7
        mem_area[16'h003d] = 16'h0006;  // adr = 0006h 
        mem_area[16'h003e] = 16'h1037;  // LD   r = GR3, x = GR7
        mem_area[16'h003f] = 16'h0003;  // adr = 0003h 
        mem_area[16'h0040] = 16'h4413;  // CPA  r1 = GR1, r2 = GR3
        mem_area[16'h0041] = 16'h4037;  // CPA  r = GR3, x = GR7
        mem_area[16'h0042] = 16'h0001;  // adr = 0001h
        mem_area[16'h0043] = 16'h4531;  // CPL  r1 = GR3, r2 = GR1
        mem_area[16'h0044] = 16'h4117;  // CPL  r = GR1, x = GR7
        mem_area[16'h0045] = 16'h0003;  // adr = 0003h
        mem_area[16'h0046] = 16'h5050;  // SLA  r = GR5, x = No Reg
        mem_area[16'h0047] = 16'h0003;  // adr = 0003h
        mem_area[16'h0048] = 16'h5051;  // SLA  r = GR5, x = GR1
        mem_area[16'h0049] = 16'h0000;  // adr = 0000h
        mem_area[16'h004a] = 16'h5060;  // SLA  r = GR6, x = No Reg
        mem_area[16'h004b] = 16'h0001;  // adr = 0001h
        mem_area[16'h004c] = 16'h5160;  // SRA  r = GR6, x = No Reg
        mem_area[16'h004d] = 16'h0005;  // adr = 0005h
        mem_area[16'h004e] = 16'h5161;  // SRA  r = GR6, x = GR1
        mem_area[16'h004f] = 16'h0000;  // adr = 0000h 
        mem_area[16'h0050] = 16'h5157;  // LD   r = GR5, x = GR7
        mem_area[16'h0051] = 16'h0007;  // adr = 0005h 
        mem_area[16'h0052] = 16'h1057;  // LD   r = GR6, x = GR7
        mem_area[16'h0053] = 16'h0005;  // adr = 0006h 
        mem_area[16'h0054] = 16'h5250;  // SLL  r = GR5, x = No Reg
        mem_area[16'h0055] = 16'h0005;  // adr = 0005h 
        mem_area[16'h0056] = 16'h5260;  // SLL  r = GR6, x = No Reg
        mem_area[16'h0057] = 16'h0005;  // adr = 0005h 
        mem_area[16'h0058] = 16'h5357;  // SRL r = GR5, x = GR7
        mem_area[16'h0059] = 16'h0001;  // adr = 0001h 
        mem_area[16'h005a] = 16'h5367;  // SRL r = GR6, x = GR7
        mem_area[16'h005b] = 16'h0001;  // adr = 0001h 
        mem_area[16'h005c] = 16'h0000;  // NOP
        mem_area[16'h005d] = 16'h0000;  // NOP
        mem_area[16'h005e] = 16'h6400;  // JUMP x = No Reg
        mem_area[16'h005f] = 16'h0000;  // adr = 0000h 

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