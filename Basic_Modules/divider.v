/////////////////////////////////////////////
/// N+1 Freqency divider 
/// imput clk        : input clock
/// output out       : N+1 diveded clock out
/// Param divide_num : N (Div Parameter)
/////////////////////////////////////////////

// Instance Format sample
//
// divider inst(
//   .clk(),
//   .out());
// defparam inst.divide_num=1;// N : Div parameter N+1 Divide

module divider(clk,out);
  //paraetor definition
  parameter divide_num=1;// N : Div parameter N+1 Divide
  localparam M = $clog2(divide_num+1); //registor SIZE depend on parameter N 
  //input definition
  input wire clk; 

  //output definition
  output wire out;

  //registor definiton
  reg [M-1:0] count_p=0;
  reg [M-1:0] count_n=0;
  reg clk_p=0;
  reg clk_n=0;

  assign out = clk_p^clk_n;

  always @(posedge clk) begin
    count_p <= count_n+1;
    if (count_n == divide_num) begin
      count_p <= 0;
      clk_p <= ~clk_p;
    end else;
  end

  always @(negedge clk) begin
    count_n <= count_p+1;
    if (count_p == divide_num) begin
      count_n <= 0;
      clk_n <= ~clk_n;
    end else;
  end 
 
endmodule