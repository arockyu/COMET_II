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
        program_aree[16'h0001] = 16'ha5a5;  // adr = a5a5h
        program_aree[16'h0002] = 16'h1220;  // LAD GR2, x = no reg
        program_aree[16'h0003] = 16'h5a5a;  // adr = 5a5ah
        program_aree[16'h0004] = 16'h1230;  // LAD GR3, x = no reg 
        program_aree[16'h0005] = 16'h0001;  // adr = 0001
        program_aree[16'h0006] = 16'h7000;  // PUSH x = no reg
        program_aree[16'h0007] = 16'h3344;  // adr = 3344h
        program_aree[16'h0008] = 16'h7001;  // PUSH x = GR1
        program_aree[16'h0009] = 16'h0000;  // adr = 0000h
        program_aree[16'h000a] = 16'h7002;  // PUSH x = GR2
        program_aree[16'h000b] = 16'h0001;  // adr = 0001h
        program_aree[16'h000c] = 16'h7100;  // POP GR0      (<- 5a5bh)   
        program_aree[16'h000d] = 16'h7140;  // POP GR4      (<- a5a5h)
        program_aree[16'h000e] = 16'h7100;  // POP GR0      (<- 3344h)
        program_aree[16'h000f] = 16'h8000;  // CALL x = no reg
        program_aree[16'h0010] = 16'h0020;  // adr = 0020H
        program_aree[16'h0011] = 16'h6400;  // JUMP x = no reg
        program_aree[16'h0012] = 16'h0006;  // adr = 0006h
        program_aree[16'h0013] = 16'h0000;  // NOP
        program_aree[16'h0014] = 16'h0000;  // NOP
        program_aree[16'h0015] = 16'h0000;  // NOP
        program_aree[16'h0016] = 16'h0000;  // NOP
        program_aree[16'h0017] = 16'h0000;  // NOP
        program_aree[16'h0018] = 16'h0000;  // NOP
        program_aree[16'h0019] = 16'h0000;  // NOP
        program_aree[16'h001a] = 16'h0000;  // NOP
        program_aree[16'h001b] = 16'h0000;  // NOP
        program_aree[16'h001c] = 16'h0000;  // NOP
        program_aree[16'h001d] = 16'h0000;  // NOP
        program_aree[16'h001e] = 16'h0000;  // NOP
        program_aree[16'h001f] = 16'h0000;  // NOP
        program_aree[16'h0020] = 16'h7000;  // PUSH x = no reg            <- called addr
        program_aree[16'h0021] = 16'h1111;  // adr = 1111h
        program_aree[16'h0022] = 16'h7100;  // POP GR0      (<- 1111h)
        program_aree[16'h0023] = 16'h8100;  // RET
        program_aree[16'h0024] = 16'h0000;  // 
        program_aree[16'h0025] = 16'h0000;  // 
        program_aree[16'h0026] = 16'h0000;  // 
        program_aree[16'h0027] = 16'h0000;  // 
        program_aree[16'h0028] = 16'h0000;  // 
        program_aree[16'h0029] = 16'h0000;  //
        program_aree[16'h002a] = 16'h0000;  //
        program_aree[16'h002b] = 16'h0000;  //
        program_aree[16'h002c] = 16'h0000;  //
        program_aree[16'h002d] = 16'h0000;  //
        program_aree[16'h002e] = 16'h0000;  //
        program_aree[16'h002f] = 16'h0000;  //
        program_aree[16'h0030] = 16'h0000;  //
        program_aree[16'h0031] = 16'h0000;  //
        program_aree[16'h0032] = 16'h0000;  //
        program_aree[16'h0033] = 16'h0000;  //
        program_aree[16'h0034] = 16'h0000;  //
        program_aree[16'h0035] = 16'h0000;  //
        program_aree[16'h0036] = 16'h0000;  //
        program_aree[16'h0037] = 16'h0000;  //
        program_aree[16'h0038] = 16'h0000;  //
        program_aree[16'h0039] = 16'h0000;  //
        program_aree[16'h003a] = 16'h0000;  //
        program_aree[16'h003b] = 16'h0000;  //
        program_aree[16'h003c] = 16'h0000;  //
        program_aree[16'h003d] = 16'h0000;  //
        program_aree[16'h003e] = 16'h0000;  //
        program_aree[16'h003f] = 16'h0000;  //
    end


endmodule