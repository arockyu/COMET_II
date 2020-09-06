# TinyFPGAの勉強4

TynyFPGAをターゲットとして使ったVerilog HDLとFPGAのお勉強の記録(その４)です。

IPA 情報処理試験での仮想マシンである[COMET II CPU](https://www.jitec.ipa.go.jp/1_13download/shiken_yougo_ver4_2.pdf)のVerilog HDL moduleでの実現を目指してます

現状はCPU core (CoMET_II_top.v) レベルで完成させテストベンチ(top_tb.v)上でのみに組込動作確認している状況です。

まあまだ細かい修正点等ありますがおおむね期待の動きをしてくれてます。

上記が軌道に乗ったらプログラム書き込み /動作確認用の制御インターフェース(UARTを想定)や外部入出力をメモリマップする機能(そもそもTinyFPGAのERAMはCOMET　IIの RAM空間を満たすほどない、、、7)も含めてTinyFPGA上で動くものにしていく予定(はたしていつになることやら)  
