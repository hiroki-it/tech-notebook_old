# オブジェクト指向分析／設計

## 01. アーキテクチャスタイル

### アーキテクチャスタイルと分析・設計手法

![アーキテクチャスタイルの種類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/アーキテクチャスタイルの種類.png)

|                        | アーキテクチャスタイル | スタイルに基づく設計             |
| -------------------- | ---------------------- | -------------------------------- |
| **デプロイメント構成** | クライアント／サーバ   | クライアントサイド／サーバサイド |
|    **システム構成**    | オブジェクト指向       | オブジェクト指向分析・設計        |
|                        | Layeredアーキテクチャ  | Layeredアーキテクチャ設計        |
|                        | MVC                    | MVC設計                          |
|   **データ通信領域**   | REST                   | RESTful                          |
|  **ドメイン領域構成**  | ドメイン駆動           | ドメイン駆動設計                 |



## 01-02. オブジェクト指向分析・設計

### オブジェクト指向分析・設計を取り巻く歴史

![プログラミング言語と設計手法の歴史](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/プログラミング言語と設計手法の歴史.png)



## 02. オブジェクト指向分析

### オブジェクト指向分析

#### ・そもそもオブジェクトとは

互いに密接に関連するデータと手続き（処理手順）をオブジェクトと呼ばれる一つのまとまりとして定義する手法のこと．

#### ・オブジェクト指向分析とは

オブジェクト指向分析では，システム化の対象になる領域に存在する概念を，オブジェクトモデリングする．

#### ・オブジェクトモデリングの注意点

オブジェクトモデリングの方法として，実体の『状態』と『動作』を考える．  しかし，これは厳密ではない．  なぜなら，ビジネス領域を実装する時には，ほとんどの場合で，動作を持たない実体を表現することになるからである．  より厳密に理解するために，実体の『状態』と『状態の変更と表示』と考えるべき．  



### オブジェクト指向分析で用いるダイアグラム図の種類

オブジェクト指向分析においては，ダイアグラム図を用いて，オブジェクトを表現することが必要になる．

#### ・機能の視点による分析とは

システムの機能と処理の流れに注目し，分析する方法．詳しくは以降の説明を参照．

#### ・振舞の視点による分析とは

システムを実行する順番やタイミングに注目し，分析する方法．詳しくは以降の説明を参照．

#### ・構造の視点による分析とは

システムの構成要素とそれぞれの関係に注目し，分析する方法．詳しくは以降の説明を参照．

※ただし，UMLにおけるクラス図に関しては設計段階で使用するため，このノートでは説明しない．

![複数視点のモデル化とUML](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/複数視点のモデル化とUML.jpg)



### UML：Unified Modeling Language（統一モデリング言語）

#### ・UMLとは

オブジェクト指向分析・設計に用いられるダイアグラム図．ダイアグラム図のUMLには，構造図，振舞図に分類される．

（※ちなみ，UMLは，システム設計だけでなく，データベース設計にも使える）

#### ・分析に用いられるUMLダイアグラム

![UML-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/UML-2.png)



## 02-02. 機能の視点

### DFD：Data Flow Diagram（データフロー図）

![データフロー図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/データフロー図.jpg)



### Use case 図（使用事例図）

ユーザーの視点で，システムの利用例を表記する方法．

**＊具体例＊**

オンラインショッピングにおけるUse case

![ユースケース図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ユースケース図.png)



###  アクティビティ図

ビジネスロジックや業務フローを手続き的に表記する方法．

**＊具体例＊**

![アクティビティ図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/アクティビティ図.png)

## 02-03. 振舞の視点

###  システムシーケンス図

#### ・システムシーケンス図とは

アクターからアクターへの振舞の流れを，時間軸に沿って表記する方法．Alfortのオブジェクト指向分析ではこれが用いられた．



### 状態遷移図

#### ・状態遷移図とは

「状態」を丸，「⁠遷移」を矢印で表現した分析モデル．矢印の横の説明は，遷移のきっかけとなる「イベント（入力）⁠／アクション（出力）⁠」を示す．

![状態遷移図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ストップウォッチ状態遷移図.jpg)

#### ・状態遷移表とは

状態遷移図から作成した表．状態遷移表を作成してみると，状態遷移図では，9つあるセルのうち4つのセルしか表現できておらず，残り5つのセルは表現されていないことに気づくことができる．

![状態遷移表](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ストップウォッチ状態遷移表.jpg)

**＊例題＊**

12.2 という状態

1. 初期の状態を『a』として，最初が数字なので，a行の『b』へ移動．
2. 現在の状態『b』から，次は数字なので，b行の『b』へ移動．
3. 現在の状態『b』から，次は小数点なので，b行の『d』へ移動．
4. 現在の状態『d』から，次は数字なので，b行の『e』へ移動．

![状態遷移表](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/状態遷移表.png)



## 02-04. 構造の視点

### ER図：Entity Relation Diagram

#### ・ER図：Entity Relation Diagramとは

データベースのオブジェクト指向分析において，エンティティ間の関係を表すために用いられるダイアグラム図．『IE 記法』と『IDEF1X 記法』が一般的に用いられる．

![ER図（IE記法）](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ER図（IE記法）.png)

#### ・Entity と Attribute

![エンティティとアトリビュート](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/エンティティとアトリビュート.png)

#### ・Relation と Cardinality（多重度）

  エンティティ間の関係を表す．

![リレーションとカーディナリティ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/リレーションとカーディナリティ.png)

#### ・1：1

![1対1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/1対1.png)

#### ・1：多（Relation が曖昧な状態）

オブジェクト指向分析が進むにつれ，「1：0 以上の関係」「1：1 以上の関係」のように具体化しく．

![1対1以上](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/1対1以上.png)

#### ・1：1 以上

![1対1以上](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/1対1以上.png)



## 03. オブジェクト指向設計

### これについては別のノートで説明する