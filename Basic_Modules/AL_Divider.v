/************************************************************************
* N-bit Arthmetric Diverder logic Unit
*
*************************************************************************
* input mclk        : Master 16MHz clock

***************************************************************************
*    
*  Diverend = Divisor * Quotient + Remeinder 
*
*
****************************************************************************/

// Instance Format sample
//
// AL_Divider inst(
//     .mclk(),
//     .rst(),
//     .en(),
//     .Dividend(),
//     .Divisor(),
//     .Quotient(),
//     .Remainder(),
//     .zero_divide(),
//     .sync());
// defparam inst.N  = 16;


module AL_Divider(
    input mclk,
    input rst,
    input en,
    input [N-1:0] Dividend,
    input [N-1:0] Divisor,
    output [N-1:0] Quotient,
    output [N-1:0] Remainder,
    output zero_divide,
    output sync);

    parameter N  = 16;
    localparam M = $clog2(N+1); //registor SIZE depend on parameter N 


    reg [M-1:0] bit_count = N-1;

    reg [2*N-2:0] lathced_Dividend;
    reg [2*N-2:0] lathced_Divisor;

    reg [N-2:0] Quotient_tmp;
    reg [2*N-2:0] Remainder_tmp;

    wire [N-2:0] dammy_zero = 0;

    assign Remainder = Remainder_tmp[N-1:0];
    
    reg [N-1:0] Quotient ;
    reg zero_divide = 1'b0;
    reg sync = 1'b0;

    always @(posedge mclk)begin
        if(rst)begin
            bit_count <= N-1;
            lathced_Dividend <= {dammy_zero,Dividend};
            lathced_Divisor  <= {Divisor,dammy_zero};    
            Quotient_tmp  <= 0;   
            sync <= 1'b0;
            zero_divide <= 1'b0;
            Quotient <= 0;
            Remainder_tmp <= 0;
        end else begin
            if(lathced_Divisor == 0 | !en)begin
                bit_count <= N-1;
                lathced_Dividend <= {dammy_zero,Dividend};
                lathced_Divisor  <= {Divisor,dammy_zero};    
                Quotient_tmp  <= 0;   
                sync <= 1'b0;
                zero_divide <= (lathced_Divisor == 0);
                Quotient <= 0;
                Remainder_tmp <= 0;
            end else if (en) begin
                zero_divide <= 1'b0;
                if(bit_count == 0)begin
                    bit_count <= N-1;
                    lathced_Dividend <= {dammy_zero,Dividend};
                    lathced_Divisor <= {Divisor,dammy_zero};  
                    Quotient_tmp <= 0;   
                    sync <= 1'b1;
                    if(lathced_Dividend >= lathced_Divisor)begin
                        Quotient <= {Quotient_tmp,1'b1};
                        Remainder_tmp <= lathced_Dividend - lathced_Divisor;
                    end else begin
                        Quotient <= {Quotient_tmp,1'b0};
                        Remainder_tmp <= lathced_Dividend;                        
                    end
                end else begin 
                    bit_count <= bit_count - 1;
                    lathced_Divisor <= lathced_Divisor>>1;
                    sync <= 1'b0;
                    if(lathced_Dividend >= lathced_Divisor)begin
                        Quotient_tmp[bit_count-1] <=1'b1;
                        lathced_Dividend <= lathced_Dividend - lathced_Divisor;
                    end else Quotient_tmp[bit_count-1] <=1'b0;
                end
            end else;
        end   
    end 

endmodule