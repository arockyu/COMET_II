# TinyFPGAの勉強4

TynyFPGAをターゲットとして使ったVerilog HDLとFPGAのお勉強の記録(その４)です。

IPA 情報処理試験での仮想マシンである[COMET II CPU](https://www.jitec.ipa.go.jp/1_13download/shiken_yougo_ver4_2.pdf)のVerilog HDL moduleでの実現を目指してます

現状はCPU core (CoMET_II_top.v) レベルで完成させテストベンチ(top_tb.v)上でのみに組込動作確認している状況です。

まあまだ細かい修正点等ありますがおおむね期待の動きをしてくれてます。

上記が軌道に乗ったらプログラム書き込み /動作確認用の制御インターフェース(UARTを想定)や外部入出力をメモリマップする機能(そもそもTinyFPGAのERAMはCOMET　IIの RAM空間を満たすほどない、、、7)も含めてTinyFPGA上で動くものにしていく予定(はたしていつになることやら)  

 
## モジュール構成 
Comet_II_topモジュール  
 - U1 Comet_II_ALUモジュール 　
 - U2 Comet_II_Controllerモジュール 　
  - U11 Comet_II_core_FSM モジュール  
  - U11 Comet_II_instrument_decoderモジュール　　



## TOPモジュール

``` verilog
module COMET_II_top (
    //Master Clock
    input mclk,

    //Software Reset (Active High)
    input rst,

    //initialization and Boot (Active High)
    input init,

    //PR/SP Initialization Value (Not To be used)
    input [15:0] PR_init,  
    input [15:0] SP_init,

    //RAM I/F
    output re,
    output [15:0] raddr,
    input [15:0] rdata,
    output we,
    output [15:0] waddr,
    output [15:0] wdata,

    //Stage monitor (for debug)
    output [2:0] stage
);


    //Initial Value of PR,SP
    parameter initial_PR = 16'h0000;
    parameter initial_SP = 16'h0000;  
```

mclk:マスタークロック  
rst:ソフトウェアリセット(Active-High)  
init:初期化及び起動(Active-High,初期設定機能は未実装)  
PR_init:  
SP_init:  

initial_PR:  
initial_SP:  