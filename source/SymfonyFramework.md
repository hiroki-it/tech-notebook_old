# Symfonyフレームワーク

## 01-01. 特に汎用的なコンポーネント

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



### :pushpin: Pimpleコンポーネント

```PHP
use Pimple\ConfigSupport;
use Pimple\Container;
use Pimple\DiSupport;
use Pimple\ServiceProviderInterface;
```



### :pushpin: Securityコンポーネント

```PHP
use Symfony\Component\Security\Core\AuthenticationEvents;
use Symfony\Component\Security\Csrf\CsrfToken;
use Symfony\Component\Security\Csrf\CsrfTokenManager;
```



### :pushpin: EventDispatcherコンポーネント

```PHP
use Symfony\Component\EventDispatcher\Event;
use Symfony\Component\EventDispatcher\EventDispatcherInterface;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
```



### :pushpin: Routingコンポーネント

```PHP
use Symfony\Component\Routing\Loader\Configurator\RoutingConfigurator;
```




## 02-01. Consoleコンポーネント

### :pushpin: CLI：Command Line Interface

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
        $this->addArgument(
          'year-month',
          InputArgument::REQUIRED,
          '処理年月を設定してください．'
        )
    }
  
    // コマンドの処理内容
    protected function execute(InputeInterface $input, OutputInterface $output)
    {
        try {
                // 日時フォーマットからCarbonインスタンスを作成する．
                $year_month = Carbon::createFromFormat(
                  'Y-m',
                  $input->getArgument('year-month')
                );
        
        } catch (\Exception $e) {
            // エラーログの文章を作成
  }  
  
}
```

### :pushpin: CLIをコールするバッチファイル

#### ・```for```

```bash
# txtファイルを変数fに繰り返し格納し，処理を行う．
for f in *txt do echo $f; done;
```

#### ・Cronによるコマンドの自動実行

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

1. Requestオブジェクト

   グローバル変数から収集した情報やHTTPリクエストのヘッダ情報やコンテンツ情報を保持

1. カーネルオブジェクトの```handle()```

   送られてきたURLを基にしたコントローラ／アクションへのルートの特定，特定されたコントローラ／アクションの実行，テンプレートのレンダリング

1. Responseオブジェクト

   HTTPレスポンスのヘッダ情報やコンテンツ情報などの情報を保持

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



### :pushpin: Request，Response

#### ・リクエストメッセージからのデータ取得，JSON型データのレスポンス

1. Ajaxによるリクエストの場合，JSON型データをレスポンスし，かつページレンダリング．
2. Ajaxによるリクエストでない場合，ページレンダリングのみ

```PHP
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use App\Repository\XxxReposiroy;

class ExampleController extends AbstractController 
{
    public function get(Request $req)
    {
        // Ajaxによるリクエストの場合．
        if ($req->headers->get('content-type') === 'application/json') {
            
            $xxxRepository = new XxxRepository;
            $entityObject = $xxxRepository->getEntity();
            
            //-- entityをObject型からArray型に変換する何らかの処理．--//
            
            // Ajaxにレンスポンス．
            return new JsonResponse([ 
                'value' => $entityArray
              ]);
        }
    
        return $this->render('.../xxx.twig')->setStatusCode(200);
    }
}
```

#### 

## 02-03. Pimpleコンポーネント

### :pushpin: Service Container

Symfonyから提供されるDIコンテナのこと．



## 02-04. Routingコンポーネント

### :pushpin: RoutingConfigurator

コントローラへのルーティングを設定する．

```PHP
use App\Controller\BlogApiController; // ルーティング先のコントローラを読み込み
use Symfony\Component\Routing\Loader\Configurator\RoutingConfigurator;

return function (RoutingConfigurator $routes) {
    $routes->add('api_post_show', '/api/posts/{id}')
        ->controller([BlogApiController::class, 'show'])
        ->methods(['GET', 'HEAD'])
    ;
    $routes->add('api_post_edit', '/api/posts/{id}')
        ->controller([BlogApiController::class, 'edit'])
        ->methods(['PUT'])
    ;
};
```

