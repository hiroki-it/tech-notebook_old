# 勉強の方針

1. 必ず、実例として、それが扱われているのかを覚えること。

2. 必ず、言葉ではなく、イラストを用いて覚えること。

3. 必ず、知識の『点』と『点』を繋ぎ、『線』にしろ

4. 必ず、まとめることでインプットしているだけなので、口頭で説明してアプトプットしろ。

5. キタミ式で大枠をとらえて、過去問で肉付けしていく。

   

# 14-01. システムの開発手法の種類

### ◇ システム開発の要素

- **設計**
- **実装**
- **テスト**

⇒ 15章と16章で解説していく。



### ◇ ウォーターフォール型開発

![ウォーターフォール型](C:\Projects\Summary_Notes\まとめノート\画像\ウォーターフォール型.png)

- **外部設計の詳細**

  外部設計では、ユーザ向けのシステム設計が行われる。

  ![外部設計の詳細](C:\Projects\Summary_Notes\まとめノート\画像\外部設計の詳細.png)



### ◇ プロトタイプ型開発

システム設計に入るまでに試作品を作り、要件定義をより正確にする開発方法。

![p456](C:\Projects\Summary_Notes\まとめノート\画像\p456.png)



### ◇ レビュー

各工程が完了した段階で、レビューを行う開発方法。

![p458](C:\Projects\Summary_Notes\まとめノート\画像\p458.png)



### ◇ RAD（Rapid Application Development）

Visual Basicなどの開発支援ツールを用いて、短期間で設計～テストまでを繰り返す開発方法。

![p462-1](C:\Projects\Summary_Notes\まとめノート\画像\p462-1.png)

![p462-2](C:\Projects\Summary_Notes\まとめノート\画像\p462-2.png)



### ◇ スパイラル型開発

システムをいくつかのサブシステムに分割し、ウォーターフォール型開発で各サブシステムを開発していく方法。

![p457](C:\Projects\Summary_Notes\まとめノート\画像\p457.png)



### ◇ アジャイル型開発

スパイラルモデルの派生型。スパイラルモデルよりも短い期間で、設計～テストまでを繰り返す開発方法。

![p463](C:\Projects\Summary_Notes\まとめノート\画像\p463.png)



### ◇ CASEツール：Computer Aided Software Enginnering

システム開発をサポートするツール群のこと。

- **上流CASEツール**

  データフロー図、ER図

- **下流CASEツール**

  テスト支援ツール

- **保守CASEツール**

  リバースエンジニアリング

![p459](C:\Projects\Summary_Notes\まとめノート\画像\p459.png)



# 14-02. サーバーサイドのテスト

### ◇ テストの流れ

テストは、小さい範囲から大きい範囲へと移行していく。

![p491-3](C:\Projects\Summary_Notes\まとめノート\画像\p491-3.jpg)

 

### ◇ 単体テスト

モジュール別に適切に動いているかを検証。ブラックボックステストやホワイトボックステストが用いられる。

![単体テスト](C:\Projects\Summary_Notes\まとめノート\画像\p490-1.jpg)

- **ブラックボックステスト**

  モジュール内の実装内容は気にせず、入力に対して、適切な出力が行われているかを検証。

  ![p492-1](C:\Projects\Summary_Notes\まとめノート\画像\p492-1.jpg)

- **ホワイトボックステスト**

  モジュール内の実装内容が適切かを確認しながら、入力に対して、適切な出力が行われているかを検証。

  ![p492-2](C:\Projects\Summary_Notes\まとめノート\画像\p492-2.jpg)



### ◇ ホワイトボックステストの方法（何をテストするかに着目すれば、思い出しやすい）

**【実装例】**

```
if (A = 1 && B = 1) {
　return X;
}
```

上記のif文におけるテストとして、以下の４つの方法が考えられる。基本的には、複数条件網羅が用いられる。

- **命令網羅（『全ての処理』が実行されるかをテスト）**

![p494-1](C:\Projects\Summary_Notes\まとめノート\画像\p494-1.png)

全ての命令が実行されるかをテスト（ここでは処理は1つ）。

すなわち…

A = 1、B = 1 の時、return X が実行されること。

- **判定条件網羅（『全ての分岐』が実行されるかをテスト）**

![p494-2](C:\Projects\Summary_Notes\まとめノート\画像\p494-2.png)

全ての分岐が実行されるかをテスト（ここでは分岐は2つ）。

すなわち…

A = 1、B = 1 の時、return X が実行されること。
A = 1、B = 0 の時、return X が実行されないこと。

- **条件網羅（『各条件の取り得る全ての値』が実行されるかをテスト）**

![p494-3](C:\Projects\Summary_Notes\まとめノート\画像\p494-3.png)

各条件が、取り得る全ての値で実行されるかをテスト（ここでは、Aが0と1、Bが0と1になる組み合わせなので、2つ）

すなわち…

A = 1、B = 0 の時、return X が実行されないこと。
A = 0、B = 1 の時、return X が実行されないこと。

または、次の組み合わせでもよい。

A = 1、B = 1 の時、return X が実行されること。
A = 0、B = 0 の時、return X が実行されないこと。

- **複数条件網羅（『各条件が取り得る全ての値』、かつ『全ての組み合わせ』が実行されるかをテスト）**

![p494-4](C:\Projects\Summary_Notes\まとめノート\画像\p494-4.png)

各条件が、取り得る全ての値で、かつ全ての組み合わせが実行されるかをテスト（ここでは4つ）

すなわち…

A = 1、B = 1 の時、return X が実行されること。
A = 1、B = 0 の時、return X が実行されないこと。
A = 0、B = 1 の時、return X が実行されないこと。
A = 0、B = 0 の時、return X が実行されないこと。



### ◇ 結合テスト

単体テストの次に行うテスト。複数のモジュールを繋げ、モジュール間のインターフェイスが適切に動いているかを検証。

![結合テスト](C:\Projects\Summary_Notes\まとめノート\画像\p491-1.jpg)

- **Top-down テスト**

  上位のモジュールから下位のモジュールに向かって、結合テストを行う場合、下位には Stub と呼ばれるダミーモジュールを作成する。

  ![トップダウンテスト](C:\Projects\Summary_Notes\まとめノート\画像\トップダウンテスト.jpg)

- **Bottom-up テスト**

  下位のモジュールから上位のモジュールに向かって、結合テストを行う場合、上位には Driver と呼ばれるダミーモジュールを作成する。

  ![ボトムアップテスト](C:\Projects\Summary_Notes\まとめノート\画像\ボトムアップテスト.jpg)



### ◇ システムテスト

結合テストの次に行うテスト。システム全体が適切に動いているかを検証。

![p491-2](C:\Projects\Summary_Notes\まとめノート\画像\p491-2.jpg)



### ◇ Regression テスト

システムを変更した後、他のプログラムに悪影響を与えていないかを検証。

![p496](C:\Projects\Summary_Notes\まとめノート\画像\p496.jpg)



### ◇ バグ管理図

プロジェクトの時、残存テスト数と不良摘出数（バグ発見数）を縦軸にとり、時間を横軸にとることで、バグ管理図を作成する。それぞれの曲線の状態から、プロジェクトの進捗状況を読み取ることができる。

![品質管理図](C:\Projects\Summary_Notes\まとめノート\画像\品質管理図.JPG)

不良摘出実績線（信頼度成長曲線）は、プログラムの品質の状態を表し、S字型でないものはプログラムの品質が良くないことを表す。

![信頼度成長曲線の悪い例](C:\Projects\Summary_Notes\まとめノート\画像\信頼度成長曲線の悪い例.JPG)



# 14-03. システム開発におけるプロジェクト管理

### ◇ 開発規模、工数、生産性の求め方

- **開発規模**

  （プログラム本数による開発規模）＝（プログラム本数）

  （プログラム行数による開発規模）＝（ｋステップ行数）

- **工数**

  （人月による工数）＝（人数・月）＝（人数 × 月数）

  （人時による工数）＝（人数・時）＝（人数 × 時間）

- **生産性**

  （プログラム本数の生産性）＝（プログラム本数／人時）＝（プログラム本数）÷（人数 × 時間）

  （kステップ行数の生産性）＝（ｋステップ行数／人月）＝（ｋステップ行数）÷（人数 × 月数）

  

### ◇ Arrow ダイアグラム

- **プロジェクトに必要な日数**

  全体的な工程に必要な日数は、所要日数が最も多い経路に影響される。この経路を、Critical Path という。

  ![p509](C:\Projects\Summary_Notes\まとめノート\画像\p509.jpg)

- **最早結合点時刻**

  全体的な工程の中で、任意の結合点に取り掛かるために必要な最少日数のこと。Critical Path に影響されるので、注意。

  ![p510-1](C:\Projects\Summary_Notes\まとめノート\画像\p510-1.jpg)

- **最遅結合点時刻**

  全体的な工程の中で、任意の結合点に取り掛かるために必要な最多日数のこと。

  ![p510-2](C:\Projects\Summary_Notes\まとめノート\画像\p510-2.jpg)





# 15-01. システム開発における設計方法

### ◇ システムの設計方法の種類と歴史

![構造化プログラミングからオブジェクト指向へ](C:\Projects\Summary_Notes\まとめノート\画像\構造化プログラミングからオブジェクト指向へ.png)



# 15-02. オブジェクトモデリングの図式化方法

### ◇  オブジェクトモデリングの図式化方法の種類

![複数視点のモデル化とUML](C:\Projects\Summary_Notes\まとめノート\画像\複数視点のモデル化とUML.jpg)



### ◇ UML：Unified Modeling Language（統一モデリング言語）

オブジェクト指向プログラミング型のシステム設計を行うには、まず、オブジェクトモデリングを行う必要がある。オブジェクトモデリングをダイアグラム図を用いて解りやすく視覚化する表記方法を Unified Modeling Language という。UMLにおけるダイアグラム図は、構造の視点に基づく構造図と、振舞の視点に基づく振舞図に分類される。

（※ちなみ、UMLは、システム設計だけでなく、データベース設計にも使える）

![UML-0](C:\Projects\Summary_Notes\まとめノート\画像\UML-0.png)

### ◇ UMLのダイアグラム一覧

![UML-1](C:\Projects\Summary_Notes\まとめノート\画像\UML-1.png)

![UML-2](C:\Projects\Summary_Notes\まとめノート\画像\UML-2.png)



# 15-03. UMLの構造図：『構造』の視点

### ◇  オブジェクトモデリングの図式化方法の種類（再掲）

![複数視点のモデル化とUML](C:\Projects\Summary_Notes\まとめノート\画像\複数視点のモデル化とUML.jpg)

![UML-1](C:\Projects\Summary_Notes\まとめノート\画像\UML-1.png)



### ◇ クラス図

クラスの構造、クラス間の関係、役割を表記する方法。

![クラス図の線の種類](C:\Projects\Summary_Notes\まとめノート\画像\クラス図の線の種類.png)

- **Class**

１つのクラスを、クラス区画、属性区画、操作区画の３要素で表記する方法。

![UML](C:\Projects\Summary_Notes\まとめノート\画像\クラス図.png)

- **Association（関連）**

２つのクラスを関連させる場合、クラスを線で繋ぐことで関連性を表記する方法。クラス図の実装の章を参照せよ。

![クラス図の関連表現](C:\Projects\Summary_Notes\まとめノート\画像\クラス図の関連表現.png)

- **Aggregation（集約）**

  クラスと別のクラスが、全体と部分の関係であることを表記する方法。クラス図の実装の章を参照せよ。

  **【具体例】**社員は１つの会社に所属する場合

    「社員」から見た「会社」は1つである。逆に、「会社」からみた「社員」は0人以上であることを表現。

![集約](C:\Projects\Summary_Notes\まとめノート\画像\集約.png)



- **Composition（合成）**

  クラス図の実装の章を参照せよ。

- **Dependency（依存）**

  

- **Realization（実現）＝ 抽象オブジェクト**

  クラス図の実装の章を参照せよ。

- **Generalization（凡化）**

  クラス間で属性、操作、関連を引継ぐことを表記する方法。サブクラスから見たスーパークラスとの関係を『汎化』、逆にスーパークラスから見たサブクラスとの関係を『特化』という。プログラミングにおける『継承』は、特化を実装する方法の一つ。

![汎化と特化](C:\Projects\Summary_Notes\まとめノート\画像\汎化と特化.png)

- **Cardinality（多重度）**

  クラスと別のクラスが、何個と何個で関係しているかを表記する方法。

  **【具体例】**社員は１つの会社にしか所属できない場合

  「社員」から見た「会社」は1つである。逆に、「会社」からみた「社員」は0人以上であるという表記。

![多重度](C:\Projects\Summary_Notes\まとめノート\画像\多重度.png)

![多重度一覧](C:\Projects\Summary_Notes\まとめノート\画像\多重度の表記方法.png)



# 15-04. UMLの構造図の実装方法

![クラス図の線の種類](C:\Projects\Summary_Notes\まとめノート\画像\クラス図の線の種類.png)



### ◇ Association（関連）



### ◇ Aggregation（集約）

【Tireクラス】

```
class Tire {}
```

【CarXクラス】

```
//CarXクラス定義
class CarX  
{
    //CarXクラスがタイヤクラスを引数として扱えるように設定
    public function __construct(Tire $t1, Tire $2, Tire $t3, Tire $t4)
    {
        $this->tire1 = $t1;
        $this->tire2 = $t2;
        $this->tire3 = $t3;
        $this->tire4 = $t4;
    }
}
```

【CarYクラス】

```
//CarYクラス定義
class CarY  
{
    //CarYクラスがタイヤクラスを引数として扱えるように設定
    public function __construct(Tire $t1, Tire $2, Tire $t3, Tire $t4)
    {
        //引数のTireクラスからプロパティにアクセス
        $this->tire1 = $t1;
        $this->tire2 = $t2;
        $this->tire3 = $t3;
        $this->tire4 = $t4;
    }
}
```

以下の様に、Tireクラスのインスタンスを、CarXクラスとCarYクラスの引数として用いている。
Tireクラスの各インスタンスと、2つのCarクラスの双方向で、依存関係はない。

```
//Tireクラスをインスタンス化
$tire1 = new Tire();
$tire2 = new Tire();
$tire3 = new Tire();
$tire4 = new Tire();
$tire5 = new Tire();
$tire6 = new Tire();

//Tireクラスのインスタンスを引数として扱う
$suv = new CarX($tire1, $tire2, $tire3, $tire4);

//Tireクラスのインスタンスを引数として扱う
$suv = new CarY($tire1, $tire2, $tire5, $tire6);
```



### ◇ Composition（合成）

【Lockクラス】

```
//Lockクラス定義
class Lock {}
```

【Keyクラス】

```
//Keyクラス定義
class Key {

    public function __construct(){
    
    }
}
```

【Carクラス】

```
//Carクラスを定義
class Car  
{
    
    public function __construct()
    {
        //引数Lockクラスをインスタンス化
        $lock = new Lock();
    }
}
```

以下の様に、LockクラスのLockインスタンスは、Carクラスの中で定義されているため、Lockインスタンスにはアクセスできない。また、Carクラスが起動しなければ、Lockインスタンスは起動できない。このように、LockインスタンスからCarクラスの方向には、強い依存関係がある。

```
//エラーになる。$lockには直接アクセスできない。
$key = new Key($lock);
```



### ◇  Dependency（依存）※関連、集約、合成の依存性の違い

『Association ＞ Aggregation ＞ Composition』の順で、依存性が低い。

![Association, Aggregation, Compositionの関係の強さの違い](C:\Projects\Summary_Notes\まとめノート\画像\Association, Aggregation, Compositionの関係の強さの違い.png)



### ◇ Generalization（汎化）

- **汎化におけるOverride**

汎化の時、子オブジェクトでメソッドを再定義すると、メソッドは上書きされる。

【親オブジェクト】
```
<?php
class Goods
{
    //商品名プロパティ
    private $name = "";

    //商品価格プロパティ
    private $price = 0;

    //コンストラクタ。商品名と商品価格を設定する
    public function __construct(string $name, int $price)
    {
        $this->name = $name;
        $this->price = $price;
    }

    //商品名と価格を表示するメソッド
    public function printPrice(): void
    {
        print($this->name."の価格: ￥".$this->price."<br>");
    }

    //商品名のゲッター
    public function getName(): string
    {
        return $this->name;
    }

    //商品価格のゲッター
    public function getPrice(): int
    {
        return $this->price;
    }
}
```

【子オブジェクト】
```
<?php
class GoodsWithTax extends Goods
{
    // printPriceメソッドをOverride
    public function printPrice(): void
    {
        //商品価格の税込み価格を計算し、表示
        $priceWithTax = round($this->getPrice() * 1.08);  // （1）
        print($this->getName()."の税込み価格: ￥".$priceWithTax."<br>");  // （2）
    }
}
```

- **抽象クラス**

抽象クラスでは、メソッドの型定義だけでなく処理内容も記述できる。ただし、子クラスでは、記述内容をOverrideしなければならない。多重継承はできず、単一継承しかできない。

  例えば、以下の条件の社員オブジェクトを実装したいとする。

  1. 午前９時に出社

  2. 営業部・開発部・総務部があり、それぞれが異なる仕事を行う

  3. 午後６時に退社

  この時、『働くメソッド』は部署ごとに異なってしまうが、どう実装したら良いのか…

![抽象クラスと抽象メソッド-1](https://user-images.githubusercontent.com/42175286/59590447-12ff8b00-9127-11e9-802e-126279fcb0b1.PNG)

  これを解決するために、例えば、次の２つが実装方法が考えられる。

1. 営業部社員オブジェクト、開発部社員オブジェクト、総務部社員オブジェクトを別々に実装

   ⇒メリット：同じ部署の他のオブジェクトに影響を与えられる。

   ⇒デメリット：各社員オブジェクトで共通の処理を個別に実装しなければならない。共通の処理が同じコードで書かれる保証がない。

  2. 一つの社員オブジェクトの中で、働くメソッドに部署ごとで変化する引数を設定
    
  ⇒メリット：全部署の社員を一つのオブジェクトで呼び出せる。
  
  ⇒デメリット：一つの修正が、全部署の社員の処理に影響を与えてしまう。

抽象オブジェクトと抽象メソッドを用いると、2つのメリットを生かしつつ、デメリットを解消可能。

![抽象クラスと抽象メソッド-2](https://user-images.githubusercontent.com/42175286/59590387-e8adcd80-9126-11e9-87b3-7659468af2f6.PNG)

- **parent::**

オーバーライドによって上書きされる前のメソッドを呼び出せる。

```
<?php
class GoodsWithTax2 extends Goods
{
    //商品名と価格を表示するメソッド。税込みで表示するように変更
    public function printPrice(): void
    {

        //親オブジェクトの同名メソッドの呼び出し
        parent::printPrice();  // （1）

        //商品価格の税込み価格を計算し、表示
        $priceWithTax = round($this->getPrice() * 1.08);
        print($this->getName()."の税込み価格: ￥".$priceWithTax."<br>");
    }
}
```



### ◇ Realization（実現）

インターフェースではメソッドの型しか定義できず、実装クラスでは処理内容を記述しなければならない。多重継承できる。

![子インターフェースの多重継承](C:\Projects\Summary_Notes\まとめノート\画像\子インターフェースの多重継承.png)

【親オブジェクト】

```
interface Communication
{
     // インターフェイスでは、実装を伴うメソッドやプロパティの宣言はできない
     public function talk();
     public function touch();
     public function gesture();
}
```

【子オブジェクト】
```
class Human implements Communication
{
     public function talk()
     {
          // 話す
     }
     public function touch()
     {
          // 触る
     }
     public function gesture()
     {
          // 身振り手振り
     }
}
```



# 15-05. 概念データモデリング

### ◇  オブジェクトモデリングの図式化方法の種類（再掲）

![複数視点のモデル化とUML](C:\Projects\Summary_Notes\まとめノート\画像\複数視点のモデル化とUML.jpg)



### ◇ ER図：Entity Relation Diagram

データベースの設計において、エンティティ間の関係を表すために用いられるダイアグラム図。『IE 記法』と『IDEF1X 記法』が一般的に用いられる。

![ER図（IE記法）](C:\Projects\Summary_Notes\まとめノート\画像\ER図（IE記法）.png)

- **Entity と Attribute**

  ![エンティティとアトリビュート](C:\Projects\Summary_Notes\まとめノート\画像\エンティティとアトリビュート.png)

- **Relation と Cardinality（多重度）**

  エンティティ間の関係を表す。

  ![リレーションとカーディナリティ](C:\Projects\Summary_Notes\まとめノート\画像\リレーションとカーディナリティ.png)

- **1：1**

  ![１：１](C:\Projects\Summary_Notes\まとめノート\画像\１：１.png)

- **1：多（Relation が曖昧な状態）**

  設計が進むにつれ、「1：0 以上の関係」「1：1 以上の関係」のように具体化しく。

  ![１：多（Relationが曖昧な状態）](C:\Projects\Summary_Notes\まとめノート\画像\１：多（Relationが曖昧な状態）.png)

- **1：1 以上**

  ![１：１以上](C:\Projects\Summary_Notes\まとめノート\画像\１：１以上.png)



# 15-06. UMLの振舞図：『機能』の視点

### ◇  オブジェクトモデリングの図式化方法の種類（再掲）

![複数視点のモデル化とUML](C:\Projects\Summary_Notes\まとめノート\画像\複数視点のモデル化とUML.jpg)

![UML-2](C:\Projects\Summary_Notes\まとめノート\画像\UML-2.png)



### ◇ Use case 図（使用事例図）

ユーザーの視点で、システムの利用例を表記する方法。

**【具体例】**オンラインショッピングにおけるUse case

![ユースケース図](C:\Projects\Summary_Notes\まとめノート\画像\ユースケース図.png)



### ◇  アクティビティ図

ビジネスロジックや業務フローを手続き的に表記する方法。

**【設計例】**

![アクティビティ図](C:\Projects\Summary_Notes\まとめノート\画像\アクティビティ図.png)

- **アルゴリズムとフローチャート**

  ![p549-1](C:\Projects\Summary_Notes\まとめノート\画像\p549-1.gif)

  ![p549-2](C:\Projects\Summary_Notes\まとめノート\画像\p549-2.gif)

  ![p549-3](C:\Projects\Summary_Notes\まとめノート\画像\p549-3.gif)





# 15-07. 構造化分析・設計

### ◇  オブジェクトモデリングの図式化方法の種類（再掲）

![複数視点のモデル化とUML](C:\Projects\Summary_Notes\まとめノート\画像\複数視点のモデル化とUML.jpg)



### ◇ DFD：Data Flow Diagram（データフロー図）

![データフロー図](C:\Projects\Summary_Notes\まとめノート\画像\データフロー図.jpg)



# 15-08. UMLの振舞図：『振舞』の視点

### ◇  シーケンス図

オブジェクトからオブジェクトへの振舞の流れを、時間軸に沿って表記する方法。Alfortの設計ではこれが用いられた。

**【設計例】**

1. 店員は在庫管理画面から在庫一覧を確認可能。
2. この機能は、『店員オブジェクト』、『管理画面オブジェクト』、『倉庫オブジェクト』、『商品オブジェクト』から構成されている。

![シーケンス図](C:\Projects\Summary_Notes\まとめノート\画像\シーケンス図.png)



# 15-09. リアルタイム構造化・分析

### ◇  オブジェクトモデリングの図式化方法の種類（再掲）

![複数視点のモデル化とUML](C:\Projects\Summary_Notes\まとめノート\画像\複数視点のモデル化とUML.jpg)



### ◇ 状態遷移図

「状態」を丸，「⁠遷移」を矢印で表す。矢印の横の説明は、遷移のきっかけとなる「イベント（入力）⁠／アクション（出力）⁠」を示す。

![状態遷移図](C:\Projects\Summary_Notes\まとめノート\画像\ストップウォッチ状態遷移図.jpg)



### ◇ 状態遷移表

状態遷移表を作成してみると，状態遷移図では、9つあるセルのうち4つのセルしか表現できておらず，残り5つのセルは表現されていないことに気づくことができる。

![状態遷移表](C:\Projects\Summary_Notes\まとめノート\画像\ストップウォッチ状態遷移表.jpg)

**【例題】**12.2 という状態

1. 初期の状態を『a』として、最初が数字なので、a行の『b』へ移動。
2. 現在の状態『b』から、次は数字なので、b行の『b』へ移動。
3. 現在の状態『b』から、次は小数点なので、b行の『d』へ移動
4. 現在の状態『d』から、次は数字なので、b行の『e』へ移動

![状態遷移表](C:\Projects\Summary_Notes\まとめノート\画像\状態遷移表.png)



# 15-10. アクセス修飾子

### ◇ static

別ファイルでのメソッドの呼び出しにはインスタンス化が必要である。しかし、static修飾子をつけることで、インスタンス化しなくとも呼び出せる。生成されたオブジェクト自身から取り出す必要がなく、静的（オブジェクトの状態とは無関係）な、プロパティやメソッドに用いる。



### ◇ private

同じオブジェクト内でのみ呼び出せる。

- **Encapsulation（カプセル化）**

カプセル化とは、システムの実装方法を外部から隠すこと。オブジェクト内のプロパティにアクセスするには、直接データを扱う事はできず、オブジェクト内のメソッドを呼び出して、アクセスしなければならない。

![カプセル化](https://user-images.githubusercontent.com/42175286/59212717-160def00-8bee-11e9-856c-fae97786ae6c.gif)



### ◇ proteced

同じオブジェクト内と子オブジェクトでのみ呼び出せる。



### ◇ public

どのオブジェクトでも呼び出せる。



# 15-11. メソッドの実装方法

### ◇ そもそも、出来るだけphpのデフォルト関数を用いる

引用：php関数リファレンス，https://www.php.net/manual/ja/funcref.php



### ◇ Getterを実装するコツ

Getterでは、プロパティを取得するだけではなく、何かしらの処理を加えたうえで取得すること。

**【実装例】**例外処理＋取得

```
private $property; 

public function getEditProperty(){
	if(!isset($this->property){
		throw new ErrorException('プロパティに値がセットされていません。')
	}
    return $this->property;
}
```



### ◇ Setterを実装するコツ

Setterとして、constructメソッドを用いる。

```
private $property; 

public function __construct($property)
{
	$this->property = $property;
}
```



### ◇ メソッドチェーン

以下のような、オブジェクトAを最外層とした関係が存在しているとする。

【オブジェクトA（オブジェクトBをプロパティに持つ）】

```
class Obj_A{
	private $ObjB;
 
	public function getObjB(){
		return $this->ObjB;
	}
}
```

【オブジェクトB（オブジェクトCをプロパティに持つ）】

```
class Obj_B{
	private $ObjC;
 
	public function getObjC(){
		return $this->ObjC;
	}
}
```

【オブジェクトC（オブジェクトDをプロパティに持つ）】

```
class Obj_C{
	private $ObjD;
 
	public function getObjD(){
		return $this->ObjD;
	}
}
```

以下のように、返り値のオブジェクトを用いて、より深い層に連続してアクセスしていく場合…

```
$ObjA = new Obj_A;

$ObjB = $ObjA->getObjB();

$ObjC = $B->getObjB();

$ObjD = $C->getObjD();
```

以下のように、メソッドチェーンという書き方が可能。

```
$D = getObjB()->getObjC()->getObjC();

// $D には ObjD が格納されている。
```



### ◇ 値の格納方法

- **参照渡し**

「参照渡し」とは、変数に代入した値の参照先（メモリアドレス）を渡すこと。

```
$value = 1;
$result = &$value; // 値の入れ物を参照先として代入
```

**【実装例】**```$b```には、```$a```の参照によって10が格納される。

```
$a = 2;
$b = &$a;  // 変数aを&をつけて代入
$a = 10;    // 変数aの値を変更
echo $b;

# 結果
10
```

- **値渡し**

「値渡し」とは、変数に代入した値のコピーを渡すこと。

```
$value = 1;
$result = $value; // 1をコピーして代入
```

**【実装例】**```$b```には、```$a```の一行目の格納によって2が格納される。

```
$a = 2;
$b = $a;  // 変数aを代入
$a = 10;  // 変数aの値を変更
echo $b;

# 結果
2
```



### ◇ **Recursive call：再帰的プログラム**

自プログラムから、自身自身を呼び出して実行できるプログラムのこと。

**【具体例】**ある関数 ``` f  ```の定義の中に ``` f ```自身を呼び出している箇所がある。

![再帰的](C:\Projects\Summary_Notes\まとめノート\画像\再帰的.png)



### ◇ 高階関数

関数を引数として受け取ったり、関数自体を返したりする関数のこと。

- **第一引数を設定**

```
<?php

// 高階関数を定義
function test($callback){
    echo $callback();
}

// コールバックを定義
function callbackMethod(){
    return "出力成功";
}

// 高階関数の引数として、コールバック関数を渡す
test("callbackMethod");
```

```
// 出力結果
出力成功
```

- **第一引数と第二引数を設定**

```
<?php
// 高階関数を定義
function test($callback, $param){
    echo $callback($param);
}

// コールバックを定義
function callbackMethod($param){
    return $param."出力成功";
}
 
// 高階関数の第一引数にコールバック関数、第二引数にコールバック関数の引数を渡す
test("callbackMethod", $param);
```

```
// 出力結果
$param出力成功
```



### ◇ Closure（無名関数）

コールバックを作成するために用いる。

```

```

- **use構文**

useで指定した変数をプロパティにもつClosureオブジェクトが作成される。

```
<?php
$foo = function($money)
{
  return function($price) use ($money)
  {
    return $price . $money;
  };
};
$hoge = $foo('円'); 
//'円'が$moneyとして渡される。$hogeには、『function($price) use ('円')』が入っている。

echo $hoge(100);
// 100が$priceとして渡される。
?>
```



### ◇ ラッパー関数

```

```



# 16-01. システム設計における実装内容の分割

### ◇ STS 分割法

プログラムを、『Source（入力処理）➔ Transform（変換処理）➔ Sink（出力処理）』のデータの流れに則って、入力モジュール、処理モジュール、出力モジュール、の３つ分割する方法。（リクエスト ➔ DB ➔ レスポンス）

![STS分割法](C:\Projects\Summary_Notes\まとめノート\画像\p485-1.png)

### ◇ Transaction 分割法

データの種類によってTransaction（処理）の種類が決まるような場合に、プログラムを処理の種類ごとに分割する方法。

![トランザクション分割法](C:\Projects\Summary_Notes\まとめノート\画像\p485-2.png)



### ◇ 共通機能分割法

プログラムを、共通の機能ごとに分割する方法

![共通機能分割法](C:\Projects\Summary_Notes\まとめノート\画像\p485-3.jpg)



### ◇ MVC

ドメイン駆動設計のノートを参照せよ。



### ◇ ドメイン駆動設計

ドメイン駆動設計のノートを参照せよ。



### ◇ テスト駆動設計

まだノートない。