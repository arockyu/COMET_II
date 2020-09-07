/**************************************************************************
/* COMET II CPU CORE
/*
/**************************************************************************
/*
/*
/*
/**************************************************************************/

module COMET_II_top (
    input mclk,
    input init,
    input rst,

    input [15:0] PR_init,
    input [15:0] SP_init,

    output re,
    output [15:0] raddr,
    input [15:0] rdata,

    output we,
    output [15:0] waddr,
    output [15:0] wdata,
    output [2:0] stage
);
    parameter initial_PR = 16'h0000;
    parameter initial_SP = 16'h0000;  


    localparam ALU_NOP  = 4'b1111;
    localparam ALU_CPA  = 4'b0000;
    localparam ALU_CPL  = 4'b0001;


   //stage definition
    localparam  IDLE  = 3'b000;
    localparam  INIT  = 3'b001;
    localparam  IFET1 = 3'b010;
    localparam  IFET2 = 3'b011;
    localparam  EXEC  = 3'b100;


    //  Resistors Declaretuin and initiallization ///////////////////////////////////////////////////////

    reg [15:0] PR = initial_PR;  //Program Counter Registor
    reg [15:0] SP = initial_SP;  //Stack Pointer Regisor 
    reg [15:0] GR[7:0];        //General Purpose Registor

    initial begin
        GR[0] = 16'h0000;
        GR[1] = 16'h0000;
        GR[2] = 16'h0000;
        GR[3] = 16'h0000;
        GR[4] = 16'h0000;
        GR[5] = 16'h0000;
        GR[6] = 16'h0000;
        GR[7] = 16'h0000;
    end
    reg [2:0] FR = 3'b000;     //Flag Registor

    wire OF = FR[2]; //Overflow Flag
    wire SF = FR[1]; //Sign Flag
    wire ZF = FR[0]; //Zero Flag

    //data signal declaration and connection logic

    wire [15:0] ALU_in0 = GR[r_r1];
    wire [15:0] ALU_in1 = shift   ? eff_adr  :               //Excecute cycle for Shift Opatation (set eff_addr)
                          r_adr_x ? rdata    :               //Excecute cycle for r,adr[,x] mode  Opatation (set rdata) 
                          r1_r2   ? GR[x_r2] : 16'h0000;     //Excecute cycle for r1,32 mode  Opatation (set GR[r2]) 

    wire [15:0] ALU_res;
    wire [2:0] ALU_FR_out;

    wire [15:0] adr; 

    wire  [15:0] eff_adr = (x_r2 != 4'd0) ? adr + GR[x_r2] : adr; //effective address

    assign we = store|push|call;
    assign waddr = store     ? eff_adr :                // STORE execute cycle 
                   push|call ? SP       : 16'hxxxx;     // PUSH/CALL execute cycle

    assign wdata =  store ? GR[r_r1] :                  // STORE execute cycle 
                    push  ? eff_adr  :                  // PUSH execute cycle
                    call  ? PR       : 16'hxxxx;        // CALL execute cycle

    assign re = set_FR & !shift & r_adr_x  | pop | ret | IFETCH_inc_PR ;

    assign raddr = IFETCH_inc_PR             ? PR      :              // instrument fetch cycle ( set raddr to PR )
                   pop | ret                 ? SP      :              // POP/RET execute cycle (set raddr SP)
                   set_FR & !shift & r_adr_x ? eff_adr : 16'hxxxx;    // r_adr_x mode memory read execute cycle (set raddr effective addr)

                   

    ////   controll signals declaration
    wire [7:0] op_code;
    wire [3:0] r_r1,x_r2;

    wire [3:0] ALU_mode;

    wire adr_en;

    wire IFETCH_inc_PR,r_adr_x,r1_r2  
        ,set_GR_al  ,store  ,lad 
        ,set_FR, shift,compare
        ,jump   
        ,dec_SP,push   ,pop    ,call   ,ret;

    ///////  fetch processes for each registors

    always @(negedge mclk)begin
        if(rst) PR = initial_PR;
        else begin
            if(stage ==INIT);
            else if (IFETCH_inc_PR) PR <= PR + 1;  // instruction fetch cycle ()
            else if (ret)           PR <= rdata;   //Execute Cycle for RET (jump to pop address)        
            else if (jump|call)     PR <= eff_adr; //Execute Cycle for CALL or JUMP(positive condition)  (jump to effctive address)
            else;
        end
    end

    always @(negedge mclk)begin
        if(rst) SP <= initial_SP;
        else begin
            if(stage ==INIT);
            else if(dec_SP)  SP <= SP - 1;  //Second Instruction Cycle for PUSH/CALL (declemet SP) 
            else if(pop|ret) SP <= SP + 1 ; //Execute cycle for POP/RET execute cycle (inclement SP) 
            else;
        end
    end

    always @(negedge mclk)begin
        if(rst) begin
            GR[0] <= 16'h0000;
            GR[1] <= 16'h0000;
            GR[2] <= 16'h0000;
            GR[3] <= 16'h0000;
            GR[4] <= 16'h0000;
            GR[5] <= 16'h0000;
            GR[6] <= 16'h0000;
            GR[7] <= 16'h0000;
        end 

        else begin
             if(set_GR_al) GR[r_r1] <= ALU_res;    // Execute cycle for LD or Alithmetic Instructions without CPA/CPL (set GR[r/r1] to ALU Result ) *LD cattegorized in Alithmetic Instruction for set FR by ALU
             else if (lad) GR[r_r1] <= eff_adr;   // Execute cycle for (set GR[r/r1] to effective addr value)
             else if (pop) GR[r_r1] <= rdata;     // Execute cycle for (set GR[r/r1] to mem read value)
             else;
        end
    end

    always @(negedge mclk)begin
        if(rst) FR = 3'b000;
        else begin
            if(set_FR) FR <= ALU_FR_out;
        end
    end

    //  ALU  //////////////////////////////////////////////////////////////////////

    Comet_II_ALU U1(
        .ALU_OP_type(ALU_mode),
    
        .indata0(ALU_in0),
        .indata1(ALU_in1),

        .result(ALU_res),
        .FR(ALU_FR_out)
    );

    //  Controllers ///////////////////////////////////////////////////////////////
    Comet_II_controller U2(
        .mclk(mclk),
        .init(init),
        .rst(rst),
    
        .rdata(rdata),
        .FR(FR),

        .adr(adr),
        .adr_en(adr_en),
        .stage(stage),

        .op_code(op_code),
        .r_r1(r_r1),
        .x_r2(x_r2),
        .ALU_mode(ALU_mode),
        .IFETCH_inc_PR(IFETCH_inc_PR),
        .r_adr_x(r_adr_x),
        .r1_r2(r1_r2),
        .set_GR_al(set_GR_al),
        .store(store),
        .lad(lad),
        .set_FR(set_FR),
        .shift(shift),
        .compare(compare),
        .jump(jump),
        .dec_SP(dec_SP),
        .push(push),
        .pop(pop),
        .call(call),
        .ret(ret)); 

    // for debug
    wire [15:0] gr0=GR[0];
    wire [15:0] gr1=GR[1];
    wire [15:0] gr2=GR[2];
    wire [15:0] gr3=GR[3];
    wire [15:0] gr4=GR[4];
    wire [15:0] gr5=GR[5];
    wire [15:0] gr6=GR[6];
    wire [15:0] gr7=GR[7];

endmodule