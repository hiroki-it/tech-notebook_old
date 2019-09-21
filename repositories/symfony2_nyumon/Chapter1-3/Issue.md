## Setter vs. Getter
![Getter vs Setter](https://user-images.githubusercontent.com/42175286/56820181-2d835980-6886-11e9-9178-37661d9bbdf8.jpg)
引用リンク：KAB-studio，http://www.kab-studio.biz/Programing/OOPinJava/03/05.html

## Symfonyのディレクトリ構成

```
Symfony
├── app #設定や画面テンプレートを格納し、基本的にPHPのコードは格納しない
│   ├── Resources
│   │   └── views (1)　# 画面テンプレートを格納
│   └── config　# 設定ファイルを格納（カーネルのためのルート定義ファイル等）
│
├── bin　# コマンドラインツールを格納
│
├── src　# 自分が作成するソースコードを格納
│   ├── AppBundle　(a) # アプリケーションのソースコードを格納
│   │  ├── Controller　# コントローラ（ページの種類に合わせたルーティング、テンプレートのレンダリング）を格納
│   │  ├── Entity #エンティティを格納
│   │  ├── Repository #レポジトリを格納
│   │  ├── Form #フォーム
│   │  └── Resources
│   │       └── views  (2) #画面テンプレートを格納 
│   │           
│   └── その他のBundle  (b) #汎用的なライブラリのソースコードを格納
│   
├── test #自動テスト（Unit tests等）
│  
├── var #自動生成されるファイル（cache、logs等）
│
├── vendor (c)  #composerでインストールしたパッケージを格納（Doctrine等）　
│
└── web #ドキュメントルート（css, javascript, image等）
```

## Webシステムの仕組みの全体像
![図2-9](https://user-images.githubusercontent.com/42175286/55077357-e2392800-50da-11e9-8ef4-18556d0263ff.png)

## カーネルを中心としたWebシステムの仕組み
（１）カーネルが、クラアントからのHTTPリクエストをリクエストオブジェクトとして受け取る。
（２）カーネルが、リクエストとコントローラアクションの間のマッピング（対応表）を元に、ルーティングを行い、テンプレートのレンダリングを実行させる。その後、テンプレートがURLを生成。
（３）カーネルが、その結果をレスポンスオブジェクトとしてクライアントに返す。
このカーネルを、特別に『HTTPカーネル』と呼ぶ。

## クライアントとサーバー間のデータの流れ
WebブラウザからWebサーバへHTTPリクエストが送られる時、レイヤーの層に応じて利用されるプロトコルが異なる。
![HTTPでのクライアントとサーバー間のデータの流れ](https://user-images.githubusercontent.com/42175286/56850631-23be2c80-6940-11e9-9f47-84a31d2f1401.png)
![TCP・IPの階層構造](https://user-images.githubusercontent.com/42175286/56851080-fffde500-6945-11e9-9ea4-be260540a3a9.png)

## レンダリング
レンダリングとは、『HTMLなどのコードを読み込んで、ウェブページの画面として表示させること』
![Webディレクターズ](https://user-images.githubusercontent.com/42175286/55421967-862c4300-55b5-11e9-924f-9f7f9fefbe53.jpg)
引用リンク：Webディレクターズ，http://web-directors.net/modules/pico/index.php?content_id=93

### **◇ レンダリングの仕組み（基本的にはフロントエンジニアの理解すべきこと）**
![ブラウザレンダリング入門〜知ることで見える世界〜](https://user-images.githubusercontent.com/42175286/55420225-7448a100-55b1-11e9-86a5-6209525d8c12.png)
引用リンク：ブラウザレンダリング入門〜知ることで見える世界〜，https://qiita.com/Leapin_JP/items/caed57ec30d638e40728

### **◇ ルーティングの流れ**
![image](https://user-images.githubusercontent.com/42175286/55173727-93b18980-51bf-11e9-9b14-693dc6187e9a.png)

### ◇ ルーティングの例
ルーティングの形式：YAMLファイル、XMLファイル、コントローラのアノテーション、PHPコードで定義
（例）YAMLファイル
![図3-7](https://user-images.githubusercontent.com/42175286/55272209-5b639580-52fc-11e9-8ba0-b0cb11c7cf54.png)

（１）まず、```config_dev.yml```がルート定義ファイルのパスを指定

```
router:
    resource: "%kernel.root_dir%/config/routing_dev.yml"
```

（２）次に、```routing_dev.yml```がルート定義ファイルのパスを指定

```
_wdt: Webデバックツールバー用のルート定義ファイルのパス #ルート定義ファイルのパスが各機能ごとに分割されている
 resource: "@WebProfilerBundle/Resources/config/routing/wdt.xml" 
 prefix: /_wdt　#prefix: 読みこんだURLの先頭に指定の文字を追加

_profiler: プロファイラ用のルート定義ファイルのパス
 resource: "@WebProfilerBundle/Resources/config/routing/profiler.xml"
 prefix: /_profiler

_main: メインのルート定義ファイル
 resource: routing.yml
```

（３）ホームページのコントローラへルーティング

```
# ...
app: コントローラのあるディレクトリを指定
    resource: '@AppBundle/Controller/'
    type: annotation
    prefix: /{_locale}
    requirements:
       _locale: %app_locales%
    defaults:
       _locale: %locale%

# ...
homepage: ホームページのコントローラへルーティング
    path:/{_local}
    defaults:
       _controller: FrameworkBundle: Template: template #コントローラ／アクションへのルート
       template: 'default/homepage.html.twig' #レンダリングするテンプレート
       _local: "%locale%"
```

（４）上記app項目でルーティングされたコントローラが、テンプレートをレンダリング

```
namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

    //指定のURL(/blog)がリクエストされる
    //⇒カーネルが、URL(/blog)とマッピングされているコントローラを探し、このコントローラにたどり着く（ルーティング）
    //⇒コントローラ名とアクション名がカーネルに返る
    //⇒カーネルがこのコントローラ／アクションを呼び出す

/**
 * @Route("/blog") 
 */
class BlogController extends Controller
{
    /**
     * @Route("/", defaults={"page": "1", "_format"="html"}, name="blog_index") #ルート定義
     */
    public function indexAction($page, $_format)
    {
        return $this->render('blog/index.'.$_format.'.twig', ['posts' => $posts]);
    }
}
```

（５）レンダリングされたテンプレートの```path()```で、URLを生成。
※第６章までのルート一覧を画像として用いている。
![ルート一覧](https://user-images.githubusercontent.com/42175286/56913732-62ddb080-6aed-11e9-880a-6748e5e5dee5.png)

## カーネルが実行する実際のスクリプト
（１）Requestオブジェクト：メソッドとして、GET送信やPOST送信で受け取った値のほか、HTTPリクエストのヘッダ情報やセッションに関する情報を保持
（２）```handle()```メソッド：コントローラ／アクションへのルーティング、コントローラ／アクションの実行、テンプレートのレンダリング
（３）Responseオブジェクト：HTTPレスポンスのヘッダ情報やコンテンツなどの情報を保持

```
$kernel = new AppKernel('dev', true); 
if (PHP_VERSION_ID < 70000) {
    $kernel->loadClassCache();
}
$request = Request::createFromGlobals();  #（１）
$response = $kernel->handle($request); #（２）
$response->send(); #（３）
$kernel->terminate($request, $response);
```
## HTTPリクエストのメソッドの種類

### **◇ GET送信**
URLに付加してHTTPリクエストを送る方法。
URLに情報が記述されるため、履歴で確認できてしまう。

### **◇ POST送信**
メッセージボディに記述してHTTPリクエストを送る方法。
メッセージボディに情報が記述されるため、履歴では確認できない。

### **◇ 一覧**
![HTTPリクエストのメソッド](https://user-images.githubusercontent.com/42175286/56901644-9875a000-6ad3-11e9-93a1-a738b2e382ac.png)

## コントローラとレンダリングするページ構成の関係
![コントローラとレンダリングするページ構成の関係](https://user-images.githubusercontent.com/42175286/55176604-c4e08880-51c4-11e9-8310-6ea20561f829.png)

## サービスコンテナ
サービスコンテナはオブジェクトで表現され、サービスのオブジェクトを返すメソッドが定義されている。

```
<?php

namespace ContainerM9iq2wg;

use Symfony\Component\DependencyInjection\Argument\RewindableGenerator;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\DependencyInjection\Container;
use Symfony\Component\DependencyInjection\Exception\InvalidArgumentException;
use Symfony\Component\DependencyInjection\Exception\LogicException;
use Symfony\Component\DependencyInjection\Exception\RuntimeException;
use Symfony\Component\DependencyInjection\ParameterBag\FrozenParameterBag;

/**
 * This class has been auto-generated
 * by the Symfony Dependency Injection Component.
 *
 * @final since Symfony 3.3
 */
class appDevDebugProjectContainer extends Container
{
    private $buildParameters;
    private $containerDir;
    private $parameters;
    private $targetDirs = [];

    public function __construct(array $buildParameters = [], $containerDir = __DIR__)
    {
        $this->methodMap = [
            'annotation_reader' => 'getAnnotationReaderService',
            'annotations.reader' => 'getAnnotations_ReaderService',
            'argument_metadata_factory' => 'getArgumentMetadataFactoryService',
            'assets.context' => 'getAssets_ContextService',
            'assets.packages' => 'getAssets_PackagesService',
            'cache.annotations' => 'getCache_AnnotationsService',
            'cache.app' => 'getCache_AppService',
```

## ドメインレイヤ（理解不足）
ビジネスロジックの集まりのことで、MVC構成のモデルに相当する。
Doctrineと連携したデータの保存、読込、ビジネスロジックを担当するクラスはドメインレイヤの一つである。
![Webアプリケーションの基本_３層アーキテクチャとMVCモデルの関係](https://user-images.githubusercontent.com/42175286/56376687-7d896d00-6243-11e9-9eef-6fff9f36bcb2.png)

## テンプレートエンジン
![Symfony4_図3-1](https://user-images.githubusercontent.com/42175286/56432786-b8ee6f00-6309-11e9-976e-6b494bc857a9.png)