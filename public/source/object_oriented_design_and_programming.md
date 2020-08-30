# オブジェクト指向設計／プログラミング

## 01. オブジェクト指向設計

### オブジェクト指向設計に用いられるUMLダイアグラム

![UML-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/UML-1.png)



### オブジェクト指向設計での作業例

#### 1. クラス図とシーケンス図の作成

オブジェクト指向分析で作られたダイアグラム図を基に，クラス図を作る．また，システムシーケンス図を基に，シーケンス図を作成する．

#### 2. デザインパターンの導入

クラス図に，デザインパターンを基にしたクラスを導入する．

#### 3. フレームワークのコンポーネントの導入

クラス図に，フレームワークのコンポーネントを導入する．



## 01-02. クラス図による設計

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



### クラスの多重度

#### ・多重度とは

クラスと別のクラスが，何個と何個で関係しているかを表記する方法．

**【具体例】**

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

**【具定例】**

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



## 01-03. シーケンス図による設計

### シーケンス図

#### ・設計例1

1. 5つのライフライン（店員オブジェクト，管理画面オブジェクト，検索画面オブジェクト，商品DBオブジェクト，商品詳細画面オブジェクト）を設定する．
2. 各ライフラインで実行される実行仕様間の命令内容を，メッセージや複合フラグメントで示す．

![シーケンス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/シーケンス図.png)

#### ・設計例2

1. 3つのライフラインを設定する．
2. 各ライフラインで実行される実行仕様間の命令内容を，メッセージや複合フラグメントで示す．

![シーケンス図_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/シーケンス図_2.png)



## 02. インスタンス間の関係性

『Association ＞ Aggregation ＞ Composition』の順で，依存性が低くなる．

![インスタンス間の関係性のクラス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インスタンス間の関係性のクラス図.png)



### Association（関連）

#### ・Associationとは

関係性の種類と問わず，インスタンスを他インスタンスのデータとして保持する関係性は，『関連』である．



### Aggregation（集約）

#### ・Aggregationとは

インスタンスを他インスタンスの```__construct()```の引数として渡し，データとして保持する関係性は，『集約』である．

【Tireクラス】

```PHP
<?php
class Tire {}
```

【CarXクラス】

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

【CarYクラス】

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



### Composition（合成）

#### ・Compositionとは

インスタンスを，他インスタンスの```__constructor```の引数として渡すのではなく，クラスの中でインスタンス化し，データとして保持する関係性は，『合成』である．

【Lockクラス】

```PHP
<?php
//Lockクラス定義
class Lock {}
```

【Carクラス】

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



## 02-02. クラス間の関係性

![クラス間の関係性のクラス図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/クラス間の関係性のクラス図.png)

### Generalization（汎化）

#### ・汎化におけるOverride

汎化の時，子クラスでメソッドの処理内容を再び実装すると，処理内容は上書きされる．

【親クラス】

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

【子クラス】

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

  **【具体例1】**

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

**【実装例】**

```PHP
<?php
// 抽象クラス．型として提供したいものを定義する．
abstract class ShainManagement
{
    // 定数の定義
    const TIME_TO_ARRIVE = strtotime('10:00:00');
    const TIME_TO_LEAVE = strtotime('19:00:00');
    

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
    
    
    // 抽象メソッド．
    // 処理内容を子クラスでOverrideしなければならない．
    abstract function toWork();
    
    
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

**【具体例2】**

プリウスと各世代プリウスが，抽象クラスと子クラスの関係にある．

![抽象クラス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/抽象クラス.png)



### Realization（実現）

#### ・Realizationとは

実装クラスが正常に機能するために最低限必要なメソッドの実装を強制する．これによって，必ず実装クラスを正常に働かせることができる．

**【具体例】**

オープンソースのライブラリは，ユーザが実装クラスを自身で追加実装することも考慮して，Realizationが用いられている．

**【具体例】**

各車は，モーター機能を必ず持っていなければ，正常に働くことができない．そこで，モータ機能に最低限必要なメソッドの実装を強制する．

![インターフェースとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インターフェースとは.png)

実装クラスに処理内容を記述しなければならない．すなわち，抽象クラスにメソッドの型のみ定義した場合と同じである．多重継承できる．

![子インターフェースの多重継承_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/子インターフェースの多重継承_2.png)

**【実装例】**

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

**【具体例】**

1. 種々の車クラスの共通処理のをもつ抽象クラスとして，Carクラスを作成．
2. 各車は，エンジン機能を必ず持っていなければ，正常に働くことができない．そこで，抽象メソッドによって，エンジン機能に最低限必要なメソッドの実装を強制する．

![インターフェースと抽象クラスの使い分け](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インターフェースと抽象クラスの使い分け.png)



## 02-03. クラス間，インスタンス間，クラス／インスタンス間の関係性

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

**【実装例1】**

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

**【実装例2】**

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

**【実装例】**

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



### 凝集度

#### ・凝集度とは

凝集度は，「モジュール内の責務の統一度合い」について用いられる用語であるが，より理解しやすくするために，特にクラスを用いて説明する．

#### ・機能的強度とは

最も理想的な凝集．クラスの責務が機能単位になるように，ロジックを振り分ける．



### 低結合と高凝集

各モジュールは，結合度が低く，凝集度が高いほどよい．例として，以下の画像では，道具モジュールを，キッチン引き出しモジュールとガレージ工具箱モジュールに分け，各クラスの結合度を低く，凝集度を高くするように対応している・

![低結合度高凝集度](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/低結合度高凝集度.png)



### Dependency Injection（サプライヤーの注入）

サプライヤー側の『インスタンス』を，クライアント側のインスタンスの外部から注入する実装方法．

#### ・Setter Injectionとは


メソッドの特に，セッターの引数から，サプライヤー側のインスタンスを注入する方法．サプライヤー側をデータとして保持させ，Aggregationの関係性を作ることができる．

#### ・Constructor Injectionとは

メソッドの特に，```__construct()``` の引数から，サプライヤー側のインスタンスを注入する方法．サプライヤー側をデータとして保持させ，Aggregationの関係性を作ることができる．

#### ・Method Injectionとは

上記二つ以外のメソッドの引数から，サプライヤー側のインスタンスを注入する方法．サプライヤー側をデータとして保持せず，読み込んでメソッドを使用する．



### DI Container（依存性注入コンテナ），Service Container

#### ・DI Container（依存性注入コンテナ），Service Containerとは

サービスコンテナともいう．名前を宣言しただけで新しいインスタンスを提供してくれるインスタンス生成専用クラスのこと．

**【実装例】**

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

// クラス名を宣言．
$sample = $container['sample'];
```

#### ・アンチパターンのService Locater Pattern

インスタンスへのコンテナ渡しのファイルを実装せず，コンテナ自体を注入していまう誤った実装方法．

**【実装例】**

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



## 02-04. Dependency Inversion Principle（依存性逆転の原則）

### DIPとは

#### ・原則1

上位レイヤーは，下位レイヤーに依存してはならない．どちらのレイヤーも『抽象』に依存すべきである．

#### ・原則2

『抽象』は実装の詳細に依存してはならない．実装の詳細が「抽象」に依存すべきである．



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




## 02-05. クラスの継承

### クラスチェーンによる継承元の参照

クラスからデータやメソッドをコールした時，そのクラスにこれらが存在しなければ，継承元まで参照しにいく仕組みを『クラスチェーン』という．プロトタイプベースのオブジェクト指向で用いられるプロトタイプチェーンについては，別ノートを参照せよ．

**【実装例】**

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
    public subValue;
  
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



### 継承元の静的メソッドを参照

**【実装例】**

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



## 02-06. 外部クラスとメソッドの読み込み

### ```use```によるクラスとメソッドの読み込み

PHPでは，```use```によって，外部ファイルの名前空間，クラス，メソッド，定数を読み込める．ただし，動的な値は持たず，静的に読み込むことに注意．しかし，チームの各エンジニアが好きな物を読み込んでいたら，スパゲッティコードになりかねない．そこで，チームでの開発では，記述ルールを設けて，```use```で読み込んで良いものを決めておくと良い．

**【以下で読み込まれるクラスの実装例】**

```PHP
<?php
// 名前空間を定義．
namespace Domain/Entity1;

// 定数を定義．
const VALUE = "これは定数です．";

class Example1
{
    public function className()
    {
        return "example1メソッドです．";
    }
}
```

#### ・名前空間の読み込み

```PHP
<?php
// use文で名前空間を読み込む．
use Domain/Entity2;

namespace Domain/Entity2;

class Example2
{
    public function method()
    {

        // 名前空間を読み込み，クラスまで辿り，インスタンス作成．
        $e1 = new Entity1/E1:
        echo $e1;
    }
}
```

#### ・クラスの読み込み

```PHP
<?php
// use文でクラス名を読み込む．
use Domain/Entity1/Example1;

namespace Domain/Entity2;

class Example2
{
    public function method()
    {
        // 名前空間を読み込み，クラスまで辿り，インスタンス作成．
        $e1 = new E1;
        echo $e1;
    }
}
```

#### ・メソッドの読み込み

```PHP
<?php
// use文でメソッドを読み込む．
use Domain/Entity1/Example1;

namespace Domain/Entity2;

class Eeample2
{
    public function method()
    {
        // Example1クラスのclassName()をコール．
        echo className();
    }
}
```

#### ・定数の読み込み

```PHP
<?php
// use文で定数を読み込む．
use Domain/Entity1/Example1;

namespace Domain/Entity2;

class Example2
{
    // Example1クラスの定数を出力．
    public function method()
    {    
        echo Example1::VALUE;
    }
}
```



## 02-07. 入れ子クラス

### PHPの場合

PHPには組み込まれていない．



### Javaの場合

クラスの中にクラスをカプセル化する機能．データやメソッドと同じ記法で，内部クラスでは，外部クラスのメンバを呼び出すことができる．

#### ・非静的内部クラス

PHPとは異なり，変数定義に『$』は用いないことに注意．

**【実装例】**

```java
// 外部クラスを定義
class OuterClass
{
    private int value;
        
    // Setterとして，コンストラクタを使用．
    OuterClass(Int value)
    {
        this.value = value;
    }
    
    // 外部クラスのデータを取得するメソッド．
    public int value()
    {
        return this.value;
    }
    
    
    // 内部クラスを定義 
    class InnerClass
    {
        // 外部クラスのデータを取得して2倍するメソッド．
        public int valueTimesTwo()
        {
            return OuterClass.this.value*2;
        }
    
    }
        
    // 内部クラスをインスタンス化するメソッド．
    public InnerClass InnerClassInstance()
    {
        // 外部クラスのインスタンス化 
        OuterClass outerCLS = new OuterClass();
        
        // 外部クラスのインスタンス内から内部クラスを呼び出し，データ型を内部クラス型に指定．
        OuterClass.InnerClass innerCLS = new outerCLS.InnerClass;
    }
}
```

#### ・静的内部クラス

呼び出すメソッドと呼び出されるメンバの両方をstaticとしなければならない．

**【実装例】**

```java
// 外部クラスを定義
class OuterClass
{
    // 静的データとする．
    private int value;
        
    // Setterとして，コンストラクタを使用．
    OuterClass(Int value)
    {
        this.value = value;
    }
    
    // 静的内部クラスを定義 
    static class InnerClass
    {
        // 外部クラスのデータを取得するメソッド．
        public int value()
        {
            return OuterClass.this.value;
        }
    
    }
        
    // 内部クラスをインスタンス化する静的メソッド．
    public static InnerClass InnerClassInstance()
    {
        // 外部クラスのインスタンス化 
        OuterClass outerCLS = new OuterClass();
        
        // 外部クラスのインスタンス内から内部クラスを呼び出し，データ型を内部クラス型に指定．
        OuterClass.InnerClass innerCLS = new outerCLS.InnerClass;
    }
}
```



## 02-08. 総称型

### PHPの場合

PHPには組み込まれていない．



### Javaの場合

オブジェクトにデータ型を引数として渡すことで，データの型宣言を行える機能．型宣言を毎回行わなければならず，煩わしいJavaならではの機能．PHPとは異なり，変数定義に『$』は用いないことに注意．

**【実装例】**

```java
class Example<T>{
    
    private T t;
    
    public Example(T t)
    {
        this.t = t;
    }
    
    public T getT()
    {
        return t;
    }
}
```

#### ・総称型を用いない場合

リスト内の要素は，Object型として取り出されるため，キャスト（明示的型変換）が必要．

**【実装例】**

```java
List list = new ArrayList();
l.add("Java");
l.add("Scala");
l.add("Ruby");

// 文字列へのキャストが必要
String str = (String)list.get(0);
```

#### ・総称型を用いる場合

**【実装例】**

```java
List<String> list = new ArrayList<String>();
list.add("Java");
list.add("Scala");
list.add("Ruby");
String str = list.get(0);
</string></string>

List<String> list = new ArrayList<String>();
list.add(10.1);    // String型でないのでコンパイルエラー
</string></string>
```



## 02-09. Trait

### PHPの場合

再利用したいメソッドやデータを部品化し，利用したい時にクラスに取り込む．Traitを用いるときは，クラス内でTraitをuse宣言する．Trait自体は不完全なクラスであり，インスタンス化できない．

![トレイト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/トレイト.png)

### Javaの場合

Javaには組み込まれていない．



## 03. 操作（メソッド）とデータ（プロパティ）

本資料の以降では，大きく，操作（メソッド）とデータ（プロパティ）に分けて，説明していく．

### 操作（メソッド）

クラスは，データを操作する．この操作はメソッドとも呼ばれる．



### データ（プロパティ）

クラスは，データをもつ．このデータはプロパティとも呼ばれる．




## 03-02. メソッドとデータのカプセル化

### ```public```

どのオブジェクトでも呼び出せる．



### ```protected```

同じクラス内と，その子クラス，その親クラスでのみ呼び出せる．

https://qiita.com/miyapei/items/6c43e8b38317afb5fdce



### ```private```

同じオブジェクト内でのみ呼び出せる．

#### ・Encapsulation（カプセル化）

カプセル化とは，システムの実装方法を外部から隠すこと．オブジェクト内のデータにアクセスするには，直接データを扱う事はできず，オブジェクト内のメソッドをコールし，アクセスしなければならない．

![カプセル化](https://user-images.githubusercontent.com/42175286/59212717-160def00-8bee-11e9-856c-fae97786ae6c.gif)

### ```static```

別ファイルでのメソッドの呼び出しにはインスタンス化が必要である．しかし，static修飾子をつけることで，インスタンス化しなくともコールできる．データ値は用いず（静的），引数の値のみを用いて処理を行うメソッドに対して用いる．

**【実装例】**

```PHP
<?php
// インスタンスを作成する集約メソッドは，データ値にアクセスしないため，常に同一の処理を行う．
public static function aggregateDogToyEntity(array $fetchedData)
{
    return new DogToyEntity
    (
        new ColorVO($fetchedData['dog_toy_type']),
        $fetchedData['dog_toy_name'],
        $fetchedData['number'],
        new PriceVO($fetchedData['dog_toy_price']),
        new ColorVO($fetchedData['color_value'])
    );
}
```

**【実装例】**

```PHP
<?php
// 受け取ったOrderエンティティから値を取り出すだけで，データ値は呼び出していない．
public static function computeExampleFee(Entity $order): Money
{
    $money = new Money($order->exampleFee);
    return $money;
}
```



## 04. メソッド

### 値を取得するアクセサメソッドの実装

#### ・Getter

Getterでは，データを取得するだけではなく，何かしらの処理を加えたうえで取得すること．

**【実装例】**

```PHP
<?php
class ABC {

    private $property; 

    public function getEditProperty()
    {
        // 単なるGetterではなく，例外処理も加える．
        if(!isset($this->property)){
            throw new ErrorException('データに値がセットされていません．');
        }
        return $this->property;
    }

}
```



### 値を設定するアクセサメソッドの実装

#### ・Setter

『Mutable』なオブジェクトを実現できる．

**【実装例】**

```PHP
<?php
class Test01 {

    private $property01;

    // Setterで$property01に値を設定
    public function setProperty($property01)
    {
        $this->property01 = $property01;
    }
    
}    
```

#### ・マジックメソッドの```__construct()```

マジックメソッドの```__construct()```を持たせることで，このデータを持っていなければならないとい制約を明示することがでできる．Setterを持たせずに，```__construct()```だけを持たせれば，ValueObjectのような，『Immutable』なオブジェクトを実現できる．

**【実装例】**

```PHP
<?php
class Test02 {

    private $property02;

    // コンストラクタで$property02に値を設定
    public function __construct($property02)
    {
        $this->property02 = $property02;
    }
    
}
```

#### ・『Mutable』と『Immutable』を実現できる理由

Test01クラスインスタンスの```$property01```に値を設定するためには，インスタンスからSetterをコールする．Setterは何度でも呼び出せ，その度にデータの値を上書きできる．

```PHP
<?php
$test01 = new Test01;

$test01->setProperty01("データ01の値");

$test01->setProperty01("新しいデータ01の値");
```

一方で，Test02クラスインスタンスの```$property02```に値を設定するためには，インスタンスを作り直さなければならない．つまり，以前に作ったインスタンスの```$property02```の値は上書きできない．Setterを持たせずに，```__construct()```だけを持たせれば，『Immutable』なクラスとなる．

```PHP
<?php
$test02 = new Test02("データ02の値");

$test02 = new Test02("新しいデータ02の値");
```

Entityは，Mutableであるため，Setterと```__construct()```の両方を持つことができる．ValueObjectは，Immutableのため，```__construct()```しか持つことができない．



### マジックメソッド（Getter系）

オブジェクトに対して特定の操作が行われた時に自動的にコールされる特殊なメソッドのこと．自動的に呼び出される仕組みは謎．共通の処理を行うGetter（例えば，値を取得するだけのGetterなど）を無闇に増やしたくない場合に用いることで，コード量の肥大化を防ぐことができる．PHPには最初からマジックメソッドは組み込まれているが，自身で実装した場合，オーバーライドされてコールされる．

#### ・```__get()```

定義されていないデータや，アクセス権のないデータを取得しようとした時に，代わりに呼び出される．メソッドは定義しているが，データは定義していないような状況で用いる．

**【実装例】**

```PHP
<?php
class Example
{

    private $example = [];
    
    // 引数と返却値のデータ型を指定
    public function __get(string $name): string
    {
        echo "{$name}データは存在しないため，データ値を取得できません．";
    }

}
```

```PHP
<?php
// 存在しないデータを取得．
$example = new Example();
$example->hoge;

// 結果
// hogeデータは存在しないため，値を呼び出せません．
```

#### ・```__call()```

定義されていないメソッドや，アクセス権のないメソッドを取得しようとした時に，代わりにコールされる．データは定義しているが，メソッドは定義していないような状況で用いる．

#### ・```__callStatic()```



### マジックメソッド（Setter系）

定義されていないstaticメソッドや，アクセス権のないstaticメソッドを取得しようとした時に，代わりに呼び出される．自動的にコールされる仕組みは謎．共通の処理を行うSetter（例えば，値を設定するだけのSetterなど）を無闇に増やしたくない場合に用いることで，コード量の肥大化を防ぐことができる．PHPには最初からマジックメソッドは組み込まれているが，自身で実装した場合，オーバーライドされて呼び出される．

#### ・```__set()```

定義されていないデータや，アクセス権のないデータに値を設定しようとした時に，代わりにコールされる．オブジェクトの不変性を実現するために使用される．（詳しくは，ドメイン駆動設計のノートを参照せよ）

**【実装例】**

```PHP
<?php
class Example
{

    private $example = [];
    
    // 引数と返り値のデータ型を指定
    public function __set(String $name, String $value): String
    {
        echo "{$name}データは存在しないため，{$value}を設定できません．";
    }

}
```

```PHP
<?php
// 存在しないデータに値をセット．
$example = new Example();
$example->hoge = "HOGE";

// 結果
// hogeデータは存在しないため，HOGEを設定できません．
```

#### ・マジックメソッドの```__construct()```

インスタンス化時に自動的に呼び出されるメソッド．インスタンス化時に実行したい処理を記述できる．Setterを持たせずに，```__construct()```でのみ値の設定を行えば，ValueObjectのような，『Immutable』なオブジェクトを実現できる．

**【実装例】**

```PHP
<?php
class Test02 {

    private $property02;

    // コンストラクタで$property02に値を設定
    public function __construct($property02)
    {
        $this->property02 = $property02;
    }
    
}
```

#### ・『Mutable』と『Immutable』を実現できる理由】

Test01クラスインスタンスの```$property01```に値を設定するためには，インスタンスからSetterをコールする．Setterは何度でもコールでき，その度にデータの値を上書きできる．

```PHP
<?php
$test01 = new Test01;

$test01->setProperty01("データ01の値");

$test01->setProperty01("新しいデータ01の値");
```

一方で，Test02クラスインスタンスの```$property02```に値を設定するためには，インスタンスを作り直さなければならない．つまり，以前に作ったインスタンスの```$property02```の値は上書きできない．Setterを持たせずに，```__construct()```だけを持たせれば，『Immutable』なオブジェクトとなる．

```PHP
<?php
$test02 = new Test02("データ02の値");

$test02 = new Test02("新しいデータ02の値");
```



### マジックメソッド（その他）

#### ・```__invoke()```

#### ・```__clone()```



### インスタンスの生成メソッド

#### ・```new static()``` と ```new self()```の違い

どちらも，自身のインスタンスを返却するメソッドであるが，生成の対象になるクラスが異なる．

```PHP
<?php
class A
{
    public static function get_self()
    {
        return new self();
    }

    public static function get_static()
    {
        return new static();
    }
}
```

```PHP
<?php
class B extends A {}
```

以下の通り，```new self()```は定義されたクラスをインスタンス化する．一方で，```new static()```はコールされたクラスをインスタンス化する．自身のインスタンス化処理が継承される場合は，```new static```を用いた方が良い．

```PHP
<?php
echo get_class(B::get_self());   // 継承元のクラスA

echo get_class(B::get_static()); // 継承先のクラスB

echo get_class(A::get_static()); // 継承元のクラスA
```



### メソッドのコール

#### ・メソッドチェーン

以下のような，オブジェクトAを最外層とした関係が存在しているとする．

【オブジェクトA（オブジェクトBをデータに持つ）】

```PHP
<?php
class Obj_A{
    private $objB;
    
    // 返却値のデータ型を指定
    public function getObjB(): ObjB
    {
        return $this->objB;
    }
}
```

【オブジェクトB（オブジェクトCをデータに持つ）】

```PHP
<?php
class Obj_B{
    private $objC;
 
    // 返却値のデータ型を指定
    public function getObjC(): ObjC
    {
        return $this->objC;
    }
}
```

【オブジェクトC（オブジェクトDをデータに持つ）】

```PHP
<?php
class Obj_C{
    private $objD;
 
    // 返却値のデータ型を指定
    public function getObjD(): ObjD
    {
        return $this->objD;
    }
}
```

以下のように，返却値のオブジェクトを用いて，より深い層に連続してアクセスしていく場合…

```PHP
<?php
$ObjA = new Obj_A;

$ObjB = $ObjA->getObjB();

$ObjC = $ObjB->getObjB();

$ObjD = $ObjC->getObjD();
```

以下のように，メソッドチェーンという書き方が可能．

```PHP
<?php
$D = getObjB()->getObjC()->getObjC();

// $D には ObjD が格納されている．
```

#### ・Recursive call：再帰的プログラム

自プログラムから自身自身をコールし，実行できるプログラムのこと．

**【具体例】**

ある関数 ``` f  ```の定義の中に ``` f ```自身を呼び出している箇所がある．

![再帰的](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/再帰的.png)

**【実装例】**

クイックソートのアルゴリズム（※詳しくは，別ノートを参照）

1. 適当な値を基準値（Pivot）とする （※できれば中央値が望ましい）
2. Pivotより小さい数を前方，大きい数を後方に分割する．
3. 二分割された各々のデータを，それぞれソートする．
4. ソートを繰り返し実行する．

**【実装例】**

```PHP
<?php
function quickSort(array $array): array 
{
    // 配列の要素数が一つしかない場合，クイックソートする必要がないので，返却する．
    if (count($array) <= 1) {
        return $array;
    }

    // 一番最初の値をPivotとする．
    $pivot = array_shift($array); 

    // グループを定義
    $left = $right = [];

    foreach ($array as $value) {

        if ($value < $pivot) {
        
            // Pivotより小さい数は左グループに格納
            $left[] = $value;
        
        } else {
        
            // Pivotより大きい数は右グループに格納
            $right[] = $value;
            
            }

    }

    // 処理の周回ごとに，結果の配列を結合．
    return array_merge
    (
        // 左のグループを再帰的にクイックソート．
        quickSort($left),
        
        // Pivotを結果に組み込む．
        array($pivot),
        
        // 左のグループを再帰的にクイックソート．
        quickSort($right)
    );

}
```

```PHP
<?php
// 実際に使ってみる．
$array = array(6, 4, 3, 7, 8, 5, 2, 9, 1);
$result = quickSort($array);
var_dump($result); 

// 昇順に並び替えられている．
// 1, 2, 3, 4, 5, 6, 7, 8 
```



### 引数

#### ・オプション引数

引数が与えられなければ，指定の値を渡す方法



### 値を返却する前の途中終了

#### ・```return;```


```PHP
<?php
function returnMethod()
{
    print "returnMethod()です。\n";
    return; // 何も返さない．
}
```

```PHP
<?php
returnMethod(); // returnMethod()です。
// 処理は続く．
```


#### ・```exit;```

```PHP
<?php
function exitMethod()
{
    print "exitMethod()です。\n";
    exit;
}
```

```PHP
<?php
exitMethod(); // exitMethod()です。
// ここで，システム全体の処理が終了する．
```



### 値の返却

#### ・```return```

メソッドがコールされた場所に値を返却した後，その処理が終わる．

#### ・```yield```

メソッドがコールされた場所に値を返却した後，そこで終わらず，```yield```の次の処理が続く．返却値は，array型である．

**【実装例】**

```PHP
<?php
function getOneToThree(): array
{
    for ($i = 1; $i <= 3; $i++) {
        // yield を返却した後、$i の値が維持される．
        yield $i;
    }
}
```

```PHP
<?php
$oneToThree = getOneToThree();

foreach ($oneToThree as $value) {
    echo "{$value}\n";
}

// 1
// 2
// 3
```



### Dispatcher

#### ・Dispatcherとは

特定の文字列によって，動的にメソッドをコールするオブジェクトをDispatcherという．

```PHP
<?php
$dispatcher = new Dispatcher;

// 文字列とメソッドの登録.
$dispatcher->addListener(string $name, callable $listener)

// 文字列からメソッドをコール.
$dispatcher->dispatch(string $name, $param)
```

#### ・イベント名に紐づくメソッドをコールするオブジェクト

イベント名を文字列で定義し，特定のイベント名が渡された時に，それに対応づけられた関数をコールする．フレームワークの```EventDispatcher```を使用するのがよい

**【実装例】**

```PHP
<?php
use Symfony\Component\EventDispatcher\EventDispatcher;

class ExampleEventDispatcher
{
   // 詳しくは，フレームワークのノートを参照． 
}
```

#### ・計算処理の返却値を保持するオブジェクト

大量のデータを集計するは，その処理に時間がかかる．そこで，そのようなメソッドでは，一度コールされて集計を行った後，データに返却値を保持しておく．そして，再びコールされた時には，返却値をデータから取り出す．

**【実装例】**

```PHP
<?php
class ResultCacher
{
    private $resultCollection;
    
    private $funcCollection;
    
    public function __construct()
    {
        $this->funcCollection = $this->addListener();
    }
  
  
    // 集計メソッド
    public function computeRevenue()
    {
        // 時間のかかる集計処理;
    }

  
    public function funcNameListener(string $funcName)
    {
        // 返却値が設定されていなかった場合，値を設定.
        if (!isset($this->resultCollection[$funcName])) {
            
            // メソッドの返却値をCollectionに設定．
            $this->resultCollection[$funcName] = $this->dispatch($funcName);
        }
        
        // 返却値が設定されていた場合,そのまま使う．
        return $this->resultCollection[$funcName];
    }
  
  
    // 返却値をキャッシュしたいメソッド名を登録しておく．
    private function addListener()
    {
        return [
          "computeRevenue" => [$this, "computeRevenue"]
        ];
    }
  
    
    private function dispatch(string $funcName)
    {
        // call_user_funcでメソッドを実行
        return call_user_func(
          // 登録されているメソッド名から，メソッドをDispatch.
          $this->funcCollection[$funcName]
        );
    }
}
```



## 04-02. 無名関数

特定の処理が，```private```メソッドとして切り分けるほどでもないが，他の部分と明示的に区分けたい時は，無名関数を用いるとよい．

### Closure（無名関数）の定義，変数格納後のコール

#### ・```use()```のみに引数を渡す場合

**【実装例】**

```PHP
<?php
$item = new Item;

// 最初の括弧を用いないことで，普段よくやっている値渡しのメソッドを定義しているのと同じになる．
// use()に，親メソッド（$optionName）のスコープの$itemを渡す．
$optionName = function () use ($item) {
    $item->getOptionName();
};

// function()には引数が設定されていないので，コール時に引数は不要．
echo $optionName;

// 出力結果
// オプションA
```

#### ・```function()```と```use()```に引数を渡す場合

**【実装例】**

```PHP
<?php
$item = new Item;

// 最初の括弧を用いないことで，普段よくやっている値渡しのメソッドを定義しているのと同じになる．
// 親メソッド（$optionName）のスコープの$itemを，use()に渡す．
// $paramは，コール時に使う変数．
$optionName = function ($para) use ($item) {
    $item->getOptionName() . $para;
};

// コール時に，$paramをfunction()に渡す．
echo $optionName("BC");

// 出力結果
// オプションABC
```

#### ・データの値として，無名関数を格納しておく裏技

**【実装例】**

```PHP
<?php
$item = new Item;

// 最初の括弧を用いないことで，普段よくやっている値渡しのメソッドを定義しているのと同じになる．
// use()に，親メソッドのスコープの$itemを渡す．
// $paramは，コール時に使う変数．
$option = new Option;

// データの値に無名関数を格納する．
$option->name = function ($para) use ($item) {
    $item->getOptionName() . $para;
};

// コール時に，$paramをfunction()に渡す．
echo $option->name("BC");

// 出力結果
// オプションABC
```



### Closure（無名関数）の定義と即コール

定義したその場でコールされる無名関数を『即時関数』と呼ぶ．無名関数をコールしたい時は，```call_user_func()```を用いる．

**【実装例】**

```PHP
<?php
$item = new Item;
$param = "BC";

// use()に，親メソッドのスコープの$itemを渡す．
// 無名関数を定義し，同時にcall_user_func()で即コールする．
// $paramは，コール時に使う変数．
$optionName = call_user_func(function ($param) use ($item) {
    $item->getOptionName() . $param;
});

// $paramはすでに即コール時に渡されている．
// これはコールではなく，即コール時に格納された返却値の出力．
echo $optionName;

// 出力結果
// オプションABC
```



### 高階関数とClosure（無名関数）の組み合わせ

関数を引数として受け取ったり，関数自体を返したりする関数を『高階関数』と呼ぶ．

#### ・無名関数を用いない場合

**【実装例】**

```PHP
<?php
// 第一引数のみの場合

// 高階関数を定義
function test($callback)
{
    echo $callback();
}

// コールバックを定義
// 関数の中でコールされるため，「後で呼び出される」という意味合いから，コールバック関数といえる．
function callbackMethod():string
{
    return "出力に成功しました．";
}

// 高階関数の引数として，コールバック関数を渡す
test("callbackMethod");

// 出力結果
// 出力に成功しました．
```

```PHP
<?php
// 第一引数と第二引数の場合

// 高階関数を定義
function higherOrder($param, $callback)
{
    return $callback($param);
}

// コールバック関数を定義
function callbackMethod($param)
{
    return $param."の出力に成功しました．";
}
 
// 高階関数の第一引数にコールバック関数の引数，第二引数にコールバック関数を渡す
higherOrder("第一引数", "callbackMethod");

// 出力結果
// 第一引数の出力に成功しました．
```

#### ・無名関数を用いる場合

**【実装例】**

```PHP
<?php
// 高階関数のように，関数を引数として渡す．
function higherOrder($parentVar, $callback)
{
    $parentVar = "&親メソッドのスコープの変数";
    return $callback($parentVar);
}

// 第二引数の無名関数．関数の中でコールされるため，「後でコールされる」という意味合いから，コールバック関数といえる．
// コールバック関数は再利用されないため，名前をつけずに無名関数とすることが多い．
// 親メソッドのスコープで定義されている変数を引数として渡す．（普段よくやっている値渡しと同じ）
higherOrder($parentVar, function () use ($parentVar) {
    return $parentVar . "の出力に成功しました．";
}
);

// 出力結果
// 親メソッドのスコープの変数の出力に成功しました．
```



### 高階関数を使いこなす！

```PHP
<?php
class Example
{
    
    /**
     * @var array
     */
    protected $properties;

    // 非無名メソッドあるいは無名メソッドを引数で渡す．
    public function Shiborikomi($callback)
    {
        if (!is_callable($callback)) {
            throw new \LogicException;
        }

        // 自身が持つ配列型のデータを加工し，再格納する．
        $properties = [];
        foreach ($this->properties as $property) {

            // 引数の無名関数によって，データに対する加工方法が異なる．
            // 例えば，判定でTRUEのもののみを返すメソッドを渡すと，自データを絞り込むような処理を行える．
            $returned = call_user_func($property, $callback);
            if ($returned) {

                // 再格納．
                $properties[] = $returned;
            }
        }

        // 他のデータは静的に扱ったうえで，自身を返す．
        return new static($properties);
    }
}
```



## 05. PHPにおけるデータ構造の実装方法

ハードウェアが処理を行う時に，データの集合を効率的に扱うためのデータ格納形式をデータ構造という．データ構造のPHPによる実装方法を以下に示す．

### Array型

同じデータ型のデータを並べたデータ格納様式のこと．

#### ・インデックス配列

番号キーごとに値が格納されたArray型のこと．

```
Array
(
    [0] => A
    [1] => B
    [2] => C
)
```

#### ・多次元配列

配列の中に配列をもつArray型のこと．配列の入れ子構造が２段の場合，『二次元配列』と呼ぶ．

```
( 
    [0] => Array
        (
            [0] => リンゴ
            [1] => イチゴ
            [2] => トマト
        )

    [1] => Array
        (
            [0] => メロン
            [1] => キュウリ
            [2] => ピーマン
        )
)
```

#### ・連想配列

キー名（赤，緑，黄，果物，野菜）ごとに値が格納されたArray型のこと．下の例は，二次元配列かつ連想配列である．

```
Array
(
    [赤] => Array
        (
            [果物] => リンゴ
            [果物] => イチゴ
            [野菜] => トマト
        )

    [緑] => Array
        (
            [果物] => メロン
            [野菜] => キュウリ
            [野菜] => ピーマン
        )
)
```

#### ・配列内の要素の走査（スキャン）

配列内の要素を順に調べていくことを『走査（スキャン）』という．例えば，```foreach()```は，配列内の全ての要素を走査する処理である．下図では，連想配列が表現されている．

![配列の走査](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/配列の走査.png)

#### ・内部ポインタを用いた配列要素の出力

『内部ポインタ』とは，配列において，参照したい要素を位置で指定するためのカーソルのこと．

```PHP
<?php
$array = array("あ", "い", "う");

// 内部ポインタが現在指定している要素を出力．
echo current($array); // あ

// 内部ポインタを一つ進め，要素を出力．
echo next($array); // い

// 内部ポインタを一つ戻し，要素を出力．
echo prev($array); // あ

// 内部ポインタを最後まで進め，要素を出力．
echo end($array); // う

// 内部ポインタを最初まで戻し，要素を出力
echo reset($array); // あ
```



### LinkedList型

PHPで用いることはあまりないデータ格納様式．詳しくは，JavaにおけるLinkedList型を参照せよ．

#### ・PHPの```list()```とは何なのか

PHPの```list()```は，List型とは意味合いが異なる．配列の要素一つ一つを変数に格納したい場合，List型を使わなければ，冗長ではあるが，以下のように実装する必要がある．

```PHP
<?php
$array = array("あ", "い", "う");
$a = $array[0];
$i = $array[1];
$u = $array[2];

echo $a.$i.$u; // あいう
```

しかし，以下の様に，```list()```を使うことによって，複数の変数への格納を一行で実装することができる．

```PHP
<?php
list($a, $i, $u) = array("あ", "い", "う");

echo $a.$i.$u; // あいう
```



### Queue型

![Queue1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Queue1.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

 

![Queue2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Queue2.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

 

![Queue3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Queue3.gif)

PHPでは，```array_push()```と```array_shift()```を組み合わせることで実装できる．

```PHP
<?php
$array = array("Blue", "Green");

// 引数を，配列の最後に，要素として追加する．
array_push($array, "Red");
print_r($array);

// 出力結果

//	Array
//	(
//		[0] => Blue
//		[1] => Green
//		[2] => Red
//	)

// 配列の最初の要素を取り出す．
$theFirst= array_shift($array);
print_r($array);

// 出力結果

//	Array
//	(
//    [0] => Green
//    [1] => Red
//	)

// 取り出された値の確認
echo $theFirst; // Blue
```

#### ・メッセージQueue

送信側の好きなタイミングでファイル（メッセージ）をメッセージQueueに追加できる．また，受信側の好きなタイミングでメッセージを取り出すことができる．

![メッセージキュー](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/メッセージキュー.jpg)



### Stack型

PHPでは，```array_push()```と```array_pop()```で実装可能．

![Stack1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Stack1.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

 

![Stack2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Stack2.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

 

![Stack3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Stack3.gif)



### Tree型

#### ・二分探索木

  各ノードにデータが格納されている．

![二分探索木](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/二分探索木1.gif)



#### ・ヒープ

  Priority Queueを実現するときに用いられる．各ノードにデータが格納されている．

![ヒープ1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ヒープ1.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

![ヒープ1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ヒープ2.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

![ヒープ2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ヒープ3.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

![. ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ヒープ4.gif)



## 05-02. Javaにおけるデータ構造の実装方法

データ構造のJavaによる実装方法を以下に示す．

### Array型

#### ・ArrayList

ArrayListクラスによって実装されるArray型．PHPのインデックス配列に相当する．

#### ・HashMap

HashMapクラスによって実装されるArray型．PHPの連想配列に相当する．



### LinkedList型

値をポインタによって順序通り並べたデータ格納形式のこと．

#### ・単方向List

![p555-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p555-1.gif)

#### ・双方向List

![p555-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p555-2.gif)

#### ・循環List

![p555-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p555-3.gif)



### Queue型

### Stack型

### Tree型



## 05-03. データ型

### スカラー型

#### ・int

#### ・float

#### ・string

#### ・boolean

|   T／F    | データの種類 | 説明                     |
| :-------: | ------------ | ------------------------ |
| **FALSE** | ```$var =``` | 何も格納されていない変数 |
|           | ```False```  | 文字としてのFalse        |
|           | ```0```      | 数字、文字列             |
|           | ```""```     | 空文字                   |
|           | array()      | 要素数が0個の配列        |
|           | NULL         | NULL値                   |
| **TRUE**  | 上記以外の値 |                          |



### 複合型


#### ・array

#### ・object

```
Fruit Object
(
    [id:private] => 1
    [name:private] => リンゴ
    [price:private] => 100
)
```



### その他のデータ型

#### ・null

#### ・date

厳密にはデータ型ではないが，便宜上，データ型とする．タイムスタンプとは，協定世界時(UTC)を基準にした1970年1月1日の0時0分0秒からの経過秒数を表したもの．

| フォーマット         | 実装方法            | 備考                                                         |
| -------------------- | ------------------- | ------------------------------------------------------------ |
| 日付                 | 2019-07-07          | 区切り記号なし、ドット、スラッシュなども可能                 |
| 時間                 | 19:07:07            | 区切り記号なし、も可能                                       |
| 日付と時間           | 2019-07-07 19:07:07 | 同上                                                         |
| タイムスタンプ（秒） | 1562494027          | 1970年1月1日の0時0分0秒から2019-07-07 19:07:07 までの経過秒数 |



### キャスト演算子

#### ・```(string)```

```PHP
<?php
$var = 10; // $varはInt型．

// キャスト演算子でデータ型を変換
$var = (string) $var; // $varはString型
```

#### ・```(int)```

```PHP
<?php
// Int型
$var = (int) $var;
```
#### ・```(bool)```
```PHP
<?php
// Boolean型
$var = (bool) $var;
```
#### ・```(float)```
```PHP
<?php
// Float型
$var = (float) $var;
```
#### ・```(array)```
```PHP
<?php
// Array型
$var = (array) $var;
```
#### ・```(object)```
```PHP
<?php
// Object型
$var = (object) $var;
```



## 05-04. 定数

### 定数が役に立つ場面

計算処理では，可読性の観点から，できるだけ数値を直書きしない．数値に意味合いを持たせ，定数として扱うと可読性が高くなる．例えば，ValueObjectにおける定数がある．

```PHP
<?php
class requiredTime
{
    // 判定値，歩行速度の目安，車速度の目安，を定数で定義する．
    const JUDGMENT_MINUTE = 21;
    const WALKING_SPEED_PER_MINUTE = 80;
    const CAR_SPEED_PER_MINUTE = 400;
    
    
    private $distance;
    
    
    public function __construct(int $distance)
    {
        $this->distance = $distance;
    }
    
    
    public function isMinuteByWalking()
    {
        if ($this->distance * 1000 / self::WALKING_SPEED_PER_MINUTE < self::JUDGMENT_MINUTE) {
            return TRUE;
        }
        
        return FALSE;
    }
    
    
    public function minuteByWalking()
    {
        $minute = $this->distance * 1000 / self::WALKING_SPEED_PER_MINUTE;
        return ceil($minute);
    }
    
    
    public function minuteByCar()
    {
        $minute = $this->distance * 1000 / self::CAR_SPEED_PER_MINUTE;
        return ceil($minute);
    }
}
```



### マジカル定数

自動的に値が格納されている定数．

#### ・```__DIR__```

この定数がコールされたファイルが設置されたディレクトリのパスが，ルートディレクトリ基準で格納されている．

**【実装例】**

以下の実装を持つファイルを，「```/var/www/app```」下に置いておき，「```/vendor/autoload.php```」と結合してパスを通す．

```PHP
<?php
# /var/www/app/vendor/autoload.php
require_once realpath(__DIR__ . '/vendor/autoload.php');
```

#### ・```__FUNCTION__```

この定数がコールされたメソッド名が格納されている．

**【実装例】**

```PHP
<?php
class ExampleA
{
  public function a()
  {
    echo __FUNCTION__;
  }
}
```

```PHP
<?php
$exampleA = new ExmapleA;
$example->a(); // a が返却される．
```

#### ・```__METHOD__```

この定数がコールされたクラス名とメソッド名が，```{クラス名}::{メソッド名}```の形式で格納されている．

**【実装例】**

```PHP
<?php
class ExampleB
{
  public function b()
  {
    echo __METHOD__;
  }
}
```

```PHP
<?php
$exampleB = new ExmapleB;
$exampleB->b(); // ExampleB::b が返却される．
```



## 05-05. 変数

### 変数展開

文字列の中で，変数の中身を取り出すことを『変数展開』と呼ぶ．

※Paizaで検証済み．

#### ・シングルクオーテーションによる変数展開

シングルクオーテーションの中身は全て文字列として認識され，変数は展開されない．

```PHP
<?php
$fruit = "リンゴ";

// 出力結果
echo 'これは$fruitです．'; // これは，$fruitです．
```

#### ・シングルクオーテーションと波括弧による変数展開

シングルクオーテーションの中身は全て文字列として認識され，変数は展開されない．

```PHP
<?php
$fruit = "リンゴ";

// 出力結果
echo 'これは{$fruit}です．'; // これは，{$fruit}です．
```

#### ・ダブルクオーテーションによる変数展開

変数の前後に半角スペースを置いた場合にのみ，変数は展開される．（※半角スペースがないとエラーになる）

```PHP
<?php
$fruit = "リンゴ";

// 出力結果
echo "これは $fruit です．"; // これは リンゴ です．
```

#### ・ダブルクオーテーションと波括弧による変数展開

波括弧を用いると，明示的に変数として扱うことができる．これによって，変数の前後に半角スペースを置かなくとも，変数は展開される．

```PHP
<?php
$fruit = "リンゴ";

// 出力結果
echo "これは{$fruit}です．"; // これは，リンゴです．
```



### 参照渡しと値渡し

#### ・参照渡し

「参照渡し」とは，変数に代入した値の参照先（メモリアドレス）を渡すこと．

```PHP
<?php
$value = 1;
$result = &$value; // 値の入れ物を参照先として代入
```

**【実装例】**```$b```には，```$a```の参照によって10が格納される．

```PHP
<?php
$a = 2;
$b = &$a;  // 変数aを&をつけて代入
$a = 10;    // 変数aの値を変更

// 出力結果
echo $b; // 10
```

#### ・値渡し

「値渡し」とは，変数に代入した値のコピーを渡すこと．

```PHP
<?php
$value = 1;
$result = $value; // 1をコピーして代入
```

**【実装例】**```$b```には，```$a```の一行目の格納によって2が格納される．

```PHP
<?php
$a = 2;
$b = $a;  // 変数aを代入
$a = 10;  // 変数aの値を変更


// 出力結果
echo $b; // 2
```

### 正規表現とパターン演算子

#### ・正規表現を用いた文字列検索

```PHP
<?php

```

#### ・オプションとしてのパターン演算子

```PHP
<?php
// jpegの大文字小文字
preg_match('/jpeg$/i', $x);
```



## 06. ファイルパス

### 絶対パス

ルートディレクトリ（fruit.com）から，指定のファイル（apple.png）までのパス．

```
<img src="http://fruits.com/img/apple.png">
```

![絶対パス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/絶対パス.png)

### 相対パス

起点となる場所（apple.html）から，指定のディレクトリやファイル（apple.png）の場所までを辿るパス．例えば，apple.htmlのページでapple.pngを使用したいとする．この時，『 .. 』を用いて一つ上の階層に行き，青の後，imgフォルダを指定する．

```
<img src="../img/apple.png">
```

![相対パス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/相対パス.png)