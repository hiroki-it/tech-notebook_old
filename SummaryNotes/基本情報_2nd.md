# 勉強の方針

1. 必ず、実例として、それが扱われているのかを覚えること。

2. 必ず、言葉ではなく、イラストを用いて覚えること。

3. 必ず、知識の『点』と『点』を繋ぎ、『線』にしろ

4. 必ず、まとめることでインプットしているだけなので、口頭で説明してアプトプットしろ。

5. キタミ式で大枠をとらえて、過去問で肉付けしていく。

   

# 04. デジタルデータの表し方

### ◇ 符号化文字集合

英語のアルファベットや日本語のひらがな、カタカナ等、どのような文字が使えるかを示した文字リストのこと。

**【具体例】**Unicode、ASCII、EBSDIC、シフトJIS、EUC



![文字集合](https://user-images.githubusercontent.com/42175286/56846533-5f8acf00-690b-11e9-8bda-f1e463c6916b.png)

引用：ウナのIT資格一問一答，http://una.soragoto.net/topics/9.html



### ◇ 文字符号化方式

任意の文字集合をどのようなbit列に変換（=**エンコード**）するかを定義した体系のこと。
【具体例】Unicodeにおける『あ』は、UTF-8 と UTF-16 で、bit列が異なる。
![文字コード](https://user-images.githubusercontent.com/42175286/56846274-6fed7a80-6908-11e9-9a42-e149b4485608.png)

引用：$shibayu36->blog;，https://blog.shibayu36.org/entry/2015/09/14/102100

【具体例】ASCIIにおける『HELLO』

![p110](C:\Projects\summary_notes\SummaryNotes\Image\p110.png)



### ◇ 『符号化文字集合』と『文字符号化方式』の対応関係（文字コード体系）一覧

（余談）Winのメモ帳での文字コードの選択ダイアログでは、 符号化文字集合と文字符号化方式の違いに混乱する言葉遣いをしている。
![文字集合と符号化方式の対応関係](https://user-images.githubusercontent.com/42175286/56847046-57359280-6911-11e9-97f3-8c270326d49f.png)
引用：se-ikeda，http://se-ikeda.jp/techmemo/215



### ◇ 画像の表現方法

**『bit-map方式』**：ドットを組み合わせることによって、画像を表現する方法。

![p113-1](C:\Projects\summary_notes\SummaryNotes\Image\p113-1.png)

1ドットを1-bitに設定した場合、1-bitで2種類の情報を表せるので、つまり1-bitで2種類の色を表すことができる。

![p113-2](C:\Projects\summary_notes\SummaryNotes\Image\p113-2.png)



### ◇ 音声の表現方法

**『PCM（Pulse Code Modulation）方式』**：音声を時間単位（サンプリング周期）で細かく区切ってサンプリングし、各単位の音声を数値化することによって、音声を表現する方法。

![p114-1](C:\Projects\summary_notes\SummaryNotes\Image\p114-1.png)

より細かい時間単位で区切り、より大きな量子化bit数に設定することによって、より原音に近い音声で表現できる。

![p115-2](C:\Projects\summary_notes\SummaryNotes\Image\p115-2.png)

**【具体例】**512×10^6 byteの容量のフラッシュメモリに記録できる音声の長さ（分）

1秒間に11,000回データを取得し、1つのデータを8 bitで保存すると仮定する。データ量は単純に、

『 11000 回 × 8 bit = 88000 bit 』

これをビット単位からバイト単位に変換すると、

『 88000 ÷ 8 ＝ 11000 byte 』 

と計算できる。

フラッシュメモリの容量は512×10^6 なので、記録可能な音声の長さ（分）は、

『 512×10^6 ÷ 11000 ÷ 60 秒 ≒ 775分 』



### ◇ 機械がコンピュータに制御される仕組み

- **センサ**

  外部のアナログ情報を計測し、アナログ情報としてコンピュータへ送信。

  **【具体例】：温度センサ、加速度センサ、照度センサ、…**

  ![p119-2](C:\Projects\summary_notes\SummaryNotes\Image\p119-2.png)

- **A/D変換器**

  アナログ情報をデジタル情報に変換。

  ![AD変換](C:\Projects\summary_notes\SummaryNotes\Image\AD変換.png)

- **コンピュータ**

  デジタル情報を受信し、次の動作を決定し、デジタル情報としてアクチュエータへ送信。

- **D/A変換器**

  デジタル情報をアナログ情報に変換。

- **アクチュエータ**

  アナログ情報を受信し、機械エネルギーに変換。

  ![p119-3](C:\Projects\summary_notes\SummaryNotes\Image\p119-3.png)



### ◇ 機械の制御方式の種類

- **シーケンス制御**

  決められた順序や条件に従って、制御の各段階を進めていく制御方式。

  **【具体例】：洗濯機**

  ![p120-1](C:\Projects\summary_notes\SummaryNotes\Image\p120-1.png)

- **フィードバック制御**

  その時の状況を定期的に計測し、目標値との差分を基に、出力を調節する制御方式。

  **【具体例】：エアコン**

  ![p120-2](C:\Projects\summary_notes\SummaryNotes\Image\p120-2.png)



# 05-01. ハードウェアの分類

### ◇ ハードウェアとソフトウェアの関係

![ソフトウェアの分類](C:\Projects\summary_notes\SummaryNotes\Image\ソフトウェアの分類.jpg)



### ◇ 装置間の関係

![p125](C:\Projects\summary_notes\SummaryNotes\Image\p125.png)



### ◇ CPU（プロセッサ）

CPUは制御と演算を行う。CPUの制御部分は、プログラムの命令を解釈して、コンピュータ全体を制御。CPUの演算部分は、計算や演算処理を行う。特、『**算術論理演算装置（ALU：Arithmetic and Logic Unit）**』とも呼ぶ。



### ◇ RAM（メインメモリ＋キャッシュメモリ）

プログラムやデータを一時的に記憶し、コンピュータの電源を切るとこれらは消える。



### ◇ ROM

プログラムやデータを長期的に記憶し、コンピュータの電源を切ってもこれらは消えない。



### ◇ 入力装置

コンピュータにデータを入力。キーボード、マウス、スキャナなど。



### ◇ 出力装置

コンピュータからデータを出力。ディスプレイ、プリンタなど。



# 05-02. CPU（プロセッサ）

### ◇ クロック周波数

CPUの回路が処理と歩調を合わせるために用いる信号を、『クロック』と言う。一定時間ごとにクロックが起こる時、１秒間にクロックが何回起こるかを『クロック周波数』という。これは、Hzで表される。ちなみに、ワイのパソコンのクロック周波数は2.60GHzでした。

（例1）3Hz = 3 (クロック数／秒)

（例2）2.6GHz = 2.6×10^9  (クロック数／秒)

![クロック数比較](C:\Projects\summary_notes\SummaryNotes\Image\クロック数比較.png)



### ◇ MIPS：Million Instructions Per Second（×10^6 命令数／秒）

CPUが1秒間に何回命令を実行するかを表す。

（例題）

命令当たりの平均クロック数は、『(4×0.3)＋(8×0.6)＋(10×0.1) 』から、『7』と求められる。

700Hz (×10^6 クロック数／秒) ÷ 7 (クロック数／命令) = 100 (×10^6 命令数／秒)

![MIPSの例題](C:\Projects\summary_notes\SummaryNotes\Image\MIPSの例題.png)

- **1命令当たりの実行時間 (秒／命令) の求め方**

  1 ÷ 100 (×10^6 命令／秒) = 10n (秒／命令)



# 06-01. メモリ（RAM + ROM）

### ◇ メモリの種類

『メモリ』は、RAMとROMに大きく分けられる。

![p162](C:\Projects\summary_notes\SummaryNotes\Image\p162.png)



### ◇ RAM：Read Access Memory

RAMは、メインメモリとして使われる『Dynamic RAM』と、キャッシュメモリとして使われる『Static RAM』に分解される。

- **Dynamic RAM**

  メインメモリとして用いられる。よく見るやつ。

  ![Dynamic RAM](C:\Projects\summary_notes\SummaryNotes\Image\Dynamic RAM.jpg)

- **Static RAM**

  キャッシュメモリとして用いられる。
  
  ![Static RAM](C:\Projects\summary_notes\SummaryNotes\Image\Static RAM.jpg)
  



### ◇ ROM：Read Only Memory

- **Mask ROM**

  ![p164-1](C:\Projects\summary_notes\SummaryNotes\Image\p164-1.png)

- **Programmable ROM**

  ![p164-2](C:\Projects\summary_notes\SummaryNotes\Image\p164-2.png)



# 06-02. キャッシュメモリ 

CPUから命令が起こるとき、CPU、メインメモリ、ハードディスク間には、読み込みと書き出しの処理速度に差がある。

![p169](C:\Projects\summary_notes\SummaryNotes\Image\p169.png)



### ◇ キャッシュメモリの機能

- **一次キャッシュメモリと二次キャッシュメモリ**

  CPUとメインメモリの間に、キャッシュメモリを何段階か設置し、読み込みと書き出しの処理速度の差を緩和させる。

![メモリキャッシュ](C:\Projects\summary_notes\SummaryNotes\Image\メモリキャッシュ.GIF)

- **メモリ ➔ 二次キャッシュメモリ ➔ 一次キャッシュメモリ**

![メモリとキャッシュメモリ](C:\Projects\summary_notes\SummaryNotes\Image\メモリとキャッシュメモリ.gif)

- **実例**

  タスクマネージャのパフォーマンスタブで、n次キャッシュメモリがどのくらい使われているのかを確認できる。

  ![キャッシュメモリの実例](C:\Projects\summary_notes\SummaryNotes\Image\キャッシュメモリの実例.png)



### ◇ キャッシュメモリへの書き込み方式の種類

- **Write-throught 方式**

  CPUは、メインメモリとキャッシュメモリの両方に書き込む。常に主記憶とキャッシュの内容が一致している状態を確保できるが、主記憶への書き込みが頻繁に行われるので遅い。

  ![Write-through方式](C:\Projects\summary_notes\SummaryNotes\Image\Write-through方式.jpg)

- **Write-back 方式**

  CPUは、キャッシュメモリのみに書き込む。次に、キャッシュメモリがメインメモリに書き込む。主記憶とキャッシュの内容が一致している状態を必ずしも確保できないが、主記憶への書き込み回数が少ないため速い

![Write-back方式](C:\Projects\summary_notes\SummaryNotes\Image\Write-back方式.jpg)



# 06-03. ディスクメモリ

CPU、メインメモリ、ストレージ間には、読み込みと書き出しの処理速度に差がある。（※再度記載）

![p169](C:\Projects\summary_notes\SummaryNotes\Image\p169.png)



### ◇ ディスクメモリの機能

メインメモリとハードディスクの間に、ディスクキャッシュを設置し、読み込みと書き出しの処理速度の差を緩和させる。

![ディスクキャッシュ](C:\Projects\summary_notes\SummaryNotes\Image\ディスクキャッシュ.gif)



# 06-04. ヒット率と実効アクセス時間

### ◇ 実効アクセス時間

![p171-1](C:\Projects\summary_notes\SummaryNotes\Image\p171-1.png)

  

# 07. ハードディスクとその他の補助記憶装置

### ◇ Defragmentation

断片化されたデータ領域を整理整頓する。

![p184-1](C:\Projects\summary_notes\SummaryNotes\Image\p184-1.png)

![p184-2](C:\Projects\summary_notes\SummaryNotes\Image\p184-2.png)

### ◇ RAID：Redundant Arrays of Inexpensive Disks

複数のハードディスクを仮想的に一つのハードディスクであるかのようにして、データを管理する技術。

- **RAID0（Striping）**

  データを、複数のハードディスクに分割して書き込む。

- **RAID1（Mirroring）**

  データを、複数のハードディスクに同じように書き込む。

- **RAID5（Striping with parity）**

  データとパリティ（誤り訂正符号）を、3つ以上のハードディスクに書き込む。

![RAIDの種類](C:\Projects\summary_notes\SummaryNotes\Image\RAIDの種類.png)



# 08-01. その他のハードウェア


### ◇ キーボードからポインティングデバイス

- **ジョイスティック**

  


### ◇ 読み取り装置

- **イメージスキャナ**

- **Optical Character Reader**

  紙上の文字を文字データとして読み取る装置。

- **Optical Mark Reader**

  マークシートの塗り潰し位置を読み取る装置。

  ![ORM](C:\Projects\summary_notes\SummaryNotes\Image\ORM.png)

- **キャプチャカード**

- **デジタルカメラ**

### ◇ バーコードリーダにおけるCheck digit

バーコードを読み取った後、読み取りによって算出したCheck digitと、実際のCheck digitを比較し、正しく読み取れているのかを判定する。

![チェックディジット](C:\Projects\summary_notes\SummaryNotes\Image\チェックディジット.gif)




### ◇ Video RAM

VRAMの容量によって、扱うことのできる解像度と色数が決まる。

![VRAM](C:\Projects\summary_notes\SummaryNotes\Image\VRAM.jpg)

富士通PCのVRAMスペックは32MB。

![本パソコンのVRAMスペック](C:\Projects\summary_notes\SummaryNotes\Image\本パソコンのVRAMスペック.jpg)

色数によって、１ドット当たり何ビットを要するが異なる。

![p204](C:\Projects\summary_notes\SummaryNotes\Image\p204.jpg)




### ◇ ディスプレイ 

- **CRTディスプレイ**

- **液晶ディスプレイ**

  電圧の有無によって液晶分子を制御。外部からの光によって画面を表示させる。

  ![液晶分子](C:\Projects\summary_notes\SummaryNotes\Image\液晶分子.png)

  ![液晶ディスプレイ](C:\Projects\summary_notes\SummaryNotes\Image\液晶ディスプレイ.jpg)

- **有機ELディスプレイ**

  有機化合物に電圧を加えることによって発光させ、画面を表示させる。

  ![有機ELディスプレイ](C:\Projects\summary_notes\SummaryNotes\Image\有機ELディスプレイ.jpg)

- **プラズマディスプレイ**

  ![プラズマディスプレイ](C:\Projects\summary_notes\SummaryNotes\Image\プラズマディスプレイ.gif)

  2枚のガラスの間に、封入された希ガスに電圧をかけると放電し、紫外線が出る。そして、この紫外線が蛍光体を発光させることによって画面を表示する。  液晶ディスプレイとのシェア差が大きくなり、2014年に世界的に生産が終了された。

  ![パナソニック製プラズマディスプレイ](C:\Projects\summary_notes\SummaryNotes\Image\パナソニック製プラズマディスプレイ.jpg)

- **LEDディスプレイ**

![LEDディスプレイ](C:\Projects\summary_notes\SummaryNotes\Image\LEDディスプレイ.jpg)

2018年1月に開催された「CES 2018」でサムスンが発表した“マイクロLEDテレビ”「The Wall」は、従来の「液晶」や「有機EL」とは異なる新たな表示方式を採用したテレビとして、大きな話題となった。




### ◇ プリンタ

- **ドットインパクトプリンタ**

  ![ドットインパクトプリンタ](C:\Projects\summary_notes\SummaryNotes\Image\ドットインパクトプリンタ.jpg)

  ![ドットインパクトプリンタの仕組み](C:\Projects\summary_notes\SummaryNotes\Image\ドットインパクトプリンタの仕組み.jpg)

- **インクジェットプリンタ**

  ![インクジェットプリンタ](C:\Projects\summary_notes\SummaryNotes\Image\インクジェットプリンタ.jpg)

  ![インクジェットプリンタの仕組み](C:\Projects\summary_notes\SummaryNotes\Image\インクジェットプリンタの仕組み.jpg)

- **レーザプリンタ**

  ![レーザプリンタ](C:\Projects\summary_notes\SummaryNotes\Image\レーザプリンタ.jpg)

  ![レーザプリンタの仕組み](C:\Projects\summary_notes\SummaryNotes\Image\レーザプリンタの仕組み.jpg)

- **プリンタの解像度**

  １インチ当たりのドット数（dpi）によって、解像度が異なる。復習ではあるが、PC上では、ドット数がどのくらいのビット数を持つかで、解像度が変わる。

![DPI](C:\Projects\summary_notes\SummaryNotes\Image\DPI.jpg)

dpiが大きくなるにつれて、解像度は大きくなる。

![DPIの比較](C:\Projects\summary_notes\SummaryNotes\Image\DPIの比較.jpg)

- **プリンタの印字速度**

  ![CPS と PPM](C:\Projects\summary_notes\SummaryNotes\Image\CPS と PPM.jpg)
  
  


# 08-02 入出力インターフェイス

### ◇ Serial interface vs. Parallel interface

シリアルインターフェイスは、情報を1bitずつ転送する方式。パラレルインターフェイスは、複数のbitの情報を同時に転送する方式。パラレルインターフェイスは、同時にデータを送信し、同時に受信しなければならない。配線の形状や長さによって、信号の転送時間は異なる。動作クロックが速ければ速いほど、配線間の同時転送に誤差が生じてしまうため、現代の高スペックパソコンには向いていない。

![パラレルインターフェイスは配線の長さが関係してくる](C:\Projects\summary_notes\SummaryNotes\Image\パラレルインターフェイスは配線の長さが関係してくる.png)

![シリアルvs パラレル の違い](C:\Projects\summary_notes\SummaryNotes\Image\シリアルvs パラレル の違い.jpeg)



### ◇ Serial interface が用いられている例

- **USB（Universal Serial Bus）**

![usbケーブル](C:\Projects\summary_notes\SummaryNotes\Image\usbインターフェイス.png)

- **IEEE1394**

ビデオカメラとの接続に用いられるインターフェイス

![ieeeケーブル](C:\Projects\summary_notes\SummaryNotes\Image\ieeeインターフェイス.jpg)



### ◇ Parallel interface が用いられている例

- **IDE（Integrated Drive Electronics）**

ハードディスクとの接続に用いられるインターフェイス。

![ideケーブル](C:\Projects\summary_notes\SummaryNotes\Image\ideインターフェイス.jpg)

- **SCSI（Small Computer System Interface）**

ハードディスク、CD-ROM、イメージスキャナなど、様々な周辺機器をデイジーチェーンするために用いるインターフェイス。

![scsiケーブル](C:\Projects\summary_notes\SummaryNotes\Image\scsiインターフェイス.jpg)



### ◇ 無線インターフェイス

- **IrDA（infrared Data Assoiciation）**
  赤外線を使って、無線通信を行うためのインターフェイス。

![irDAインターフェイス](C:\Projects\summary_notes\SummaryNotes\Image\irDAインターフェイス.jpg)

- **Bluetooth**
  2.4GHzの電波を使って無線通信を行うためのインターフェイス。
  
  


# 09-01. ソフトウェアの分類

### ◇ ハードウェアとソフトウェアの関係（再度記載）

![ソフトウェアの分類](C:\Projects\summary_notes\SummaryNotes\Image\ソフトウェアの分類.jpg)



### ◇ 応用ソフトウェア

**【具体例】**その辺のアプリ



### ◇ Middleware

**【具体例】**データベース管理システム



### ◇ 基本ソフトウェア

さらに３つのプログラムに分類される。

- 制御プログラム（OSの中核を担うプログラム）

  **【具体例】**カーネル、マイクロカーネル、モノリシックカーネル

- 言語処理プログラム（構造解析を行うプログラム）

  **【具体例】**C、Java、PHP、Javascript

- サービスプログラム

  **【具体例】**ファイル圧縮プログラム



### ◇ Firmware

システムソフトウェア（ミドルウェア ＋ 基本ソフトウェア）とハードウェアの間の段階にある。

**【具体例】**BIOS：Basic Input/Output System

![BIOS](C:\Projects\summary_notes\SummaryNotes\Image\BIOS.jpg)

**【具体例】**UEFI：United Extensible Firmware Interface

![UEFIとセキュアブート](C:\Projects\summary_notes\SummaryNotes\Image\UEFIとセキュアブート.JPG)



# 09-02. OSS：Open Source Software 

### ◇ OSSの10個の定義

1. 利用者は、無償あるいは有償で自由に再配布できる。

2. 利用者は、ソースコードを入手できる。

3. 利用者は、コードを自由に変更できる。また、変更後に提供する場合、異なるライセンスを追加できる。

4. 差分情報の配布を認める場合には、同一性の保持を要求してもかまわない。 ⇒ よくわからない

5. 提供者は、特定の個人やグループを差別できない。

6. 提供者は、特定の分野を差別できない。

7. 提供者は、全く同じOSSの再配布において、ライセンスを追加できない。

8. 提供者は、特定の製品でのみ有効なライセンスを追加できない。

9. 提供者は、他のソフトウェアを制限するライセンスを追加できない。

10. 提供者は、技術的に偏りのあるライセンスを追加できない。

    

### ◇ OSSの種類

![OSS一覧](C:\Projects\summary_notes\SummaryNotes\Image\OSS一覧.png)

引用：https://openstandia.jp/oss_info/

- **OS**

  CentOS、Linux、Unix、Ubuntu

- **データベース**

  MySQL、MariaDB

- **プログラミング言語**

  言うまでもない。

- **フレームワーク**

  言うまでもない。

- **OR Mapper**

  言うまでもない。

- **バージョン管理**

  Git、Subversion

- **Webサーバ**

  Apache

- **業務システム**

  Redmine

- **インフラ構築**

  Chef、Puppet

- **クラウド構築**

  Docker



# 09-03. ジョブ管理

### ◇ ジョブ管理とタスク管理の関係

![ジョブ管理とタスク管理の概要](C:\Projects\summary_notes\SummaryNotes\Image\ジョブ管理とタスク管理の概要.jpg)

### ◇ マスタスケジュラ

ジョブスケジュラにジョブの実行を命令する。



### ◇ ジョブスケジュラ

ジョブとは、プロセスのセットのこと。データをコンピュータに入力し、複数の処理が実行され、結果が出力されるまでの一連の処理のこと。『Task』と『Job』の定義は曖昧なので、『process』と『set of processes』を使うべきとのこと。

引用：https://stackoverflow.com/questions/3073948/job-task-and-process-whats-the-difference/31212568

複数のジョブ（プログラムやバッチ）の起動と終了を制御したり、ジョブの実行と終了を監視報告するソフトウェア。ややこしいことに、タスクスケジューラとも呼ぶ。

- **Reader**

ジョブ待ち行列に登録

- **Initiator**

ジョブステップに分解

- **タスク管理**

CPUに対して、処理命令が行われる

- **Terminator**

出力待ち行列に登録

- **Writer**

優先度順に出力の処理フローを実行



### ◇ ジョブ管理の実装例

- **Windowsのタスクスケジューラ**

  決められた時間または一定間隔でプログラムやスクリプトを実行する機能。

  ![タスクスケジューラ](C:\Projects\summary_notes\SummaryNotes\Image\タスクスケジューラ.png)



# 09-03. タスク管理について

### ◇ タスク管理の３つの方式

タスクとは、スレッドに似たような、単一のプロセスのこと。

![タスクの状態遷移](C:\Projects\summary_notes\SummaryNotes\Image\タスクの状態遷移.jpg)

- **到着順方式**

  実行可能な状態になったタスクから順に、CPUの使用権を与えていく方式。

- **優先順方式**

  各タスクに優先度を設定し、優先度の高いタスクから順に、CPUの使用権を与えていく方式。

- **Round robin 方式**

  Round robinは、『総当たり』の意味。一定時間ごとに、CPUの使用権を与えるタスクを切り換える方式。
  
  

### ◇ Spooling

アプリケーションから低速な周辺機器へデータを出力する時、まず、CPUはスプーラにデータを出力する。Spoolerは、全てのデータをまとめて出力するのではなく、一時的に補助記憶装置（Spool）にためておきながら、少しずつ出力する（Spooling）。

  ![スプーリング](C:\Projects\summary_notes\SummaryNotes\Image\スプーリング.jpg)



# 09-05. 物理メモリ空間の活用（出題頻度低い）


### ◇ 固定区画方式

### ◇ 可変区画方式

### ◇ オーバーレイ方式

### ◇ フラグメンテーション／メモリコンパクション

### ◇ スワッピング方式




# 09-06. ？？？の活用

### ◇ Reusable（再使用可能プログラム）

  一度プログラムを実行した後、補助記憶装置から主記憶装置にロードし直さずに、再び実行を繰り返すことができるプログラムのこと。

  ![再使用可能](C:\Projects\summary_notes\SummaryNotes\Image\再使用可能.gif)

### ◇ Reentrant（再入可能プログラム）

  あるプログラムが呼び出したプログラムを、他のプログラムがさらに呼び出しを行い、同時に実行できるプログラムのこと。

![再入可能](C:\Projects\summary_notes\SummaryNotes\Image\再入可能.gif)

### ◇ Relocatable（再配置可能プログラム）

  補助記憶装置から主記憶装置へロードする際に、アドレス空間上のどこに配置しても実行できるプログラムのこと。

![再配置可能](C:\Projects\summary_notes\SummaryNotes\Image\再配置可能.gif)



# 09-07. 仮想メモリ空間の活用

### ◇ Demand paging 方式

1. プログラムをページという単位に分割し、ハードディスクで管理。
2. 仮想アドレス空間を固定長の領域に区切り、ページをその領域で管理。
3. 実行に必要なページだけを物理メモリに読み込ませる

![p258](C:\Projects\summary_notes\SummaryNotes\Image\p258.png)



### ◇ ページアウトの種類

![p259-2](C:\Projects\summary_notes\SummaryNotes\Image\p259-2.png)

- **LRU方式：Least Recently Used**

  ![p261](C:\Projects\summary_notes\SummaryNotes\Image\p261.png)





# 10. ファイル管理

### ◇ 絶対パス

ルートディレクトリ（fruit.com）から、指定のファイル（apple.png）までのパス。

```
<img src="http://fruits.com/img/apple.png">
```

![絶対パス](C:\Projects\summary_notes\SummaryNotes\Image\絶対パス.png)

### ◇ 相対パス

起点となる場所（apple.html）から、指定のディレクトリやファイル（apple.png）の場所までを辿るパス。例えば、apple.htmlのページでapple.pngを使用したいとする。この時、『 .. 』を用いて一つ上の階層に行き、青の後、imgフォルダを指定する。

```
<img src="../img/apple.png">
```

![相対パス](C:\Projects\summary_notes\SummaryNotes\Image\相対パス.png)
