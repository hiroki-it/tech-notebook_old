# 01. クラスター解析とは

クラスター解析とは、<font color="red">**データを統計的にグループ化（クラスタリング）する方法**</font>のこと。

プロットのまとまりでグループを視覚化する非階層クラスター解析。
![tech_mining_img96.jpg](https://qiita-image-store.s3.amazonaws.com/0/292201/cc0d786b-4f53-4053-c0af-b58d6e41bca4.jpeg)

樹状にグループを視覚化する階層クラスター解析がある。

![tech_mining_img77.jpg](https://qiita-image-store.s3.amazonaws.com/0/292201/be4a81d4-b0cb-d077-b1b4-930a9b88c14a.jpeg)

Rでクラスター解析を行うために、以下の手順が必要。

1. <font color="red">**データを読み込む**</font>
2. <font color="red">**データを距離行列に変換**</font>
3. <font color="red">**距離行列をクラスタリング**</font>
4. <font color="red">**解析結果を視覚化**</font>



# 02-01. 関数の探し方＆引数の調べ方

### ◇ 探し方
Rでやってみたいことがあったら、英語を使って<font color="red">**『 〇〇 in R 』**</font>とググる。
（例）表の読み込みをしたいから、『read table in r』とググる。



### ◇ 引数の調べ方
英語圏エンジニアのブログ等で自分のやりたいことをしているfunctionを探す。
その後、```function```の具体的な引数を https://www.rdocumentation.org で調べる。
（例）```read.table```で表の読み込みができることを見つけ、```read.table```とググる。
関数リンク：https://www.rdocumentation.org/packages/utils/versions/3.5.1/topics/read.table
以下の画面では、```read.table```の<font color="red">**引数の一覧**</font>が示されている。
```read.table```の後ろを丸括弧で囲い、その中に```file```、```header```、```sep```などの引数を書き込む必要がある。
![read.table1.png](https://qiita-image-store.s3.amazonaws.com/0/292201/d5f46f93-0ddd-6bad-6c1d-8059b2414426.png)
以下の画面では、```Arguments```(引数)の説明がされている。
```file```：読み込むデータ名を入力。
```header```：```TRUE```の場合、ヘッダーが有るものとして読み込む。```FALSE```は無い場合。
```sep```：```""```の場合、スペース区切り形式として読み込む。ここに書かれてはいないが、カンマ形式の場合```,```、タブ切り形式の場合```\t```に変更可能。
![read.table2.png](https://qiita-image-store.s3.amazonaws.com/0/292201/81ab4321-13ac-2e8b-6b30-acf496038d22.png)



### ◇ （1）```install.packages()```：パッケージをンストール

（例）```ape```パッケージ

```
install.packages("ape")
```

パッケージをインストール可能。
インストール時に、どのミラーサイトでインストールするか聞かれるので、<font color="red">**『Japan(Tokyo)』**</font>を選ぶ。

リンク：https://www.rdocumentation.org/packages/utils/versions/3.5.1/topics/install.packages



### ◇ （2）```library()```：パッケージを展開
（例）```ape```パッケージ

```
library(ape)
```

パッケージを展開（アクティブ化）する関数。
パッケージはRを閉じるたびに非アクティブ化されてしまうので、<font color="red">**起動するたびに```library()```が必要。**</font>

リンク：https://www.rdocumentation.org/packages/base/versions/3.5.1/topics/library



### ◇ （3）ディレクトリの指定
読み込みたいファイルは指定したディレクトリ(＝作業フォルダ)内にないといけないので、まず指定。
Rの上タブにある<font color="red">**『ファイル ⇒ ディレクトリの変更』**</font>から、ディレクトリを指定可能。



### ◇ （4）```object <-　"〇〇"```
（例）```test.txt```を```table```と名づけたオブジェクトに格納。

```
table <- "test.txt"
```

Rで中核となる命令。
データなどを文字に割り当てる。
割り当てを<font color="red">**『格納』**</font>と言う。（受験数学の『〇〇を文字Xと置く』のイメージ）
データをオブジェクトに格納してから扱っていく。



### ◇ （5）```remove(list=ls())```：全てのオブジェクトを削除
```
remove(list=ls())
```

今までに作成されたオブジェクトを全て削除可能。
試行錯誤していると間違った格納をしていることがあるので、時々リセットしておく。

リンク：https://www.rdocumentation.org/packages/base/versions/3.5.1/topics/remove



### ◇ （6）summary()：データの中身を確認
（例）オブジェクトである```table```の中身を確認。

```
summary(table)
```

データの中身を見ることが可能。

リンク：https://www.rdocumentation.org/packages/base/versions/3.5.1/topics/summary



### ◇ （7）```read.table()```：表データの読み込み
（例）```test.txt```をタブ有り・スペース区切りとして読み込み。

```
table <- read.table("test.txt",
header=TRUE,
sep="")
```
拡張子も忘れずに、ファイル名を```""```で囲って指定。（オブジェクトを引数として選ぶ場合```""```は不要）
```header```：ヘッダーの有無を指定。
```sep```：表データ形式を指定。（```/t```：タブ切、```,```：カンマ区切り）
処理の出力先として、```table```に格納。

リンク：https://www.rdocumentation.org/packages/utils/versions/3.5.1/topics/read.table

※```table```として、次のようなペアワイズ比較の有意差の対応表を扱うこともできる。
（ペアワイズ：総当たり的に比較された状態）

![ペアワイズ表.png](https://qiita-image-store.s3.amazonaws.com/0/292201/96059127-746e-4c7e-d777-de98b356a2f2.png)



### ◇ （8）```class()```：データフレームを確認
（例）```table```のデータフレームを確認。

```R.class_table.r
class(table)
```

データの```class```を確認。
functionによって読み込みのできるデータフレームが異なるので、事前に確認しておく。
例として、```table```の```class```を確認。

リンク：https://www.rdocumentation.org/packages/base/versions/3.5.1/topics/class



### ◇ （9）```data.matrix()```：データフレームを距離行列に変換
（例）```table```を距離行列に変換。

```
lower.matrix <- data.matrix(table)

class(lower.matrix)
```
クラスター解析を行う```function```は、データフレームが距離行列でないと認識できないため、data.matrixで事前に変換しておく必要がある。
変換後、ためしに、```class```でデータフレームを確認すると、```matrix```と返されるはず。
有意差表は下半分にしかデータがないので、```lower.matrix```として格納。
