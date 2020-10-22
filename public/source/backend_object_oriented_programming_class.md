# オブジェクト指向設計／プログラミング（1）

## 01. オブジェクト指向設計

### オブジェクト指向設計に用いられるUMLダイアグラム

![UML-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/UML-1.png)

<br>

### オブジェクト指向設計での作業例

#### 1. クラス図とシーケンス図の作成

オブジェクト指向分析で作られたダイアグラム図を基に，クラス図を作る．また，システムシーケンス図を基に，シーケンス図を作成する．

#### 2. デザインパターンの導入

クラス図に，デザインパターンを基にしたクラスを導入する．

#### 3. フレームワークのコンポーネントの導入

クラス図に，フレームワークのコンポーネントを導入する．

<br>

## 02. クラス図による設計

### クラス図

#### ・インスタンス間の関係性を表す図

Association（関連），Aggregation（集約），Composition（合成）が用いられる．詳しくは，以降の説明を参照．

![インスタンス間の関係性のクラス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インスタンス間の関係性のクラス図.png)

#### ・クラス間の関係性を表す図

Generalization（汎化），Realization（実現）が用いられる．詳しくは，以降の説明を参照．

![クラス間の関係性のクラス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/クラス間の関係性のクラス図.png)

#### ・クラス間，インスタンス間，クラス／インスタンス間の関係性を表す図

Dependency（依存）が用いられる．詳しくは，以降の説明を参照．

![クラス間，インスタンス間，クラスインスタンス間の関係性のクラス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/クラス間，インスタンス間，クラスインスタンス間の関係性のクラス図.png)

<br>

### クラスの多重度

#### ・多重度とは

クラスと別のクラスが，何個と何個で関係しているかを表記する方法．

**＊具体例＊**

社員は１つの会社にしか所属できない場合

「会社クラス」から見て，対する「社員クラス」の数は1つである．逆に，「社員クラス」から見て，対する「会社クラス」の数は0以上であるという表記．

![多重度](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/多重度.png)

| 表記  |    対するクラスがいくつあるか    |
| :---: | :------------------------------: |
|   1   |              必ず1               |
| 0.. 1 |  0以上1以下（つまり、0または1）  |
| 0.. n |            0以上n以下            |
| m.. n |            m以上n以下            |
|   *   | 0以上無限大以下（つまり、0以上） |
| 0.. * | 0以上無限大以下（つまり、0以上） |

**＊具体例＊**

【 営業部エンティティ 】

◁ー【 1課エンティティ 】

◁ー【 2課エンティティ 】

◁ー【 3課エンティティ 】



親エンティティなし

◁ー【 経営企画課エンティティ 】



というクラスの継承関係があった時，これを抽象的にまとめると，



【 部エンティティ(0.. *) 】

◁ー【 (0.. 1)課エンティティ 】



部エンティティから見て，対する課エンティティは0個以上である．

課エンティティから見て，対する部エンティティは0または1個である．

<br>

## 02-02. シーケンス図による設計

### シーケンス図

#### ・設計例1

1. 5つのライフライン（店員オブジェクト，管理画面オブジェクト，検索画面オブジェクト，商品DBオブジェクト，商品詳細画面オブジェクト）を設定する．
2. 各ライフラインで実行される実行仕様間の命令内容を，メッセージや複合フラグメントで示す．

![シーケンス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/シーケンス図.png)

#### ・設計例2

1. 3つのライフラインを設定する．
2. 各ライフラインで実行される実行仕様間の命令内容を，メッセージや複合フラグメントで示す．

![シーケンス図_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/シーケンス図_2.png)

<br>

## 03. インスタンス間の関係性

『Association ＞ Aggregation ＞ Composition』の順で，依存性が低くなる．

![インスタンス間の関係性のクラス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インスタンス間の関係性のクラス図.png)

<br>

### Association（関連）

#### ・Associationとは

関係性の種類と問わず，インスタンスを他インスタンスのデータとして保持する関係性は，『関連』である．

<br>

### Aggregation（集約）

#### ・Aggregationとは

インスタンスを他インスタンスの```__construct()```の引数として渡し，データとして保持する関係性は，『集約』である．

＊Tireクラス＊

```PHP
<?php
class Tire {}
```

＊CarXクラス＊

```PHP
<?php
//CarXクラス定義
class CarX
{
    private $tire1;
    
    private $tire2;
    
    private $tire3;
    
    private $tire4;

    //CarXクラスがタイヤクラスを引数として扱えるように設定
    public function __construct(Tire $t1, Tire $t2, Tire $t3, Tire $t4)
    {
        // Tireクラスのインスタンスをデータとして保持
        $this->tire1 = $t1;
        $this->tire2 = $t2;
        $this->tire3 = $t3;
        $this->tire4 = $t4;
    }
}
```

＊CarYクラス＊

```PHP
<?php
//CarYクラス定義
class CarY
{
    private $tire1;
    
    private $tire2;
    
    private $tire3;
    
    private $tire4;
    
    //CarYクラスがタイヤクラスを引数として扱えるように設定
    public function __construct(Tire $t1, Tire $t2, Tire $t3, Tire $t4)
    {
        // Tireクラスのインスタンスをデータとして保持．
        $this->tire1 = $t1;
        $this->tire2 = $t2;
        $this->tire3 = $t3;
        $this->tire4 = $t4;
    }
}
```

以下の様に，Tireクラスのインスタンスを，CarXクラスとCarYクラスの引数として用いている．

```PHP
<?php
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

<br>

### Composition（合成）

#### ・Compositionとは

インスタンスを，他インスタンスの```__constructor```の引数として渡すのではなく，クラスの中でインスタンス化し，データとして保持する関係性は，『合成』である．

＊Lockクラス＊

```PHP
<?php
//Lockクラス定義
class Lock {}
```

＊Carクラス＊

```PHP
<?php
//Carクラスを定義
class Car
{
    private $lock;
    
    public function __construct()
    {
        // 引数Lockクラスをインスタンス化
        // Tireクラスのインスタンスをデータとして保持．
        $this->lock = new Lock();
    }
}
```

以下の様に，Lockインスタンスは，Carクラスの中で定義されているため，Lockインスタンスにはアクセスできない．また，Carクラスが起動しなければ，Lockインスタンスは起動できない．このように，LockインスタンスからCarクラスの方向には，Compositionの関係性がある．

```PHP
<?php
// Carクラスのインスタンスの中で，Lockクラスがインスタンス化される．
$car = new Car();
```



## 04. クラス間の関係性

![クラス間の関係性のクラス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/クラス間の関係性のクラス図.png)

### Generalization（汎化）

#### ・汎化におけるOverride

汎化の時，子クラスでメソッドの処理内容を再び実装すると，処理内容は上書きされる．

＊親クラス＊

```PHP
<?php
// 通常クラス
class Goods
{
    // 商品名データ
    private $name = "";

    // 商品価格データ
    private $price = 0;

    // コンストラクタ．商品名と商品価格を設定する
    public function __construct(string $name, int $price)
    {
        $this->name = $name;
        $this->price = $price;
    }

    // ★★★★★★注目★★★★★★
    // 商品名と価格を表示するメソッド
    public function printPrice(): void
    {
        print($this->name."の価格: ￥".$this->price."<br>");
    }

    // 商品名のゲッター
    public function getName(): string
    {
        return $this->name;
    }

    // 商品価格のゲッター
    public function getPrice(): int
    {
        return $this->price;
    }
}
```

＊子クラス＊

```PHP
<?php
// 通常クラス
class GoodsWithTax extends Goods
{
    // ★★★★★★注目★★★★★★
    // printPriceメソッドをOverride
    public function printPrice()
    {
        // 商品価格の税込み価格を計算し，表示
        $priceWithTax = round($this->getPrice() * 1.08);  // （1）
        print($this->getName()."の税込み価格: ￥".$priceWithTax."<br>");  // （2）
    }
}
```

#### ・抽象クラス

ビジネスロジックとして用いる．多重継承できない．

  **＊具体例＊**

以下の条件の社員オブジェクトを実装したいとする．

1. 午前９時に出社

2. 営業部・開発部・総務部があり，それぞれが異なる仕事を行う

3. 午後６時に退社

  この時，『働くメソッド』は部署ごとに異なってしまうが，どう実装したら良いのか…

![抽象クラスと抽象メソッド-1](https://user-images.githubusercontent.com/42175286/59590447-12ff8b00-9127-11e9-802e-126279fcb0b1.PNG)

  これを解決するために，例えば，次の２つが実装方法が考えられる．

1. 営業部社員オブジェクト，開発部社員オブジェクト，総務部社員オブジェクトを別々に実装

   ⇒メリット：同じ部署の他のオブジェクトに影響を与えられる．

   ⇒デメリット：各社員オブジェクトで共通の処理を個別に実装しなければならない．共通の処理が同じコードで書かれる保証がない．

  2. 一つの社員オブジェクトの中で，働くメソッドに部署ごとで変化する引数を設定

  ⇒メリット：全部署の社員を一つのオブジェクトで呼び出せる．

  ⇒デメリット：一つの修正が，全部署の社員の処理に影響を与えてしまう．

抽象オブジェクトと抽象メソッドを用いると，2つのメリットを生かしつつ，デメリットを解消可能．

![抽象クラスと抽象メソッド-2](https://user-images.githubusercontent.com/42175286/59590387-e8adcd80-9126-11e9-87b3-7659468af2f6.PNG)

**＊実装例＊**

```PHP
<?php
// 抽象クラス．型として提供したいものを定義する．
abstract class ShainManagement
{
    // 定数の定義
    const TIME_TO_ARRIVE = strtotime('10:00:00');
    const TIME_TO_LEAVE = strtotime('19:00:00');
    
    // 抽象メソッド．
    // 処理内容を子クラスでOverrideしなければならない．
    abstract function toWork();

    // 具象メソッド．出勤時刻を表示．もし遅刻していたら，代わりに差分を表示．
    // 子クラスへそのまま継承される．子クラスでオーバーライドしなくても良い．
    public function toArrive()
    {
        $nowTime = strtotime( date('H:i:s') );
    
        // 出社時間より遅かった場合，遅刻と表示する．
        if($nowTime > self::TIME_TO_ARRIVE){
        
            return sprintf(
                "%s の遅刻です．",
                date('H時i分s秒', $nowTime - self::TIME_TO_ARRIVE)
            );
        }
        
        return sprintf(
            "%s に出勤しました．",
            date('H時i分s秒', $nowTime)
        );
    
    }
  
    // 具象メソッド．退社時間と残業時間を表示．
    // 子クラスへそのまま継承される．子クラスでオーバーライドしなくても良い．
    public function toLeave()
    {
        $nowTime = strtotime( date('H:i:s') );
        
        return sprintf(
            "%sに退社しました．%s の残業です．",
            date('H時i分s秒', $nowTime),
            date('H時i分s秒', $nowTime - self::TIME_TO_LEAVE)
        );
    }
}
```

```PHP
<?php
// 子クラス
class EnginnerShainManagement extends ShainManagement
{
    // 鋳型となった抽象クラスの抽象メソッドはOverrideしなければならない．
    public function toWork()
    {
        // 処理内容；
    }
}
```

**＊具体例＊**

プリウスと各世代プリウスが，抽象クラスと子クラスの関係にある．

![抽象クラス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/抽象クラス.png)

<br>

### Realization（実現）

#### ・Realizationとは

実装クラスが正常に機能するために最低限必要なメソッドの実装を強制する．これによって，必ず実装クラスを正常に働かせることができる．

**＊具体例＊**

オープンソースのライブラリは，ユーザが実装クラスを自身で追加実装することも考慮して，Realizationが用いられている．

**＊具体例＊**

各車は，モーター機能を必ず持っていなければ，正常に働くことができない．そこで，モータ機能に最低限必要なメソッドの実装を強制する．

![インターフェースとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インターフェースとは.png)

実装クラスに処理内容を記述しなければならない．すなわち，抽象クラスにメソッドの型のみ定義した場合と同じである．多重継承できる．

![子インターフェースの多重継承_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/子インターフェースの多重継承_2.png)

**＊実装例＊**

```PHP
<?php
// コミュニケーションのメソッドの実装を強制するインターフェース
interface Communication
{
     // インターフェイスでは，実装を伴うメソッドやデータの宣言はできない
     public function talk();
     public function touch();
     public function gesture();
}
```

```PHP
<?php
// 正常に機能するように，コミュニケーションのメソッドの実装を強制する．
class Human implements Communication
{
    // メソッドの処理内容を定義しなければならない．
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

<br>

### 通常クラス，抽象クラス，インターフェースの違い

|                              |    通常クラス    |    抽象クラス    |                       インターフェース                       |
| ---------------------------- | :--------------: | :--------------: | :----------------------------------------------------------: |
| **役割**                     | 専用処理の部品化 | 共通処理の部品化 | 実装クラスが正常に機能するために最低限必要なメソッドの実装を強制 |
| **子クラスでの継承先数**     |     単一継承     |     単一継承     |                      単一継承｜多重継承                      |
| **メンバ変数のコール**       |   自身と継承先   |    継承先のみ    |                          実装先のみ                          |
| **定数の定義**               |        〇        |        〇        |                              〇                              |
| **抽象メソッドの定義**       |        ✕         |        〇        |                     〇（abstractは省略）                     |
| **具象メソッドの定義**       |        〇        |        〇        |                              ✕                               |
| **```construct()``` の定義** |        〇        |        〇        |                              ✕                               |

**＊具体例＊**

1. 種々の車クラスの共通処理のをもつ抽象クラスとして，Carクラスを作成．
2. 各車は，エンジン機能を必ず持っていなければ，正常に働くことができない．そこで，抽象メソッドによって，エンジン機能に最低限必要なメソッドの実装を強制する．

![インターフェースと抽象クラスの使い分け](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インターフェースと抽象クラスの使い分け.png)

<br>


## 04-02. クラスの継承

### クラスチェーンによる継承元の参照

クラスからデータやメソッドをコールした時，そのクラスにこれらが存在しなければ，継承元まで参照しにいく仕組みを『クラスチェーン』という．プロトタイプベースのオブジェクト指向で用いられるプロトタイプチェーンについては，別ノートを参照せよ．

**＊実装例＊**

```PHP
<?php
  
// 継承元クラス
class Example
{
    private $value1;
  
    public function getValue()
    {
        return $this->value1; 
    }  
}
```

```PHP
<?php
  
// 継承先クラス
class SubExample extends Example
{
    public $subValue;
  
    public function getSubValue()
    {
        return $this->subValue; 
    }  
}
```

```PHP
<?php
  
$subExample = new SubExample;

// SubExampleクラスにはgetValue()は無い．
// 継承元まで辿り，Exampleクラスからメソッドがコールされる（クラスチェーン）．
echo $subExample->getValue();
```

<br>

### 継承元の静的メソッドを参照

**＊実装例＊**

```PHP
<?php
  
abstract class Example 
{
    public function example()
    {
        // 処理内容;
    }
}
```

```PHP
<?php
  
class SubExample extends Example
{
    public function subExample()
    {
        // 継承元の静的メソッドを参照．
        $example = parent::example();
    } 
}
```

<br>

### Trait

#### ・Traitとは

![Trait](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Trait.png)

再利用したいメソッドやデータを部品化し，利用したい時にクラスに取り込む．Traitを用いるときは，クラス内でTraitをuse宣言する．Trait自体は不完全なクラスであり，インスタンス化できない．

**＊実装例＊**

```php
<?php
  
trait ExampleTrait
{
    public function example()
    {
        return "Hello World";
    }
}
```

```php
<?php

class Example
{
    use ExampleTrait;
}

$exmaple = new Example();
$example->example(); // Hello World
```

<br>

## 04-03. 外部ファイルの読み込み

### ```require_once```メソッドによる，クラス，非クラスのメソッドの読み込み

#### ・```require_once```メソッドとは

外部ファイルとして定義された，クラス，非クラスのメソッド，を一度だけ読み込める．動的な値は持たず，静的に読み込むことに注意．ただし，チームの各エンジニアが好きな物を読み込んでいたら，スパゲッティコードになりかねない．そこで，チームでの開発では，記述ルールを設けて，```require_once```メソッドで読み込んで良いものを決めておくと良い．


#### ・クラスからメソッドをコール

```php
<?php
  
class Example1
{
    const VALUE = "これは定数です．";
  
    public function className()
    {
        return "example1メソッドです．";
    }
}
```

```php
<?php

// 外部ファイル名を指定して，クラスを読み込む．
require_once('Example1.php');

class Example2
{
    public function method()
    {
        $e1 = new Example1:
        $e1->className();
    }
}
```

#### ・クラスから定数をコール

```php
<?php
  
// 外部ファイル名を指定して，クラスを読み込む．
require_once('Example1.php');

class Example2
{
    public function method()
    {    
        // Example1クラスの定数を出力．
        return Example1::VALUE;
    }
}
```

#### ・非クラスからメソッドをコール

```php
<?php

function printTest() {
    return  'test';
}
```

```php
<?php

// 外部ファイル名を指定して読み込む．
require_once ('printTestFunction.php');

printTest();
```

<br>

### ```use```によるクラスの読み込み

#### ・```use```とは

PHP```5.3```以降では，外部ファイルとして定義されたクラスの```namespace```を，```use```で指定することによって，そのクラスのみを読み込める．非クラスを読み込むことはできない．動的な値は持たず，静的に読み込むことに注意．ただし，チームの各エンジニアが好きな物を読み込んでいたら，スパゲッティコードになりかねない．そこで，チームでの開発では，記述ルールを設けて，```use```で読み込んで良いものを決めておくと良い．

#### ・外部ファイルのクラスからメソッドをコール

```use```文で```namespace```を指定して，外部ファイルのクラスを読み込める．

**＊実装例＊**

```PHP
<?php
  
// 名前空間を定義．
namespace Domain\Entity;

class Example1
{
    // 定数を定義．
    const VALUE = "これは定数です．";
  
    public function className()
    {
        return "example1メソッドです．";
    }
}
```

```PHP
<?php

namespace Domain\Entity;

// namespaceを指定して，外部ファイルのクラスを読み込む．
use Domain\Entity\Example1;

class Example2
{
    public function method()
    {
        $e1 = new Example1:
        $e1->className();
    }
}
```

#### ・外部ファイルのクラスから定数をコール

**＊実装例＊**

```PHP
<?php

namespace Domain\Entity;

// namespaceを指定して，外部ファイルのクラスを読み込む．
use Domain\Entity1\Example1;

class Example2
{
    public function method()
    {    
        // Example1クラスの定数を出力．
        echo Example1::VALUE;
    }
}
```

<br>

## 05. クラス間，インスタンス間，クラス／インスタンス間の関係性

###  Dependency（依存）

#### ・Dependencyとは

クラス間，インスタンス間，クラス／インスタンス間について，依存される側が変更された場合に，依存する側で変更が起きる関係性は，『依存』である．Association，Aggregation，Compositionの関係性と，さらにデータをクラス／インスタンス内に保持しない以下の場合も含む．

![クラス間，インスタンス間，クラスインスタンス間の関係性のクラス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/クラス間，インスタンス間，クラスインスタンス間の関係性のクラス図.png)

#### ・クラス間の場合

Generalizatoin，Realizationの関係性．

#### ・インスタンス間の場合

この場合，依存する側をクライアント，依存される側をサプライヤーという．クライアント側はサプライヤー側をデータとして保持する．Association，Aggregation，Compositionの関係性．

#### ・クラス／インスタンス間の場合

この場合，依存する側をクライアント，依存される側をサプライヤーという．クライアント側はサプライヤー側をデータとして保持しない．サプライヤー側を読みこみ，メソッドの処理の中で，『一時的に』サプライヤー側のインスタンスを使用するような関係性．例えば，Controllerのメソッドが，ServiceやValidatorのインスタンスを使用する場合がある．

参照リンク：

https://stackoverflow.com/questions/1230889/difference-between-association-and-dependency

https://stackoverflow.com/questions/41765798/difference-between-aggregation-and-dependency-injection

### 結合度

#### ・結合度とは

依存には，引数の渡し方によって，程度がある．それによって，処理を，どのクラスのデータと操作に振り分けていくかが決まる．結合度はモジュール間の依存度合いについて用いられる用語であるが，より理解しやすくするために，特にクラスを用いて説明する．

#### ・データ結合とは

最も理想的な結合．スカラ型のデータをサプライヤー側として，クライアント側のインスタンスの引数として渡すような関係．

**＊実装例＊**

ModuleAとModuleBは，データ結合の関係にある．

```PHP
<?php
class ModuleA // コールされる側
{
    public function methodA(int $a, int $b, string $c)
    {
        return "$a + $b".$c;
    }
}
```

```PHP
<?php
class ModuleB // コールする側
{
    public function methodB()
    {
        $moduleA= new ModuleA();
        $result = $moduleA->methodA(1, 2, "です."); // スカラ型データを渡すだけ
    }
}
```

**＊実装例＊**

デザインパターンのFactoryクラスでは，スカラ型データの値に応じて，インスタンスを作り分ける．Factoryクラスのインスタンスと，これをコールする他インスタンス は，データ結合の関係にある．

```PHP
<?php
/**
 * コールされる側
 *
 * 距離に応じて，移動手段のオブジェクトを作り分けるファクトリクラス
 */
class TransportationMethodsFactory
{
    public static function createInstance($distance)
    {
        $walking = new Walking($distance);
        $car = new Car($distance);
        
        if($walking->needsWalking()) {
            return $walking;
        }
        
        return $car;
    }
}
```

#### ・スタンプ結合とは

object型のデータをサプライヤー側として，クライアント側のインスタンスの引数として渡す関係．

**＊実装例＊**

ModuleAとModuleBは，スタンプ結合の関係にある．

```PHP
<?php
class Common
{
    private $value;
  
    public function __construct(int $value) 
    {
        $this->value = $value;
    }
  
  
    public function getValue()
    {
        return $this->value;
    }
}
```

```PHP
<?php
class ModuleA
{
    public function methodA()
    {
        $common = new Common(1);
        
        $moduleB = new ModuleB;
        
        return $moduleB->methodB($common); // 1
    }
}
```

```PHP
<?php
class ModuleB
{
    public function methodB(Common $common)
    {
        return $common->getValue(); // 1
    }
}
```

<br>

### 凝集度

#### ・凝集度とは

凝集度は，「モジュール内の責務の統一度合い」について用いられる用語であるが，より理解しやすくするために，特にクラスを用いて説明する．

#### ・機能的強度とは

最も理想的な凝集．クラスの責務が機能単位になるように，ロジックを振り分ける．

<br>

### 低結合と高凝集

各モジュールは，結合度が低く，凝集度が高いほどよい．例として，以下の画像では，道具モジュールを，キッチン引き出しモジュールとガレージ工具箱モジュールに分け，各クラスの結合度を低く，凝集度を高くするように対応している・

![低結合度高凝集度](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/低結合度高凝集度.png)

<br>

### Dependency Injection（サプライヤーの注入）

サプライヤー側の『インスタンス』を，クライアント側のインスタンスの外部から注入する実装方法．

#### ・Setter Injectionとは


メソッドの特に，セッターの引数から，サプライヤー側のインスタンスを注入する方法．サプライヤー側をデータとして保持させ，Aggregationの関係性を作ることができる．

#### ・Constructor Injectionとは

メソッドの特に，```__construct```メソッド の引数から，サプライヤー側のインスタンスを注入する方法．サプライヤー側をデータとして保持させ，Aggregationの関係性を作ることができる．

#### ・Method Injectionとは

上記二つ以外のメソッドの引数から，サプライヤー側のインスタンスを注入する方法．サプライヤー側をデータとして保持せず，読み込んでメソッドを使用する．



### DI Container（依存性注入コンテナ），Service Container

#### ・DI Container（依存性注入コンテナ），Service Containerとは

クラス名を登録（バインド）しただけで新しいインスタンスを生成（リゾルブ）してくれるオブジェクトを『ServiceContainer』という．

**＊実装例＊**

Pimpleライブラリを使用した場合

```PHP
<?php
use Pimple\Container;

use XxxLogger;
use YyyNotification;

class Container
{
    public function __construct()
    {
        $container['xxx.logger'] = function ($container) {
            return new XxxLogger();
        };
        
        $container['yyy.notification'] = function ($container) {
            return new YyyNotification();
        };
        
        $container['sample'] = function ($container) {
            return new Sample($container['xxx.logger'], $container['yyy.notification']);
        };
    }
}
```

```PHP
<?php
// autoload.php で，DIコンテナ自体のインスタンスを事前に生成．
$container = new Container();
```

```PHP
<?php
// DIコンテナの読み込み
require_once __DIR__ . '/autoload.php';

// クラス名を宣言してインスタンスを生成．
$sample = $container['sample'];
```

#### ・アンチパターンのService Locater Pattern

インスタンスへのコンテナ渡しのファイルを実装せず，コンテナ自体を注入していまう誤った実装方法．

**＊実装例＊**

```PHP
<?php
class Sample
{
    public function __construct($container)
    {
        $this->logger            = $container['xxx.logger'];
        $this->notification      = $container['yyy.notification'];
    }
}
```
```PHP
<?php
// DIコンテナ自体をインジェクションしてしまうと，不要なインスタンスにも依存してしまう．
$sample = new Sample($container);
```

<br>

## 05-02. Dependency Inversion Principle（依存性逆転の原則）

### DIPとは

#### ・原則1

上位レイヤーは，下位レイヤーに依存してはならない．どちらのレイヤーも『抽象』に依存すべきである．

#### ・原則2

『抽象』は実装の詳細に依存してはならない．実装の詳細が「抽象」に依存すべきである．

<br>

### DIPに基づかない設計 vs. 基づく設計

#### ・DIPに基づかない設計の場合（従来）

より上位レイヤーのコール処理を配置し，より下位レイヤーでコールされる側の定義を行う．これによって，上位レイヤーのクラスが，下位レイヤーのクラスに依存する関係性になる．

![DIPに基づかない設計の場合](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DIPに基づかない設計の場合.png)

#### ・DIPに基づく設計の場合

抽象クラス（またはインターフェース）で抽象メソッドを記述することによって，実装クラスでの実装が強制される．つまり，実装クラスは抽象クラスに依存している．より上位レイヤーに抽象クラス（またはインターフェース）を配置することによって，下位レイヤーのクラスが上位レイヤーのクラスに依存しているような逆転関係を作ることができる．

![DIPに基づく設計の場合](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DIPに基づく設計の場合.png)

#### ・DIPに基づくドメイン駆動設計の場合

1. Repositoryの抽象クラスを，より上位のドメイン層に配置する．
2. Repositoryの実装クラスを，より下位のInfrastructure層に配置する．
3. 両方のクラスに対して，バインディング（関連付け）を行い，抽象クラスをコールした時に，実際には実装クラスがコールされるようにする．
4. これらにより，依存性が逆転する．依存性逆転の原則に基づくことによって，ドメイン層への影響なく，Repositoryの交換が可能になる．

![ドメイン駆動設計_逆転依存性の原則](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ドメイン駆動設計_依存性逆転の原則.jpg)

![トレイト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/トレイト.png)
