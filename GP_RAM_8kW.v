module GP_RAM_8kW (
    input clk,
    input [12:0] addr,
    inout [15:0] data,
    input ce,
    input we,
    input re);

    parameter num_of_MEMcores = 32;

 
    wire [15:0] ram_rdata[31:0];
    wire [15:0] ram_wdata[31:0];

    wire ce,we,re;
    wire [15:0] HiZs;
    reg  [15:0] data_out; 
    assign data     = (ce && we ) ? ram_wdata[ addr[12:8] ] : 
                      (ce && re ) ? ram_rdata[ addr[12:8] ] : HiZs;                 
    
    generate
        genvar k;
        for(k=0 ; k<num_of_MEMcores ; k=k+1) begin//:generate_eram
            RAM_256x16 RAM_Cores(
                .addr(addr[7:0]),
                .wdata(ram_wdata[k]),
                .rdata(ram_rdata[k]),
                .ce(ce&(addr[12:8]==k)),
                .clk(clk),
                .we(we),
                .re(re));
        end
    endgenerate

endmodule