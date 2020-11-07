/***************************************************************************
 * PWM modulated signal generator
 *
 *--------------------------------------------------------------------------
 * input clk                : master clock input
 * input [res*chn-1:0] d_in : input signal 
 *                            (chn channels , resbit resolution)
 * output [chn-1:0] pwm_out  : PWM modulated output(chn chanels)
 *
 *--------------------------------------------------------------------------
 * param res                : Resolution of input and
 *                            internal saw signals(num of bits)
 * param chn                : number of channels
 * param fclkm              : frequrency master clock[Hz]
 * param fs                 : Swiching frequency (1/Pulde width)[\hz]
 * ---------------------------------------------------------------------------
 * * On mulutiple channel mode( chn > 1 )
 *   n channel of input signal d_in is assigned to d_in[n*res+res-1:n*res] 
 *   (n:0 to chn-1)
 *   n channel of output signal pwm_out is assigned to pwm_out[n]
 *
 ******************************************************************************/
 
// Instance Format sample
//
// PWM_generator(
//     .clk(),
//     .d_in(),
//     .pwm_out() );
//     defparam inst.res = 8;              
//     defparam inst.chn = 1;  
//     defparam inst.fclkm = 16000000;     //Frequency of master clock input(default :16MHZ)
//     defparam inst.fs =10000;            //Sample/sec (default:10kHz)

module PWM_generator(
    input clk,
    input [res*chn-1:0] d_in,
    output [chn-1:0] pwm_out );

    parameter res = 8;              
    parameter chn = 1;  
    parameter fclkm = 16000000;     //Frequency of master clock input(default :16MHZ)
    parameter fs =10000;            //Sample/sec (default:10kHz)

    localparam period = 1 << res;         //period of PWM wave (base) (2^res)
    localparam div_n = ((fclkm/(fs*period)) >= 1)? fclkm/(fs*period) -1 : 0; //

    integer j; // general purpose 


    //Assigning d_in input port to internal wire arrays by each channels
    
    wire [res-1:0] d_in_internal[chn-1:0];

    generate
        genvar n;
        for ( n=0 ; n!=chn ; n=n+1 )begin
            assign d_in_internal[n] = d_in[(n+1)*res -1:n*res];
        end
    endgenerate



    //Definition and Initializing of output registor

    reg [chn-1:0] d_out_internal =0;


    //Assigning output registor to output port
    generate
        genvar m;
        for ( m=0 ; m != chn ; m=m+1 )begin
            assign pwm_out[m] = d_out_internal[m] ;
        end
    endgenerate


    //generation internal clk

    wire clk_internal;

    divider D101 (clk,clk_internal);
    defparam D101.divide_num = div_n;

    //Definition of registor exspressing saw wave
    reg [res-1:0] saw_sig = 0;

    //operation cycle 
    always @(posedge clk_internal)begin
        saw_sig =saw_sig + 1;

        for( j=0 ; j!=chn ; j++ )begin
            d_out_internal[j] <= ( d_in_internal[j] > saw_sig ) ? 1'b1 : 1'b0;
        end
    end


endmodule
