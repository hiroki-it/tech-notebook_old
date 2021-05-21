# ドメイン駆動設計

## 01. MVC

### MVCとは

ドメイン駆動設計が考案される以前，MVCの考え方が主流であった．

![MVCモデル](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/MVCモデル.png)

<br>

### MVCからドメイン駆動設計への発展

#### ・MVCの問題点

しかし，特にModelの役割が抽象的過ぎたため，開発規模が大きくなるにつれて，Modelに役割を集中させ過ぎてしまうことがあった．

#### ・MVCからDDDへの移行

ドメイン駆動設計が登場したことによって，MVCは発展し，M・V・Cそれぞれの役割がより具体的で精密になった．Modelの肥大化は，Modelがもつビジネスロジックをドメイン層，またCRUD処理をインフラストラクチャ層として分割することによって，対処された．

<br>

## 02. ドメイン駆動設計とは

### ドメイン駆動設計の手順

#### ・戦略的設計の手順

1. ドメインエキスパートと話し合い，ドメインの境界線を見つけ，それぞれを境界づけられたコンテキストとする．
2. コンテキストマップを作成する．
3. ユースケースとユースケースシナリオを作成する．
4. ドメインエキスパートと話し合い，現実世界の業務内容に含まれる『名詞』と『振舞』を洗い出す．
5. 『名詞』と『振舞』を要素として，オブジェクト指向分析と設計を行い，エンティティや値オブジェクトを抽出していく．
6. エンティティや値オブジェクトを用いて，ドメインモデリング（オブジェクト間の関連付け）を行う．

#### ・戦術的設計の手順

戦略的設計を基に，各オブジェクトとオブジェクト間の関連性を実装していく．

<br>

### ドメイン駆動設計にまつわる用語

#### ・ドメインエキスパート，ユビキタス言語とは

ドメインエキスパート（現実世界のビジネスルールに詳しく，また実際にシステムを使う人）と，エンジニアが話し合いながら，ビジネスルールに対して，オブジェクト指向分析と設計を行っていく．この時，ドメインエキスパートとエンジニアの話し合いに齟齬が生まれぬように，ユビキタス言語（業務内容について共通の用語）を設定しておく．

![ドメインモデル](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/domain-model.png)

#### ・境界づけられたコンテキストとは

コアドメインやサブドメインの内部を詳細にグループ化する時，ビジネスの関心事の視点で分割されたまとまりのこと．コンテキストの中は，さらに詳細なコンテキストにグループ化できる．両方のコンテキストで関心事が異なっていても，対象は同じドメインであることもある．

![コアドメイン，サブドメイン，境界づけられたコンテキスト](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/core-domain_sub-domain_bounded-context.png)

**＊具体例＊**

仕事仲介サイトでは，仕事の発注者のドメインに注目した時，発注時の視点で分割された仕事募集コンテキストと，同じく契約後の視点で分割された契約コンテキストにまとめることができる．モデリングされた「仕事」は，コンテキスト間で視点が異なるため，意味合いが異なる．

![境界づけられたコンテキストの例](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/bounded-context_example.png)

#### ・コンテキストマップとは

広義のドメイン全体の俯瞰する図のこと．コアドメイン，サブドメイン，境界づけられたコンテキストを定義した後，これらの関係性を視覚化する．

![コンテキストマップ](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/context-map.png)

<br>

### ドメイン駆動設計の派生型

現在までに，ドメイン駆動設計の派生型がいくつか提唱されている．

#### ・Layeredアーキテクチャ

#### ・Hexagonalアーキテクチャ

#### ・Onionアーキテクチャ

  <br>

## 02-02. Layeredアーキテクチャ型ドメイン駆動設計

### 責務の分担方法

![ドメイン駆動設計](https://user-images.githubusercontent.com/42175286/58724663-2ec11c80-8418-11e9-96e9-bfc6848e9374.png)

<br>

### DIPに基づくドメイン駆動設計

#### ・依存性を逆転させる方法

1. リポジトリの抽象クラスを，より上位のドメイン層に配置する．
2. リポジトリの実装クラスを，より下位のインフラストラクチャ層に配置する．
3. 両方のクラスに対して，バインディング（関連付け）を行い，抽象クラスをコールした時に，実際には実装クラスがコールされるようにする．
4. これらにより，依存性が逆転する．依存性逆転の原則に基づくことによって，ドメイン層への影響なく，リポジトリの交換が可能になる．

![ドメイン駆動設計_逆転依存性の原則](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ドメイン駆動設計_依存性逆転の原則.jpg)

<br>


## 03. アプリケーション層（ユースケース層）

### コントローラ

#### ・コントローラとは

ドメイン層のロジックを組み合わせて，ユースケースを実装する．例えば，CRUD処理がユーザにとってはどのように定義されているのか（登録，参照，更新，削除）に着目し，一つのメソッドのロジックの粒度を決めるようにする．

**＊実装例＊**

```php
<?php

namespace App\Controller;        
    
class AcceptOrdersController
{
    // 単なるメソッドではなく，ユースケースとなるようなメソッド
    public function acceptOrders()
    {
    
    }
}  
```

**＊ユースケース例＊**

オンラインショッピングにおけるユースケース．

![ユースケース図](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ユースケース図.png)

<br>

### アプリケーションサービス

#### ・アプリケーションサービスとは

アプリケーション層の中で，ドメイン層のオブジェクトを使用する汎用的なメソッドが切り分けられたもの．コントローラにメソッドを提供する．ドメイン層のドメインサービスとは異なり，あくまでアプリケーション層のロジックが切り分けられたものである．

**＊実装例＊**

Slackへの通知処理をアプリケーションサービスとして切り分ける．

```php
<?php

namespace App\Service;

class SlackNotificationService
{
    private $message;

    public function __construct(Message $message)
    {
        $this->message = $message;
    }

    public function notify()
    {
        // SlackのAPIにメッセージを送信する処理
    }
}
```

これを，アプリケーション層でコールするようにする．

```php
<?php

namespace App\Controller;

use App\Service\SlackNotificationService;

class ExampleController
{
    public function example()
    {
        $message = new Message(/* メッセージに関するデータを渡す */)
        $slackNotificationService = new SlackNotificationService($message)
        $slackNotificationService->notify();
    }
}  
```

<br>

### 入力データに対するフォーマットのValidationパターン

#### ・Validationパターンとは

デザインパターンの一つ．フロントエンドからサーバサイドに送信されてきたデータのフォーマットを検証する責務を持つ．例えば，ユーザインターフェース層からアプリケーション層に送信されてきたJSON形式データのフォーマットを検証する．

**＊実装例＊**

```php
<?php

// Validationのライブラリ
use Respect\Validation\Validator;

class FormatValidator
{
    /**
     * 日時データのフォーマットを検証します．
     */
    public function validateFormat($dateTime)
    {
        if (empty($dateTime)) {
            return false;
        }

        if (!Validator::date(\DateTime::ATOM)->validate($dateTime)) {
            return false;
        }

        return true;
    }
}
```

<br>

### Converterパターン

#### ・Converterパターンとは

デザインパターンの一つ．データ構造を変換する責務を持つ．例えば，アプリケーション層からユーザインターフェース層へのデータのレスポンス時に，送信するオブジェクトデータ（ルートエンティティ）を連想配列に変換する．

**＊実装例＊**

```php
<?php
    
namespace App\Converter;
    
class Converter
{
   /**
    * オブジェクトを連想配列に詰め替えます．
    */
    public function convertToArray(XxxEntity $xxxEntity)
    {
        $xxxArray["id"] = $xxxEntity->id;
        $xxxArray["name"] = $xxxEntity->name;
        $xxxArray["email"] = $xxxEntity->email;
    }
}  
```

<br>


## 04. ドメイン層

### リポジトリ（インターフェース）

#### ・リポジトリ（インターフェース）とは

![Repository](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Repository.png)

デザインパターンの一つ．データベースにアクセスする責務を持つ．リクエストによるデータ送信が行われる．Controllerは，ドメイン層の抽象メソッドをコールし，DBにおけるデータのCRUDを行う．DIPに基づくドメイン駆動設計の場合，リポジトリのインターフェースを配置する．

**＊実装例＊**

```php
<?php

namespace App\Domain\Repository;    
    
interface DogToyRepository
{
    /**
     * 具象メソッドはインフラストラクチャ層のリポジトリに実装．
     */
    function findAllDogToys();
}
```

<br>

### エンティティ

#### ・エンティティとは

![ドメイン駆動設計_エンティティ](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ドメイン駆動設計_エンティティ.jpg)

#### ・保持するデータの値が一定でない

状態を変化させる必要があるデータをもつ．

#### ・データの値が同じでも区別できる

オブジェクトにアイデンティティがあり，他のオブジェクトと同じ属性をもっていても，区別される．

**＊実装例＊**

```php
<?php

namespace App\Domain\ValueObject;

/**
 * 犬用おもちゃのエンティティ
 */
class DogToy
{
    /**
     * 犬用おもちゃID
     */
    private $id;

    /**
     * 犬用おもちゃタイプ
     */
    private $type;

    /**
     * 犬用おもちゃ商品名
     */
    private $name;

    /**
     * 数量
     */
    private $number;

    /**
     * 価格の値オブジェクト
     */
    private $priceVO;

    /**
     * 色の値オブジェクト
     */
    private $colorVO;

    public function __construct(int $type, string $name, int $number, priceVO $priceVO, ColorVO $colorVO)
    {
        $this->type = $type;
        $this->name = $name;
        $this->number = $number;
        $this->priceVO = $priceVO;
        $this->colorVO = $colorVO;
    }

    /**
     * エンティティの等価性を検証します．
     */
    public function equals($dogToy)
    {
        return ($dogToy instanceof $this || $this instanceof $dogToy)
            && $this->id->equals($dogToy->getId());
    }

    /**
     * 犬用おもちゃ名（色）を返却します．
     */
    public function nameWithColor()
    {
        return sprintf(
            "%s（%s）",
            $this->name->value(),
            $this->colorVO->name()
        );
    }
}
```

#### ・ルートエンティティ

![ドメイン駆動設計_集約関係](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ドメイン駆動設計_集約関係.jpg)

 エンティティや値オブジェクトからなる集約の中で，最終的にアプリケーション層へレスポンスされる集約を，『ルートエンティティ』という．

**＊実装例＊**

```php
<?php

namespace App\Domain\Entity;

/**
 * 犬用注文エンティティ
 */
class DogOrder
{
    /**
     * 犬用商品コンボID
     */
    private $id;

    /**
     * 犬用おもちゃ
     */
    private $dogToy;

    /**
     * 犬用えさ
     */
    private $dogFood;

    public function __construct(DogToy $dogToy, DogFood $dogFood)
    {
        $this->dogToy = $dogToy;
        $this->dogFood = $dogFood;
    }

    /**
     * エンティティの等価性を検証します．
     *
     * IDのみ検証する必要がある．
     */
    public function equals(DogOrder $dogOrder)
    {
        // データ型を検証します．
        return ($dogOrder instanceof $this || $this instanceof $dogOrder)
            // IDを検証します．
            && $this->id->equals($dogOrder->getId());
    }

    /**
     * 犬用おもちゃを返却します．
     */
    public function getDogToy()
    {
        return $this->dogToy;
    }

    /**
     * 犬えさを返却します
     */
    public function getDogFood()
    {
        return $this->dogFood;
    }
}
```

<br>

### Specificationパターン

#### ・Specificationパターンとは

デザインパターンの一つ．ビジネスルールの検証，検索条件オブジェクトの生成は、Entitiyや値オブジェクトに持たせた場合，肥大化の原因となり，可読性と保守性が悪い．そこで，こういったビジネスルールをSpecificationオブジェクトにまとめておく．

#### ・入力データに対するビジネスルールのValidation

真偽値メソッド（```isXxxx```メソッド）のように，オブジェクトのデータを検証して、仕様を要求を満たしているか、何らかの目的のための用意ができているかを調べる処理する．

**＊実装例＊**

```php
<?php

namespace App\Specification;

class ExampleSpecification
{
    /**
     * ビジネスルールを判定します．
     */
    public function isSatisfiedBy(Entity $entity): bool
    {
        if (!$entity->isX) return false;
        if (!$entity->isY) return false;
        if (!$entity->isZ) return false;

        return true;
    }
} 
```

#### ・検索条件オブジェクトの生成

リクエストのパスパラメータとクエリパラメータを引数として，検索条件のオブジェクトを生成する．ビジネスルールのValidationを行うSpecificationクラスと区別するために，Criteriaオブジェクトという名前としても用いられる．

**＊実装例＊**

```php
<?php

namespace App\Criteria;

class XxxCriteria
{
    private $id;

    private $name;

    private $email;

    /**
     * 検索条件のオブジェクトを生成します．
     */
    public function build(array $array)
    {
        // 自身をインスタンス化．
        $criteria = new static();

        if (isset($array["id"])) {
            $criteria->id = $array["id"];
        }

        if (isset($array["name"])) {
            $criteria->id = $array["name"];
        }

        if (isset($array["email"])) {
            $criteria->id = $array["email"];
        }

        return $criteria;
    }
}
```

<br>

### 値オブジェクト

以降の説明を参照．

<br>

### Type Code（標準型）

#### ・Type Codeとは

Type Codeは概念的な呼び名で，実際は，標準的なライブラリとして利用できるEnumクラスに相当する．一意に識別する必要がないユビキタス言語の中でも，特に『区分』や『種類』などは，値オブジェクトとしてではなく，Enumクラスとしてモデリング／実装する．ただし，類似するパターンとして値オブジェクトのディレクトリ内に配置しても良い． 

#### ・色

**＊実装例＊**

```php
<?php

namespace App\Domain\ValueObject\Type;

/**
 * 色タイプ
 */
class ColorType
{
    const RED = "1";
    const BLUE = "2";

    /**
     * 『self::定数名』で，定義の値へアクセスします．
     */
    private $set = [
        self::RED  => ["name" => "レッド"],
        self::BLUE => ["name" => "ブルー"]
    ];

    /**
     * 値 
     */
    private $value;

    /**
     * 色名
     */
    private $name;

    // インスタンス化の時に，『色の区分値』を受け取る．
    public function __construct(string $value)
    {
        // $kbnValueに応じて，色名をnameデータにセットする．
        $this->value = $value;
        $this->name = static::$set[$value]["name"];
    }

    /**
     * 値を返却します．
     */
    public function value(): int
    {
        return $this->value;
    }


    /**
     * 色名を返却します．
     */
    public function name(): string
    {
        return $this->name;
    }
}
```

#### ・性別

**＊実装例＊**

```php
<?php

namespace App\Domain\ValueObject\Type;

/**
 * 性別タイプ
 */
class SexType
{
    const MAN     = 1;
    const WOMAN   = 2;
    const UNKNOWN = 3;

    private static $set = [
        self::MAN     => ["name" => "男性"],
        self::WOMAN   => ["name" => "女性"],
        self::UNKNOWN => ["name" => "不明"],
    ];

    /**
     * 値
     */
    private $value;
    
    /**
     * 名前
     */
    private $name;

    public function __construct($value)
    {
        $this->value = $value;
        $this->name = static::$set[$value]["name"];
    }
    
    /**
     * 値を返却します．
     */
    public function value(): int
    {
        return $this->value;
    }    
    /**
     * 名前を返却します．
     */
    public function name()
    {
        return $this->name;
    }
}
```

#### ・年号

**＊実装例＊**

```php
<?php
    
namespace App\Domain\ValueObject\Type;

/**
 * 年月日タイプ
 */
class YmdType
{
    const MEIJI   = "1"; // 明治
    const TAISHO  = "2"; // 大正
    const SHOWA   = "3"; // 昭和
    const HEISEI  = "4"; // 平成
    const REIWA   = "5"; // 令和
    const SEIREKI = "9"; // 西暦

    private static $set = [
        self::MEIJI   => ["name" => "明治"],
        self::TAISHO  => ["name" => "大正"],
        self::SHOWA   => ["name" => "昭和"],
        self::HEISEI  => ["name" => "平成"],
        self::REIWA   => ["name" => "令和"],
        self::SEIREKI => ["name" => "西暦"],
    ];

    private static $ymd = [
        self::MEIJI  => [
            "start" => [ "year" => 1868, "month" => 1, "day" => 25, ],
            "end"   => [ "year" => 1912, "month" => 7, "day" => 29, ],
        ],
        self::TAISHO => [
            "start" => [ "year" => 1912, "month" => 7,  "day" => 30, ],
            "end"   => [ "year" => 1926, "month" => 12, "day" => 24, ],
        ],
        self::SHOWA  => [
            "start" => [ "year" => 1926, "month" => 12, "day" => 25, ],
            "end"   => [ "year" => 1989, "month" => 1,  "day" => 7, ],
        ],
        self::HEISEI => [
            "start" => [ "year" => 1989, "month" => 1,  "day" => 8, ],
            "end"   => [ "year" => 2019, "month" => 4, "day" => 30, ],
        ],
        self::REIWA => [
            "start" => [ "year" => 2019, "month" => 5,  "day" => 1, ],
            "end"   => [ "year" => 9999, "month" => 12, "day" => 31, ],
        ],
    ];
    
    /**
     * 値 
     */
    private $value;
    
    /**
     * 年号名
     */
    private $name;
    
    /**
     * 値を返却します．
     */
    public function value(): int
    {
        return $this->value;
    }
    
    public function __construct($value)
    {
        $this->value = $value;
        $this->name = static::$set[$value]["name"];
    }

    /**
     * 年号名を返却します．
     */
    public function name()
    {
        return $this->name;
    }
}

```

<br>

### ドメインサービス

#### ・ドメインサービスとは

ドメイン層の中で，汎用的なメソッドが切り分けられたもの．ドメイン層にメソッドを提供する．ドメイン層の例外処理をまとめたDomainExceptionクラスもこれに当てはまる．

<br>

## 04-02. 値オブジェクト

### 値オブジェクトとは

![ドメイン駆動設計_バリューオブジェクト](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ドメイン駆動設計_バリューオブジェクト.jpg)

金額，数字，電話番号，文字列，日付，氏名，色などのユビキタス言語に関するデータと，これを扱うメソッドを実装する場合，一意で識別できるデータ（例えば，```$id```データ）をもたないオブジェクトとして，これらの実装をまとめておくべきである．このオブジェクトを，値オブジェクトという．

<br>

### 一意に識別できるデータをもたず，対象のユビキタス言語に関するデータをメソッドを持つ

#### ・金額

金額データの計算をController内処理やエンティティ内メソッドで行うのではなく，金額計算を行う値オブジェクトのメソッドとして分割する．

**＊実装例＊**

```php
<?php

namespace App\Domain\ValueObject;
    
/**
 * 金額の値オブジェクト
 */
class MoneyVO
{
    /**
     * 金額
     */        
    private $amount;

    public function __construct($amount = 0)
    {
        $this->amount = (float) $amount;
    }
    
    /**
     * 金額を返却します．
     */        
    public function amount()
    {
        return $this->amount;
    }
    
    /**
     * 単位を返却します．
     */    
    public function unit()
    {
        return "円";
    }
    
    /**
     * 足し算の結果を返却します．
     */    
    public function add(Money $rhs)
    {
        return new static($this->amount + $rhs->amount);
    }
    
    /**
     * 引き算の結果を返却します
     */
    public function substract(Money $rhs)
    {
        return new static($this->amount - $rhs->amount);
    }
    
    /**
     * 掛け算の結果を返却します
     */    
    public function multiply($rhs)
    {
        return new static($this->amount * $rhs);
    }    
}
```

#### ・所要時間

所要時間データの計算をController内処理やエンティティ内メソッドで行うのではなく，所要時間計算を行う値オブジェクトのメソッドとして分割する．

**＊実装例＊**

```php
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
    
    /**
     * 徒歩または車のどちらを使用するかを判定します．
     */    
    public function isMinuteByWalking()
    {
        if ($this->distance * 1000 / self::WALKING_SPEED_PER_MINUTE < self::JUDGMENT_MINUTE) {
            return true;
        }
        
        return false;
    }
    
    /**
     * 徒歩での所要時間を計算します．
     */    
    public function minuteByWalking()
    {
        $minute = $this->distance * 1000 / self::WALKING_SPEED_PER_MINUTE;
        return ceil($minute);
    }
    
    /**
     * 車での所用時間を計算します．
     */    
    public function minuteByCar()
    {
        $minute = $this->distance * 1000 / self::CAR_SPEED_PER_MINUTE;
        return ceil($minute);
    }
}
```

#### ・住所

郵便番号データとその処理を値オブジェクトとして分割する．

**＊実装例＊**

```php
<?php

/**
 * 住所クラス
 */
class Address
{
    /**
     * 住所の文字数上限
     */
    const ADDRESS_MAX_LENGTH = 512;

    /**
     * 郵便番号
     *
     * @var string|null
     */
    private $zip;

    /**
     * 住所 (番地など)
     */
    private $address;

    /**
     * 住所 カナ(番地など)
     */
    private $kana;

    /**
     * 市区町村
     */
    private $city;

    public function __construct(City $city, string $zip = null, string $address = null, string $kana = null)
    {
        $this->zip = $zip;
        $this->address = $address;
        $this->kana = $kana;
        $this->city = $city;
    }

    /**
     * 郵便番号を返却します.
     */
    public function zip()
    {
        if (!$this->zip) {
            return '';
        }

        return sprintf(
            "〒%s-%s",
            substr($this->zip, 0, 3),
            substr($this->zip, 3)
        );
    }

    /**
     * 住所を返却します．
     */
    public function address(): string
    {
        return sprintf(
            "%s%s%s",
            $this->city->prefecture->name ?? '',
            $this->city->name ?? '',
            $this->address ?? ''
        );
    }
}
```

#### ・氏名

氏名，性別，データとその処理を値オブジェクトとして分割する．

**＊実装例＊**

```php
<?php

/**
 * 氏名クラス
 */
class Name
{
     /**
     * 名前の文字数上限下限
     */
    const MIN_NAME_LENGTH = 1;
    const MAX_NAME_LENGTH = 64;

    /**
     * 姓
     */
    private $lastName;

    /**
     * 名
     */
    private $firstName;

    /**
     * セイ
     */
    private $lastKanaName;

    /**
     * メイ
     */
    private $firstKanaName;

    /**
     * 氏名を作成します．
     */
    public function fullName()
    {
        return $this->lastName . $this->firstName;
    }

    /**
     * カナ氏名を作成します．
     */
    public function fullKanaName()
    {
        return $this->lastKanaName . $this->firstKanaName;
    }
}

```

<br>

### オブジェクトの持つデータの不変性

#### ・不変性に関するベストプラクティス

エンティティと値オブジェクトのどちらとして，オブジェクトをモデリング／実装すべきなのかについて考える．そもそも，大前提として，『オブジェクトの持つデータはできるだけ不変にすべき』というベストプラクティスがあり，その結果，値オブジェクトというが生まれたと考えられる．実は，値オブジェクトを使わずに全てエンティティとしてモデリング／実装することは可能である．しかし，不変にしてもよいところも可変になり，可読性や信頼性を下げてしまう可能性がある．

#### ・普遍性をコードで実現する方法

インスタンス化時に自動的に呼び出される```construct```メソッドを用いる．インスタンス化時に実行したい処理を記述できる．セッターを持たせずに，```construct```メソッドでのみ値の設定を行えば，値オブジェクトのような，『Immutable』なオブジェクトを実現できる．

**＊実装例＊**

```php
<?php

namespace App\Domain\ValueObject;    
    
/**
 * 値オブジェクト
 */     
class ExampleVO
{
    private $propertyA;
    
    private $propertyB;
    
    private $propertyC;
    
    public function __construct($param)
    {
        $this->propertyA = $param["a"];
        $this->propertyB = $param["b"];
        $this->propertyC = $param["c"];
    }   
}
```

#### ・『Immutable』を実現できる理由

Test01クラスインスタンスの```$property01```に値を設定するためには，インスタンスからセッターを呼び出す．セッターは何度でも呼び出せ，その度にデータの値を上書きできてしまう．

**＊実装例＊**

```php
<?php

$test01 = new Test01;

$test01->setProperty01("データ01の値");

$test01->setProperty01("新しいデータ01の値");
```

一方で，Test02クラスインスタンスの```$property02```に値を設定するためには，インスタンスを作り直さなければならない．つまり，以前に作ったインスタンスの```$property02```の値は上書きできない．セッターを持たせずに，```construct```メソッドだけを持たせれば，『Immutable』なオブジェクトとなる．

**＊実装例＊**

```php
<?php

$test02 = new Test02("データ02の値");

$test02 = new Test02("新しいデータ02の値");
```

<br>

### 概念的な統一体

```php
<?php

// ここに実装例
```

<br>

### オブジェクトの交換可能性

オブジェクトが新しくインスタンス化された場合，以前に同一オブジェクトから生成されたインスタンスから新しく置き換える必要がある．

<br>

### オブジェクトの等価性

全てのデータの値が他のVOと同じ場合，同一のVOと見なされる．

**＊実装例＊**

```php
<?php

namespace App\Domain\ValueObject;

/**
 * 犬用おもちゃID
 */
class DogToyId
{
    /**
     * 値 
     */
    private $value;
    
    public function __constructor(string $value)
    {
        $this->value = $value
    }
    
    /**
     * VOの属性の等価性を検証します．
     */
    public function equals($id)
    {
        // データ型を検証します．
        return ($id instanceof $this || $this instanceof $id)
            // 値を検証します．
            && $this->value() === $id->value();
    }
}
```

```php
<?php

namespace App\Domain\ValueObject;    
    
/**
 * 支払情報の値オブジェクト
 */
class PaymentInfoVO
{
    // 予め実装したImmutableObjectトレイトを用いて，データの不変性を実現
    use ImmutableObject;

    /**
     * 支払い方法
     *
     * @var PaymentType
     */
    private $paymentType;
    
    /**
     * 連絡先メールアドレス
     *
     * @var string|null
     */
    private $contactMail;
    
    /**
     * 金額
     *
     * @var Money
     */
    private $price;  
    
    /**
     * VOの属性の等価性を検証します．
     *
     * 全ての属性を検証する必要がある．
     */
    public function equals($paymentInfoVO)
    {
        // データ型を検証します．
        return ($paymentInfoVO instanceof $this || $this instanceof $paymentInfoVO)
            // 全ての属性を検証します．
            && $this->paymentType->value() === $paymentInfoVO->paymentType->value()
            && $this->contactMail->value() === $paymentInfoVO->contactMail->value()
            && $this->price->value() === $paymentInfoVO->price->value();
    }
}
```

 <br>

### メソッドによってオブジェクトの状態が変わらない

セッターを定義せずに```constructor```メソッドを使用することにより，外部からメソッドをコールしてデータを変更できなくなる．

<br>


## 05. インフラストラクチャ層

### リポジトリ（実装クラス）

#### ・DBに対する書き込み責務（Create，Update，Delete）

![ドメイン駆動設計_リポジトリ_データ更新](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ドメイン駆動設計_リポジトリ_データ更新.png)

DBに対する書き込み操作を行う．

1. GETまたはPOSTによって，アプリケーション層から値が送信される．

2. ファクトリによって，送信された値からエンティティや値オブジェクトを構成する．さらに，それらから集約を構成する．

3. リポジトリによって，最終的な集約を構成する．

4. リポジトリによって，集約を連想配列に分解する．

5. ```add()```によって，リポジトリのデータに，集約を格納する．

6. ```store()```によって，Transactionクラスのデータに，リポジトリを格納する．

7. DBに対して，書き込みを行う．


参考：

https://www.doctrine-project.org/projects/doctrine-orm/en/2.8/reference/query-builder.html

https://github.com/doctrine/dbal/blob/2.12.x/lib/Doctrine/DBAL/Query/QueryBuilder.php

**＊実装例＊**

CREATE処理のため，DoctrineのQueryBuilderクラスの```insert```メソッドを実行する．

```php
<?php
    
namespace App\Infrastructure\Repositories;    
    
use App\Domain\Entity\DogToy;
use Doctrine\DBAL\Query\QueryBuilder;

/**
 * 犬用おもちゃリポジトリ
 */
class DogToyRepository
{
    /**
     * ルートエンティティを書き込みます．
     */
    public function create(DogToy $dogToy)
    {
        // クエリビルダ生成
        $query = $this->createQueryBuilder();
        
        // SQLを定義する．
        $query->insert("dog_toy_table")
            ->values([
                // ルートエンティティの要素をカラム値として設定する．（IDはAutoIncrement）
                "name"  => $dogToy->getName()->value(),
                "type"  => $dogToy->getType()->value(),
                "price" => $dogToy->getPriceVO()->value(),
                "color" => $dogToy->getColorVO()->value(),
        ]);
    }
}
```

UPDATE処理のため，DoctrineのQueryBuilderクラスの```update```メソッドを実行する．

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\DogToy;
use Doctrine\DBAL\Query\QueryBuilder;

/**
 * 犬用おもちゃリポジトリ
 */
class DogToyRepository
{
    /**
     * ルートエンティティを書き込みます．
     */
    public function create(DogToy $dogToy)
    {
        // クエリビルダ生成
        $query = $this->createQueryBuilder();
        
        // SQLを定義する．
        $query->update("dog_toy_table", "dog_toy")
            // ルートエンティティの要素をカラム値として設定する．
            ->set("dog_toy.name", $dogToy->getName()->value())
            ->set("dog_toy.type", $dogToy->getType()->value())
            ->set("dog_toy.price", $dogToy->getPriceVO()->value())
            ->set("dog_toy.color", $dogToy->getColorVO()->value())
            ->where("dog_toy.id", $dogToy->getId()->value();
    }
}
```

DELETE処理（論理削除）のため，DoctrineのQueryBuilderクラスの```update```メソッドを実行する．

```php
<?php

namespace App\Infrastructure\Repositories;    

use App\Constants\FlagConstant;
use App\Domain\Entity\DogToy;
use Doctrine\DBAL\Query\QueryBuilder;

/**
 * 犬用おもちゃリポジトリ
 */
class DogToyRepository
{
    /**
     * ルート Entityを書き込みます．
     */
    public function create(DogToy $dogToy)
    {
        // クエリビルダ生成
        $query = $this->createQueryBuilder();
        
        // SQLを定義する．
        $query->update("dog_toy_table", "dog_toy")
            // 論理削除
            ->set("dog_toy.is_deleted", FlagConstant::IS_ON)
            ->where("dog_toy.id", $dogToy->getId()->value();
    }
}
```

#### ・DBに対する読み出し責務（Read）

![ドメイン駆動設計_リポジトリ_データ取得](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ドメイン駆動設計_リポジトリ_データ取得.jpg)

DBに対する書き込み操作を行う．

1. アプリケーション層から集約がリクエストされる．
2. DBに対して，読み出しを行う．
3. ファクトリによって，送信された値からエンティティや値オブジェクトを構成する．さらに，それらから集約を構成する．
4. リポジトリによって，最終的な集約を構成する．
5. 再構成された集約をアプリケーション層にレスポンス．

参考：

https://www.doctrine-project.org/projects/doctrine-orm/en/2.8/reference/query-builder.html

https://github.com/doctrine/dbal/blob/2.12.x/lib/Doctrine/DBAL/Query/QueryBuilder.php

**＊実装例＊**

READ処理のため，DoctrineのQueryBuilderクラスの```select```メソッドを実行する．

```php
<?php
    
namespace App\Infrastructure\Repositories;

use App\Constants\FlagConstant;
use App\Domain\Entity\DogToy;
use Doctrine\DBAL\Query\QueryBuilder;

/**
 * 犬用おもちゃリポジトリ
 */
class DogToyRepository
{   
     /**
     * ルートエンティティのセットを生成します．
     */
    public function findAllDogToys(): array
    {
        $dogToys = [];
        
        foreach($this->fetchAllDogToy() as $fetched){
            $dogToys[] = $this->aggregateDogToy($fetched);
        }
        
        return $dogToys;
    }
    
    /**
    * Entityを全て読み出します．
    */
    private function fetchAllDogToy(): array
    {
        // クエリビルダ生成
        $query = $this->createQueryBuilder();
        
        // SQLを設定する．
        $query->select(
            "dog_toy.id    AS dog_toy_id",
            "dog_toy.name  AS dog_toy_name",
            "dog_toy.type  AS dog_toy_type",
            "dog_toy.price AS dog_toy_price",
            "dog_toy.color AS dog_toy_color"
        )
        ->from("dog_toy_table", "dog_toy")
        // 論理削除されていないもののみ
        ->where("dog_toy.is_deleted", FlagConstant::IS_OFF)
        ->getQuery();    
        
        // SQLを実行する．
        $query->getResult();
    }

    /**
     * ルートエンティティを生成します．
     */
    private function aggregateDogToy(array $fetched): DogToy
    {
        $dogToy = new DogToy(
            $fetched["dog_toy_id"],
            $fetched["dog_toy_name"],
            $fetched["dog_toy_type"],
            new PriceVO($fetched["dog_toy_price"],
            new ColorVO($fetched["dog_toy_color"]
        );
        
        return $dogToy;
    }
}
```

<br>

### ファクトリ

#### ・責務

責務として，新たな集約を構成する．既存の集約を分解して再構成させてもよい．

**＊実装例＊**

```php
<?php
    
namespace App\Infrastructure\Factories;

use App\Domain\Entity\DogToy;
use App\Domain\Entity\DogFood;
use App\Domain\Entity\DogCombo;

/**
 * 犬用コンボファクトリ
 */
class DogComboFactory
{   
    /**
     * 新たな集約を構成します．
     */
    public static function createDogCombo($data): DogItem
    {
        return new DogCombo(
            new DogToy(
                $data["dog_toy_id"],
                $data["dog_toy_name"],
                $data["dog_toy_type"],
                $data["dog_toy_price"],
                $data["dog_toy_color"],
            ),
            new DogFood(
                $data["dog_food_id"],
                $data["dog_food_name"],
                $data["dog_food_type"],
                $data["dog_food_price"],
                $data["dog_food_flavor"],
            )
        );
    } 
}
```
