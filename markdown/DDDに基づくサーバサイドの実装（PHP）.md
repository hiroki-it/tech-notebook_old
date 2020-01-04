# 目次

<!-- TOC -->

- [01-01. Webページにおける処理の流れ](#01-01-webページにおける処理の流れ)
- [02-01. MVCとは](#02-01-mvcとは)
    - [:pushpin: MVCからドメイン駆動設計への発展](#pushpin-mvcからドメイン駆動設計への発展)
- [03-01. ドメイン駆動設計とは](#03-01-ドメイン駆動設計とは)
    - [:pushpin: ドメインエキスパートとユビキタス言語](#pushpin-ドメインエキスパートとユビキタス言語)
    - [:pushpin: 戦略的設計](#pushpin-戦略的設計)
    - [:pushpin: 戦術的設計](#pushpin-戦術的設計)
    - [:pushpin: ドメイン駆動設計の派生型](#pushpin-ドメイン駆動設計の派生型)
- [03-02. Layeredアーキテクチャ型ドメイン駆動設計](#03-02-layeredアーキテクチャ型ドメイン駆動設計)
    - [:pushpin: 責務の分担方法](#pushpin-責務の分担方法)
- [03-03. Dependency Inversion Principle（依存性逆転の原則）](#03-03-dependency-inversion-principle依存性逆転の原則)
    - [:pushpin: DIPとは](#pushpin-dipとは)
    - [:pushpin: DIPに基づくドメイン駆動設計](#pushpin-dipに基づくドメイン駆動設計)
- [04-01. Application層](#04-01-application層)
    - [:pushpin: Controllerの責務](#pushpin-controllerの責務)
    - [:pushpin: Caster（データ構造変換クラス）の責務](#pushpin-casterデータ構造変換クラスの責務)
- [05-01. Domain層のRepository](#05-01-domain層のrepository)
- [05-02. Entity](#05-02-entity)
    - [:pushpin: 責務](#pushpin-責務)
    - [:pushpin: RouteEntityとは](#pushpin-routeentityとは)
- [05-03. ValueObject](#05-03-valueobject)
    - [:pushpin: 責務](#pushpin-責務-1)
    - [:pushpin: 一意に識別できるプロパティをもたず、対象のユビキタス言語に関するプロパティをメソッドを持つ](#pushpin-一意に識別できるプロパティをもたず対象のユビキタス言語に関するプロパティをメソッドを持つ)
    - [:pushpin: プロパティの不変性](#pushpin-プロパティの不変性)
    - [:pushpin: 概念的な統一体](#pushpin-概念的な統一体)
    - [:pushpin: オブジェクトの交換可能性](#pushpin-オブジェクトの交換可能性)
    - [:pushpin: オブジェクト間の等価性](#pushpin-オブジェクト間の等価性)
    - [:pushpin: メソッドによってオブジェクトの状態が変わらない](#pushpin-メソッドによってオブジェクトの状態が変わらない)
- [05-04. TypeCode（標準型）](#05-04-typecode標準型)
    - [:pushpin: 責務](#pushpin-責務-2)
    - [:pushpin: EnumによるTypeCodeの実装](#pushpin-enumによるtypecodeの実装)
- [05-05. Id](#05-05-id)
- [05-06. Service](#05-06-service)
- [06-01. Infrastructure層のRepository](#06-01-infrastructure層のrepository)
    - [:pushpin: 集約の構成、DBへのデータのCreate](#pushpin-集約の構成dbへのデータのcreate)
    - [:pushpin: DBにおけるデータのRead、集約の再構成](#pushpin-dbにおけるデータのread集約の再構成)
- [06-02. Factory](#06-02-factory)
    - [:pushpin: 責務](#pushpin-責務-3)

<!-- /TOC -->
## 01-01. Webページにおける処理の流れ

一例として、処理フローは、『(Vuex) ⇄ (AJAX )⇄ (DDD) ⇄  (DB) 』で実装される．

![Vuex と DDD-1](https://user-images.githubusercontent.com/42175286/58743936-d7519980-8475-11e9-83b2-0d10505206b9.png)

![Vuex と DDD-2](https://user-images.githubusercontent.com/42175286/58744171-a1aeaf80-8479-11e9-9844-f9beb6f13327.png)



## 02-01. MVCとは

ドメイン駆動設計が考案される以前、MVCの考え方が主流であった．

![MVCモデル](https://user-images.githubusercontent.com/42175286/57635646-8838e700-75e2-11e9-837d-253c006b7725.png)



### :pushpin: MVCからドメイン駆動設計への発展

しかし、特にModelの役割が抽象的過ぎたため、開発規模が大きくなるにつれて、Modelに役割を集中させ過ぎてしまうことがあった．それから、ドメイン駆動設計が登場したことによって、MVCは発展し、M・V・Cそれぞれの役割がより具体的で精密になった．



## 03-01. ドメイン駆動設計とは

### :pushpin: ドメインエキスパートとユビキタス言語

ドメインエキスパート（現実世界の業務内容に詳しく、また実際にシステムを使う人）と、エンジニアが話し合いながら、設計していく．設計の時、ドメインエキスパートとエンジニアの話し合いに齟齬が生まれぬように、ユビキタス言語（業務内容について共通の用語）を設定しておく．



### :pushpin: 戦略的設計

1. ドメインエキスパートと話し合い、現実世界の業務内容に含まれる『名詞』と『振舞』に着目．
2. 『名詞』と『振舞』を要素として、EntityやValueObjectを設計．
3. 設計されたEntityやValueObjectを用いて、ドメインモデリング（オブジェクト間の関連付け）を行う．



### :pushpin: 戦術的設計

戦略的設計を基に、各オブジェクトとオブジェクト間の関連性を実装していく．

![DDDの概念](https://user-images.githubusercontent.com/42175286/61179612-d305c800-a640-11e9-8c4a-3d31225af633.jpg)



### :pushpin: ドメイン駆動設計の派生型

現在までに、ドメイン駆動設計の派生型がいくつか提唱されている．

- **Layeredアーキテクチャ**

- **Hexagonalアーキテクチャ**

- **Onionアーキテクチャ**

  

## 03-02. Layeredアーキテクチャ型ドメイン駆動設計

### :pushpin: 責務の分担方法

![ドメイン駆動設計](https://user-images.githubusercontent.com/42175286/58724663-2ec11c80-8418-11e9-96e9-bfc6848e9374.png)

Layeredアーキテクチャ型ドメイン駆動設計において、MVCは、以下の4層に再編成できる．

- **User Interface層**
- **Application層**
- **Domain層（ビジネロジックをコード化）**
- **Infrastructure層（DBとマッピング）**



## 03-03. Dependency Inversion Principle（依存性逆転の原則）

### :pushpin: DIPとは

1. 上位のモジュールは、下位のモジュールに依存してはならない．どちらのモジュールも『抽象』に依存すべきである．
2. 『抽象』は実装の詳細に依存してはならない．実装の詳細が「抽象」に依存すべきである．



### :pushpin: DIPに基づくドメイン駆動設計

Repositoryの抽象クラスは、ドメイン層に配置する．そして、Repositoryの実装クラスはInfrastructure層に配置する．抽象クラスで抽象メソッドを記述することによって、実装クラスでの実装が強制される．つまり、実装クラスは抽象クラスに依存している．依存性逆転の原則に基づくことによって、ドメイン層への影響なく、Repositoryの交換が可能．

![ドメイン駆動設計_逆転依存性の原則](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ドメイン駆動設計_依存性逆転の原則.jpg)




## 04-01. Application層

### :pushpin: Controllerの責務

CRUDのReadの場合、以下のような処理手順を組み合わせて、Use case（使用事例）を実装する．

1. 最初に、リクエストによるJSON型データ送信を受け取る．
2. JSON型データを連想配列にパースする．
3. Repositoryのメソッドに連想配列を渡し、DBからオブジェクトデータをReadする．
4. Casterに、Readしたオブジェクトデータを渡し、連想配列に変換する．以下のCasterの説明を参照せよ．
5. 最後に、連想配列をJSON型データにパースし、JavaScriptに送信する．

![シリアライズとデシリアライズ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/シリアライズとデシリアライズ.png)

**【実装例】**

```PHP
class AcceptOrdersController
{
	// 単なるメソッドではなく、Use caseとなるようなメソッド
	public function acceptOrders()
	{
	
	}

}  
```

**【Use caseの例】**

オンラインショッピングにおけるUse case

![ユースケース図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ユースケース図.png)



### :pushpin: Caster（データ構造変換クラス）の責務



責務として、レスポンスによるデータ送信時に、オブジェクトデータ（Entity）を連想配列に変換する．

```PHP
// Entityを連想配列に変換するメソッド
private function castAcceptOrders(Array $toyOrderEntity)
{
  
}  
```



## 05-01. Domain層のRepository

リクエストによるデータ送信が行われる．Controllerは、Domain層の抽象メソッドをコールし、DBにおけるデータのCRUDを行う．DIPに基づくドメイン駆動設計の場合、Repositoryの抽象クラスを配置する．

```PHP
abstract class getDogToyEntityRepository
{

	// 対応する具象メソッドはInfrastructure層のRepositoryに実装．
	abstract public function arrayDogToyEntities();

}
```




## 05-02. Entity

### :pushpin: 責務

オブジェクトをEntityとしてモデリング／実装したいのならば、以下に条件を満たす必要がある．

（ユビキタス言語の例）顧客、注文など

1. 状態を変化させる必要があるプロパティをもつ．
2. オブジェクトにアイデンティティがあり、他のオブジェクトと同じ属性をもっていても、区別される． 

![ドメイン駆動設計_エンティティ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ドメイン駆動設計_エンティティ.jpg)

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
		Value $toyType,
		String $toyName,
		Int $number,
		priceVO $priceVO,
		ColorVO $colorVO
	)
	{
		$this->toyType $toyType,
		$this->toyName = $toyName,
		$this->number = $number,
		$this->priceVO = $priceVO,
		$this->colorVO = $colorVO
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
		)
	}
	
}
```



### :pushpin: RouteEntityとは

  EntityやValueObjectからなる集約の中で、最終的にアプリケーション層へレスポンスされる集約を、『RouteEntity』という．

![ドメイン駆動設計_集約関係](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ドメイン駆動設計_集約関係.jpg)

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



## 05-03. ValueObject

### :pushpin: 責務

EntityとValueObjectのどちらとして、オブジェクトモデルをモデリング／実装すべきなのかについて考える．そもそも、大前提として、『オブジェクトモデルはできるだけ不変にすべき』というベストプラクティスがあり、その結果、ValueObjectというが生まれたと考えられる．実は、ValueObjectを使わずに全てEntityとしてモデリング／実装することは可能である．しかし、不変にしてもよいところも可変になり、可読性や信頼性を下げてしまう可能性がある．

![ドメイン駆動設計_バリューオブジェクト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ドメイン駆動設計_バリューオブジェクト.jpg)

**【実装例】**

```PHP
/**
 * 支払情報オブジェクト
 */
class PaymentInfoVO
{
    // 予め実装したImmutableObjectトレイトを用いて、プロパティの不変性を実現
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

```



### :pushpin: 一意に識別できるプロパティをもたず、対象のユビキタス言語に関するプロパティをメソッドを持つ

金額、数字、電話番号、文字列、日付、氏名、色などのユビキタス言語に関するプロパティとメソッドを実装する場合、一意で識別できるプロパティ（例えば、```$id```プロパティ）をもたないオブジェクトに、これらの実装を部品としてまとめておくべきである．このオブジェクトを、ValueObjectという．

- **金額計算**

金額計算をController内処理やEntity内メソッドで行うのではなく、金額計算を行うValueObjectのメソッドとして分割する．

- **所要時間計算**

所要時間計算をController内処理やEntity内メソッドで行うのではなく、所要時間計算を行うValueObjectのメソッドとして分割する．



### :pushpin: プロパティの不変性

インスタンス化時に自動的に呼び出される```__construct()```を用いる．インスタンス化時に実行したい処理を記述できる．Setterを持たせずに、```__construct()```でのみ値の設定を行えば、ValueObjectのような、『Immutable』なオブジェクトを実現できる．

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

- **『Immutable』を実現できる理由**

Test01クラスインスタンスの```$property01```に値を設定するためには、インスタンスからSetterを呼び出す．Setterは何度でも呼び出せ、その度にプロパティの値を上書きできてしまう．

```PHP
$test01 = new Test01;

$test01->setProperty01("プロパティ01の値");

$test01->setProperty01("新しいプロパティ01の値");
```

一方で、Test02クラスインスタンスの```$property02```に値を設定するためには、インスタンスを作り直さなければならない．つまり、以前に作ったインスタンスの```$property02```の値は上書きできない．Setterを持たせずに、```__construct()```だけを持たせれば、『Immutable』なオブジェクトとなる．

```PHP
$test02 = new Test02("プロパティ02の値");

$test02 = new Test02("新しいプロパティ02の値");
```



### :pushpin: 概念的な統一体

```

```





### :pushpin: オブジェクトの交換可能性

オブジェクトが新しくインスタンス化された場合、以前に同一オブジェクトから生成されたインスタンスから新しく置き換える必要がある．



### :pushpin: オブジェクト間の等価性

全てのプロパティの値が他のVOと同じ場合、同一のVOと見なされる．

 

### :pushpin: メソッドによってオブジェクトの状態が変わらない

**【実装例1】**

```PHP
// （1）ドメイン層の氏名を扱うVO
class NameVO
{
		// （2）予め実装したImmutableObjectトレイトを用いて、プロパティの不変性を実現
    use ImmutableObject;

    // 苗字プロパティ
    private $lastName;
    
    // 名前プロパティ
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

同様に、Immutableトレイトを基に、VOを生成する．

```PHP
// ドメイン層の金額を扱うVO
class Money
{

}
```



## 05-04. TypeCode（標準型）

### :pushpin: 責務

一意に識別する必要がないユビキタス言語の中でも、特に『区分』や『種類』などは、ValueObjectとしてではなく、TypeCodeとしてモデリング／実装する．VOまたはEnumによって実装する．



### :pushpin: EnumによるTypeCodeの実装

**【実装例1】**

```PHP
class ColorVO extends Enum
{
	const RED = '1';
	const BLUE = '2';


	// 『self::定数名』で、定義の値へアクセスする．
	private $defs = [
		self::RED => ['colorname' => 'レッド'];
		self::BLUE => ['colorname' => 'ブルー'];
	];


	// 色値プロパティ
	private $colorValue;
	
	
	// 色名プロパティ．
	private $colorName;
	
	
	// インスタンス化の時に、『色の区分値』を受け取る．
	public function __construct
	(
        String $value
	)
	{
		// $kbnValueに応じて、色名をcolornameプロパティにセットする．
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



## 05-05. Id

- **実装例**





## 05-06. Service

他の３区分に分類できないもの（例：Id-Aを生成するId-B）．



## 06-01. Infrastructure層のRepository

### :pushpin: 集約の構成、DBへのデータのCreate

1. GETまたはPOSTによって、アプリケーション層から値が送信される．

2. Repositoryによって、送信された値からEntityやValueObjectを構成する．さらに、それらから集約を構成する．

3. Factoryによって、集約を加工する．

4. Repositoryによって、集約を連想配列に分解する．

5. DBのテーブルに挿入する．

   ![ドメイン駆動設計_リポジトリ_データ更新](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ドメイン駆動設計_リポジトリ_データ更新.png)

**【実装例】**

```PHP
// 集約の構成とデータ追加を行う．
class setDogToyEntityRepository
{
  // 接続先したいデータベースが設定されたプロパティ
	private $dbs;
  
	public function setDataSet(Request $request)
	{
  
		$dogToyEntity = new DogToyEntity;
  
  
		// 送信された値を取り出して格納し、集約を生成．
		$dogToyEntity->toyType = $request->xxx(),
		$dogToyEntity->toyName	= $request->xxx(),
		$dogToyEntity->number = $request->xxx(),
		$dogToyEntity->priceVO = $request->xxx(new PriceVO()),
		$dogToyEntity->colorVO = $request->xxx(new ColorVO()),
  
  
		// 集約を連想配列に分解する．
		$date = [
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



### :pushpin: DBにおけるデータのRead、集約の再構成

1. アプリケーション層から集約がリクエストされる．
2. DBのテーブルからデータをRead．
3. Repositoryによって、リクエストされたデータからEntityやValueObjectを構成する．さらに、それらから集約を構成する．
4. Factoryによって、集約を加工する．
5. 再構成された集約をアプリケーション層にレスポンス．

![ドメイン駆動設計_リポジトリ_データ取得](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ドメイン駆動設計_リポジトリ_データ取得.jpg)

**【実装例】**

```PHP
// データのReadと集約再構成を行う．
class getDogToyEntityRepository
{
  // 接続先したいデータベースが設定されたプロパティ
	private $dbs;


	// 連想配列データから『RouteEntity』の集約を構成し、レスポンスする．
	public function arrayDogToyEntities(): DogToyEntities
	{	
		$dogToyEntities = [];
		foreach($this->fetchDataSet() as $fetchedData){
			$dogToyEntities[] = $this->aggregateDogToyEntity($fetchedData)
		}
        
		return $toyOrderEntities;
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



## 06-02. Factory

### :pushpin: 責務

責務として、構成した集約関係を加工して新たな集約を再構成する．

- **実装例**

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
		isset($this->factory){
			$toyToyOrderEntity = //なんらかの集約処理;
			}
    
		return $toyOrderEntity;
	}
    
}
```
