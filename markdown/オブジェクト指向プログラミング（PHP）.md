# 01-01. カプセル化

### ◆ public

どのオブジェクトでも呼び出せる。



### ◆ protected

同じクラス内と、その親クラスまたは子クラスでのみ呼び出せる。



### ◆ private

同じオブジェクト内でのみ呼び出せる。

- **Encapsulation（カプセル化）**

カプセル化とは、システムの実装方法を外部から隠すこと。オブジェクト内のプロパティにアクセスするには、直接データを扱う事はできず、オブジェクト内のメソッドをコールし、アクセスしなければならない。

![カプセル化](https://user-images.githubusercontent.com/42175286/59212717-160def00-8bee-11e9-856c-fae97786ae6c.gif)

- **プロパティにアクセスできない時の**

### ◆ static

別ファイルでのメソッドの呼び出しにはインスタンス化が必要である。しかし、static修飾子をつけることで、インスタンス化しなくともコールできる。プロパティ値は用いず（静的）、引数の値のみを用いて処理を行うメソッドに対して用いる。

**【実装例】**

```PHP
// インスタンスを作成する集約メソッドは、プロパティ値にアクセスしないため、常に同一の処理を行う。
public static function aggregateDogToyEntity(Array $fetchedData)
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
// 受け取ったOrderエンティティから値を取り出すだけで、プロパティ値は呼び出していない。
public static function computeExampleFee(Entity $order): Money
{
	$money = new Money($order->exampleFee);
	return $money;
}
```



# 01-02. クラス間の関係性

![クラス図の線の種類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/クラス図の線の種類.png)



### ◆ Association（関連）



### ◆ Aggregation（集約）

【Tireクラス】

```
class Tire {}
```

【CarXクラス】

```PHP
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

```PHP
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

```PHP
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



### ◆ Composition（合成）

【Lockクラス】

```PHP
//Lockクラス定義
class Lock {}
```

【Keyクラス】

```PHP
//Keyクラス定義
class Key {

    public function __construct()
    {
    
    }
}
```

【Carクラス】

```PHP
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

```PHP
//エラーになる。$lockには直接アクセスできない。
$key = new Key($lock);
```



### ◆  Dependency（依存）※関連、集約、合成の依存性の違い

『Association ＞ Aggregation ＞ Composition』の順で、依存性が低い。

![Association, Aggregation, Compositionの関係の強さの違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Association, Aggregation, Compositionの関係の強さの違い.png)



### ◆ Generalization（汎化）

- **汎化におけるOverride**

汎化の時、子クラスでメソッドの処理内容を再び実装すると、処理内容は上書きされる。

【親クラス】

```PHP
// 通常クラス
class Goods
{
    // 商品名プロパティ
    private $name = "";

    // 商品価格プロパティ
    private $price = 0;

    // コンストラクタ。商品名と商品価格を設定する
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
// 通常クラス
class GoodsWithTax extends Goods
{
	// ★★★★★★注目★★★★★★
    // printPriceメソッドをOverride
    public function printPrice(): void
    {
        // 商品価格の税込み価格を計算し、表示
        $priceWithTax = round($this->getPrice() * 1.08);  // （1）
        print($this->getName()."の税込み価格: ￥".$priceWithTax."<br>");  // （2）
    }
}
```

- **抽象クラス**

ビジネスロジックとして用いる。多重継承できない。

  **【具体例1】**

以下の条件の社員オブジェクトを実装したいとする。

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

```PHP
// 抽象クラス。型として提供したいものを定義する。
abstract class ShainManagement
{
	// 定数の定義
	const TIME_TO_ARRIVE = strtotime('10:00:00');
	const TIME_TO_LEAVE = strtotime('19:00:00');
	

	// 具象メソッド。出勤時刻を表示。もし遅刻していたら、代わりに差分を表示。
	// 子クラスへそのまま継承される。子クラスでオーバーライドしなくても良い。
	public function toArrive()
	{
		$nowTime = strtotime( date('H:i:s') );
	
		// 出社時間より遅かった場合、遅刻と表示する。
		if($nowTime > self::TIME_TO_ARRIVE){
		
			return sprintf(
				"%s の遅刻です。",
                date('H時i分s秒', $nowTime - self::TIME_TO_ARRIVE)
			);
		}
		
		return sprintf(
            "%s に出勤しました。",
            date('H時i分s秒', $nowTime)
		);
	
	}
	
	
	// 抽象メソッド。
	// 処理内容を子クラスでOverrideしなければならない。
	abstract function toWork();
	
	
	// 具象メソッド。退社時間と残業時間を表示。
	// 子クラスへそのまま継承される。子クラスでオーバーライドしなくても良い。
	public function toLeave()
	{
		$nowTime = strtotime( date('H:i:s') );
		
		return sprintf(
            "%sに退社しました。%s の残業です。",
            date('H時i分s秒', $nowTime),
            date('H時i分s秒', $nowTime - self::TIME_TO_LEAVE)
		);
	}
}
```

```PHP
// 子クラス
class EnginnerShainManagement extend ShainManagement
{
	// 鋳型となった抽象クラスの抽象メソッドはOverrideしなければならない。
	public function toWork
	{
		// 処理内容；
	}
}
```

**【具体例2】**

プリウスと各世代プリウスが、抽象クラスと子クラスの関係にある。

![抽象クラス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/抽象クラス.png)



### ◆ Realization（実現）

実装クラスが正常に機能するために最低限必要なメソッドの実装を強制する。これによって、必ず実装クラスを正常に働かせることができる。

**【具体例】**

オープンソースのライブラリは、ユーザが実装クラスを自身で追加実装することも考慮して、Realizationが用いられている。

**【具体例】**

各車は、モーター機能を必ず持っていなければ、正常に働くことができない。そこで、モータ機能に最低限必要なメソッドの実装を強制する。

![インターフェースとは](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/インターフェースとは.png)

実装クラスに処理内容を記述しなければならない。すなわち、抽象クラスにメソッドの型のみ定義した場合と同じである。多重継承できる。

![子インターフェースの多重継承_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/子インターフェースの多重継承_2.png)

**【実装例】**

```PHP
// 鋳型
// コミュニケーションのメソッドの実装を強制するインターフェース
interface Communication
{
     // インターフェイスでは、実装を伴うメソッドやプロパティの宣言はできない
     public function talk();
     public function touch();
     public function gesture();
}
```

```PHP
// 機能箱
// 正常に機能するように、コミュニケーションのメソッドの実装を強制する。
class Human implements Communication
{
	// メソッドの処理内容を定義しなければならない。
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



### ◆ 通常クラス、抽象クラス、インターフェースの違い

|                              |    通常クラス    |    抽象クラス    |                       インターフェース                       |
| ---------------------------- | :--------------: | :--------------: | :----------------------------------------------------------: |
| **役割**                     | 専用処理の部品化 | 共通処理の部品化 | 実装クラスが正常に機能するために最低限必要なメソッドの実装を強制 |
| **子クラスでの継承先数**     |     単一継承     |     単一継承     |                      単一継承｜多重継承                      |
| **メンバ変数のコール**       |   自身と継承先   |    継承先のみ    |                          実装先のみ                          |
| **定数の定義**               |        〇        |        〇        |                              〇                              |
| **抽象メソッドの定義**       |        ✕         |        〇        |                              〇                              |
| **具象メソッドの定義**       |        〇        |        〇        |                              ✕                               |
| **```construct()``` の定義** |        〇        |        〇        |                              ✕                               |

**【具体例】**

1. 種々の車クラスの共通処理のをもつ抽象クラスとして、Carクラスを作成。
2. 各車は、エンジン機能を必ず持っていなければ、正常に働くことができない。そこで、エンジン機能に最低限必要なメソッドの実装を強制する。

![インターフェースと抽象クラスの使い分け](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/インターフェースと抽象クラスの使い分け.png)



### ◆ Trait（※php独自の機能）

再利用したいメソッドやプロパティを部品化し、利用したい時にクラスに取り込む。Traitを用いるときは、クラス内でTraitをuse宣言する。Trait自体は不完全なクラスであり、インスタンス化できない。

![トレイト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/トレイト.png)







# 01-03. メソッド

### ◆ メソッドの実装手順

1. その会社のシステムで使われているライブラリ
2. PHPのデフォルト関数（引用：PHP関数リファレンス，https://www.PHP.net/manual/ja/funcref.PHP）
3. 新しいライブラリ



### ◆ 値を取得するアクセサメソッドの実装

Getterでは、プロパティを取得するだけではなく、何かしらの処理を加えたうえで取得すること。

**【実装例】**

```PHP
class ABC {

    private $property; 

    public function getEditProperty()
    {
        // 単なるGetterではなく、例外処理も加える。
        if(!isset($this->property){
            throw new ErrorException('プロパティに値がセットされていません。')
        }
        return $this->property;
    }

}
```



### ◆ 値を設定するアクセサメソッドの実装

- **Setter**

『Mutable』なオブジェクトを実現できる。

**【実装例】**

```PHP
class Test01 {

    private $property01;

	// Setterで$property01に値を設定
    public function setProperty($property01)
    {
        $this->property01 = $property01;
    }
    
}    
```

- **マジックメソッドの```__construct()```**

Setterを持たせずに、```__construct()```だけを持たせれば、ValueObjectのような、『Immutable』なオブジェクトを実現できる。

**【実装例】**

```PHP
class Test02 {

    private $property02;

	// コンストラクタで$property02に値を設定
    public function __construct($property02)
    {
        $this->property02 = $property02;
    }
    
}
```
- **『Mutable』と『Immutable』を実現できる理由**

Test01クラスインスタンスの```$property01```に値を設定するためには、インスタンスからSetterをコールする。Setterは何度でも呼び出せ、その度にプロパティの値を上書きできる。

```PHP
$test01 = new Test01

$test01->setProperty01("プロパティ01の値")

$test01->setProperty01("新しいプロパティ01の値")
```

一方で、Test02クラスインスタンスの```$property02```に値を設定するためには、インスタンスを作り直さなければならない。つまり、以前に作ったインスタンスの```$property02```の値は上書きできない。Setterを持たせずに、```__construct()```だけを持たせれば、『Immutable』なオブジェクトとなる。

```PHP
$test02 = new Test02("プロパティ02の値")

$test02 = new Test02("新しいプロパティ02の値")
```



### ◆ メソッドチェーン

以下のような、オブジェクトAを最外層とした関係が存在しているとする。

【オブジェクトA（オブジェクトBをプロパティに持つ）】

```PHP
class Obj_A{
	private $objB;
	
	// 返却値のデータ型を指定
	public function getObjB(): ObjB
	{
		return $this->objB;
	}
}
```

【オブジェクトB（オブジェクトCをプロパティに持つ）】

```PHP
class Obj_B{
	private $objC;
 
	// 返却値のデータ型を指定
	public function getObjC(): ObjC
	{
		return $this->objC;
	}
}
```

【オブジェクトC（オブジェクトDをプロパティに持つ）】

```PHP
class Obj_C{
	private $objD;
 
 	// 返却値のデータ型を指定
	public function getObjD(): ObjD
	{
		return $this->objD;
	}
}
```

以下のように、返却値のオブジェクトを用いて、より深い層に連続してアクセスしていく場合…

```PHP
$ObjA = new Obj_A;

$ObjB = $ObjA->getObjB();

$ObjC = $B->getObjB();

$ObjD = $C->getObjD();
```

以下のように、メソッドチェーンという書き方が可能。

```PHP
$D = getObjB()->getObjC()->getObjC();

// $D には ObjD が格納されている。
```



### ◆ マジックメソッド（Getter系）

オブジェクトに対して特定の操作が行われた時に自動的にコールされる特殊なメソッドのこと。自動的に呼び出される仕組みは謎。共通の処理を行うGetter（例えば、値を取得するだけのGetterなど）を無闇に増やしたくない場合に用いることで、コード量の肥大化を防ぐことができる。PHPには最初からマジックメソッドは組み込まれているが、自身で実装した場合、オーバーライドされてコールされる。

- **```__get()```**

定義されていないプロパティや、アクセス権のないプロパティを取得しようとした時に、代わりに呼び出される。メソッドは定義しているが、プロパティは定義していないような状況で用いる。

```PHP
class Example
{

	private $example = [];
	
	// 引数と返却値のデータ型を指定
	public function __get(String $name): String
	{
		echo "{$name}プロパティは存在しないため、プロパティ値を取得できません。"
	}

}
```

```PHP
// 存在しないプロパティを取得。
$example = new Example();
$example->hoge;

// 結果
hogeプロパティは存在しないため、値を呼び出せません。
```

- **```__call()```**

定義されていないメソッドや、アクセス権のないメソッドを取得しようとした時に、代わりにコールされる。プロパティは定義しているが、メソッドは定義していないような状況で用いる。

- **```__callStatic()```**



### ◆ マジックメソッド（Setter系）

定義されていないstaticメソッドや、アクセス権のないstaticメソッドを取得しようとした時に、代わりに呼び出される。自動的にコールされる仕組みは謎。共通の処理を行うSetter（例えば、値を設定するだけのSetterなど）を無闇に増やしたくない場合に用いることで、コード量の肥大化を防ぐことができる。PHPには最初からマジックメソッドは組み込まれているが、自身で実装した場合、オーバーライドされて呼び出される。

- **```__set()```**

定義されていないプロパティや、アクセス権のないプロパティに値を設定しようとした時に、代わりにコールされる。オブジェクトの不変性を実現するために使用される。（詳しくは、ドメイン駆動設計のノートを参照せよ）

```PHP
class Example
{

	private $example = [];
	
	// 引数と返り値のデータ型を指定
	public function __set(String $name, String $value): String
    {
    	echo "{$name}プロパティは存在しないため、{$value}を設定できません。"
    }

}
```

```PHP
// 存在しないプロパティに値をセット。
$example = new Example();
$example->hoge = "HOGE";

// 結果
hogeプロパティは存在しないため、HOGEを設定できません。
```

- **マジックメソッドの```__construct()```**

インスタンス化時に自動的に呼び出されるメソッド。インスタンス化時に実行したい処理を記述できる。Setterを持たせずに、```__construct()```でのみ値の設定を行えば、ValueObjectのような、『Immutable』なオブジェクトを実現できる。

**【実装例】**

```PHP
class Test02 {

    private $property02;

	// コンストラクタで$property02に値を設定
    public function __construct($property02)
    {
        $this->property02 = $property02;
    }
    
}
```

- **【『Mutable』と『Immutable』を実現できる理由】**

Test01クラスインスタンスの```$property01```に値を設定するためには、インスタンスからSetterをコールする。Setterは何度でもコールでき、その度にプロパティの値を上書きできる。

```PHP
$test01 = new Test01

$test01->setProperty01("プロパティ01の値")
PHP
$test01->setProperty01("新しいプロパティ01の値")
```

一方で、Test02クラスインスタンスの```$property02```に値を設定するためには、インスタンスを作り直さなければならない。つまり、以前に作ったインスタンスの```$property02```の値は上書きできない。Setterを持たせずに、```__construct()```だけを持たせれば、『Immutable』なオブジェクトとなる。

```PHP
$test02 = new Test02("プロパティ02の値")

$test02 = new Test02("新しいプロパティ02の値")
```



### ◆ **Recursive call：再帰的プログラム**

自プログラムから自身自身をコールし、実行できるプログラムのこと。

**【具体例】**

ある関数 ``` f  ```の定義の中に ``` f ```自身を呼び出している箇所がある。

![再帰的](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/再帰的.png)

**【実装例】**

クイックソートのアルゴリズム（※詳しくは、別ノートを参照）

1. 適当な値を基準値（Pivot）とする （※できれば中央値が望ましい）
2. Pivotより小さい数を前方、大きい数を後方に分割する。
3. 二分割された各々のデータを、それぞれソートする。
4. ソートを繰り返し実行する。

```PHP
function quickSort(Array $array): Array 
{
	// 配列の要素数が一つしかない場合、クイックソートする必要がないので、返却する。
	if (count($array) <= 1) {
		return $array;
	}

	// 一番最初の値をPivotとする。
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

    // 処理の周回ごとに、結果の配列を結合。
	return array_merge
	(
		// 左のグループを再帰的にクイックソート。
		quickSort($left),
		
		// Pivotを結果に組み込む。
		array($pivot),
		
		// 左のグループを再帰的にクイックソート。
		quickSort($right)
	);

}
```

```PHP
// 実際に使ってみる。
$array = array(6, 4, 3, 7, 8, 5, 2, 9, 1);
$result = quickSort($array);
var_dump($result); 

// 昇順に並び替えられている。
1, 2, 3, 4, 5, 6, 7, 8 
```



### ◆ プロパティを用いた処理結果の保持

大量のデータを集計するメソッドは、その処理に時間がかかる。そこで、そのようなメソッドでは、一度コールされて集計を行った後、プロパティに返却値を保持しておく。そして、再びコールされた時には、返却値をプロパティから取り出す。

```PHP
public cachedResult;

public funcCollection;


public function callFunc__construct()
{
	$this->funcCollection = $this->funcCollection()
}


// 返却値をキャッシュしたいメソッドをあらかじめ登録しておく。
public function funcCollection()
{
  return  [
    'computeProfit' => [$this, 'computeProfit']
  ];
}


// 集計メソッド
public function computeProfit()
{
	// 時間のかかる集計処理;
}


// cacheプロパティに配列が設定されていた場合に値を設定し、設定されていた場合はそのまま使う。
public function cachedResult($funcName)
{
  if(!isset($this->cachedResult[$funcName]){
    
    // Collectionに登録されているメソッド名を出力し、call_user_funcでメソッドをコールする。
    $this->cachedResult[$funcName] = call_user_func($this->funcCollection[$funcName])
  }
  return $this->cachedResult[$funcName];
}
```



# 01-04. 無名関数

### ◆ Closure（無名関数）の定義、変数格納後のコール

- **```use()```のみに引数を渡す場合**

```PHP
$item = new Item;

// 最初の括弧を用いないことで、普段よくやっている値渡しのメソッドを定義しているのと同じになる。
// use()に、親メソッド（$optionName）のスコープの$itemを渡す。
$optionName = function() use($item){
								$item->getOptionName();
							});
	
// function()には引数が設定されていないので、コール時に引数は不要。
echo $optionName;
  
// 出力結果
// オプションA
```

- **```function()```と```use()```に引数を渡す場合**

```PHP
$item = new Item;

// 最初の括弧を用いないことで、普段よくやっている値渡しのメソッドを定義しているのと同じになる。
// 親メソッド（$optionName）のスコープの$itemを、use()に渡す。
$optionName = function($para) use($item){
								$item->getOptionName().$para;
							};
	
// コール時に、$paramをfunction()に渡す。
echo $optionName("BC");
  
// 出力結果
// オプションABC
```

- **プロパティの値に無名関数を格納しておく裏技**

```PHP
$item = new Item;

// 最初の括弧を用いないことで、普段よくやっている値渡しのメソッドを定義しているのと同じになる。
// use()に、親メソッドのスコープの$itemを渡す。
// function()に、コール時に新しく$paramを渡す。
$option = new Option;

// プロパティの値に無名関数を格納する。
$option->name = function($para) use($item){
									$item->getOptionName().$para;
								};
	
// コール時に、$paramをfunction()に渡す。
echo $option->name("BC");

// 出力結果
// オプションABC
```



### ◆ Closure（無名関数）の定義と即コール

定義したその場でコールされる無名関数を『即時関数』と呼ぶ。無名関数をコールしたい時は、```call_user_func()```を用いる。

```PHP
$item = new Item;

// use()に、親メソッドのスコープの$itemを渡す。
// 無名関数を定義し、同時にcall_user_func()で即コールする。さらに、$paramをfunction()に渡す。
$optionName = call_user_func(function("BC") use($item){
                                  $item->getOptionName().$para;
                               });
	
// $paramはすでに即コール時に渡されている。
// これはコールではなく、即コール時に格納された返却値の出力。
echo $optionName;

// 出力結果
// オプションABC
```



### ◆ 高階関数とClosure（無名関数）の組み合わせ

関数を引数として受け取ったり、関数自体を返したりする関数を『高階関数』と呼ぶ。

- **無名関数を用いない場合**

**【実装例】**

```PHP
// 第一引数のみの場合

// 高階関数を定義
function test($callback)
{
    echo $callback();
}

// コールバックを定義
// 関数の中でコールされるため、「後で呼び出される」という意味合いから、コールバック関数といえる。
function callbackMethod()：String
{
    return "出力に成功しました。";
}

// 高階関数の引数として、コールバック関数を渡す
test("callbackMethod");

// 出力結果
// 出力に成功しました。
```

```PHP
// 第一引数と第二引数の場合

// 高階関数を定義
public function higher-order($param, $callback)
{
    return $callback($param);
}

// コールバック関数を定義
public function callbackMethod($param)
{
    return $param."の出力に成功しました。";
}
 
// 高階関数の第一引数にコールバック関数の引数、第二引数にコールバック関数を渡す
higher-order("第一引数", "callbackMethod");

// 出力結果
// 第一引数の出力に成功しました。
```

- **無名関数を用いる場合**

**【実装例】**

```PHP
// 高階関数のように、関数を引数として渡す。
public function higher-order($parentVar, $callback)
{
	$parentVar = "&親メソッドのスコープの変数"
	return $callback($parentVar)
}

// 第二引数の無名関数。関数の中でコールされるため、「後でコールされる」という意味合いから、コールバック関数といえる。
// コールバック関数は再利用されないため、名前をつけずに無名関数とすることが多い。
// 親メソッドのスコープで定義されている変数を引数として渡す。（普段よくやっている値渡しと同じ）
high-order($parentVar, function() use($parentVar)
        {
            return $parentVar."の出力に成功しました。";
        }
	)
	
// 出力結果
// 親メソッドのスコープの変数の出力に成功しました。	
```



### ◆ 高階関数を使いこなす！

```PHP
/**
 * @var Array
 */
protected $properties;

// 非無名メソッドあるいは無名メソッドを引数で渡す。
public function Shiborikomi($callback)
{
	if (!is_callable($callback)) {
	throw new \LogicException;
	}

	// 自身が持つ配列型のプロパティを加工し、再格納する。
	$properties = [];
	foreach ($this->properties as $property) {
        
		// 引数の無名関数によって、プロパティに対する加工方法が異なる。
		// 例えば、判定でTRUEのもののみを返すメソッドを渡すと、自プロパティを絞り込むような処理を行える。
		$returned = call_user_func($property, $callback);
		if ($returned) {
		
			// 再格納。
			$properties[] = $returned;
		}
	}

	// 他のプロパティは静的に扱ったうえで、自身を返す。
	return new static($properties);
}
```



# 01-05. 継承におけるクラスチェーン

クラスからプロパティやメソッドをコールした時、そのクラスにこれらが存在しなければ、継承元まで辿る仕組みを『クラスチェーン』という。プロトタイプベースのオブジェクト指向で用いられるプロトタイプチェーンについては、別ノートを参照せよ。

```PHP
// 継承元クラス
class Example
{
	public value;
  
	public function getValue()
	{
		return $this->value1; 
	}  
}
```

```PHP
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
$subExample = new SubExample;

// SubExampleクラスにはgetValue()は無い。
// 継承元まで辿り、Exampleクラスからメソッドがコールされる（クラスチェーン）。
echo $subExample->getValue()
```



# 01-06. 外部クラスとメソッドの読み込み

### ◆ ```use```によるクラスとメソッドの読み込み

PHPでは、```use```によって、外部ファイルの名前空間、クラス、メソッド、定数を読み込める。ただし、動的な値は持たず、静的に読み込むことに注意。しかし、チームの各エンジニアが好きな物を読み込んでいたら、スパゲッティコードになりかねない。そこで、チームでの開発では、記述ルールを設けて、```use```で読み込んで良いものを決めておくと良い。

**【以下で読み込まれるクラスの実装例】**

```PHP
// 名前空間を定義。
namespace Domain/Entity1;

// 定数を定義。
const VALUE = "これは定数です。"

class Example1
{
	public function className()
	{
		return "example1メソッドです。";
	}
}
```

- **名前空間の読み込み**

```PHP
// use文で名前空間を読み込む。
use Domain/Entity2

namespace Domain/Entity2;

class Example2
{
	// 名前空間を読み込み、クラスまで辿り、インスタンス作成。
	$e1 = new Entity1/E1:
	echo $e1;
}
```

- **クラスの読み込み**

```PHP
// use文でクラス名を読み込む。
use Domain/Entity1/E1;

namespace Domain/Entity2;

class Example2
{
	// 名前空間を読み込み、クラスまで辿り、インスタンス作成。
	$e1 = new E1;
	echo $e1;
}
```

- **メソッドの読み込み**

```PHP
// use文でメソッドを読み込む。
use Domain/Entity1/E1/className;

namespace Domain/Entity2;

class Eeample2
{
	// Example1クラスのclassName()をコール。
	echo className();
}
```

- **定数の読み込み**

```PHP
// use文で定数を読み込む。
use Domain/Entity1/E1/VALUE;

namespace Domain/Entity2;

class Example2
{
	// Example1クラスの定数を出力。
	echo VALUE;
}
```



### ◆ 親クラスの静的メソッドの読み込み

```PHP
abstract class Example 
{
	public function example()
	{
		// 処理内容;
	}
}
```

```PHP
class SubExample extends Example
{
	public function subExample()	
	{
		// 親メソッドの静的メソッドを読み込む
		$example = parent::example();
	} 
}
```



# 02-01. データ構造

処理において、データの集合を効率的に扱うためのデータ格納形式のこと。

### ◆ Array型

- **多次元配列**

中に配列をもつ配列のこと。配列の入れ子構造が２段の場合、『二次元配列』と呼ぶ。

```PHP
Array
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

- **連想配列**

中に配列をもち、キーに名前がついている（赤、緑、黄、果物、野菜）ような配列のこと。下の例は、二次元配列かつ連想配列である。

```PHP
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

- **配列内の要素の走査（スキャン）**

配列内の要素を順に調べていくことを『走査（スキャン）』という。例えば、```foreach()```は、配列内の全ての要素を走査する処理である。下図では、連想配列が表現されている。

![配列の走査](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/配列の走査.png)

- **内部ポインタを用いた配列要素の出力**

『内部ポインタ』とは、配列において、参照したい要素を位置で指定するためのカーソルのこと。

```PHP
$array = array("あ", "い", "う");

// 内部ポインタが現在指定している要素を出力。
echo current($array); // あ

// 内部ポインタを一つ進め、要素を出力。
echo next($array); // い

// 内部ポインタを一つ戻し、要素を出力。
echo prev($array); // あ

// 内部ポインタを最後まで進め、要素を出力。
echo end($array); // う

// 内部ポインタを最初まで戻し、要素を出力
echo reset($array); // あ
```



### ◆ List型

配列の要素一つ一つを変数に格納したい場合、List型を使わなければ、冗長ではあるが、以下のように実装する必要がある。

```PHP
$array = array("あ", "い", "う");
$a = $array[0];
$i = $array[1];
$u = $array[2];

echo $a.$i.$u; // あいう
```

しかし、以下の様にList型を使うことによって、複数の変数への格納を一行で実装することができる。

```PHP
list($a, $i, $u) = array("あ", "い", "う")

echo $a.$i.$u; // あいう
```

- **単方向List**

![p555-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/p555-1.gif)

- **双方向List**

![p555-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/p555-2.gif)

- **循環List**

![p555-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/p555-3.gif)



### ◆ Object型

```PHP
Fruit Object
(
	[id:private] => 1
	[name:private] => リンゴ
	[price:private] => 100
)
```



### ◆ Queue型

![Queue1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Queue1.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/矢印_80x82.jpg)

 

![Queue2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Queue2.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/矢印_80x82.jpg)

 

![Queue3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Queue3.gif)

PHPでは、```array_push()```と```array_shift()```を組み合わせることで実装できる。

```PHP
$array = array("Blue", "Green");

// 引数を、配列の最後に、要素として追加する。
array_push($array, "Red");
print_r($array);

// 出力結果

//	Array
//	(
//		[0] => Blue
//		[1] => Green
//		[2] => Red
//	)

// 配列の最初の要素を取り出す。
$theFirst= array_shift($array);
print_r($array);

// 出力結果

//	Array
//	(
//    [0] => Green
//    [1] => Red
//	)

// 取り出された値の確認
echo $theFirst // Blue
```



### ◆ Stack型

PHPでは、```array_push()```と```array_pop()```で実装可能。

![Stack1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Stack1.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/矢印_80x82.jpg)

 

![Stack2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Stack2.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/矢印_80x82.jpg)

 

![Stack3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/Stack3.gif)

### ◆ ツリー構造

- **二分探索木**

  各ノードにデータが格納されている。

![二分探索木](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/二分探索木1.gif)



- **ヒープ**

  Priority Queueを実現するときに用いられる。各ノードにデータが格納されている。

![ヒープ1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ヒープ1.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/矢印_80x82.jpg)

![ヒープ1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ヒープ2.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/矢印_80x82.jpg)

![ヒープ2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ヒープ3.gif)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/矢印_80x82.jpg)

![. ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/ヒープ4.gif)



# 02-02 データ型

### ◆ Boolean型

- **Falseの定義**

| データの種類 | 説明                     |
| ------------ | ------------------------ |
| ```$var =``` | 何も格納されていない変数 |
| ```False```  | 文字としてのFalse        |
| ```0```      | 数字、文字列             |
| ```""```     | 空文字                   |
| array()      | 要素数が0個の配列        |
| NULL         | NULL値                   |

- **Trueの定義**

上記の値以外は、全て TRUEである。



### ◆ Date型

厳密にはデータ型ではないが、便宜上、データ型とする。タイムスタンプとは、協定世界時(UTC)を基準にした1970年1月1日の0時0分0秒からの経過秒数を表したもの。

| フォーマット         | 実装方法            | 備考                                                         |
| -------------------- | ------------------- | ------------------------------------------------------------ |
| 日付                 | 2019-07-07          | 区切り記号なし、ドット、スラッシュなども可能                 |
| 時間                 | 19:07:07            | 区切り記号なし、も可能                                       |
| 日付と時間           | 2019-07-07 19:07:07 | 同上                                                         |
| タイムスタンプ（秒） | 1562494027          | 1970年1月1日の0時0分0秒から2019-07-07 19:07:07 までの経過秒数 |



# 03-01. 定数

### ◆ 定数が有効な場面

計算処理では、可読性の観点から、できるだけ数値を直書きしない。数値に意味合いを持たせ、定数として扱うと可読性が高くなる。例えば、ValueObjectにおける定数がある。

```PHP
class requiedTime
{
  // 判定値、歩行速度の目安、車速度の目安、を定数で定義する。
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
    if ($this->distance * 1000 / self::WALKING_SPEED_PER_MINUTE < self::JUDGMENT_MINUTE){
      return true; 
    }

    return false;
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



# 03-02. 変数

### ◆ 変数展開

文字列の中で、変数の中身を取り出すことを『変数展開』と呼ぶ。

※Paizaで検証済み。

- **シングルクオーテーションによる変数展開**

シングルクオーテーションの中身は全て文字列として認識され、変数は展開されない。

```PHP
$fruit = "リンゴ";

// 出力結果
echo 'これは$fruitです。'; // これは、$fruitです。
```

- **シングルクオーテーションと波括弧による変数展開**

シングルクオーテーションの中身は全て文字列として認識され、変数は展開されない。

```PHP
$fruit = "リンゴ";

// 出力結果
echo 'これは{$fruit}です。'; // これは、{$fruit}です。
```

- **ダブルクオーテーションによる変数展開**

変数の前後に半角スペースを置いた場合にのみ、変数は展開される。（※半角スペースがないとエラーになる）

```PHP
$fruit = "リンゴ";

// 出力結果
echo "これは $fruit です。"; // これは リンゴ です。
```

- **ダブルクオーテーションと波括弧による変数展開**

波括弧を用いると、明示的に変数として扱うことができる。これによって、変数の前後に半角スペースを置かなくとも、変数は展開される。

```PHP
$fruit = "リンゴ";

// 出力結果
echo "これは{$fruit}です。"; // これは、リンゴです。
```



### ◆ 参照渡しと値渡し

- **参照渡し**

「参照渡し」とは、変数に代入した値の参照先（メモリアドレス）を渡すこと。

```PHP
$value = 1;
$result = &$value; // 値の入れ物を参照先として代入
```

**【実装例】**```$b```には、```$a```の参照によって10が格納される。

```PHP
$a = 2;
$b = &$a;  // 変数aを&をつけて代入
$a = 10;    // 変数aの値を変更

// 出力結果
echo $b; // 10
```

- **値渡し**

「値渡し」とは、変数に代入した値のコピーを渡すこと。

```PHP
$value = 1;
$result = $value; // 1をコピーして代入
```

**【実装例】**```$b```には、```$a```の一行目の格納によって2が格納される。

```PHP
$a = 2;
$b = $a;  // 変数aを代入
$a = 10;  // 変数aの値を変更


// 出力結果
echo $b; // 2
```



# 03-03. 演算子

### ◆ 等価演算子を用いたインスタンスの比較

- **イコールが2つの場合**

同じオブジェクトから別々に作られたインスタンスであっても、『同じもの』として認識される。

```PHP
class Example {};

if(new Example == new Example){
	echo '同じです';
} else { echo '異なります' }

// 実行結果
同じです
```

- **イコールが3つの場合**

同じオブジェクトから別々に作られたインスタンスであっても、『異なるもの』として認識される。

```PHP
class Example {};

if(new Example === new Example){
	echo '同じです';
} else { echo '異なります' }

// 実行結果
異なります
```

同一のインスタンスの場合のみ、『同じもの』として認識される。

```PHP
class Example {};

$a = $b = new Example;

if($a === $b){
	echo '同じです';
} else { echo '異なります' }

// 実行結果
同じです
```



### ◆ キャスト演算子

**【実装例】**

```PHP
$var = 10;　// $varはInt型。

// キャスト演算子でデータ型を変換
$var = (string) $var; // $varはString型
```

**【その他のキャスト演算子】**

```PHP
// Int型
$var = (int) $var;
(integer)

// Boolean型
$var = (bool) $var;
(boolean)

// Float型
$var = (float) $var;
(double)
(real)

// Array型
$var = (array) $var;

// Object型
$var = (object) $var;
```



### ◆ 正規表現とパターン演算子

- **正規表現を用いた文字列検索**

```PHP

```

- **オプションとしてのパターン演算子**

```PHP
// jpegの大文字小文字
preg_match('/jpeg$/i', $x);
```



# 04-01. 条件式

### ◆ ```if```-```else```はできるだけ用いない

- **```if```-```else```を用いた場合**

可読性が悪いため、避けるべき。

```PHP
// マジックナンバーを使わずに、定数として定義
const noOptionItem = 0;

// RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す。
if(!empty($routeEntity->options) {
    foreach ($routeEntity->options as $option) {
    
    	// if文を通過した場合、メソッドの返却値が格納される。
        // 通過しない場合、定数が格納される。
        if ($option->isOptionItemA()) {
            $result['optionItemA'] = $option->optionItemA();
		} else {
			$result['optionItemA'] = noOptionItem;
			}
		
        if ($option->isOptionItemB()) {
            $result['optionItemB'] = $option->optionItemB();
		} else {
			$result['optionItemB'] = noOptionItem;
			}
			
        if ($option->isOptionItemC()) {
            $result['optionItemC'] = $option->optionItemC();
		} else {
			$result['optionItemC'] = noOptionItem;
			}		
	};
}

return $result;
```

- **初期値と上書きのロジックを用いた場合**

よりすっきりした書き方になる。

```PHP
// マジックナンバーを使わずに、定数として定義
const noOptionItem = 0;

// 初期値0を設定
$result['optionItemA'] = noOptionItem;
$result['optionItemB'] = noOptionItem;
$result['optionItemC'] = noOptionItem;

// RouteEntityからoptionsオブジェクトに格納されるoptionオブジェクト配列を取り出す。
if(!empty($routeEntity->options) {
    foreach ($routeEntity->options as $option) {
    
		// if文を通過した場合、メソッドの返却値によって初期値0が上書きされる。
        // 通過しない場合、初期値0が用いられる。
        if ($option->isOptionItemA()) {
            $result['optionItemA'] = $option->optionItemA();
		}
		
        if ($option->isOptionItemB()) {
            $result['optionItemB'] = $option->optionItemB();
		}		

        if ($option->isOptionItemC()) {
            $result['optionItemC'] = $option->optionItemC();
		}
	};
}

return $result;
```



### ◆ ```if```-```elseif```-```else```と```switch```-```case```-```break```

**【実装例】**

曜日を判定し、文字列を出力する。

- **```if```-```elseif```-```else```**

```PHP
// 変数に Tue を格納
$weeks = 'Tue';
 
// if文でTueに該当したら'火曜日'と表示する。
if ($weeks == 'Mon') {
  echo '月曜日';
} else if($weeks == 'Tue'){
  echo '火曜日';
} else if($weeks == 'Wed'){
  echo '水曜日';
} else if($weeks == 'Thu'){
  echo '木曜日';
} else if($weeks == 'Fri'){
  echo '金曜日';
} else if($weeks == 'Sat'){
  echo '土曜日';
} else {
  echo '日曜日';
}

// 実行結果
火曜日
```

- **```switch```-```case```-```break```**

```PHP
// 変数に Tue を格納
$weeks = 'Tue';
 
// 条件分岐でTueに該当したら'火曜日'と表示する。breakでif文を抜けなければ、全て実行されてしまう。
switch ($weeks) {
  case 'Mon':
    echo '月曜日';
    break;
  case 'Tue':
    echo '火曜日';
    break;
  case 'Wed':
    echo '水曜日';
    break;
  case 'Thu':
    echo '木曜日';
    break;
  case 'Fri':
    echo '金曜日';
    break;
  case 'Sat':
    echo '土曜日';
    break;
  case 'Sun':
    echo '日曜日';
    break;
}

// 実行結果
火曜日
```



### ◆ ```if```-```elseif```-```else```はできるだけ用いない

- **決定表を用いた条件分岐の整理**

**【実装例】**

うるう年であるかを判定し、文字列を出力する。以下の手順で設計と実装を行う。

1. 条件分岐の処理順序の概要を日本で記述する。
2. 記述内容を、条件部と動作部に分解し、決定表で表す。
3. 決定表を、流れ図で表す。

![決定表](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/決定表.png)

- **```if```-```elseif```-```else```を用いた場合**

可読性が悪いため、避けるべき。

```PHP
// 西暦を格納する。
$year = N;
```

```PHP
public function leapYear(Int $year): String
{

    // (5)
    if($year <= 0){
        throw new Exception("負の数は判定できません。");

    // (4)
    } elseif($year % 4 != 0 ){
        return "平年";

    // (3)
    } elseif($year % 100 != 0){
        return "うるう年";

    // (2)
    } elseif($year % 400 != 0){
        return "平年";

    // (1)
    } else{
    	return "うるう年";
    	
    }
}
```

- **```if```と```return```を用いた場合**

```return```を用いることで、```if```が入れ子状になることを防ぐことができる。

```PHP
// 西暦を格納する。
$year = N;
```

```PHP
public function leapYear(Int $year): String
{

    // (5)
    if($year <= 0){
    	throw new Exception("負の数は判定できません。");
    }

    // (4)
    if($year % 4 != 0 ){
    	return "平年";
    }

    // (3)
    if($year % 100 != 0){
    	return "うるう年";
    }

    // (2)
    if($year % 400 != 0){
    	return "平年";
    }

    // (1)
    return "うるう年";
    
}
```

- **```switch```-```case```-```break```を用いた場合**

```switch```-```case```-```break```によって、実装に、『◯◯の場合に切り換える』という意味合いを持たせられる。ここでは、メソッドに実装することを想定して、```break```ではなく```return```を用いている。

```PHP
public function leapYear(Int $year): String
{
	switch(true) {
    
    // (5)
    case($year <= 0)
    	throw new Exception("負の数は判定できません。");

    // (4)
		case($year % 4 != 0 ):
    	return "平年";

    // (3)
    case($year % 100 != 0):
    	return "うるう年";

    // (2)
    case($year % 400 != 0):
    	return "平年";

    // (1)
    dafault:
    	"うるう年";
	}
      
}
```



### ◆ オブジェクトごとにプロパティの値の有無が異なる時の出力

```PHP
// 全てのオブジェクトが必ず持っているわけではなく、
$csv['オリコ払い'] = $order->oricoCondition ? $order->oricoCondition->

// 全てのオブジェクトが必ず持っているプロパティの場合には不要
$csv['ID'] = $order->id;
```



# 04-02. 例外処理

データベースから取得した後に直接表示する値の場合、データベースでNullにならないように制約をかけられるため、変数の中身に例外判定を行う必要はない。しかし、データベースとは別に新しく作られる値の場合、例外判定が必要になる。

### ◆ 例外処理前の条件分岐

〇：```TRUE```

✕：```FALSE```

|          | ```if(var)```、```!empty(var)``` | ```isset(var)```、```!is_null(​var)``` |
| :------- | :------: | :-----------: |
| ```0```  |    ✕     |       **〇**       |
| ```1```  |  **〇**  |    **〇**     |
| ```""``` |    ✕     |       **〇**       |
| ```"あ"``` |    ✕     |       **〇**       |
| NULL |    ✕     |       ✕       |
| array(0) |    ✕     |       **〇**       |
| array(1) |  **〇**  |    **〇**     |

```PHP
# 右辺には、上記に当てはまらない状態『TRUE』が置かれている。
if($this->$var == TRUE){
	// 処理A;
}

# ただし、基本的に右辺は省略すべき。
if($this->$var){
	// 処理A;
}
```



### ◆ Exceptionクラスを継承した独自例外クラス

```PHP
// HttpRequestに対処する例外クラス
class HttpRequestException extends Exception
{
	// インスタンスが作成された時に実行される処理
	public function __construct()
	{
		parent::__construct("HTTPリクエストに失敗しました", 400);
	}
	
	// 新しいメソッドを定義
	public function example()
	{
		// なんらかの処理;
	}
}
```



### ◆ ```if```-```throw```文

特定の処理の中に、想定できる例外があり、それをエラー文として出力するために用いる。ここでは、全ての例外クラスの親クラスであるExceptionクラスのインスタンスを投げている。

```PHP
if (empty($value)) {
	throw new Exception('Variable is empty');
}

return $value;
```



### ◆ ```try```-```catch```文

特定の処理の中に、想定できない例外があり、それをエラー文として出力するために用いる。定義されたエラー文は、デバック画面に表示される。

```PHP
// Exceptionを投げる
try{
    // WebAPIの接続に失敗した場合
    if(...){
        throw new WebAPIException();
    }
    
    if(...){
        throw new HttpRequestException();
    }

// try文で指定のExceptionが投げられた時に、指定のcatch文に入る
// あらかじめ出力するエラーが設定されている独自例外クラス（以下参照）
}catch(WebAPIException $e){
   	// エラー文を出力。
   	print $e->getMessage();

    
}catch(HttpRequestException $e){
   	// エラー文を出力。
   	print $e->getMessage();

    
// Exceptionクラスはtry文で生じた全ての例外をキャッチしてしまうため、最後に記述するべき。
}catch(Exception $e){
    // 特定できなかったことを示すエラーを出力
    throw new Exception("なんらかの例外が発生しました。");

        
// 正常と例外にかかわらず、必ず実行される。
}finally{
    // 正常と例外にかかわらず、必ずファイルを閉じるための処理
}
```

以下、上記で使用した独自の例外クラス。

```PHP
// HttpRequestに対処する例外クラス
class HttpRequestException extends Exception
{
	// インスタンスが作成された時に実行される処理
	public function __construct()
	{
		parent::__construct("HTTPリクエストに失敗しました", 400);
	}
```

```PHP
// HttpRequestに対処する例外クラス
class HttpRequestException extends Exception
{
	// インスタンスが作成された時に実行される処理
	public function __construct()
	{
		parent::__construct("HTTPリクエストに失敗しました", 400);
	}
```



# 05-01. 反復処理

### ◆ ```foreach()```

- **配列を返却したい場合**

```

```



- **いずれかの配列の要素を返却する場合**

```

```



- **エンティティごとに、プロパティの値を持つか否かが異なる場合**



### ◆ ```for()```

- **要素の位置を繰り返しズラす場合**

```PHP
moveFile(fromPos < toPos)
{
	if(fromPos < toPos){
		for(i = fromPos ; i ≦ toPos - 1; ++ 1){
			File[i] = File[i + 1];
		}
	}
}
```



### ◆ 無限ループ

反復処理では、何らかの状態になった時に反復処理を終えなければならない。しかし、終えることができないと、無限ループが発生してしまう。

- **```break```**

```PHP
// 初期化
$i = 0; 
while($i < 4){
    
	echo $i;
    
	// 改行
	echo PHP_EOL;
}
```

- **continue**



### ◆ 反復を含む流れ図における実装との対応

『N個の正負の整数の中から、正の数のみの合計を求める』という処理を行うとする。

- **```for()```**

![流れ図_for文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/流れ図_for文.png)

```PHP
$a = array(1, -1, 2, ... ,N);
```

```PHP
sum = 0;

for(i = 0; i < N; i++){
	$x = $a[i]
	if($x > 0){
		sum += $x;
	}
}
```

- **```while()```**

![流れ図_while文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/流れ図_while文.png)

```PHP
$a = array(1, -1, 2, ... ,N);
```

```PHP
sum = 0;

// 反復数の初期値
i = 0;

while(i < N){
	$x = $a[i];
	if($x > 0){
		sum += $x
	}
	i += 1;
}
```

- **```foreach()```**

![流れ図_foreach文](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/流れ図_foreach文.png)

```PHP
$a = array(1, -1, 2, ... ,N);
```

```PHP
sum = 0;

foreach($a as $x){
    if($x > 0){
        sum += $x;
    }
}
```







# 05-02. ファイルパス

### ◆ 絶対パス

ルートディレクトリ（fruit.com）から、指定のファイル（apple.png）までのパス。

```PHP
<img src="http://fruits.com/img/apple.png">
```

![絶対パス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/絶対パス.png)

### ◆ 相対パス

起点となる場所（apple.html）から、指定のディレクトリやファイル（apple.png）の場所までを辿るパス。例えば、apple.htmlのページでapple.pngを使用したいとする。この時、『 .. 』を用いて一つ上の階層に行き、青の後、imgフォルダを指定する。

```PHP
<img src="../img/apple.png">
```

![相対パス](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/相対パス.png)

