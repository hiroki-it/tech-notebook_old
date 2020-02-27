# ドメイン駆動設計

## 01-01. MVCとは

ドメイン駆動設計が考案される以前，MVCの考え方が主流であった．

![MVCモデル](https://user-images.githubusercontent.com/42175286/57635646-8838e700-75e2-11e9-837d-253c006b7725.png)



### :pushpin: MVCからドメイン駆動設計への発展

しかし，特にModelの役割が抽象的過ぎたため，開発規模が大きくなるにつれて，Modelに役割を集中させ過ぎてしまうことがあった．それから，ドメイン駆動設計が登場したことによって，MVCは発展し，M・V・Cそれぞれの役割がより具体的で精密になった．



## 02-01. ドメイン駆動設計とは

### :pushpin: ドメインエキスパートとユビキタス言語

ドメインエキスパート（現実世界の業務内容に詳しく，また実際にシステムを使う人）と，エンジニアが話し合いながら，設計していく．設計の時，ドメインエキスパートとエンジニアの話し合いに齟齬が生まれぬように，ユビキタス言語（業務内容について共通の用語）を設定しておく．



### :pushpin: 戦略的設計

1. ドメインエキスパートと話し合い，現実世界の業務内容に含まれる『名詞』と『振舞』に着目．
2. 『名詞』と『振舞』を要素として，EntityやValueObjectを設計．
3. 設計されたEntityやValueObjectを用いて，ドメインモデリング（オブジェクト間の関連付け）を行う．



### :pushpin: 戦術的設計

戦略的設計を基に，各オブジェクトとオブジェクト間の関連性を実装していく．

![DDDの概念](https://user-images.githubusercontent.com/42175286/61179612-d305c800-a640-11e9-8c4a-3d31225af633.jpg)



### :pushpin: ドメイン駆動設計の派生型

現在までに，ドメイン駆動設計の派生型がいくつか提唱されている．

#### ・Layeredアーキテクチャ

#### ・Hexagonalアーキテクチャ

#### ・Onionアーキテクチャ

  

## 02-02. Layeredアーキテクチャ型ドメイン駆動設計

### :pushpin: 責務の分担方法

![ドメイン駆動設計](https://user-images.githubusercontent.com/42175286/58724663-2ec11c80-8418-11e9-96e9-bfc6848e9374.png)

Layeredアーキテクチャ型ドメイン駆動設計において，MVCは，以下の4層に再編成できる．

#### ・User Interface層
#### ・Application層
#### ・Domain層（ビジネロジックをコード化）
#### ・Infrastructure層（DBとマッピング）



## 02-03. DIPに基づくドメイン駆動設計

**※詳しくは，オブジェクト指向プログラミングのノートを参照**

1. Repositoryの抽象クラスを，より上位のドメイン層に配置する．
2. Repositoryの実装クラスを，より下位のInfrastructure層に配置する．
3. 両方のクラスに対して，バインディング（関連付け）を行い，抽象クラスをコールした時に，実際には実装クラスがコールされるようにする．
4. これらにより，依存性が逆転する．依存性逆転の原則に基づくことによって，ドメイン層への影響なく，Repositoryの交換が可能になる．

![ドメイン駆動設計_逆転依存性の原則](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ドメイン駆動設計_依存性逆転の原則.jpg)




## 03-01. Application層（UseCase層）



## 03-02. Controller

### :pushpin: 責務

CRUDのReadの場合，以下のような処理手順を組み合わせて，Use case（使用事例）を実装する．

1. 最初に，リクエストによるJSON型データ送信を受け取る．
2. JSON型データを連想配列にパースする．
3. Repositoryのメソッドに連想配列を渡し，DBからオブジェクトデータをReadする．
4. Casterに，Readしたオブジェクトデータを渡し，連想配列に変換する．以下のCasterの説明を参照せよ．
5. 最後に，連想配列をJSON型データにパースし，JavaScriptに送信する．

![シリアライズとデシリアライズ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/シリアライズとデシリアライズ.png)

**【実装例】**

```PHP
class AcceptOrdersController
{
    // 単なるメソッドではなく，Use caseとなるようなメソッド
    public function acceptOrders()
    {
    
    }

}  
```

**【Use caseの例】**

オンラインショッピングにおけるUse case

![ユースケース図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ユースケース図.png)



## 03-03. Caster（データ型変換パターン）

### :pushpin: 責務

デザインパターンの一つ．レスポンスによるデータ送信時に，オブジェクトデータ（Entity）を連想配列に変換する．

```PHP
// Entityを連想配列に変換するメソッド
private function castAcceptOrders(Array $toyOrderEntity)
{
  
}  
```



## 03-04. Application Service

### :pushpin: 責務

ドメイン層のオブジェクトを使用する汎用的なメソッドをもち，Controllerにメソッドを提供する．

**【実装例】**

```

```




## 04-01. Domain層



## 04-02. 抽象Repository

### :pushpin: 責務

リクエストによるデータ送信が行われる．Controllerは，Domain層の抽象メソッドをコールし，DBにおけるデータのCRUDを行う．DIPに基づくドメイン駆動設計の場合，Repositoryの抽象クラスを配置する．

```PHP
abstract class getDogToyEntityRepository
{

    // 対応する具象メソッドはInfrastructure層のRepositoryに実装．
    abstract public function arrayDogToyEntities();

}
```

#### ・抽象Repositoryと具象Repositoryの対応付け

Application層




## 04-03. Entity

### :pushpin: 責務

オブジェクトをEntityとしてモデリング／実装したいのならば，以下に条件を満たす必要がある．

（ユビキタス言語の例）顧客，注文など

1. 状態を変化させる必要があるデータをもつ．
2. オブジェクトにアイデンティティがあり，他のオブジェクトと同じ属性をもっていても，区別される． 

![ドメイン駆動設計_エンティティ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ドメイン駆動設計_エンティティ.jpg)

**【実装例】**

```PHP
class DogToyEntity
{
    // おもちゃタイプ
    private $toyType;
    
    // おもちゃ商品名
    private $toyName;
    
    // 数量
    private $number;
    
    // 価格VO
    private $priceVO;
    
    // 色VO
    private $colorVO;
    
    
    // Setterを実装
    public function __construct
    (
        int $toyType,
        string $toyName,
        int $number,
        priceVO $priceVO,
        ColorVO $colorVO
    )
    {
        $this->toyType = $toyType;
        $this->toyName = $toyName;
        $this->number = $number;
        $this->priceVO = $priceVO;
        $this->colorVO = $colorVO;
    }
        
    // Getterを実装
    public function toyNameWithColor()
    {
        if($this->toyName && $this->colorVO->colorName());
        return sprintf
        (
            '%s（%s）',
            $this->toyName,
            $this->colorVO->colorName()
        );
    }
    
}
```



### :pushpin: RouteEntityとは

  EntityやValueObjectからなる集約の中で，最終的にアプリケーション層へレスポンスされる集約を，『RouteEntity』という．

![ドメイン駆動設計_集約関係](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ドメイン駆動設計_集約関係.jpg)

**【実装例】**

```PHP
class ToyOrderEntity
{
    // 犬用おもちゃ
    private $dogToyEntity;
    
    // 猫用おもちゃ
    private $catToyEntity;
    
    // Setterを実装
    public function __construct
    (
        DogToyEntity $dogToyEntity,
        CatToyEntity $catToyEntity
    )
    {
        $this->dogToyEntity = $dogToyEntity;
        $this->catToyEntity = $catToyEntity;
    }
  
    // 	Getterを実装
    public function getXXX()
    {
        //  Read処理;
    }  
  
}
```



## 04-04. ValueObject

### :pushpin: 責務

EntityとValueObjectのどちらとして，オブジェクトモデルをモデリング／実装すべきなのかについて考える．そもそも，大前提として，『オブジェクトモデルはできるだけ不変にすべき』というベストプラクティスがあり，その結果，ValueObjectというが生まれたと考えられる．実は，ValueObjectを使わずに全てEntityとしてモデリング／実装することは可能である．しかし，不変にしてもよいところも可変になり，可読性や信頼性を下げてしまう可能性がある．

![ドメイン駆動設計_バリューオブジェクト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ドメイン駆動設計_バリューオブジェクト.jpg)

**【実装例】**

```PHP
/**
 * 支払情報オブジェクト
 */
class PaymentInfoVO
{
    // 予め実装したImmutableObjectトレイトを用いて，データの不変性を実現
    use ImmutableObject;

    /**
     * 支払いID
     *
     * @var PaymentId
     */
    private $PaymentId;

    /**
     * 支払い方法
     *
     * @var PaymentType
     */
    private $PaymentType;
    
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
}
```



### :pushpin: 一意に識別できるデータをもたず，対象のユビキタス言語に関するデータをメソッドを持つ

金額，数字，電話番号，文字列，日付，氏名，色などのユビキタス言語に関するデータと，これを扱うメソッドを実装する場合，一意で識別できるデータ（例えば，```$id```データ）をもたないオブジェクトとして，これらの実装をまとめておくべきである．このオブジェクトを，ValueObjectという．

#### ・金額データと計算

金額データの計算をController内処理やEntity内メソッドで行うのではなく，金額計算を行うValueObjectのメソッドとして分割する．

#### ・所要時間データと計算

所要時間データの計算をController内処理やEntity内メソッドで行うのではなく，所要時間計算を行うValueObjectのメソッドとして分割する．

#### ・住所データと処理

郵便番号データとその処理をValueObjectとして分割する．



### :pushpin: データの不変性

インスタンス化時に自動的に呼び出される```__construct()```を用いる．インスタンス化時に実行したい処理を記述できる．Setterを持たせずに，```__construct()```でのみ値の設定を行えば，ValueObjectのような，『Immutable』なオブジェクトを実現できる．

**【実装例】**

```PHP
class ExampleVO
{

        private $propertyA;
  
        private $propertyB;

        private $propertyC;

        // コンストラクタで$propertyに値を設定
        public function __construct($param)
        {
            $this->propertyA = $param['a'];
            $this->propertyB = $param['b'];
            $this->propertyC = $param['c'];
        }
    
}
```

#### ・『Immutable』を実現できる理由

Test01クラスインスタンスの```$property01```に値を設定するためには，インスタンスからSetterを呼び出す．Setterは何度でも呼び出せ，その度にデータの値を上書きできてしまう．

```PHP
$test01 = new Test01;

$test01->setProperty01("データ01の値");

$test01->setProperty01("新しいデータ01の値");
```

一方で，Test02クラスインスタンスの```$property02```に値を設定するためには，インスタンスを作り直さなければならない．つまり，以前に作ったインスタンスの```$property02```の値は上書きできない．Setterを持たせずに，```__construct()```だけを持たせれば，『Immutable』なオブジェクトとなる．

```PHP
$test02 = new Test02("データ02の値");

$test02 = new Test02("新しいデータ02の値");
```



### :pushpin: 概念的な統一体

```

```





### :pushpin: オブジェクトの交換可能性

オブジェクトが新しくインスタンス化された場合，以前に同一オブジェクトから生成されたインスタンスから新しく置き換える必要がある．



### :pushpin: オブジェクト間の等価性

全てのデータの値が他のVOと同じ場合，同一のVOと見なされる．

 

### :pushpin: メソッドによってオブジェクトの状態が変わらない

**【実装例1】**

```PHP
// （1）ドメイン層の氏名を扱うVO
class NameVO
{
        // （2）予め実装したImmutableObjectトレイトを用いて，データの不変性を実現
    use ImmutableObject;

    // 苗字データ
    private $lastName;
    
    // 名前データ
    private $firstName;
    
    // （6） メソッドによってオブジェクトの状態が変わらない
    public function fullName(): String
    {
        return $this->lastName . $this->firstName;
    }
    
    // 
    protected static function computedPropertyNames()
    {
        return [
            'fullName'
        ];
    }
}
```

**【実装例2】**

同様に，Immutableトレイトを基に，VOを生成する．

```PHP
// ドメイン層の金額を扱うVO
class Money
{

}
```



## 04-05. TypeCode（標準型）

### :pushpin: 責務

一意に識別する必要がないユビキタス言語の中でも，特に『区分』や『種類』などは，ValueObjectとしてではなく，TypeCodeとしてモデリング／実装する．VOまたはEnumによって実装する．



### :pushpin: EnumによるTypeCodeの実装

**【実装例1】**

```PHP
class ColorVO extends Enum
{
    const RED = '1';
    const BLUE = '2';


    // 『self::定数名』で，定義の値へアクセスする．
    private $defs = [
        self::RED => ['colorname' => 'レッド'],
        self::BLUE => ['colorname' => 'ブルー']
    ];


    // 色値データ
    private $colorValue;
    
    
    // 色名データ．
    private $colorName;
    
    
    // インスタンス化の時に，『色の区分値』を受け取る．
    public function __construct
    (
        String $value
    )
    {
        // $kbnValueに応じて，色名をcolornameデータにセットする．
        $this->colorValue = $value;
        $this->colorname = $this->defs[$value]['colorName'];
    }
    
    
    // constructによってセットされた色値を返すメソッド．
    public function colorValue() :Int
    {
        return $this->colorValue;
    } 


    // constructによってセットされた色名を返すメソッド．
    public function colorName() :String
    {
        return $this->colorName;
    } 
    
}
```



## 04-06. Id

### :pushpin: 責務



## 04-07. Domain Service

### :pushpin: 責務



## 05-01. Infrastructure層



## 05-02. 具象Repository

### :pushpin: 責務

DBの操作を行う．



### :pushpin: DBに対する書き込み（Create，Update，Delete）

1. GETまたはPOSTによって，アプリケーション層から値が送信される．

2. Factoryによって，送信された値からEntityやValueObjectを構成する．さらに，それらから集約を構成する．

3. Repositoryによって，最終的な集約を構成する．

4. Repositoryによって，集約を連想配列に分解する．

5. ```add()```によって，Repositoryに集約を登録する．

6. ```store()```によって，Transaction処理にRepositoryを登録する．

7. DBに対して，書き込みを行う．

   ![ドメイン駆動設計_リポジトリ_データ更新](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ドメイン駆動設計_リポジトリ_データ更新.png)

**【実装例】**

```PHP
// 集約の構成とデータ追加を行う．
class setDogToyEntityRepository
{
  // 接続先したいデータベースが設定されたデータ
    private $dbs;
  
    public function setDataSet(Request $request)
    {
  
        $dogToyEntity = new DogToyEntity;
  
  
        // 送信された値を取り出して格納し，集約を生成．
        $dogToyEntity->toyType = $request->xxx();
        $dogToyEntity->toyName	= $request->xxx();
        $dogToyEntity->number = $request->xxx();
        $dogToyEntity->priceVO = $request->xxx(new PriceVO());
        $dogToyEntity->colorVO = $request->xxx(new ColorVO());
  
  
        // 集約を連想配列に分解する．
        $data = [
            'type' => $dogToyEntity->toyType,
            'name' => $dogToyEntity->toyName,
            'number' => $dogToyEntity->number,
            'price' => $dogToyEntity->priceVO->price(),
            'color_value' => $dogToyEntity->colorVO->value(),
        ];
  
  
        // データベースのテーブルに挿入する．
        $this->dbs['app']->insert(dog_toy_table, $data);
    
    }
}
```



### :pushpin: DBに対する読み出し（Read）

1. アプリケーション層から集約がリクエストされる．
2. DBに対して，読み出しを行う．
3. Factoryによって，送信された値からEntityやValueObjectを構成する．さらに，それらから集約を構成する．
4. Repositoryによって，最終的な集約を構成する．
5. 再構成された集約をアプリケーション層にレスポンス．

![ドメイン駆動設計_リポジトリ_データ取得](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/ドメイン駆動設計_リポジトリ_データ取得.jpg)

**【実装例】**

```PHP
// データのReadと集約再構成を行う．
class getDogToyEntityRepository
{
  // 接続先したいデータベースが設定されたデータ
    private $dbs;


    // 連想配列データから『RouteEntity』の集約を構成し，レスポンスする．
    public function arrayDogToyEntities(): DogToyEntities
    {
        $dogToyEntities = [];
        foreach($this->fetchDataSet() as $fetchedData){
            $dogToyEntities[] = $this->aggregateDogToyEntity($fetchedData)
        }
        
        return $dogToyEntities;
    }


    // データベースからデータをReadする．
    private function fetchDataSet()
    {
        $select = [
            'dog_toy.type AS dog_type',
            'dog_toy.name AS dog_toy_name',
            'dog_toy.number AS number',
            'dog_toy.price AS dog_toy_price',
            'dog_toy.color_value AS color_value'
        ];
        
        $query = $this->getFecthQuery($select);
        return $query->getConnection()->executeQuery()->fetchAll(); 
    }


    // 集約を行うメソッド
    private function aggregateDogToyEntity(Array $fetchedData)
    {
        $dogToyEntity = new DogToyEntity;
        $dogToyEntity->toyType = $fetchedData['dog_toy_type'];
        $dogToyEntity->toyName = $fetchedData['dog_toy_name'];
        $dogToyEntity->number = $fetchedData['number'];
        $dogToyEntity->priceVO = new PriceVO($fetchedData['dog_toy_price']);
        $dogToyEntity->colorVO = new ColorVO($fetchedData['color_value']);
    }
  
}
```



## 05-03. Factory

### :pushpin: 責務

責務として，構成した集約関係を加工して新たな集約を再構成する．

#### ・実装例

```PHP
// 構成した集約関係を加工して新たな集約を再構成する
class Factory
{
  
    private $factory;

    
    public function __construct
    (
        Factory $factory
    )
    {
        $this->$factory = $factory;
    }
    
  
    public function factoryToyOrderEntity()
    {
        if(isset($this->factory)){
            $toyOrderEntity = ;//なんらかの集約処理;
            }
    
        return $toyOrderEntity;
    }
    
}
```
