/**************************************************************************
/* COMET II CPU ALU
/* Combinational Logic
/**************************************************************************
/*input [3:0] ALU_OP_type   : Arithmetic Operation type
/*input [15:0] indata0      : first term input data (in0)
/*input [15:0] indata1      : second term input data(in1)
/*output [15:0] result      : result value of operation
/*output [2:0] FR           : result FR value of operation
/**************************************************************************/
/* It's assumed that first designated registor (r,r1) is connected to 
/* indata0, and seconnd designated registor (r2) or effective address 
/* value(adr+x) is connected to indata1.
/* LD operation is included in ALU operations to update FR.In that case,
/* ALU output FR value to be updated and indata1 value as result.
/* (Indata0 would be ignored)
/*
/**************************************************************************/


module Comet_II_ALU (
    input [3:0] ALU_OP_type,
  
    input [15:0] indata0,
    input [15:0] indata1,

    output [15:0] result,
    output [2:0] FR
);

    ////// localparams /////////////

    //ALU mode
    localparam ALU_NOP = 4'b1111;
    localparam ALU_LD  = 4'b0111;   

    localparam ALU_ADDA = 4'b1000;
    localparam ALU_SUBA = 4'b1001;
    localparam ALU_ADDL = 4'b1010;
    localparam ALU_SUBL = 4'b1011;

    localparam ALU_AND  = 4'b1100;
    localparam ALU_OR   = 4'b1101;
    localparam ALU_XOR  = 4'b1110;

    localparam ALU_CPA  = 4'b0000;
    localparam ALU_CPL  = 4'b0001;

    localparam ALU_SLA  = 4'b0100;
    localparam ALU_SRA  = 4'b0101;
    localparam ALU_SLL  = 4'b0010;
    localparam ALU_SRL  = 4'b0011;



    reg OF;
    reg SF;
    reg ZF;
    reg [2:0] FR;
    reg [16:0] temp_res;
    reg [15:0] result;
    wire [15:0] minus_indata1 = ~indata1 +16'd1;
    
    always @(*)begin
        case(ALU_OP_type)
            ALU_NOP : ;
            ALU_LD  :
                begin
                    OF = 1'b0;
                    SF = indata1[15];
                    ZF = (indata1[15:0] == 16'd0);
                    result = indata1;
                    FR={OF,SF,ZF};
                end
            ALU_ADDA:
                begin
                    temp_res = {1'b0,indata0} + {1'b0,indata1};
                    OF = ( indata0[15] == 1'b0 && indata1[15] == 1'b0 ) ?  temp_res[15]  :         
                         ( indata0[15] == 1'b1 && indata1[15] == 1'b1 ) ? !temp_res[15] : 1'b0;
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_SUBA:
                begin
                    temp_res = {1'b0,indata0} + {1'b0,minus_indata1};
                    OF = ( indata0[15] == 1'b0 && minus_indata1[15] == 1'b0 ) ?  temp_res[15]  :         
                         ( indata0[15] == 1'b1 && minus_indata1[15] == 1'b1 ) ? !temp_res[15] : 1'b0;
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];   
                    FR={OF,SF,ZF};             
                end
            ALU_ADDL:
                begin
                    temp_res = {1'b0,indata0} + {1'b0,indata1};
                    OF = temp_res[16];
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_SUBL:
                begin
                    temp_res = {1'b0,indata0} - {1'b0,indata1};
                    OF = temp_res[16];
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_AND :
                begin
                    temp_res = indata0 & indata1;
                    OF = 1'b0;
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_OR  :
                begin
                    temp_res = indata0 | indata1;
                    OF = 1'b0;
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_XOR  :
                begin
                    temp_res = indata0 ^ indata1;
                    OF = 1'b0;
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_CPA :
                begin
                    temp_res = {1'b0,indata0} + {1'b0,minus_indata1};
                    OF = 1'b0;
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_CPL :
                begin
                    temp_res = {1'b0,indata0} - {1'b0,indata1};
                    OF = 1'b0;
                    SF = temp_res[16];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_SLA :
                begin
                    temp_res = {2'b00,indata0[14:0]} << indata1;
                    OF = temp_res[15];
                    SF = indata0[15];
                    result = {indata0[15],temp_res[14:0]};
                    ZF = (result == 16'd0) ;
                    FR={OF,SF,ZF};
                end
            ALU_SRA :
                begin
                    temp_res = $signed({indata0,1'b0}) >>> indata1;
                    OF = temp_res[0];
                    SF = temp_res[16];
                    ZF = (temp_res[16:1] == 16'd0);
                    result = temp_res[16:1];
                    FR={OF,SF,ZF};
                end
            ALU_SLL :
                begin
                    temp_res = {1'b0,indata0} << indata1;
                    OF = temp_res[16];
                    SF = temp_res[15];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[15:0];
                    FR={OF,SF,ZF};
                end
            ALU_SRL :
                begin
                    temp_res = {1'b0,(indata0 >> indata1)};
                    OF = temp_res[0];
                    SF = temp_res[16];
                    ZF = (temp_res[15:0] == 16'd0);
                    result = temp_res[16:1];
                    FR={OF,SF,ZF};
                end
            default: ;
        endcase
    end

endmodule