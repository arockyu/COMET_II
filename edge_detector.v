/********************************************************
* edge detector module
*
**********************************************************
*
***********************************************************
* parameter 
*
*
***********************************************************/

module edge_detector(
    input mclk,
    input signal,
    output pos,
    output neg);

    parameter init_value = 1'b0;
    parameter sync_negegde = 1'b0;
    
    reg pos = 1'b0; 
    reg neg = 1'b0; 
    reg sig_before = init_value;

    wire clk = mclk^sync_negegde;

    always @(posedge clk) begin
        sig_before <= signal;
        pos <= !sig_before & signal; 
        neg <= sig_before & !signal;
    end
    


endmodule