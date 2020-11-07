/************************************************************************
* N-bit t0o 2N bit Arithmetric Multiplier logic Unit
*
*************************************************************************
* input mclk        : Master 16MHz clock

***************************************************************************
*    
* Result = In1 * In2
*
*
****************************************************************************/

module AL_Mutiplier(
    input mclk,
    input rst,
    input en,
    input [N-1:0] In1,
    input [N-1:0] In2,
    output [2*N-1:0] Result,
    output sync);

    parameter N  = 16;
    localparam M = $clog2(N+1); //registor SIZE depend on parameter N 


    reg [M-1:0] bit_count = 0;

    reg [2*N-2:0] lathced_In1 = 0;
    reg [2*N-2:0] lathced_In2 = 0;

    reg [2*N-1:0] Result = 0;
    reg [2*N-1:0] Result_tmp = 0;
    wire [N-2:0] dammy_zero = 0;


    reg sync = 1'b0;

    always @(posedge mclk)begin
        if(rst)begin
            bit_count <= 0;
            lathced_In1 <= {dammy_zero,In1};
            lathced_In2 <= {dammy_zero,In2};  
            Result_tmp = 0;    
            Result  <= 0;   
            sync <= 1'b0;

        end else begin
            if(!en)begin
                bit_count <= 0;
                lathced_In1 <= {dammy_zero,In1};
                lathced_In2 <= {dammy_zero,In2};
                Result_tmp = 0;     
                Result  <= 0;   
                sync <= 1'b0;

            end else if (en) begin
                
                if(bit_count == N-1)begin
                    bit_count <= 0;
                    lathced_In1 <= {dammy_zero,In1};
                    lathced_In2 <= {dammy_zero,In2};  
                    Result_tmp <= 0; 
                    sync <= 1'b1;
                    Result <= Result_tmp + ((lathced_In1[bit_count]) ? lathced_In2 : 0 );
                end else begin 
                    bit_count <= bit_count + 1;
                    lathced_In2 <= lathced_In2 << 1;
                    sync <= 1'b0;
                    Result_tmp <= Result_tmp + ((lathced_In1[bit_count]) ? lathced_In2 : 0 );
                end
            end else;
        end   
    end 

endmodule