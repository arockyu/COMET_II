/**************************************************************************
/* COMET II CPU CORE Main FSM and instrument fetcher
/*
/**************************************************************************
/*
/*
/*
/**************************************************************************/



module Comet_II_core_FSM (
    input mclk,
    input init,
    input rst,
  
    input [15:0] rdata,

    output [7:0] op_code,
    output [7:0] regs,
    output [15:0] adr,
    output adr_en,
    output [2:0] state
);

    //localparam 
 
    // OP code of two words instruments
    localparam NOP = 8'b0000_0000;
    localparam OP1 = 8'b0001_00xx;
    localparam OP2 = 8'b0010_00xx;
    localparam OP3 = 8'b0011_00xx;
    localparam OP4 = 8'b0100_00xx;
    localparam OP5 = 8'b0101_00xx;
    localparam OP6 = 8'b0110_xxxx;
    localparam OP7 = 8'b0111_0000;
    localparam OP8 = 8'b1000_0000;
    localparam OPF = 8'b1111_0000;

    //state definition

    localparam  IDLE  = 3'b000;
    localparam  INIT  = 3'b001;
    localparam  IFET1 = 3'b010;
    localparam  IFET2 = 3'b011;
    localparam  EXEC  = 3'b100;
    localparam  WBACK = 3'b101;   


    // regs and output
    reg [15:0] IR1    = 16'h0000;
    reg [15:0] IR2    = 16'h0000;
    reg addr_enable   =  1'b0;

    wire [7:0]  op_code = IR1[15: 8];
    wire [7:0]  regs    = IR1[ 7: 0];
    wire [15:0] adr    = IR2;


    ///////  FSM  //////////////////////////////////////////////////////////////////////

    reg [2:0] state = IDLE;
    reg [2:0] state_next = IDLE; 

    always @(*)begin
        state_next = state;
        if(rst) state_next = IDLE;
        case(state)
            IDLE   : if(init) state_next = INIT;
            INIT   : state_next = IFET1;
            IFET1  :
                begin
                    if(op_code[7:2] == 6'b0001_00 | op_code[7:2]  == 6'b0010_00  | op_code[7:2]  == 6'b0011_00 |
                       op_code[7:2]  == 6'b0100_00 | op_code[7:2]  == 6'b0101_00 | op_code[7:4]  == 4'b0110 |
                       op_code == OP7 | op_code == OP8 | op_code == OPF   ) state_next = IFET2;
                    else if(op_code == NOP)state_next = IFET1;
                    else state_next = EXEC;
                end
            IFET2  : state_next = EXEC;
            EXEC   : state_next = IFET1;
            WBACK  : state_next = IFET1;
            default: state_next = state;
        endcase
    end

    always @(posedge mclk)begin
        if(rst) begin
            state  <=  IDLE;


        end else begin
            state <= state_next;            
        end
    end


    //instruction fetch cycle
    always @(negedge mclk)begin
        if(rst) begin
            IR1    <= 16'h0000;
            IR2    <= 16'h0000;

            addr_enable <= 1'b0;
        end else begin        
            case(state)
                IDLE   : ;
                INIT   : ;
                IFET1  : 
                    begin
                        IR1 <= rdata;
                        addr_enable <= 1'b0;
                    end
                IFET2  :
                    begin 
                        IR2 <= rdata;
                        addr_enable <= 1'b1;
                    end
                EXEC   : ;
                WBACK  : ;   
            endcase
        end
    end

    ////////////////////////////////////////////////////////////////////////////////////

endmodule