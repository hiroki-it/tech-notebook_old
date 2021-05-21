# テスト

## 01. テスト全体の手順

### テスティングフレームワークによるテスト

#### ・テスト手順

1. ソースコードを整形する．
2. ソースコードの静的解析を行う．
3. ユニットテストと機能テストを行う．

#### ・整形ツール

PhpStorm，PHP-CS-Fixer

#### ・静的解析ツール

PhpStorm，PHPStan，Larastan

#### ・ユニットテストツール，機能テストツール

PHPUnit

<br>

### テスト仕様書に基づくテスト

#### ・テスト手順

1. テスト仕様書に基づく，ユニットテスト，Integrationテスト，User Acceptanceテストを行う．
2. グラフによるテストの可視化

<br>

## 02. PHPUnit

### コマンド

#### ・オプション無し

全てのテストファイルを対象として，定義されたメソッドを実行する．

```bash
$ vendor/bin/phpunit
PHPUnit 9.5.0 by Sebastian Bergmann and contributors.

...                                                   3 / 3 (100%)
 
Time: 621 ms, Memory: 24.00 MB
 
OK (3 tests, 3 assertions)
```

#### ・--filter

特定のテストファイルを対象として，定義されたメソッドを実行する．

```shell
$ vendor/bin/phpunit --filter Example
PHPUnit 9.5.0 by Sebastian Bergmann and contributors.

...                                                   1 / 1 (100%)
 
Time: 207 ms, Memory: 8.00 MB
 
OK (1 tests, 1 assertions)
```

#### ・--list-tests

実行の対象となるテストファイルを一覧で表示する．

```shell
$ vendor/bin/phpunit --list-tests
PHPUnit 9.5.0 by Sebastian Bergmann and contributors.
 
Available test(s):
 - Tests\Unit\ExampleTest::testExampleMethod
 - Tests\Feature\ExampleTest::testExampleMethod
```

<br>

### phpunit.xmlファイル

#### ・```phpunit.xml```ファイルとは

PHPUnitの設定を行う．標準の設定では，あらかじめルートディレクトリに```tests```ディレクトリを配置し，これを```Units```ディレクトリまたは```Feature```ディレクトリに分割しておく．また，```Test```で終わるphpファイルを作成しておく必要がある．

#### ・```testsuites```タグ

PHPUnitの対象とするディレクトリ名やファイル名を定義できる．```testsuites```タグ内の```testsuites```タグを追加変更すると，検証対象のディレクトリを増やし，また対象のディレクトリ名を変更できる．

```xml
<phpunit>
    
...
    
    <testsuites>
        <testsuite name="Unit">
            <directory suffix="Test.php">./tests/Unit</directory>
        </testsuite>
        
        <testsuite name="Feature">
            <directory suffix="Test.php">./tests/Feature</directory>
        </testsuite>
    </testsuites>
    
...
    
</phpunit>
```

#### ・```php```タグ

PHPUnitの実行前に設定する```ini_set```関数，```define```関数，グローバル変数，を定義できる．タグ名との対応関係については，以下を参考にせよ．

参考：https://phpunit.readthedocs.io/ja/latest/configuration.html#php-ini

**＊実装例＊**

composerの実行時にメモリ不足にならないようにメモリを拡張する．また，テスト用のデータベースに接続できるよう，データベースに関する環境変数を設定する．

```xml
<phpunit>
    
...
    
    <php>
        <!-- <グローバル変数名 name="キー名" value="値"/> -->
        
        <!-- composerの実行時にメモリ不足にならないようにする -->
        <ini name="memory_limit" value="512M"/>
        
        <!-- データベースの接続情報 -->
        <server name="DB_CONNECTION" value="mysql"/>
        <server name="DB_DATABASE" value="test"/>
        <server name="DB_USERNAME" value="test"/>
        <server name="DB_PASSWORD" value="test"/>
    </php>
    
...
    
</phpunit>
```

<br>

### アサーションメソッド

#### ・アサーションメソッドとは

実際の値と期待値を比較し，結果に応じて```SUCCESS```または```FAILURES```を返却する．非staticまたはstaticとしてコールできる．

参考：https://phpunit.readthedocs.io/ja/latest/assertions.html

```php
$this->assertTrue();
```

```php
self::assertTrue()
```

#### ・assertTrue

実際値が```true```かどうかを検証する．

```php
$this->assertTrue($response->isOk());
```

#### ・assertEquals

「```==```」を使用して，期待値と実際値の整合性を検証する．データ型を検証できないため，```assertSame```メソッドを使用する方が良い．

```php
$this->assertSame(200, $response->getStatusCode());
```

#### ・assertSame

「```===```」を使用して，期待値と実際値の整合性を検証する．値だけでなく，データ型も検証できる．


```php
$this->assertSame(200, $response->getStatusCode());
```

<br>

### ユニットテスト

#### ・ユニットテストとは

クラスやメソッドが単体で処理が正しく動作するかを検証する方法．検証対象以外の処理はスタブとして定義する．以降のテスト例では，次のような通知クラスとメッセージクラスが前提にあるとする．

```php
<?php

use CouldNotSendMessageException;
    
class ExampleNotification
{
    private $httpClient;
        
    private $token;
    
    private $logger;
        
    public function __construct(Clinet $httpClient, string $token, LoggerInterface $logger)
    {
        $this->httpClient = $httpClient;        
        $this->token = $token;
        $this->logger = $logger;
    }
    
    public function sendMessage(ExampleMessage $exampleMessage)
    {
        if (empty($this->token)) {
            throw new CouldNotSendMessageException("API requests is required.");
        }
        
        if (empty($exampleMessage->channel_id)) {
            throw new CouldNotSendMessageException("Channnel ID is required.");
        }
        
        $json = json_encode($exampleMessage->message);
        
        try {
            $this->httpClient->request(
                "POST",
                "https://xxxxxxxx",
                [
                    "headers" => [
                        "Authorization" => $this->token,
                        "Content-Length" => strlen($json),
                        "Content-Type" => "application/json",
                    ],
                    "form_params" => [
                        "body" =>  $exampleMessage->message
                    ]
                ]
            );

        } catch (ClientException $exception) {

            $this->logger->error(sprintf(
                "ERROR: %s at %s line %s",
                $exception->getMessage(),
                $exception->getFile(),
                $exception->getLine()
            ));

            throw new CouldNotSendMessageException($exception->getMessage());
        } catch (\Exception $exception) {

            $this->logger->error(sprintf(
                "ERROR: %s at %s line %s",
                $exception->getMessage(),
                $exception->getFile(),
                $exception->getLine()
            ));

            throw new CouldNotSendMessageException($exception->getMessage());
        }
        
        return true;
    }
}
```

```php
<?php
 
class ExampleMessage
{
    private $channel_id;
    
    private $message;

    public function __construct(string $channel_id, string $message)
    {
        $this->channel_id = $channel_id;        
        $this->message = $message;
    }
}
```

#### ・正常系テスト例

メソッドのアノテーションで，```@test```を宣言する．

**＊実装例＊**

リクエストにて，チャンネルとメッセージを送信した時に，レスポンスとして```TRUE```が返信されるかを検証する．

```php
<?php

use ExampleMessage;
use ExampleNotifiation;
use PHPUnit\Framework\TestCase;

class ExampleNotificationTest extends TestCase
{
    private $logger;

    private $client;

    public function setUp()
    {
        // 検証対象外のクラスはモックとする．
        $this->client = \Phake::mock(Client::class);
        $this->logger = \Phake::mock(LoggerInterface::class);
    }
    
   /**
    * @test
    */
    public function testSendMessage()
    {
        $exampleNotification = new ExampleNotification(
            $this->client,
            "xxxxxxx",
            $this->logger
        );
        
        $exampleMessage = new ExampleMessage("test", "X-CHANNEL");
        
        $this->assertTrue(
            $exampleNotification->sendMessage($exampleMessage)
        );
    }
}
```

```shell
# Time: x seconds
# OK
```

#### ・異常系テスト例

メソッドのアノテーションで，```@test```と```@expectedException```を宣言する．

**＊実装例＊**

リクエストにて，メッセージのみを送信しようとした時に，例外を発生させられるかを検証する．

```php
<?php

use ExampleMessage;
use ExampleNotifiation;
use PHPUnit\Framework\TestCase;

class ExampleNotificationTest extends TestCase
{
    private $logger;

    private $client;

    public function setUp()
    {
        // 検証対象外のクラスはモックとする．
        $this->client = \Phake::mock(Client::class);
        $this->logger = \Phake::mock(LoggerInterface::class);
    }

   /**
    * @test
    * @expectedException
    */
    public function testCouldNotSendMessageException()
    {
        $exampleNotification = new ExampleNotification(
            $this->client,
            "xxxxxxx",
            $this->logger
        );
        
        $exampleMessage = new ExampleMessage("test", "");

        $exampleNotification->sendMessage($exampleMessage);
    }
}
```

```shell
# Time: x seconds
# OK
```

<br>

### 機能テスト

#### ・機能テストとは

アプリケーション自身のControllerクラスに対してリクエストを送信し，正しくレスポンスを返信するかどうかを検証する方法．スタブを使用することは少ない．メソッドのアノテーションで，```@test```を宣言する必要がある．

**＊実装例＊**

```php
<?php

use PHPUnit\Framework\TestCase;
use GuzzleHttp\Client;

class ExampleControllerTest extends TestCase
{
    /**
     * @test
     */
    public function testMethod()
    {
        // アプリケーション自身のControllerクラスにリクエストを送信する処理．
        $client = new Client();
        $response = $client->request(
            "GET",
            "https://xxxxxxxx",
            [
                "query" => [
                    "id" => 1
                ]
            ]
        );
        
        // レスポンスの実際値と期待値の整合性を検証する．
    }
}
```

#### ・テストケース例

| HTTPメソッド | 分類   | データの条件                                                 | ```assert```メソッドの検証内容例                             |
| ------------ | ------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| POST，PUT    | 正常系 | リクエストのボディにて，必須パラメータにデータが割り当てられている場合． | ・Controllerが200ステータスのレスポンスを返信すること．<br>・更新されたデータのIDが期待通りであること．<br>・レスポンスされたデータが期待通りであること． |
|              |        | リクエストのボディにて，任意パラメータにデータが割り当てられていない場合． | ・Controllerが200ステータスのレスポンスを返信すること．<br/>・更新されたデータのIDが期待通りであること．<br/>・レスポンスされたデータが期待通りであること． |
|              |        | リクエストのボディにて，空文字やnullが許可されたパラメータに，データが割り当てられていない場合． | ・Controllerが200ステータスのレスポンスを返信すること．<br/>・更新されたデータのIDが期待通りであること．<br/>・レスポンスされたデータが期待通りであること． |
|              | 異常系 | リクエストのボディにて，必須パラメータにデータが割り当てられていない場合． | ・Controllerが400ステータスのレスポンスを返信すること．<br/>・レスポンスされたデータが期待通りであること． |
|              |        | リクエストのボディにて，空文字やnullが許可されたパラメータに，空文字やnullが割り当てられている場合． | ・Controllerが400ステータスのレスポンスを返信すること．<br/>・レスポンスされたデータが期待通りであること． |
|              |        | リクエストのボディにて，パラメータのデータ型が誤っている場合． | ・Controllerが400ステータスのレスポンスを返信すること．<br/>・レスポンスされたデータが期待通りであること． |
| GET          | 正常系 | リクエストにて，パラメータにデータが割り当てられている場合． | Controllerが200ステータスのレスポンスを返信すること．        |
|              | 異常系 | リクエストのボディにて，パラメータに参照禁止のデータが割り当てられている場合（認可の失敗）． | Controllerが403ステータスのレスポンスを返信すること．        |
| DELETE       | 正常系 | リクエストのボディにて，パラメータにデータが割り当てられている場合． | ・Controllerが200ステータスのレスポンスを返信すること．<br/>・削除されたデータのIDが期待通りであること．<br/>・レスポンスされたデータが期待通りであること． |
|              | 異常系 | リクエストのボディにて，パラメータに削除禁止のデータが割り当てられている場合（認可の失敗）． | ・Controllerが400ステータスのレスポンスを返信すること．<br/>・レスポンスされたデータが期待通りであること． |
| 認証認可     | 正常系 | リクエストのヘッダーにて，認証されているトークンが割り当てられている場合（認証の成功）． | Controllerが200ステータスのレスポンスを返信すること．        |
|              | 異常系 | リクエストのヘッダーにて，認証されていないトークンが割り当てられている場合（認証の失敗）． | Controllerが401ステータスのレスポンスを返信すること．        |
|              |        | リクエストのボディにて，パラメータにアクセス禁止のデータが割り当てられている場合（認可の失敗）． | Controllerが403ステータスのレスポンスを返信すること．        |

#### ・正常系GET

Controllerが200ステータスのレスポンスを返信することを検証する．

**＊実装例＊**

```php
<?php
    
use GuzzleHttp\Client;    
use PHPUnit\Framework\TestCase;

class ExampleControllerTest extends TestCase
{
   /**
    * @test
    */    
    public function testGetPage()
    {
        // 外部サービスがクライアントの場合はモックを使用する．
        $client = new Client();

        // GETリクエスト
        $client->request(
            "GET",
            "/xxx/yyy/"
        );
        
        $response = $client->getResponse();

        // 200ステータスが返却されるかを検証する．
        $this->assertSame(200, $response->getStatusCode());
    }
}
```

#### ・正常系POST

Controllerが200ステータスのレスポンスを返信すること，更新されたデータのIDが期待通りであること，レスポンスされたデータが期待通りであることを検証する．

**＊実装例＊**

```php
<?php

use GuzzleHttp\Client;
use PHPUnit\Framework\TestCase;

class ExampleControllerTest extends TestCase
{
    /**
     * @test
     */
    public function testPostMessage()
    {      
        $client = new Client();

        // APIにPOSTリクエスト
        $client->request(
            "POST",
            "/xxx/yyy/",
            [
                "id"      => 1,
                "message" => "Hello World!"
            ],
            [
                "HTTP_X_API_Token" => "Bearer xxxxxx"
            ]
        );

        $response = $client->getResponse();

        // 200ステータスが返却されるかを検証する．
        $this->assertSame(200, $response->getStatusCode());

        // レスポンスデータを抽出する．
        $actual = json_decode($response->getContent(), true);

        // 更新されたデータのIDが正しいかを検証する．
        $this->assertSame(1, $actual["id"]);

        // レスポンスされたメッセージが正しいかを検証する．
        $this->assertSame(
            [
                "データを変更しました．"
            ],
            $actual["message"]
        );
    }
}
```

#### ・異常系POST

Controllerが400ステータスのレスポンスを返信すること，レスポンスされたデータが期待通りであること，を検証する．

**＊実装例＊**

```php
<?php

use GuzzleHttp\Client;
use PHPUnit\Framework\TestCase;

class ExampleControllerTest extends TestCase
{
    /**
     * @test
     */
    public function testErrorPostMessage()
    {     
        $client = new Client();

        // APIにPOSTリクエスト
        $client->request(
            "POST",
            "/xxx/yyy/",
            [
                "id"      => 1,
                "message" => ""
            ],
            [
                "HTTP_X_API_Token" => "Bearer xxxxxx"
            ]
        );

        $response = $client->getResponse();

        // 400ステータスが返却されるかを検証する．
        $this->assertSame(400, $response->getStatusCode());

        // レスポンスデータのエラーを抽出する．
        $actual = json_decode($response->getContent(), true);

        // レスポンスされたエラーメッセージが正しいかを検証する．
        $this->assertSame(
            [
                "IDは必ず入力してください．",
                "メッセージは必ず入力してください．"
            ],
            $actual["errors"]
        );
    }
}
```

<br>

### テストデータ

#### ・Data Provider

メソッドのアノテーションで，```@test```と```@dataProvider データプロバイダ名```を宣言する．データプロバイダの返却値として配列を設定し，配列の値の順番で，引数に値を渡すことができる．

**＊実装例＊**

```php
<?php

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
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
            ["あ", "い", "う"],
            ["1", "2", "3"]
        ];
    }
}
```

<br>

### 事前準備と後片付け

#### ・```setUp```メソッド

テストクラスの中で，自動的に一番最初にコールされるメソッドである．例えば，モックオブジェクトなどを事前に準備するために用いられる．

**＊実装例＊**

```php
<?php
    
use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{
    protected $example;
    
    protected function setUp()
    {
        // 基本的には，一番最初に記述する．
        parent::setUp();
        
        $this->example = Phake::mock(Example::class);
    }
}
```

#### ・```tearDown```メソッド

テストクラスの中で，自動的に一番最後にコールされるメソッドである．例えば，グローバル変数やサービスコンテナにデータを格納する場合，後の検証でもそのデータが誤って使用されてしまわないように，サービスコンテナを破棄するために用いられる．

**＊実装例＊**

```php
<?php

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{
    protected $container;
    
    protected function setUp()
    {
        // DIコンテナにデータを格納する．
        $this->container["option"];
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

## 03.  Test Double（テストダブル）

### テストダブルの種類

#### ・モックオブジェクト

上流クラスが下流クラスを正しくコールできるかどうかを検証したい時に，上流クラス以外の部分の処理は不要であり，下流クラスの実体があるかのように見せかける．この見せかけの下流クラスを『モックオブジェクト』という．この時，下流クラスのモックオブジェクトにスタブを定義し，実体のある上流クラスが下流クラスにパラメータを渡した時に，下流クラスを正しい回数実行できているかを検証する．

#### ・スタブ

クラスのメソッドの特定の処理を検証したい時に，対象以外の部分の処理は不要であり，処理の実体があるかのように見せかける．この見せかけの部分的処理を『スタブ』という．この時，スタブは正しい処理を実行するように定義し，その他の実体のある処理が正しく実行されるかを検証する．検証対象の処理のみに実体であっても，一連の処理を実行できる．実体のあるクラスに対して，またモックオブジェクトに対して，スタブを定義できる．

#### ・モックオブジェクトツール，スタブツール

PHPUnit，Phake，Mockery

<br>

### PHPUnit

#### ・```createMock```メソッド

クラスの名前空間を元に，モックオブジェクトを生成する．

```php
<?php
    
use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{   
   /**
    * @test
    */    
    public function testExample()
    {    
        $mock = $this->createMock(Example::class);
    }
}
```

#### ・```method```メソッド

 モックオブジェクトに対してスタブを定義する．また，特定の変数が渡された時に，特定の値を返却させることができる．

```php
<?php

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{   
   /**
    * @test
    */    
    public function testExample()
    {    
        $mock = $this->createMock(Example::class);
        
        $mock->method("find")
            ->with(1)
            ->willReturn([]);
    }
}
```

<br>

### Phake

#### ・Phakeとは

モックオブジェクトとスタブを提供するライブラリ．

参考：https://github.com/mlively/Phake#phake

#### ・```mock```メソッド

クラスの名前空間を元に，モックオブジェクトを生成する．

```php
<?php

$mock = Phake::mock(Example::class);
```

#### ・```when```メソッド

 モックオブジェクトに対してスタブを定義する．また，特定の変数が渡された時に，特定の値を返却させることができる．

**＊実装例＊**

モックオブジェクトの```find```メソッドは，```1```が渡された時に，空配列を返却する．

```php
<?php
    
$mock = Phake::mock(Example::class);

\Phake::when($mock)
    ->find(1)
    ->thenReturn([]);
```

#### ・```verify```メソッド

上流オブジェクトが下流オブジェクトをコールできることを確認するために，モックオブジェクトに定義されたスタブのメソッドが```n```回実行できたことを検証する．

**＊実装例＊**

```php
<?php

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{   
   /**
    * @test
    */    
    public function testExample()
    {    
        // モックオブジェクトを定義する．
        $mockExampleRepository = Phake::mock(ExampleRepository::class);
        $exampleId = Phake::mock(ExampleId::class);

        // モックオブジェクトにスタブを定義する．
        \Phake::when($mockExampleRepository)
            ->find($exampleId)
            ->thenReturn(new User(1)); 
        
        // 上流クラスにモックオブジェクトを設定する．
        $example = new Example($mockExampleRepository);
        
        // 上流クラスの内部にある下流モックオブジェクトのfindメソッドをコールする
        $example->getUser($exampleId)

        // 上流のクラスが，下流モックオブジェクトにパラメータを渡し，メソッドを実行したことを検証する．
        Phake::verify($mockExampleRepository, Phake::times(1))->find($exampleId);
    }
}
```

<br>

## 04. PHPStan

### コマンド

#### ・オプション無し

全てのファイルを対象として，静的解析を行う．

```shell
$ vendor/bin/phpstan analyse
```

<br>

### phpstan.neonファイル

#### ・```phpstan.neonファイル```とは

PHPStanの設定を行う．

#### ・```includes```

```yaml
includes:
    - ./vendor/nunomaduro/larastan/extension.neon
```

#### ・```parameters```

静的解析の設定を行う．

**＊実装例＊**

```yaml
parameters:
    # 解析対象のディレクトリ
    paths:
        - src
    # 解析の厳格さ（最大レベルは８）．各レベルの解析項目については以下を参考にせよ．
    # https://phpstan.org/user-guide/rule-levels
    level: 5
    # 発生を無視するエラーメッセージ
    ignoreErrors:
        - '#Unsafe usage of new static#'
    # 解析対象として除外するディレクトリ
    excludes_analyse:
        - ./src/Example/*
        
    checkMissingIterableValueType: false
    inferPrivatePropertyTypeFromConstructor: true
```

<br>

## 05. テスト仕様書に基づくユニットテスト

### 注意点

PHPUnitでのユニットテストとは意味合いが異なるので注意する．

<br>

### ブラックボックステスト

#### ・ブラックボックステストとは

実装内容は気にせず，入力に対して，適切な出力が行われているかを検証する．

![p492-1](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p492-1.jpg)

<br>

### ホワイトボックステスト

#### ・ホワイトボックステストとは

実装内容が適切かを確認しながら，入力に対して，適切な出力が行われているかを検証する．ホワイトボックステストには，以下の方法がある．何を検証するかに着目すれば，思い出しやすい．

![p492-2](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p492-2.jpg)

**＊実装例＊**

```php
if (A = 1 && B = 1) {
　return X;
}
```

上記のif文におけるテストとして，以下の４つの方法が考えられる．基本的には，複数条件網羅が用いられる．

#### ・命令網羅

![p494-1](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p494-1.png)

全ての命令が実行されるかを検証する．

**＊例＊**

A = 1，B = 1 の時，```return X``` が実行されること．

#### ・判定条件網羅

![p494-2](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p494-2.png)

全ての判定が実行されるかを検証する．

**＊例＊**

A = 1，B = 1 の時，```return X``` が実行されること．
A = 1，B = 0 の時，```return X``` が実行されないこと．

#### ・条件網羅

![p494-3](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p494-3.png)

各条件が，取り得る全ての値で実行されるかを検証する．

**＊例＊**

A = 1，B = 0 の時，```return X``` が実行されないこと．
A = 0，B = 1 の時，```return X``` が実行されないこと．

または，次の組み合わせでもよい．

A = 1，B = 1 の時，```return X``` が実行されること．
A = 0，B = 0 の時，```return X``` が実行されないこと．

#### ・複数条件網羅

![p494-4](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p494-4.png)

各条件が，取り得る全ての値で，かつ全ての組み合わせが実行されるかを検証する．

**＊例＊**

A = 1，B = 1 の時，```return X``` が実行されること．
A = 1，B = 0 の時，```return X``` が実行されないこと．
A = 0，B = 1 の時，```return X``` が実行されないこと．
A = 0，B = 0 の時，```return X``` が実行されないこと．

 <br>

## 05-02. テスト仕様書に基づく結合テスト

### 結合テストとは

単体テストの次に行うテスト．複数のモジュールを繋げ，モジュール間のインターフェイスが適切に動いているかを検証．

![結合テスト](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p491-1.jpg)

<br>

### 結合テストの方向

#### ・トップダウンテスト

上流のモジュールから下流のモジュールに向かって，結合テストを行う．下流にはテストダブルのスタブを作成する．

![トップダウンテスト](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/トップダウンテスト.jpg)

<br>

#### ・ボトムアップテスト

下流のモジュールから上流のモジュールに向かって，結合テストを行う．上流にはテストダブルのドライバーを作成する．

![ボトムアップテスト](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/ボトムアップテスト.jpg)

<br>

### Scenarioテスト

実際の業務フローを参考にし，ユーザが操作する順にテストを行う．

<br>


## 05-03. テスト仕様書に基づくシステムテスト

### システムテスト

#### ・システムテストとは

結合テストの次に行うテスト．システム全体が適切に動いているかを検証する．User Acceptanceテスト，また総合テストともいう．

#### ・テストケース例

以下の操作を対象として検証するとよい．

| 大分類 | 中分類           | 検証対象の操作                                               |
| ------ | ---------------- | ------------------------------------------------------------ |
| 機能   | 正常系           | 基本操作（登録，参照，更新，削除），画面遷移，状態遷移，セキュリティ，など |
|        | 異常系           | 基本操作（登録，参照，更新，削除），など                     |
|        | 組み合わせ       | 同時操作，割り込み操作，排他制御に関わる操作，など           |
|        | 業務シナリオ     | シナリオに沿ったユーザによる一連の操作                       |
|        | 開発者シナリオ   | シナリオに沿った開発者による一連の操作（手動コマンドなど）   |
|        | 外部システム連携 | 外部のAPIとの連携処理に関わる操作                            |
| 非機能 | 負荷耐性や性能   | 各種負荷テスト（性能テスト，限界テスト，耐久テスト）         |

<br>

### 機能テスト

機能要件を満たせているかを検証する．PHPUnitでの機能テストとは意味合いが異なるので注意．

<br>

### 負荷テスト

#### ・負荷テストとは

実際の運用時に，想定したリクエスト数に耐えられるか，を検証する．また，テスト結果から，運用時の監視で参考にするための，安全範囲（青信号），危険範囲（黄色信号），限界値（赤信号），を導く必要がある．

参考：https://www.oracle.com/jp/technical-resources/article/ats-tech/tech/useful-class-8.html

#### ・負荷テストのパラメータ

| 項目       | 説明                                                         |
| ---------- | ------------------------------------------------------------ |
| スレッド数 | ユーザ数に相当する．                                         |
| ループ数   | ユーザ当たりのリクエスト送信数に相当する．                   |
| RampUp秒   | リクエストを送信する期間に相当する．長くし過ぎすると，全てのリクエスト数を送信するまでに時間がかかるようになるため，負荷が小さくなる． |

#### ・性能テスト

![performance-test](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/performance-test.png)

一定時間内に，ユーザが一連のリクエスト（例：ログイン，閲覧，登録，ログアウト）を行った時に，システムのスループットとレスポンス時間にどのような変化があるかを検証する．具体的にはテスト時に，アクセス数を段階的に増加させて，その結果をグラフ化する．グラフ結果を元に，想定されるリクエスト数が現在の性能にどの程度の負荷をかけるのかを確認し，また性能の負荷が最大になる値を導く．これらを運用時の監視の参考値にする．

#### ・限界テスト

性能の限界値に達するほどのリクエスト数が送信された時に，障害回避処理（例：アクセスが込み合っている旨のページを表示）が実行されるかを検証する．具体的にはテスト時に，障害回避処理以外の動作（エラー，間違った処理，障害回復後にも復旧できない，システムダウン）が起こらないかを確認する．

#### ・耐久テスト

長時間の大量リクエストが送信された時に，短時間では検出できないどのような問題が存在するかを検証する．具体的にはテスト時に，長時間の大量リクエストを処理させ，問題（例：微量のメモリリークが蓄積してメモリを圧迫，セッション情報が蓄積してメモリやディスクを圧迫，ログが蓄積してディスクを圧迫，ヒープやトランザクションログがCPUやI/O処理を圧迫）

<br>

### 再現テスト

#### ・再現テストとは

障害発生後の措置としてスペックを上げる場合，そのスペックが障害発生時の負荷に耐えられるかを検証する．

#### ・テストケース例

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

###  ポストモーテム

#### ・ポストモーテムとは

障害報告書とは異なり，原因特定とシステム改善に重きを置いた報告書のこと．障害報告書は，責任の報告の意味合いが強くなってしまう．テンプレートは以下の通り．

```markdown
# ポストモーテム

## タイトル

## 日付

## 担当者

**※担当者を絶対に責めず，障害は誰のせいでもないという意識を強く持つ．**

## 原因と対応

**※原因特定とシステム改善に重きを置くこと．**

## システム的/収益的な影響範囲

## 幸運だったこと

## 仕組みの改善策

**※「以後は注意する」ではなく，再発しない仕組み作りになるようにする．**

## 障害発生から対応までのタイムライン

```

<br>

## 06. その他のテスト

### Regressionテスト（回帰テスト）

システムを変更した後，他のプログラムに悪影響を与えていないかを検証．

![p496](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/p496.jpg)

<br>

## 07. グラフによるテストの可視化

### バグ管理図

プロジェクトの時，残存テスト数と不良摘出数（バグ発見数）を縦軸にとり，時間を横軸にとることで，バグ管理図を作成する．それぞれの曲線の状態から，プロジェクトの進捗状況を読み取ることができる．

![品質管理図](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/品質管理図.jpg)

不良摘出実績線（信頼度成長曲線）は，プログラムの品質の状態を表し，S字型でないものはプログラムの品質が良くないことを表す．

![信頼度成長曲線の悪い例](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/信頼度成長曲線の悪い例.jpg)



