# テストフレームワークとテスト仕様書

## 01. テスト全体の手順

### テスティングフレームワークによるテスト

1. テスティングフレームワークによる，静的解析を行う．
2. テスティングフレームワークによる，UnitテストとFunctionalテストを行う．

### テスト仕様書に基づくテスト

1. テスト仕様書に基づく，Unitテスト，Integrationテスト，User Acceptanceテストを行う．

2. グラフによるテストの可視化

<br>

## 03.  PHPUnitによるUnit／Functionalテストの要素

### Phakeによるモックオブジェクトとスタブの定義

テストコードにおいては，クラスの一部または全体を，処理を持たないもの（モックオブジェクト）に置き換える．

#### ・```mock```メソッド

クラス名（名前空間）を元に，モックオブジェクトを生成する．

```PHP
<?php
// クラスの名前空間を引数として渡す．
$mock = Phake::mock(Example::class);
```

#### ・```when```メソッド

モックオブジェクトに対して，スタブを生成する．

```PHP
<?php
// $mockに対して，method()を設定し，$paramが渡された時に，[]（空配列）を返却するものとする．
\Phake::when($mock)
    ->method($param)
    ->thenReturn([]);
```

#### ・```verify```メソッド

メソッドがn回以上コールされたかを検証できる．

**＊実装例＊**

```PHP
<?php
// モックオブジェクトを生成．
$mock = Phake::mock(Example::class);

// モックオブジェクトに対してスタブを生成．
\Phake::when($mock)
    ->method($param)
    ->thenReturn([]);

// スタブをコール．
$mock->method("A");

// $mockのmethod()が$n回コールされ，その時の引数が$paramであったかを検証．
Phake::verify($mock, Phake::times($n))->method($param);
```

**＊実装例＊**

先に，以下のような，実体的なクラスがあるとする．

```PHP
<?php
class Aggregation
{
    private $example;
    
    public function __construct($example)
    {
        $this->example = $example;
    }
    
    public function aggMethod($param)
    {
        // privateメソッドをコール
        $param = $this->addB($param);
        // ExampleクラスのexaMethodをコール．
        return $this->example->exaMethod($param);
    }
    
    private function addB($param)
    {
        return $param.'B';
    }
}
```

実体的なオブジェクトに対して，モックオブジェクトを設定していく．

```PHP
<?php
// モックオブジェクトを生成．
$mock = Phake::mock(Example::class);

// モックオブジェクトをもつ実体的な集約を生成．
$aggregation = new Aggregation($mock);

// 実体的な集約のもつモックオブジェクトに対してスタブを生成．
\Phake::when($mock)
    ->exaMethod($param)
    ->thenReturn([]);

// 実体的な集約のもつ実体的なメソッドをコールし，間接的に$mockのスタブをコール．
// 集約のもつaddB()は，スタブのexaMethod()とは異なって実体的なので，処理が通る．
$aggregation->aggMethod("A");

// $mockのexaMethod()が1回コールされ，その時の引数がABであったかを検証．
Phake::verify($mock, Phake::times(1))->exaMethod("AB");
```

<br>

### テストの事前準備と後片付け

#### ・```setUp```メソッド

モックオブジェクトなどを事前に準備するために用いられる．

```PHP
<?php
class ExampleUseCaseTest extends \PHPUnit_Framework_TestCase
{
    protected $exampleService;
    
    protected function setUp()
    {
        // 基本的には，一番最初に記述する．
        parent::setUp();
        
        $this->exampleService = Phake::mock(ExampleService::class);
    }
}
```

#### ・```tearDown```メソッド

テスト時に，グローバル変数やDIコンテナにデータを格納する場合，後のテストでもそのデータが誤って使用されてしまう可能性がある．そのために，テストの後片付けを行う．

```PHP
<?php
class ExampleUseCaseTest extends \PHPUnit_Framework_TestCase
{
    protected $container;
    
    // メソッドの中で，最初に自動実行される．
    protected function setUp()
    {
        // DIコンテナにデータを格納する．
        $this->container['option'];
    }
    
    // メソッドの中で，最後に自動実行される．
    protected function tearDown()
    {
        // 次に，DIコンテナにデータを格納する．
        $this->container = null;
    }
}
```

<br>

### テストデータの準備

#### ・Data Provider

テストメソッドのアノテーションに，```@dataProvider {データ名}```とすることで，テストメソッドに定義した配列データを渡すことができる．

```PHP
class xxxTest
{
    
    /* @test
     * @dataProvider provideData
     */
    public function testMethod($paramA, $paramB, $paramC)
    {
        // 何らかの処理 
    }
    
    public function provideData(): array
    {
        return [
            // 配列データは複数あっても良い，
            // testMethod()の引数と同じ順番で，配列データの要素が並ぶ．
            ["あ", "い", "う"],
            ["1", "2", "3"]
        ];
    }
}
```

<br>

### 実際値と期待値の比較

https://phpunit.readthedocs.io/ja/latest/assertions.html

<br>

## 03-02. PHPUnitによるUnit／Functionalテストの実装まとめ

### Unitテスト

#### ・Unitテストとは

クラスやメソッドが単体で処理が正しく動作するかをテストする方法．

```PHP
<?php
// ここに実装例
```

<br>

### Functionalテスト

#### ・Functionalテストとは

Controllerに対してリクエストを行い，正しくレスポンスが行われるかをテストする方法．

#### ・レスポンスが成功するか（ステータスコードが```200```番台か）

```PHP
<?php
// ここに実装例
```

#### ・レスポンスが成功するか ＆ レスポンスされるエラーメッセージが正しいか

```PHP
<?php
// ここに実装例
```

#### ・レスポンスが成功するか ＆ レスポンスされた配列データが期待値と同じか

レスポンス期待値のデータセットを```@dataProvider```に定義し，データベースに用意しておいた配列データが，```@dataProvider```と一致するかでテストする．

```PHP
<?php
// ここに実装例
```

<br>

## 03-03. テスト仕様書に基づくUnitテスト

PHPUnitでのUnitテストとは意味合いが異なるので注意．

### ブラックボックステスト

実装内容は気にせず，入力に対して，適切な出力が行われているかをテストする．

![p492-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p492-1.jpg)

<br>

### ホワイトボックステスト

実装内容が適切かを確認しながら，入力に対して，適切な出力が行われているかをテストする．ホワイトボックステストには，以下の方法がある．何をテストするかに着目すれば，思い出しやすい．

![p492-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p492-2.jpg)

**＊実装例＊**

```
if (A = 1 && B = 1) {
　return X;
}
```

上記のif文におけるテストとして，以下の４つの方法が考えられる．基本的には，複数条件網羅が用いられる．

#### ・命令網羅（『全ての処理』が実行されるかをテスト）

![p494-1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p494-1.png)

全ての命令が実行されるかをテスト（ここでは処理は1つ）．

すなわち…

A = 1，B = 1 の時，```return X``` が実行されること．

#### ・判定条件網羅（『全ての判定』が実行されるかをテスト）

![p494-2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p494-2.png)

全ての判定が実行されるかをテスト（ここでは判定は```TRUE```か```FALSE```の2つ）．

すなわち…

A = 1，B = 1 の時，```return X``` が実行されること．
A = 1，B = 0 の時，```return X``` が実行されないこと．

#### ・条件網羅（『各条件の取り得る全ての値』が実行されるかをテスト）

![p494-3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p494-3.png)

各条件が，取り得る全ての値で実行されるかをテスト（ここでは，Aが0と1，Bが0と1になる組み合わせなので，2つ）

すなわち…

A = 1，B = 0 の時，```return X``` が実行されないこと．
A = 0，B = 1 の時，```return X``` が実行されないこと．

または，次の組み合わせでもよい．

A = 1，B = 1 の時，```return X``` が実行されること．
A = 0，B = 0 の時，```return X``` が実行されないこと．

#### ・複数条件網羅（『各条件が取り得る全ての値』，かつ『全ての組み合わせ』が実行されるかをテスト）

![p494-4](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p494-4.png)

各条件が，取り得る全ての値で，かつ全ての組み合わせが実行されるかをテスト（ここでは4つ）

すなわち…

A = 1，B = 1 の時，```return X``` が実行されること．
A = 1，B = 0 の時，```return X``` が実行されないこと．
A = 0，B = 1 の時，```return X``` が実行されないこと．
A = 0，B = 0 の時，```return X``` が実行されないこと．

 <br>

## 03-04. テスト仕様書に基づくIntegrationテスト（結合テスト）

単体テストの次に行うテスト．複数のモジュールを繋げ，モジュール間のインターフェイスが適切に動いているかを検証．

![結合テスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p491-1.jpg)

### Top-downテスト

上位のモジュールから下位のモジュールに向かって，結合テストを行う場合，下位には Stub と呼ばれるダミーモジュールを作成する．

![トップダウンテスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/トップダウンテスト.jpg)

<br>

### Bottom-upテスト

下位のモジュールから上位のモジュールに向かって，結合テストを行う場合，上位には Driver と呼ばれるダミーモジュールを作成する．

![ボトムアップテスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ボトムアップテスト.jpg)

<br>

### Scenarioテスト

実際の業務フローを参考にし，ユーザが操作する順にテストを行う．

<br>


## 04. テスト仕様書に基づくシステムテスト（User Acceptanceテスト，総合テスト）

### システムテスト

結合テストの次に行うテスト．システム全体が適切に動いているかをテストする．User Acceptanceテスト，また総合テストともいう．

<br>

### Functionalテスト

機能要件を満たせているかをテストする．PHPUnitでのFunctionalテストとは意味合いが異なるので注意．

<br>

### 負荷テスト

#### ・負荷テストとは

実際の運用時に，想定したリクエスト数に耐えられるか，をテストする．また，テスト結果から，運用時の監視で参考にするための，安全範囲（青信号），危険範囲（黄色信号），限界値（赤信号），を導く必要がある．

参考：https://www.oracle.com/jp/technical-resources/article/ats-tech/tech/useful-class-8.html

#### ・負荷テストのパラメータ

| 項目       | 説明                                                         |
| ---------- | ------------------------------------------------------------ |
| スレッド数 | ユーザ数に相当する．                                         |
| ループ数   | ユーザ当たりのリクエスト送信数に相当する．                   |
| RampUp秒   | リクエストを送信する期間に相当する．長くし過ぎすると，全てのリクエスト数を送信するまでに時間がかかるようになるため，負荷が小さくなる． |

#### ・性能テスト

![スループットとレスポンスタイム](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/スループットとレスポンスタイム.png)

一定時間内に，ユーザが一連のリクエスト（例：ログイン，閲覧，登録，ログアウト）を行った時に，システムのスループットとレスポンス時間にどのような変化があるかをテストする．具体的にはテスト時に，アクセス数を段階的に増加させて，その結果をグラフ化する．グラフ結果を元に，想定されるリクエスト数が現在の性能にどの程度の負荷をかけるのかを確認し，また性能の負荷が最大になる値を導く．これらを運用時の監視の参考値にする．

#### ・限界テスト

性能の限界値に達するほどのリクエスト数が送信された時に，障害回避処理（例：アクセスが込み合っている旨のページを表示）が実行されるかをテストする．具体的にはテスト時に，障害回避処理以外の動作（エラー，間違った処理，障害回復後にも復旧できない，システムダウン）が起こらないかを確認する．

#### ・耐久テスト

長時間の大量リクエストが送信された時に，短時間では検出できないどのような問題が存在するかをテストする．具体的にはテスト時に，長時間の大量リクエストを処理させ，問題（例：微量のメモリリークが蓄積してメモリを圧迫，セッション情報が蓄積してメモリやディスクを圧迫，ログが蓄積してディスクを圧迫，ヒープやトランザクションログがCPUやI/O処理を圧迫）

#### ・再現テスト

障害発生後の措置としてスペックを上げる場合，そのスペックが障害発生時の負荷に耐えられるかをテストする．

**＊障害とデータ例＊**

開始からピークまでに，次のようにリクエスト数が増し，障害が起こったとする．その後，データを収集した．

| 障害発生期間                            | 合計閲覧ページ数<br>```(PV数/min)``` | 平均ユーザ数<br/>```(UA数/min)``` | ユーザ当たり閲覧ページ数<br/>```(PV数/UA数)``` |
| --------------------------------------- | ------------------------------------ | --------------------------------- | ---------------------------------------------- |
| ```13:00 ~```<br> ```13:05```（開始）   | ```300```                            | ```100```                         | ```3```                                        |
| ```13:05 ~```<br> ```13:10```           | ```600```                            | ```200```                         | ```3```                                        |
| ```13:10 ~```<br> ```13:15```（ピーク） | ```900```                            | ```300```                         | ```3```                                        |

| ランキング | URL              | 割合       |
| ---------- | ---------------- | ---------- |
| 1          | ```/aaa/bbb/*``` | 40 ```%``` |
| 2          | ```/ccc/ddd/*``` | 30 ```%``` |
| 3          | ```/eee/fff/*``` | 20 ```%``` |
| 4          | ```/ggg/hhh/*``` | 10 ```%``` |

**＊テスト例＊**

ユーザ当たりの閲覧ページ数はループ数に置き換えられるので，ループ数は「```3```回」になる．障害発生期間の閲覧ページ数はスレッド数に置き換えられるので，スレッド数は「```1800```個（```300 + 600 + 900```）」になる．障害発生期間は，Ramp-Upに置き換えられるので，Ramp-Up期間は「```900```秒（```15```分間）」

| スレッド数（個） | ループ数（回） | Ramp-Up期間```(sec)``` |
| ---------------- | -------------- | ---------------------- |
| ```1800```       | ```3```        | ```900```              |

<br>

## 04-02. Regressionテスト（退行テスト）

システムを変更した後，他のプログラムに悪影響を与えていないかを検証．

![p496](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/p496.jpg)

<br>

## 05. グラフによるテストの可視化

### バグ管理図

プロジェクトの時，残存テスト数と不良摘出数（バグ発見数）を縦軸にとり，時間を横軸にとることで，バグ管理図を作成する．それぞれの曲線の状態から，プロジェクトの進捗状況を読み取ることができる．

![品質管理図](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/品質管理図.jpg)

不良摘出実績線（信頼度成長曲線）は，プログラムの品質の状態を表し，S字型でないものはプログラムの品質が良くないことを表す．

![信頼度成長曲線の悪い例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/信頼度成長曲線の悪い例.jpg)



