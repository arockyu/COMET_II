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

    //decoded Control Signals Output 
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
    output ret    );   

    wire OF = FR[2];
    wire SF = FR[1];
    wire ZF = FR[0];

    reg [14:0]  decoded_pattern;



    assign {IFETCH_inc_PR 
           ,r_adr_x,r1_r2  
           ,set_GR_al ,store  ,lad    
           ,set_FR ,shift ,compare
           ,jump   
           ,dec_SP ,push   ,pop    ,call   ,ret}   = decoded_pattern;

    reg ALU_mode;

    ////// localparams /////////////

    //OP Code definition  
    localparam NOP = 8'b0000_0000;
  
    localparam LD   = 8'b0001_0000; //Third lowest bit set tp zero
    localparam ST   = 8'b0001_0001;
    localparam LAD  = 8'b0001_0010;  

    localparam ADDA = 8'b0010_0000; //Third lowest bit set tp zero  
    localparam SUBA = 8'b0010_0001; //Third lowest bit set tp zero  
    localparam ADDL = 8'b0010_0010; //Third lowest bit set tp zero  
    localparam SUBL = 8'b0010_0011; //Third lowest bit set tp zero  

    localparam AND  = 8'b0011_0000; //Third lowest bit set tp zero  
    localparam OR   = 8'b0011_0001; //Third lowest bit set tp zero  
    localparam XOR  = 8'b0011_0010; //Third lowest bit set tp zero  

    localparam CPA  = 8'b0100_0000; //Third lowest bit set tp zero  
    localparam CPL  = 8'b0100_0001; //Third lowest bit set tp zero  

    localparam SLA  = 8'b0101_0000; //Third lowest bit set tp zero  
    localparam SRA  = 8'b0101_0001; //Third lowest bit set tp zero  
    localparam SLL  = 8'b0101_0010; //Third lowest bit set tp zero  
    localparam SRL  = 8'b0101_0011; //Third lowest bit set tp zero  

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

    localparam SVC  = 8'b1111_0000; //Not To be Implemented 

    //ALU mode
    localparam ALU_NOP  = 4'b1111;

    localparam ALU_LD   = 4'b0111;   //Define LD as an Alisthmetic instruction for setting FR

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

    //state(Stage) definition
    localparam  IDLE  = 3'b000;
    localparam  INIT  = 3'b001;
    localparam  IFET1 = 3'b010;
    localparam  IFET2 = 3'b011;
    localparam  EXEC  = 3'b100;
    localparam  WBACK = 3'b101;   //Write Back cycle (Not to be used)

    //set GR Number From First Instruction Word(Low eight bits)
    assign r_r1  = regs[7:4];
    assign x_r2  = regs[3:0];


    // ALU mode decode (OP Code to ALU mode)(conbination logic)
    always @(*)begin
        case(op_code & 8'b1111_1011)
            NOP  : ALU_mode = ALU_NOP; // NOP
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
            default: ALU_mode = ALU_NOP; // No Alismetic Instruction (to be set ALU_NOP)
        endcase
    end

    // Other Control signals Combination decoder (conbination logic)
    always @(*)begin
        case(state)
            IDLE :
                begin 
                    decoded_pattern = 15'b000_0000_0000_0000; //All Controll Signals set to low 
                end
            INIT : 
                begin 
                    decoded_pattern = 15'b000_0000_0000_0000; //All Controll Signals set to low  
                end
            IFET1: //First Word Instrument Fetch Cycle
                begin 
                    //set IFETCH_inc_PR to active to PR incriment
                    decoded_pattern = 15'b100_0000_0000_0000;                   
                end
            IFET2://Second Word Instrument Fetch Cycle
                begin
                    //set IFETCH_inc_PR to active to PR incriment 
                    decoded_pattern[14] = 1'b1;
                    
                    //set set_GR_al,store,lad to low
                    decoded_pattern[13:12] = 2'b00;

                    //set set_GR_al,store,lad to low
                    decoded_pattern[11:9] = 3'b000;

                    //set set_FR,shift,compare to low
                    decoded_pattern[8:6] = 3'b000;         

                    //set jump to low          
                    decoded_pattern[5] = 1'b0;

                    //set dec_SP for SP pre-declemention befoore PUSH/CALL Execute Cycle
                    case(op_code)
                        PUSH   : decoded_pattern[4:0] = 5'b1_0000;
                        CALL   : decoded_pattern[4:0] = 5'b1_0000;
                        default: decoded_pattern[4:0] = 5'b0_0000;
                    endcase
                end
            EXEC : //Execution Cycle
                begin
                    //set IFETCH_inc_PR to zero
                    decoded_pattern[14] = 1'b0;

                    //set ,r_adr_x,r1_r2
                    if(ALU_mode != ALU_NOP)begin  // Alithmetic Opration (include LD)
                        if(op_code [3:2] == 2'b00) decoded_pattern[13:12] = 2'b10;  // set r1.r2 mode (1 Word Istruction)
                        else decoded_pattern[13:12] = 2'b01;                        // set x,adr[,x] mode (2 Word Instruciton)
                    end else begin               // Non-Alithmetic operation
                        case(op_code)
                            POP     : decoded_pattern[13:12] = 2'b00;     
                            RET     : decoded_pattern[13:12] = 2'b00;
                            default : decoded_pattern[13:12] = 2'b10;     // set x,adr[,x] mode  (2 Word Instruciton)
                        endcase
                    end

                    //set set_GR_al,store,lad
                    decoded_pattern[11] = (ALU_mode != ALU_NOP & op_code[7:4] != 4'h4); //set set_GR_al for Alithmetic Operation include LD exclude CPA/CPL
                    decoded_pattern[10] = (op_code == ST);   // Set to store
                    decoded_pattern[ 9] = (op_code == LAD);  // Set to lad

                    //set set_FR
                    decoded_pattern[8] = (ALU_mode != ALU_NOP);
                    //set shift
                    decoded_pattern[7] = (op_code[7:4] == 4'h5); //Set to shift to direct effective adress value to ALU 
                    //set compare 
                    decoded_pattern[6] = (op_code[7:4] == 4'h4); //For Debug  *GR shall not change on CPA/CPL Instruction

                    //set jump
                     case(op_code)
                        JPL    : decoded_pattern[5] = (!SF & !ZF);
                        JMI    : decoded_pattern[5] = (SF);
                        JNZ    : decoded_pattern[5] = (!ZF);
                        JZE    : decoded_pattern[5] = (ZF);
                        JOV    : decoded_pattern[5] = (OF);
                        JUMP   : decoded_pattern[5] = 1'b1; 
                        CALL   : decoded_pattern[5] = 1'b0; 
                        RET    : decoded_pattern[5] = 1'b0;                 
                        default: decoded_pattern[5] = 1'b0;
                    endcase                   

                    //dec_SP ,push   ,pop    ,call   ,ret 
                    case(op_code)
                        PUSH   : decoded_pattern[4:0] = 5'b0_1000;
                        POP    : decoded_pattern[4:0] = 5'b0_0100;
                        CALL   : decoded_pattern[4:0] = 5'b0_0010;
                        RET    : decoded_pattern[4:0] = 5'b0_0001;
                        default: decoded_pattern[4:0] = 5'b0_0000;
                    endcase
                end
            WBACK:;
            default: decoded_pattern = 15'b000_0000_0000_0000;
        endcase
    end

endmodule