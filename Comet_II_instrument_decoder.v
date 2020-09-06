/**************************************************************************
/* COMET II CPU instrument_decoderr
/*
/**************************************************************************
/*
/*
/*
/**************************************************************************/


module Comet_II_instrument_decoder (
    input [2:0] state,
    input [2:0] FR,
    input [7:0] op_code,
    input [7:0] regs,
    input adr_en,


    output [3:0] r_r1,
    output [3:0] x_r2,

    output [3:0] ALU_mode,
    
    output inc_PR,

    output r_adr_x,
    output r1_r2,

    output ld,
    output store,
    output lad,

    output jump,

    output dec_SP,
    output push,

    output pop,
    output call,
    output ret    );   

    reg [11:0]  decoded_pattern;

    wire OF = FR[2];
    wire SF = FR[1];
    wire ZF = FR[0];

    assign {inc_PR ,r_adr_x,r1_r2  ,ld
           ,store  ,lad    ,jump   ,dec_SP
           ,push   ,pop    ,call   ,ret}   = decoded_pattern;

    reg ALU_mode;

    ////// localparams /////////////

    //OP Code definition
    localparam NOP = 8'b0000_0000;
  
    localparam LD   = 8'b0001_0000;
    localparam ST   = 8'b0001_0001;    
    localparam LAD  = 8'b0001_0010;  

    localparam ADDA = 8'b0010_0000;
    localparam SUBA = 8'b0010_0001;
    localparam ADDL = 8'b0010_0010;
    localparam SUBL = 8'b0010_0011;

    localparam AND  = 8'b0011_0000;
    localparam OR   = 8'b0011_0001;
    localparam XOR  = 8'b0011_0010;

    localparam CPA  = 8'b0100_0000;
    localparam CPL  = 8'b0100_0001;

    localparam SLA  = 8'b0101_0000;
    localparam SRA  = 8'b0101_0001;
    localparam SLL  = 8'b0101_0010;
    localparam SRL  = 8'b0101_0011;

    localparam JMI  = 8'b0110_0001;
    localparam JNZ  = 8'b0110_0010;
    localparam JZE  = 8'b0110_0011;
    localparam JUMP = 8'b0110_0100;
    localparam JPL  = 8'b0110_0101;
    localparam JOV  = 8'b0110_0110;

    localparam PUSH = 8'b0111_0000;
    localparam POP  = 8'b0111_0001;

    localparam CALL = 8'b1000_0000;
    localparam RET  = 8'b1000_0001;

    localparam SVC  = 8'b1111_0000;

    //ALU mode

    localparam ALU_NOP  = 4'b1111;

    localparam ALU_LD   = 4'b0111;   

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

    //state definition
    localparam  IDLE  = 3'b000;
    localparam  INIT  = 3'b001;
    localparam  IFET1 = 3'b010;
    localparam  IFET2 = 3'b011;
    localparam  EXEC  = 3'b100;
    localparam  WBACK = 3'b101;   


    assign r_r1  = regs[7:4];
    assign x_r2  = regs[3:0];


    always @(*)begin

        case(op_code & 8'b1111_1011)
            NOP  : ALU_mode = ALU_NOP;
            LD   : ALU_mode = ALU_LD;
            ADDA : ALU_mode = ALU_ADDA;
            SUBA : ALU_mode = ALU_SUBA;
            ADDL : ALU_mode = ALU_ADDL;
            SUBL : ALU_mode = ALU_SUBL;
            AND  : ALU_mode = ALU_AND;
            OR   : ALU_mode = ALU_OR;
            XOR  : ALU_mode = ALU_XOR;
            CPA  : ALU_mode = ALU_CPA;
            CPL  : ALU_mode = ALU_CPL;
            SLA  : ALU_mode = ALU_SLA;
            SRA  : ALU_mode = ALU_SRA;
            SLL  : ALU_mode = ALU_SLL;
            SRL  : ALU_mode = ALU_SRL;
            default: ALU_mode = ALU_NOP;
        endcase
    end

    always @(*)begin
        case(state)
            IDLE :
                begin 
                    decoded_pattern = 12'b0000_0000_0000;
                end
            INIT : 
                begin 
                    decoded_pattern = 12'b0000_0000_0000;
                end
            IFET1: 
                begin 
                    //set inc_PR to active
                    decoded_pattern = 12'b1000_0000_0000;                   
                end
            IFET2:
                begin
                    //set inc_PR to active
                    decoded_pattern[11] = 1'b1;
                    
                    decoded_pattern[10:9] = 2'b10;
                    decoded_pattern[8:6] = 3'b000;
                    decoded_pattern[5] = 1'b0;
                    case(op_code)
                        PUSH   : decoded_pattern[4:0] = 5'b1_0000;
                        CALL   : decoded_pattern[4:0] = 5'b1_0000;
                        default: decoded_pattern[4:0] = 5'b0_0000;
                    endcase
                end
            EXEC :
                begin
                    //set inc_PR to zero
                    decoded_pattern[11] = 1'b0;

                    //set ,r_adr_x,r1_r2
                    if(ALU_mode != ALU_NOP)begin
                        if(op_code [3:2] == 2'b00) decoded_pattern[10:9] = 2'b10;
                        else decoded_pattern[10:9] = 2'b01;
                    end else begin
                        case(op_code)
                            POP     : decoded_pattern[10:9] = 2'b00;
                            RET     : decoded_pattern[10:9] = 2'b00;
                            default : decoded_pattern[10:9] = 2'b10;
                        endcase
                    end

                    //set ld,store,lad
                    decoded_pattern[8] = (ALU_mode != ALU_NOP & op_code[7:4]!=4'd4);
                    decoded_pattern[7] = (op_code == ST);
                    decoded_pattern[6] = (op_code == LAD);

                    //set jump
                     case(op_code)
                        JPL    : decoded_pattern[5] = (!SF & !ZF);
                        JMI    : decoded_pattern[5] = (SF);
                        JNZ    : decoded_pattern[5] = (!ZF);
                        JZE    : decoded_pattern[5] = (ZF);
                        JOV    : decoded_pattern[5] = (OF);
                        JUMP   : decoded_pattern[5] = 1'b1; 
                        CALL   : decoded_pattern[5] = 1'b1; 
                        RET    : decoded_pattern[5] = 1'b1;                 
                        default: decoded_pattern[5] = 1'b0;
                    endcase                   

                    case(op_code)
                        PUSH   : decoded_pattern[4:0] = 5'b0_1000;
                        POP    : decoded_pattern[4:0] = 5'b0_0100;
                        CALL   : decoded_pattern[4:0] = 5'b0_0010;
                        RET    : decoded_pattern[4:0] = 5'b0_0001;
                        default: decoded_pattern[4:0] = 5'b0_0000;
                    endcase
                end
            WBACK:;
            default: decoded_pattern = 12'b0000_0000_0000;
        endcase
    end

endmodule