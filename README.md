# 仮想計算機COMET IIのVerilog HDLでの実装

[TynyFPGA BX]([https://tinyfpga.com/bx/guide.html)をターゲットとして使ったVerilog HDLとFPGAのお勉強の記録です。

IPA 情報処理試験での仮想マシンである[COMET II CPU](https://www.jitec.ipa.go.jp/1_13download/shiken_yougo_ver4_2.pdf)のVerilog HDL moduleでの実現を目指してます

現状はCPU core (CoMET_II_top.v) レベルで完成させテストベンチ(top_tb.v)上でのみに組込動作確認している状況です。

テストカバレッジは狭いですがまあおおむね期待の動きをしてくれてます。

CPUのトップモジュールレベルまではターゲットのFPGAの[Lattice iCE40](https://www.latticesemi.com/ja-JP/Products/FPGAandCPLD/iCE40)に依存しないように記述してるつもりです。

今後はプログラム書き込み /動作確認用の制御インターフェース(UARTを想定)や外部入出力をメモリマップする機能などをつくってTinyFPGA上で動くものにしていく予定、、だけどやる気が出ないのではたしていつになることやら(そもそもTinyFPGA BXの組込RAMはCOMET　IIのRAM空間(64kB)を満たすほどない、、、)

 
## モジュール構成 

* Top Comet_II_topモジュール(レジスタ設定、メモリアクセス)
  * U1 Comet_II_ALUモジュール(算術演算組み合わせ論理)
  * U2 Comet_II_Controllerモジュール(コントローラモジュールFSM)
    * U2.U11 Comet_II_core_FSM モジュール(コントローラFSM部分及び命令フェッチ機能)
    * U2.U11 Comet_II_instrument_decoderモジュール(命令デコーダ組み合わせ論理)



## TOPモジュール

``` verilog:COMET_II_top.v
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
入出六ポート
- mclk:マスタークロック入力  
- rst:ソフトウェアリセット(Active-High)入力  
- init:初期化及び起動(Active-High,初期設定機能は未実装)  
- PR_init:PR初期設定値(未実装アサインのみ)  
- SP_init:SP初期設定値 (未実装アサインのみ)   
- re:RAMリードイネーブル(Active-High)
- raddr:RAMリードアドレス　
- rdata:RAMリードデータ
- we:RAMライトイネーブル(Active-High)
- waddr:RAMライトアドレス
- wdata:RAMライトデータ
- stage:CPU実行ステージ

パラメータ宣言  
- initial_PR:PR初期値  
- initial_SP:SP初期値  

## CPU動作概略

実行ステージ(マスタークロック立ち上がりで切替)は以下の通り  

0:アイドル状態(初期状態)  
1:初期設定状態  
2:命令フェッチサイクル(1Word目)  
3:命令フェッチサイクル(2Word目)  
4:実行サイクル  

アイドル状態ではCPU動かずinitを一度activeにするとマスタクロックの立ち上がりに同期して初期化状態⇒実行フェッチサイクルと遷移しと、その後命令フェッチサイクルと実行サイクルを繰り返す。  
命令フェッチサイクルは1ワード命令のときは1Word目のみ,2ワード命令のときは2Woro目も実行する。  
(現状初期設定状態では特に機能を設定してない)  
命令フェッチ、実行の各サイクルのメモリリード/ライト及びレジスタ更新はマスタクロックの立下りに同期してなされる。  
NOP命令のときのみ命令フェッチ1Word目の次の状態がみ命令フェッチ1Word目のまま(ただしPRは+1)となる。  

したがって実行に必要なクロックサイクルはNOP命令は1クロックサイクル、NOP以外の1WORD命令 2クロックサイクル、2Word命令サイクルは3サイクルとなる。  
（2ワード命令PUSH/CALL命令におけるSP減算動作は命令フェッチサイクル2Word目のクロック立下りで実施され、メモリライト動作が実行サイクルで実施される）  

ALUにFRの更新値算出の機能を集約させているためFRをが設定されるLD命令も算術演算のカテゴリに含めALUにロードデータを入力するようにしている。  

SCV命令は現状実装してない。  


## シミュレーション環境
TinyFPGAに対応した開発環境である[apio](https://apiodoc.readthedocs.io/en/stable/)のapio simコマンドをつかってます。  
apioでは具体的には[icarus Verilog](http://iverilog.icarus.com/)というソフトをつかってコード解析、シミュレーションを実施して、[vvp](https://linux.die.net/man/1/vvp)というコマンドでicarus Verilogの出力を.vcdというファイルに変換しそれを[GTKWave](http://gtkwave.sourceforge.net/)をつかってシミュレーション波形として表示するようになっているようです。  
詳細は勉強中です。(詳しい方教えてくださると幸いです。)

## テストベンチ
工事中
