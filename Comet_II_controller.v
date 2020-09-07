/**************************************************************************
/* COMET II CPU controller
/*
/**************************************************************************
/*
/*
/*
/**************************************************************************/
module Comet_II_controller (
    input mclk,
    input init,
    input rst,
  
    input [15:0] rdata,
    input [2:0] FR,

    output [15:0] adr,
    output adr_en,
    output [2:0] stage,

    output [7:0] op_code,
    output [3:0] r_r1,
    output [3:0] x_r2,
    output [3:0] ALU_mode,

    output IFETCH_inc_PR,
    output r_adr_x,
    output r1_r2,
    output set_GR_al,
    output store,
    output lad,
    output set_FR,
    output shift,
    output compare,
    output jump,
    output dec_SP,
    output push,
    output pop,
    output call,
    output ret);   

    wire [7:0] regs;

    Comet_II_core_FSM U11(
        .mclk(mclk),
        .init(init),
        .rst(rst),
    
        .rdata(rdata),

        .op_code(op_code),
        .regs(regs),
        .adr(adr),
        .adr_en(adr_en),
        .state(stage)
    );


    Comet_II_instrument_decoder U12(
        .state(stage),
        .FR(FR),
        .op_code(op_code),
        .regs(regs),
        .adr_en(adr_en),

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
        .ret(ret)
    ); 



endmodule