/********************************************************
* Input Signal Glitch Noize Filter
*
**********************************************************
* input clk
* input d_in
* output d_out
***********************************************************
* parameter n       :   
*
*
***********************************************************/

module filter(
    input clk,
    input d_in,
    output d_out);

    parameter n = 2;

    reg [n:0] in_buf=0;
    reg out_state=1'b0;

    always @(posedge clk) begin
        in_buf[0] <= d_in;
        in_buf[n:1] <=  in_buf[n-1:0];

        if(&in_buf[n:1]) out_state<=1'b1;
        if(~|in_buf[n:1]) out_state <= 1'b0;
    end
    
    assign d_out = out_state; 

endmodule