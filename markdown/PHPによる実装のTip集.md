# 01-01. アクセス修飾子

### ◆ public

どのオブジェクトでも呼び出せる。



### ◆ protected

同じクラス内と、その親クラスまたは子クラスでのみ呼び出せる。



### ◆ private

同じオブジェクト内でのみ呼び出せる。

- **Encapsulation（カプセル化）**

カプセル化とは、システムの実装方法を外部から隠すこと。オブジェクト内のプロパティにアクセスするには、直接データを扱う事はできず、オブジェクト内のメソッドをコールし、アクセスしなければならない。

![カプセル化](https://user-images.githubusercontent.com/42175286/59212717-160def00-8bee-11e9-856c-fae97786ae6c.gif)



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



# 01-02. メソッド

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



# 01-03. 無名関数

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



# 01-04. 継承とクラスチェーン

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



# 01-05. 外部クラスとメソッドの読み込み

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
| $var =       | 何も格納されていない変数 |
| False        | 文字としてのFalse        |
| 0            | 数字、文字列             |
| ""           | 空文字                   |
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



# 02-03. 定数

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



# 02-04. 変数

### ◆ スーパーグローバル変数

スコープに関係なく、どのプログラムからでもアクセスできる連想配列変数

![スーパーグローバル変数](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/スーパーグローバル変数.png)

- **```$_SERVER```に格納されている値**

```PHP
$_SERVER['SERVER_ADDR']           サーバのIPアドレス(例:192.168.0.1)
$_SERVER['SERVER_NAME']           サーバの名前(例:www.example.com)
$_SERVER['SERVER_PORT']           サーバのポート番号(例:80)
$_SERVER['SERVER_PROTOCOL']       サーバプロトコル(例:HTTP/1.1)
$_SERVER['SERVER_ADMIN']          サーバの管理者(例:root@localhost)
$_SERVER['SERVER_SIGNATURE']      サーバのシグニチャ(例:Apache/2.2.15...)
$_SERVER['SERVER_SOFTWARE']       サーバソフトウェア(例:Apache/2.2.15...)
$_SERVER['GATEWAY_INTERFACE']     CGIバージョン(例:CGI/1.1)
$_SERVER['DOCUMENT_ROOT']         ドキュメントルート(例:/var/www/html)
$_SERVER['PATH']                  環境変数PATHの値(例:/sbin:/usr/sbin:/bin:/usr/bin)
$_SERVER['PATH_TRANSLATED']       スクリプトファイル名(例:/var/www/html/test.php)
$_SERVER['SCRIPT_FILENAME']       スクリプトファイル名(例:/var/www/html/test.php)
$_SERVER['REQUEST_URI']           リクエストのURI(例:/test.php)
$_SERVER['PHP_SELF']              PHPスクリプト名(例:/test.php)
$_SERVER['SCRIPT_NAME']           スクリプト名(例:/test.php)
$_SERVER['PATH_INFO']             URLの引数に指定されたパス名(例:/test.php/aaa)
$_SERVER['ORIG_PATH_INFO']        PHPで処理される前のPATH_INFO情報
$_SERVER['QUERY_STRING']          URLの?以降に記述された引数(例:q=123)
$_SERVER['REMOTE_ADDR']           クライアントのIPアドレス(例:192.168.0.123)
$_SERVER['REMOTE_HOST']           クライアント名(例:client32.example.com)
$_SERVER['REMOTE_PORT']           クライアントのポート番号(例:64799)
$_SERVER['REMOTE_USER']           クライアントのユーザ名(例:tanaka)
$_SERVER['REQUEST_METHOD']        リクエストメソッド(例:GET)
$_SERVER['REQUEST_TIME']          リクエストのタイムスタンプ(例:1351987425)
$_SERVER['REQUEST_TIME_FLOAT']    リクエストのタイムスタンプ(マイクロ秒)(PHP 5.1.0以降)
$_SERVER['REDIRECT_REMOTE_USER']  リダイレクトされた場合の認証ユーザ(例:tanaka)
$_SERVER['HTTP_ACCEPT']           リクエストのAccept:ヘッダの値(例:text/html)
$_SERVER['HTTP_ACCEPT_CHARSET']   リクエストのAccept-Charset:ヘッダの値(例:utf-8)
$_SERVER['HTTP_ACCEPT_ENCODING']  リクエストのAccept-Encoding:ヘッダの値(例:gzip)
$_SERVER['HTTP_ACCEPT_LANGUAGE']  リクエストのAccept-Language:ヘッダの値(ja,en-US)
$_SERVER['HTTP_CACHE_CONTROL']    リクエストのCache-Control:ヘッダの値(例:max-age=0)
$_SERVER['HTTP_CONNECTION']       リクエストのConnection:ヘッダの値(例:keep-alive)
$_SERVER['HTTP_HOST']             リクエストのHost:ヘッダの値(例:www.example.com)
$_SERVER['HTTP_REFERER']          リンクの参照元URL(例:http://www.example.com/)
$_SERVER['HTTP_USER_AGENT']       リクエストのUser-Agent:ヘッダの値(例:Mozilla/5.0...)
$_SERVER['HTTPS']                 HTTPSを利用しているか否か(例:on)
$_SERVER['PHP_AUTH_DIGEST']       ダイジェスト認証時のAuthorization:ヘッダの値
$_SERVER['PHP_AUTH_USER']         HTTP認証時のユーザ名
$_SERVER['PHP_AUTH_PW']           HTTP認証時のパスワード
$_SERVER['AUTH_TYPE']             HTTP認証時の認証形式
```

- **スーパーグローバル変数からの値取得（Symfony）**

```PHP
// $_GET['hoge']
$request->query->get('hoge');
 
// $_POST['hoge']
$request->request->get('hoge');
 
// ルーティングパラメータ / ex) @Route('/{hoge}')
$request->attributes->get('hoge');
 
// $_COOKIE['hoge']
$request->cookies->get('hoge');
 
// $_FILES['hoge']
$request->files->get('hoge');
 
// $_SERVER['SCRIPT_FILENAME']
$request->server->get('SCRIPT_FILENAME');
 
// $_SERVER['HTTP_USER_AGENT']
$request->headers->get('User-Agent');
 
// query > attribute  > request の順で検索
$request->get('hoge');
```



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



# 02-05. 演算子

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



# 02-06. データのキャッシュ

### ◆ プロパティを用いたキャッシュ

大量のデータを集計するメソッドは、その処理に時間がかかる。そこで、そのようなメソッドでは、一度コールされて集計を行った後、プロパティに返却値を格納しておく。そして、再びコールされた時には、返却値をプロパティから取り出す。

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



# 03-01. 条件式

### ◆ if-elseとswitch-case-break

**【実装例】**

曜日を判定し、文字列を出力する。

- **if-else**

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
} else if($weeks == 'Sun'){
  echo '日曜日';
}

// 実行結果
火曜日
```
- **switch-case-break**

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



### ◆ if-elseはできるだけ用いない

- **if-elseを用いた場合**

冗長になってしまう。

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

- **if-elseを用いた場合（初期値と上書きのロジックを用いた場合）**

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



### ◆ if-elseif-elseはできるだけ用いない

- **決定表を用いて条件分岐を表現**

**【実装例】**

うるう年であるかを判定し、文字列を出力する。以下の手順で設計と実装を行う。

1. 条件分岐の処理順序の概要を日本で記述する。
2. 記述内容を、条件部と動作部に分解し、決定表で表す。
3. 決定表を、流れ図で表す。

![決定表](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/決定表.png)

- **if-elseif-elseを用いた場合の場合**

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

- **if-elseif-elseを用いない条件分岐の場合**

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



### ◆ オブジェクトごとにプロパティの値の有無が異なる時の出力

```PHP
// 全てのオブジェクトが必ず持っているわけではなく、
$csv['オリコ払い'] = $order->oricoCondition ? $order->oricoCondition->

// 全てのオブジェクトが必ず持っているプロパティの場合には不要
$csv['ID'] = $order->id;
```



# 03-02. 例外処理

データベースから取得した後に直接表示する値の場合、データベースでNullにならないように制約をかけられるため、変数の中身に例外判定を行う必要はない。しかし、データベースとは別に新しく作られる値の場合、例外判定が必要になる。

### ◆ 例外処理前の条件分岐

〇：```TRUE```

✕：```FALSE```

|          | if(var) ／  !empty(var) | isset(var) ／ ! is_null(​var) |
| :------- | :------: | :-----------: |
| 0        |    ✕     |       ✕       |
| 1        |  **〇**  |    **〇**     |
| ""       |    ✕     |       ✕       |
| "あ"     |    ✕     |       ✕       |
| NULL     |    ✕     |       ✕       |
| array()  |    ✕     |       ✕       |
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



### ◆ if-throw文

特定の処理の中に、想定できる例外があり、それをエラー文として出力するために用いる。ここでは、全ての例外クラスの親クラスであるExceptionクラスのインスタンスを投げている。

```PHP
if (empty($value)) {
	throw new Exception('Variable is empty');
}

return $value;
```



### ◆ try-catch文

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



# 04-01. 反復処理

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



# 05-01. 実装のモジュール化

### ◆ STS分割法

プログラムを、『Source（入力処理）➔ Transform（変換処理）➔ Sink（出力処理）』のデータの流れに則って、入力モジュール、処理モジュール、出力モジュール、の３つ分割する方法。（リクエスト ➔ DB ➔ レスポンス）

![STS分割法](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/p485-1.png)



### ◆ Transaction分割法

データの種類によってTransaction（処理）の種類が決まるような場合に、プログラムを処理の種類ごとに分割する方法。

![トランザクション分割法](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/p485-2.png)



### ◆ 共通機能分割法

プログラムを、共通の機能ごとに分割する方法

![共通機能分割法](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/p485-3.jpg)



### ◆ MVC

ドメイン駆動設計のノートを参照せよ。



### ◆ ドメイン駆動設計

ドメイン駆動設計のノートを参照せよ。



### ◆ デザインパターン

デザインパターンのノートを参照せよ。



# 06-01. ファイルパス

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

