# Silexフレームワーク

## 01-01. Symfonyから採用している主なコンポーネント

### :pushpin: Consoleコンポーネント

```PHP
use Symfony\Component\Console\Application;
use Symfony\Component\Console\Command\LockableTrait;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
```

### :pushpin: HttpFoundationコンポーネント

```PHP
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\ResponseHeaderBag;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\RedirectResponse;
```

### :pushpin: HttpKernelコンポーネント

```PHP
use Symfony\Component\HttpKernel\Event\FilterResponseEvent;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
```

### :pushpin: Securityコンポーネント

```PHP
use Symfony\Component\Security\Csrf\CsrfToken;
use Symfony\Component\Security\Csrf\CsrfTokenManager;
```

### :pushpin: Pimpleコンポーネント

```PHP
use \Squid\Package\Pimple\ConfigSupport;
use \Squid\Package\Pimple\DiSupport;
```



## 01-01. Doctrineライブラリ

### :pushpin: ```createQueryBuilder()```

データベース接続に関わる```getConnection()```を起点として，返り値から繰り返しメソッドを取得し，```fetchAll()```で，テーブルのクエリ名をキーとした連想配列が返される．

- **プレースホルダー**

プリペアードステートメントともいう．SQL中にパラメータを設定し，値をパラメータに渡した上で，SQLとして発行する方法．処理速度が速い．また，パラメータに誤ってSQLが渡されても，これを実行できなくなるため，SQLインジェクションの対策にもなる

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

                  // FROMを設定する．
                  ->from('mst_dog_toy', 'dog_toy')

                  // WHEREを設定する．この時，値はプレースホルダーとしておく．
                  ->where('dog_toy.type = :type'))

                  // プレースホルダーに値を設定する．ここでは，引数で渡す『$toyType』とする．
                  ->setParameter('type', $toyType);


  // データベースから『$toyType』に相当するレコードを取得する．
  return $queryBuilder->getConnection()

                      // 設定したSQLとプレースホルダーを取得する．
                      ->executeQuery($queryBuilder->getSQL(),
                                      $queryBuilder->getParameters(),
                      )
    
                      // レコードを取得する．
                      ->fetchAll();

}
```





## 02-01. Consoleコンポーネント

### :pushpin: Commandクラス

Commandクラスによって定義されたコマンドは，バッチファイル（```.bat```）に一連の処理として組み合わせられる．

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
        $this->addArgument('year-month', InputArgument::REQUIRED, '処理年月を設定してください．')
    }
  
    // コマンドの処理内容
    protected function execute(InputeInterface $input, OutputInterface $output)
    {
        try {
                // 日時フォーマットからCarbonインスタンスを作成する．
                $year_month = Carbon::createFromFormat('Y-m', $input->getArgument('year-month'));
        
        } catch (\Exception $e) {
            // エラーログの文章を作成
  }  
  
}
```

### :pushpin: バッチファイル

#### ・```for```

```bash
# txtファイルを変数fに繰り返し格納し，処理を行う．
for f in *txt do echo $f; done;
```

#### ・Cronによるコマンド自動実行

**【具体例】**

10秒ごとに，コマンドを自動実行する．

```bash
# 10秒ごとに，コマンド処理を実行．
for f in `seq 0 10 59`; do (sleep {$f}; create:example) & done;
```

```bash
# 15時ごとに，コマンド処理を実行．
0 15 * * * * create:example;
```



## 02-02. HttpFoundationコンポーネント

### :pushpin: AppKernel

![図2-9-ver2](https://user-images.githubusercontent.com/42175286/57711074-08c21b00-76a9-11e9-959e-b3777f70d2c6.png)

#### ・カーネルに必要なオブジェクト

1. Requestオブジェクト：グローバル変数から収集した情報やHTTPリクエストのヘッダ情報やコンテンツ情報を保持
1. カーネルオブジェクトの```handle()```：送られてきたURLを基にしたコントローラ／アクションへのルートの特定，特定されたコントローラ／アクションの実行，テンプレートのレンダリング
1. Responseオブジェクト：HTTPレスポンスのヘッダ情報やコンテンツ情報などの情報を保持

#### ・オブジェクトから取り出されたメソッドの役割

1. カーネルが，クラアントからのHTTPリクエストをリクエストオブジェクトとして受け取る．
1. カーネルが，送られてきたURLとルート定義を基に，リクエストに対応するコントローラアクションを探し，実行させる．その後，テンプレートがURLを生成．
1. カーネルが，その結果をレスポンスオブジェクトとしてクライアントに返す．
   このカーネルを，特別に『HTTPカーネル』と呼ぶ．

**【app.phpの実装例】**

```PHP
use Symfony\Component\HttpFoundation\Request;


$kernel = new AppKernel('dev', true);

if (PHP_VERSION_ID < 70000) {
    $kernel->loadClassCache();
}

$request = Request::createFromGlobals();  //（１）

// 以下の実装ファイルも参照せよ．
$response = $kernel->handle($request); //（２）

$response->send(); //（３）

$kernel->terminate($request, $response);
```

上記の```handle()```が定義されているファイル．ここで定義された```handle()```が，C/Aへのルートの特定，特定されたC/Aの実行，テンプレートのレンダリングを行う．

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



## 02-03. Pimpleコンポーネント

### :pushpin: Service Container

Symfonyから提供されるDIコンテナのこと．


