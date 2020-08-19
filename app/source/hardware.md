# ハードウェア

## 01. ハードウェアとは

### ハードウェアの種類

#### ・ユーザの操作が，ソフトウェアを介して，ハードウェアに伝わるまで

![ソフトウェアとハードウェア](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ソフトウェアとハードウェア.png)

#### ・CPU（プロセッサ）

CPUは制御と演算を行う．CPUの制御部分は，プログラムの命令を解釈して，コンピュータ全体を制御．CPUの演算部分は，計算や演算処理を行う．特に，『**算術論理演算装置（ALU：Arithmetic and Logic Unit）**』とも呼ぶ．

#### ・RAM（メインメモリ＋キャッシュメモリ）

プログラムやデータを一時的に記憶し，コンピュータの電源を切るとこれらは消える．

#### ・ROM

プログラムやデータを長期的に記憶し，コンピュータの電源を切ってもこれらは消えない．

#### ・ストレージ（HDD vs SSD）

HDD：Hard Disk DriveとSSD：Solid State Driveがある．

#### ・入力装置

コンピュータにデータを入力．キーボード，マウス，スキャナなど．

#### ・出力装置

コンピュータからデータを出力．ディスプレイ，プリンタなど．



## 02. CPU（プロセッサ）

### IntelとAMDにおけるCPUの歴史（※2009年まで）

![IntelとAMDにおけるCPUの歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/IntelとAMDにおけるCPUの歴史.png)



### クロック周波数

CPUの回路が処理と歩調を合わせるために用いる信号を，『クロック』と言う．一定時間ごとにクロックが起こる時，１秒間にクロックが何回起こるかを『クロック周波数』という．これは，Hzで表される．ちなみに，ワイのパソコンのクロック周波数は2.60GHzでした．

（例1）
```
3Hz
= 3 (クロック数／秒)
```
（例2）
```
2.6GHz
= 2.6×10^9  (クロック数／秒)
```
![クロック数比較](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/クロック数比較.png)



### MIPS：Million Instructions Per Second（×10^6 命令数／秒）

CPUが1秒間に何回命令を実行するかを表す．

（例題）

```
(命令当たりの平均クロック数) 
= (4×0.3)＋(8×0.6)＋(10×0.1) = 7

(クロック周波数) ÷ (クロック当たりの命令数)
= 700Hz (×10^6 クロック数／秒) ÷ 7 (クロック数／命令) 
= 100 (×10^6 命令数／秒)
```

![MIPSの例題](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/MIPSの例題.png)

#### ・1命令当たりの実行時間 (秒／命令) の求め方

```
1 ÷ 100 (×10^6 命令／秒) = 10n (秒／命令)
```


## 03. 物理メモリ（RAM + ROM）

### 物理メモリの種類

『物理メモリ』は，RAMとROMに大きく分けられる．

![p162](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p162.png)



### RAM：Read Access Memory

RAMは，メインメモリとして使われる『Dynamic RAM』と，キャッシュメモリとして使われる『Static RAM』に分類される．

#### ・Dynamic RAM

  メインメモリとして用いられる．よく見るやつ．

![Dynamic RAM](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dynamic RAM.jpg)

#### ・Static RAM

  キャッシュメモリとして用いられる．


![Static RAM](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Static RAM.jpg)




### ROM：Read Only Memory

#### ・Mask ROM

![p164-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p164-1.png)

#### ・Programmable ROM

![p164-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p164-2.png)



### Garbage collection

プログラムが確保したメモリ領域のうち，不要になった領域を自動的に解放する機能．

#### ・JavaにおけるGarbage collection

Javaでは，JVM：Java Virtual Machine（Java仮想マシン）が，メモリ領域をオブジェクトに自動的に割り当て，また一方で，不要になったメモリ領域の解放を行う．一方で自動的に行う．



## 04. SRAM

CPUから命令が起こるとき，CPU，DRAM，ストレージ間には，読み込みと書き出しの処理速度に差がある．

![p169](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p169.png)



### キャッシュメモリとは

#### ・一次キャッシュメモリと二次キャッシュメモリ**

  CPUとメインメモリの間に，キャッシュメモリを何段階か設置し，CPUとメインメモリの間の読み込みと書き出しの処理速度の差を緩和させる．

![メモリキャッシュ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/メモリキャッシュ.gif)



### キャッシュメモリの読み込み方法

#### ・ユーザー ➔ メインメモリ ➔ 二次キャッシュメモリ ➔ 一次キャッシュメモリ

1. ユーザーが，パソコンに対して命令を与える．
2. CPUは，命令をメインメモリに書き込む．
3. CPUは，メインメモリから命令を読み出す．
4. CPUは，二次キャッシュメモリに書き込む．
5. CPUは，一次キャッシュメモリに書き込む．
6. CPUは，命令を実行する．

![メモリとキャッシュメモリ_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/メモリとキャッシュメモリ_1.jpg)

#### ・実例

  タスクマネージャのパフォーマンスタブで，n次キャッシュメモリがどのくらい使われているのかを確認できる．

![キャッシュメモリの実例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/キャッシュメモリの実例.png)



### キャッシュメモリへの書き込み方式の種類

#### ・Write-throught 方式

  CPUは，命令をメインメモリとキャッシュメモリの両方に書き込む．常にメインメモリとキャッシュメモリの内容が一致している状態を確保できるが，メモリへの書き込みが頻繁に行われるので遅い．

![Write-through方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Write-through方式.jpg)

#### ・Write-back 方式

  CPUは，キャッシュメモリのみに書き込む．次に，キャッシュメモリがメインメモリに書き込む．メインメモリとキャッシュメモリの内容が一致している状態を必ずしも確保できないが，メインメモリへの書き込み回数が少ないため速い

![Write-back方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Write-back方式.jpg)



### 実効アクセス時間

![p171-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p171-1.png)

  

## 05. アドレス空間管理の種類

### 前置き

言葉の使い方を，以下に統一する．

主記憶 ⇒ 物理メモリ（メインメモリ＋キャッシュメモリ）

補助記憶 ⇒ ストレージ

仮想記憶 ⇒ 仮想メモリ

![アドレス空間管理の種類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/アドレス空間管理の種類.png)



### 物理メモリのアドレス空間管理

#### ・区画方式

#### ・スワッピング方式

#### ・オーバーレイ方式



### 仮想メモリのアドレス空間管理

#### ・ページング方式



## 05-02. 物理メモリのアドレス空間管理

### 固定区画方式（同じ大きさの区画に分割する方式）

#### ・単一区画方式とは

物理メモリの領域を，一つの区画として扱い，プログラムに割り当てる方式．単一のプログラムしか読み込めず，余りのメモリ領域は利用できない．

![単一区画方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/単一区画方式.png)

#### ・多重区画方式とは

物理メモリの領域を，複数の同じ大きさの区画に分割し，各区画にプログラムに割り当てる方式．複数のプログラムを読み込むことができるが，単一区画方式と同様に，余ったメモリ領域は利用できない．

![多重区画方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/多重区画方式.png)



### 可変区画方式（様々な大きさの区画に分割する方式）

#### ・可変区画方式とは

物理メモリの領域を，プログラムの大きさに応じて，区画を様々な大きさの区画に分割し，プログラムに割り当てる方式．固定区画方式とは異なり，メモリ領域を有効に利用できる．

![可変区画方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/可変区画方式.png)



### スワッピング方式

#### ・スワッピング方式とは

![スワッピング方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/スワッピング方式.png)

物理メモリの領域を，優先度の高いプログラムに割り当て，反対に優先度が低いプログラムはストレージに退避させる方式．スワップ領域の作成方法については，CentOSのノートを参照．



### オーバーレイ方式

#### ・オーバーレイ方式とは



## 05-03. 仮想メモリのアドレス空間管理

### ページング方式

#### ・ページング方式とは

仮想メモリの実装方法の一つ．仮想メモリのアドレス空間を『固定長』の領域（ページ），また物理メモリのアドレス空間を『固定長』の領域（ページフレーム）に分割し，管理する方式．

![ページの構造](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ページの構造.png)

#### ・ページイン／ページアウト

仮想メモリは，CPUの処理によって稼働したプログラムの要求を，物理メモリの代理として受け付ける．sutore-ji から物理メモリのページフレームにページを読み込むことを『Page-in』という．また，物理メモリのページフレームからストレージにページを追い出すことを『Page-out』という．

![ページインとページアウト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ページインとページアウト.png)



#### ・仮想メモリとのマッピングによる大容量アドレス空間の実現

仮想メモリのアドレス空間を，物理メモリのアドレス空間とストレージにマッピングすることによって，物理メモリのアドレス空間を疑似的に大きく見せかけることができる．

![仮想メモリとのマッピングによる大容量アドレス空間の再現_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/仮想メモリとのマッピングによる大容量アドレス空間の再現_1.png)

ちなみに，富士通の仮想メモリの容量は，以下の通り．

![仮想メモリのアドレス空間の容量設定](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/仮想メモリのアドレス空間の容量設定.png)



### セグメント方式

#### ・セグメント方式とは

仮想メモリの実装方法の一つ．仮想メモリのアドレス空間を『可変長』の領域（セグメント），また物理メモリのアドレス空間を『可変長』の領域（セグメント）に分割し，管理する方式．



### MMU：Memory Management Unit（メモリ管理ユニット）

#### ・MMUにおける動的アドレス変換機構

MMUによって，仮想メモリのアドレスは，物理メモリのアドレスに変換される．この仕組みを，『動的アドレス変換機構』と呼ぶ．

![メモリ管理ユニット](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/メモリ管理ユニット.png)

#### ・アドレス変換の仕組み（ページング方式型／セグメント方式型）

1. 仮想メモリにおけるページの仮想アドレスを，ページ番号とページオフセットに分割する．

![ページの構造](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ページの構造.png)

2. ページテーブルを用いて，仮想アドレスのページ番号に対応する物理アドレスのページ番号を探す．
3. 物理ページ番号にページオフセットを再結合し，物理メモリのページフレームの物理アドレスとする．

![仮想メモリとのマッピングによる大容量アドレス空間の再現_3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/仮想メモリとのマッピングによる大容量アドレス空間の再現_3.png)

#### ・ページテーブルにおける仮想ページ番号と物理ページ番号の対応づけ

![仮想メモリとのマッピングによる大容量アドレス空間の再現_4](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/仮想メモリとのマッピングによる大容量アドレス空間の再現_4.png)



## 05-04. Page fault発生時の処理

### Page faultとは

ストレージから物理メモリのアドレス空間への割り込み処理のこと．CPUによって稼働したプログラムが，仮想メモリのアドレス空間のページにアクセスし，そのページが物理メモリのアドレス空間にマッピングされていなかった場合に，ストレージから物理メモリのアドレス空間に『ページイン』が起こる．

![ページフォールト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ページフォールト.png)



### Page Replacementアルゴリズム

ページアウトのアルゴリズムのこと．方式ごとに，物理メモリのページフレームからストレージにページアウトするページが異なる．

#### ・『FIFO方式：First In First Out』と『LIFO方式：Last In First Out』

![p261-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p261-2.png)

![p261-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p261-3.png)

#### ・『LRU方式：Least Recently Used』と『LFU方式：Least Frequently Used』

![p261-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p261-1.png)

![p261-4](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p261-4.png)



## 05-05. アドレス空間管理におけるプログラムの種類

### Reusable（再使用可能プログラム）

一度実行すれば，再度，ストレージから物理メモリにページインを行わずに，実行を繰り返せるプログラムのこと．

![再使用可能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/再使用可能.gif)



### Reentrant（再入可能プログラム）

再使用可能の性質をもち，また複数のプログラムから呼び出されても，互いの呼び出しが干渉せず，同時に実行できるプログラムのこと．

![再入可能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/再入可能.gif)



### Relocatable（再配置可能プログラム）

ストレージから物理メモリにページインを行う時に，アドレス空間上のどこに配置されても実行できるプログラムのこと．

![再配置可能](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/再配置可能.gif)



## 06. ディスクメモリ

CPU，メインメモリ，ストレージ間には，読み込みと書き出しの処理速度に差がある．（※再度記載）

![p169](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p169.png)



### ディスクメモリの機能

メインメモリとストレージの間に，ディスクキャッシュを設置し，読み込みと書き出しの処理速度の差を緩和させる．

![ディスクキャッシュ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ディスクキャッシュ.gif)



## 07. HDD

### Defragmentation

断片化されたデータ領域を整理整頓する．

![p184-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p184-1.png)

![p184-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p184-2.png)



### RAID：Redundant Arrays of Inexpensive Disks

複数のHDDを仮想的に一つのHDDであるかのようにして，データを管理する技術．

#### ・RAID0（Striping）

  データを，複数のHDDに分割して書き込む．

#### ・RAID1（Mirroring）

  データを，複数のHDDに同じように書き込む．

#### ・RAID5（Striping with parity）

  データとパリティ（誤り訂正符号）を，3つ以上のHDDに書き込む．

![RAIDの種類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/RAIDの種類.png)



## 08. GPUとVRAM

GPUとVRAMの容量によって，扱うことのできる解像度と色数が決まる．

![VRAM](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/VRAM.jpg)

富士通PCのGPUとVRAMの容量は，以下の通り．

![本パソコンのVRAMスペック](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/本パソコンのVRAMスペック.jpg)

色数によって，１ドット当たり何ビットを要するが異なる．

![p204](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p204.jpg)

