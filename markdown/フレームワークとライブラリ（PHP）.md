# 目次

<!-- TOC -->

- [01-01. Symfonyフレームワーク](#01-01-symfonyフレームワーク)
    - [:pushpin: 採用すべき最低限のクラス](#pushpin-採用すべき最低限のクラス)
- [01-02. Consoleに関するクラス](#01-02-consoleに関するクラス)
    - [:pushpin: Commandクラス](#pushpin-commandクラス)
    - [:pushpin: バッチファイル](#pushpin-バッチファイル)
- [01-03. HttpFoundationに関するクラス](#01-03-httpfoundationに関するクラス)
    - [:pushpin: AppKernel](#pushpin-appkernel)
- [02-01. Carbonライブラリ](#02-01-carbonライブラリ)
    - [:pushpin: Date型](#pushpin-date型)
    - [:pushpin: ```instance()```](#pushpin-instance)
    - [:pushpin: ```create()```](#pushpin-create)
    - [:pushpin: ```createFromXXX()```](#pushpin-createfromxxx)
    - [:pushpin: ```parse()```](#pushpin-parse)
- [03-01. Pinqライブラリ](#03-01-pinqライブラリ)
- [04-01. Doctrineライブラリ](#04-01-doctrineライブラリ)
    - [:pushpin: ```createQueryBuilder()```](#pushpin-createquerybuilder)

<!-- /TOC -->
## 01-01. Symfonyフレームワーク

### :pushpin: 採用すべき最低限のクラス

```PHP
// Consoleに関するクラス
use Symfony\Component\Console\Application;
use Symfony\Component\Console\Command\LockableTrait;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;


// HttpFoundationに関するクラス
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;


// HttpKernelに関するクラス
use Symfony\Component\HttpKernel\Event\FilterResponseEvent;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;


// Securityに関するクラス
use Symfony\Component\Security\Csrf\CsrfToken;
use Symfony\Component\Security\Csrf\CsrfTokenManager;
```



## 01-02. Consoleに関するクラス

### :pushpin: Commandクラス

Commandクラスによって定義されたコマンドは、バッチファイル（```.bat```）に一連の処理として組み合わせられる。

**【実装例】**

```PHP
use Symfony\Component\Console\Command\LockableTrait;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;

class createExampleCommand extends \Symfony\Component\Console\Command\Command
{
  // オプションの設定
	protected function configure()
	{
		// コマンド名
		$this->setName('create:example');
    
		// コマンド名の後に追加したい引数名
		$this->addArgument('year-month', InputArgument::REQUIRED, '処理年月を設定してください。')
	}
  
	// コマンドの処理内容
	protected function execute(InputeInterface $input, OutputInterface $output)
	{
		try {
				// 日時フォーマットからCarbonインスタンスを作成する。
				$year_month = Carbon::createFromFormat('Y-m', $input->getArgument('year-month'));
		
		} catch (\Exception $e) {
			// エラーログの文章を作成
  }  
  
}
```

### :pushpin: バッチファイル

- **```for```**

```bash
# txtファイルを変数fに繰り返し格納し、処理を行う。
for f in *txt do echo $f; done;
```

- **Cronによるコマンド自動実行**

**【具体例】**

10秒ごとに、コマンドを自動実行する。

```bash
# 10秒ごとに、コマンド処理を実行。
for f in `seq 0 10 59`; do (sleep {$f}; create:example) & done;
```

```bash
# 15時ごとに、コマンド処理を実行。
0 15 * * * * create:example;
```



## 01-03. HttpFoundationに関するクラス

### :pushpin: AppKernel

![図2-9-ver2](https://user-images.githubusercontent.com/42175286/57711074-08c21b00-76a9-11e9-959e-b3777f70d2c6.png)

- **カーネルに必要なオブジェクト**

1. Requestオブジェクト：グローバル変数から収集した情報やHTTPリクエストのヘッダ情報やコンテンツ情報を保持
1. カーネルオブジェクトの```handle()```：送られてきたURLを基にしたコントローラ／アクションへのルートの特定、特定されたコントローラ／アクションの実行、テンプレートのレンダリング
1. Responseオブジェクト：HTTPレスポンスのヘッダ情報やコンテンツ情報などの情報を保持

- **オブジェクトから取り出されたメソッドの役割**

1. カーネルが、クラアントからのHTTPリクエストをリクエストオブジェクトとして受け取る。
1. カーネルが、送られてきたURLとルート定義を基に、リクエストに対応するコントローラアクションを探し、実行させる。その後、テンプレートがURLを生成。
1. カーネルが、その結果をレスポンスオブジェクトとしてクライアントに返す。
   このカーネルを、特別に『HTTPカーネル』と呼ぶ。

**【app.phpの実装例】**

```PHP
use Symfony\Component\HttpFoundation\Request;


$kernel = new AppKernel('dev', true);

if (PHP_VERSION_ID < 70000) {
    $kernel->loadClassCache();
}

$request = Request::createFromGlobals();  //（１）

// 以下の実装ファイルも参照せよ。
$response = $kernel->handle($request); //（２）

$response->send(); //（３）

$kernel->terminate($request, $response);
```

上記の```handle()```が定義されているファイル。ここで定義された```handle()```が、C/Aへのルートの特定、特定されたC/Aの実行、テンプレートのレンダリングを行う。

```PHP
public function handle
(
    Request $request,
    $type = HttpKernelInterface::MASTER_REQUEST,
    $catch = true
)
{
	$this->boot();
    
	++$this->requestStackSize;
    
	$this->resetServices = true;

	try {
        return $this->getHttpKernel()->handle($request, $type, $catch);
	
    } finally {
        --$this->requestStackSize;
	}
}
```



## 02-01. Carbonライブラリ

### :pushpin: Date型

厳密にはデータ型ではないが、便宜上、データ型とする。タイムスタンプとは、協定世界時(UTC)を基準にした1970年1月1日の0時0分0秒からの経過秒数を表したもの。

| フォーマット         | 実装方法            | 備考                                                         |
| -------------------- | ------------------- | ------------------------------------------------------------ |
| 日付                 | 2019-07-07          | 区切り記号なし、ドット、スラッシュなども可能                 |
| 時間                 | 19:07:07            | 区切り記号なし、も可能                                       |
| 日時                 | 2019-07-07 19:07:07 | 同上                                                         |
| タイムスタンプ（秒） | 1562494027          | 1970年1月1日の0時0分0秒から2019-07-07 19:07:07 までの経過秒数 |



### :pushpin: ```instance()``` 

DateTimeインスタンスを引数として、Carbonインスタンスを作成する。

```PHP
$datetime = new \DateTime('2019-07-07 19:07:07');
$carbon = Carbon::instance($datetime);

echo $carbon;
// 出力結果
2019-07-07 19:07:07
```



### :pushpin: ```create()```

日時の文字列からCarbonインスタンスを作成する。

```PHP
$carbon = Carbon::create(2019, 07, 07, 19, 07, 07);

echo $carbon;
// 出力結果
2019-07-07 19:07:07
```



### :pushpin: ```createFromXXX()```

指定の文字列から、Carbonインスタンスを作成する。

```PHP
// 日時数字から、Carbonインスタンスを作成する。
$carbonFromeDate = Carbon::createFromDate(2019, 07, 07);

// 時間数字から、Carbonインスタンスを作成する。
$carbonFromTime = Carbon::createFromTime(19, 07, 07);

// 日付、時間、日時フォーマットから、Carbonインスタンスを作成する。
// 第一引数でフォーマットを指定する必要がある。
$carbonFromFormat = Carbon::createFromFormat('Y-m-d H:m:s', '2019-07-07 19:07:07');

// タイムスタンプフォーマットから、Carbonインスタンスを作成する。
$carbonFromTimestamp = Carbon::createFromTimestamp(1562494027);


echo $carbonFromeDate;
// 出力結果  
2019-07-07
  
echo $carbonFromTime;
// 出力結果  
19:07:07

echo $carbonFromFormat;
// 出力結果    
2019-07-07 19:07:07

echo $carbonFromTimestamp;
// 出力結果
2019-07-07 19:07:07
```



### :pushpin: ```parse()```

日付、時間、日時フォーマットから、Carbonインスタンスを作成する。

```PHP
// createFromFormat()とは異なり、フォーマットを指定する必要がない。
$carbon = Carbon::parse('2019-07-07 19:07:07')
```


## 03-01. Pinqライブラリ

SQLのSELECTやWHEREといった単語を用いて、```foreach()```のように、コレクションデータを走査できるライブラリ。

## 04-01. Doctrineライブラリ

### :pushpin: ```createQueryBuilder()```

```getConnection()```を起点として、返り値から繰り返しメソッドを取得し、```fetchAll()```で、テーブルのクエリ名をキーとした連想配列が返される。

**【実装例】**

```PHP
use Doctrine\DBAL\Connection;


class dogToyQuey(Value $toyType): Array
{
  // QueryBuilderインスタンスを作成する
  $queryBuilder = $this->createQueryBuilder();

  // SELECTを設定する
  $queryBuilder->select([
                  'dog_toy.type AS dog_toy_type',
                  'dog_toy.name AS dog_toy_name',
                  'dog_toy.number AS number',
                  'dog_toy.price AS dog_toy_price',
                  'dog_toy.color_value AS color_value'
                  ])

                  // FROMを設定する。
                  ->from('mst_dog_toy', 'dog_toy')

                  // WHEREを設定する。この時、値はプレースホルダーとしておく。
                  ->where('dog_toy.type = :type'))

                  // プレースホルダーに値を設定する。ここでは、引数で渡す『$toyType』とする。
                  ->setParameter('type', $toyType);


  // データベースから『$toyType』に相当するレコードを取得する。
  return $queryBuilder->getConnection()

                      // 設定したSQLとプレースホルダーを取得する。
                      ->executeQuery($queryBuilder->getSQL(),
                                      $queryBuilder->getParameters(),
                      )
    
											// レコードを取得する。
                      ->fetchAll();

}
```
