# Laravel



## Facade

### artisanによる操作

```bash
# ここにコマンド例
```



### 静的プロキシ

#### ・Facadeクラスとは

Facadeに登録されたクラス（Facadeクラス）とServiceContainerを繋ぐ静的プロキシとして働く．メソッドをコールできるようになる．

#### ・Facadeクラスを使用しない場合

new演算子でインスタンスを作成する．

**＊実装例＊**

```php
<?php
    
class Example
{
    public function method()
    {
        return "example";
    }
}
```
```php
// 通常
$example = new Example();
$example->method();
```

#### ・ServiceContainerクラスを通じてメソッドをコール

**＊実装例＊**

```php
<?php

class Example
{
    public function method()
    {
        return "example";
    }
}
```
```php
use Illuminate\Support\Facades\ Example;
    
// Facade利用
$result = Example::method();
```



### 標準登録されたFacadeクラスの種類

| Facade名             | クラス名                                                     | サービスコンテナ結合キー |
| :------------------- | :----------------------------------------------------------- | :----------------------- |
| App                  | [Illuminate\Foundation\Application](https://laravel.com/api/6.x/Illuminate/Foundation/Application.html) | `app`                    |
| Artisan              | [Illuminate\Contracts\Console\Kernel](https://laravel.com/api/6.x/Illuminate/Contracts/Console/Kernel.html) | `artisan`                |
| Auth                 | [Illuminate\Auth\AuthManager](https://laravel.com/api/6.x/Illuminate/Auth/AuthManager.html) | `auth`                   |
| Auth (Instance)      | [Illuminate\Contracts\Auth\Guard](https://laravel.com/api/6.x/Illuminate/Contracts/Auth/Guard.html) | `auth.driver`            |
| Blade                | [Illuminate\View\Compilers\BladeCompiler](https://laravel.com/api/6.x/Illuminate/View/Compilers/BladeCompiler.html) | `blade.compiler`         |
| Broadcast            | [Illuminate\Contracts\Broadcasting\Factory](https://laravel.com/api/6.x/Illuminate/Contracts/Broadcasting/Factory.html) |                          |
| Broadcast (Instance) | [Illuminate\Contracts\Broadcasting\Broadcaster](https://laravel.com/api/6.x/Illuminate/Contracts/Broadcasting/Broadcaster.html) |                          |
| Bus                  | [Illuminate\Contracts\Bus\Dispatcher](https://laravel.com/api/6.x/Illuminate/Contracts/Bus/Dispatcher.html) |                          |
| Cache                | [Illuminate\Cache\CacheManager](https://laravel.com/api/6.x/Illuminate/Cache/CacheManager.html) | `cache`                  |
| Cache (Instance)     | [Illuminate\Cache\Repository](https://laravel.com/api/6.x/Illuminate/Cache/Repository.html) | `cache.store`            |
| Config               | [Illuminate\Config\Repository](https://laravel.com/api/6.x/Illuminate/Config/Repository.html) | `config`                 |
| Cookie               | [Illuminate\Cookie\CookieJar](https://laravel.com/api/6.x/Illuminate/Cookie/CookieJar.html) | `cookie`                 |
| Crypt                | [Illuminate\Encryption\Encrypter](https://laravel.com/api/6.x/Illuminate/Encryption/Encrypter.html) | `encrypter`              |
| DB                   | [Illuminate\Database\DatabaseManager](https://laravel.com/api/6.x/Illuminate/Database/DatabaseManager.html) | `db`                     |
| DB (Instance)        | [Illuminate\Database\Connection](https://laravel.com/api/6.x/Illuminate/Database/Connection.html) | `db.connection`          |
| Event                | [Illuminate\Events\Dispatcher](https://laravel.com/api/6.x/Illuminate/Events/Dispatcher.html) | `events`                 |
| File                 | [Illuminate\Filesystem\Filesystem](https://laravel.com/api/6.x/Illuminate/Filesystem/Filesystem.html) | `files`                  |
| Gate                 | [Illuminate\Contracts\Auth\Access\Gate](https://laravel.com/api/6.x/Illuminate/Contracts/Auth/Access/Gate.html) |                          |
| Hash                 | [Illuminate\Contracts\Hashing\Hasher](https://laravel.com/api/6.x/Illuminate/Contracts/Hashing/Hasher.html) | `hash`                   |
| Lang                 | [Illuminate\Translation\Translator](https://laravel.com/api/6.x/Illuminate/Translation/Translator.html) | `translator`             |
| Log                  | [Illuminate\Log\LogManager](https://laravel.com/api/6.x/Illuminate/Log/LogManager.html) | `log`                    |
| Mail                 | [Illuminate\Mail\Mailer](https://laravel.com/api/6.x/Illuminate/Mail/Mailer.html) | `mailer`                 |
| Notification         | [Illuminate\Notifications\ChannelManager](https://laravel.com/api/6.x/Illuminate/Notifications/ChannelManager.html) |                          |
| Password             | [Illuminate\Auth\Passwords\PasswordBrokerManager](https://laravel.com/api/6.x/Illuminate/Auth/Passwords/PasswordBrokerManager.html) | `auth.password`          |
| Password (Instance)  | [Illuminate\Auth\Passwords\PasswordBroker](https://laravel.com/api/6.x/Illuminate/Auth/Passwords/PasswordBroker.html) | `auth.password.broker`   |
| Queue                | [Illuminate\Queue\QueueManager](https://laravel.com/api/6.x/Illuminate/Queue/QueueManager.html) | `queue`                  |
| Queue (Instance)     | [Illuminate\Contracts\Queue\Queue](https://laravel.com/api/6.x/Illuminate/Contracts/Queue/Queue.html) | `queue.connection`       |
| Queue (Base Class)   | [Illuminate\Queue\Queue](https://laravel.com/api/6.x/Illuminate/Queue/Queue.html) |                          |
| Redirect             | [Illuminate\Routing\Redirector](https://laravel.com/api/6.x/Illuminate/Routing/Redirector.html) | `redirect`               |
| Redis                | [Illuminate\Redis\RedisManager](https://laravel.com/api/6.x/Illuminate/Redis/RedisManager.html) | `redis`                  |
| Redis (Instance)     | [Illuminate\Redis\Connections\Connection](https://laravel.com/api/6.x/Illuminate/Redis/Connections/Connection.html) | `redis.connection`       |
| Request              | [Illuminate\Http\Request](https://laravel.com/api/6.x/Illuminate/Http/Request.html) | `request`                |
| Response             | [Illuminate\Contracts\Routing\ResponseFactory](https://laravel.com/api/6.x/Illuminate/Contracts/Routing/ResponseFactory.html) |                          |
| Response (Instance)  | [Illuminate\Http\Response](https://laravel.com/api/6.x/Illuminate/Http/Response.html) |                          |
| Route                | [Illuminate\Routing\Router](https://laravel.com/api/6.x/Illuminate/Routing/Router.html) | `router`                 |
| Schema               | [Illuminate\Database\Schema\Builder](https://laravel.com/api/6.x/Illuminate/Database/Schema/Builder.html) |                          |
| Session              | [Illuminate\Session\SessionManager](https://laravel.com/api/6.x/Illuminate/Session/SessionManager.html) | `session`                |
| Session (Instance)   | [Illuminate\Session\Store](https://laravel.com/api/6.x/Illuminate/Session/Store.html) | `session.store`          |
| Storage              | [Illuminate\Filesystem\FilesystemManager](https://laravel.com/api/6.x/Illuminate/Filesystem/FilesystemManager.html) | `filesystem`             |
| Storage (Instance)   | [Illuminate\Contracts\Filesystem\Filesystem](https://laravel.com/api/6.x/Illuminate/Contracts/Filesystem/Filesystem.html) | `filesystem.disk`        |
| URL                  | [Illuminate\Routing\UrlGenerator](https://laravel.com/api/6.x/Illuminate/Routing/UrlGenerator.html) | `url`                    |
| Validator            | [Illuminate\Validation\Factory](https://laravel.com/api/6.x/Illuminate/Validation/Factory.html) | `validator`              |
| Validator (Instance) | [Illuminate\Validation\Validator](https://laravel.com/api/6.x/Illuminate/Validation/Validator.html) |                          |
| View                 | [Illuminate\View\Factory](https://laravel.com/api/6.x/Illuminate/View/Factory.html) | `view`                   |
| View (Instance)      | [Illuminate\View\View](https://laravel.com/api/6.x/Illuminate/View/View.html) |                          |



## ServiceProvider

### artisanによる操作

#### ・クラスの自動生成

```bash
$ php artisan make:provider {クラス名}
```



### ServiceProvider

#### ・用途

| ServiceProvider名                                  | 用途                                                   |
| -------------------------------------------------- | ------------------------------------------------------ |
| AppServiceProvider                                 | ServiceContainerへの登録（バインド）と生成（リゾルブ） |
| EventServiceProvider                               | EventListenerとEventhandler関数の対応関係の定義        |
| RouteServiceProvider<br>（app.php，web.phpも使用） | ルーティングとコントローラの対応関係の定義             |

#### ・ServiceProviderクラスの自動コール

```config/app.php```のproviders配列にクラスの名前空間を実装すると，アプリケーションの起動時にServiceProviderをコールできるため，ServiceContainerへのクラスのバインドが自動的に完了する．

**＊実装例＊**

```php
<?php

'providers' => [
    
    // 複数のServiceProviderが実装されている

    App\Providers\ComposerServiceProvider::class,
],
```



### ServiceContainerクラスへのバインド（登録）

#### ・ServiceContainerクラスとは

クラスをバインド（登録）しただけで新しいインスタンスをリゾルブ（生成）してくれるオブジェクトを『ServiceContainer』という．

```php
<?php

namespace Illuminate\Contracts\Container;

use Closure;
use Psr\Container\ContainerInterface;

interface Container extends ContainerInterface
{
    /**
     * 通常のバインディングとして，自身にバインドする．
     * 第二引数は，クロージャー，もしくはクラス名前空間
     *
     * @param  string  $abstract
     * @param  \Closure|string|null  $concrete
     * @param  bool  $shared
     * @return void
     */
    public function bind($abstract, $concrete = null, $shared = false);
    
    /**
     * singletonとして，自身にバインドする．
     *
     * @param  string  $abstract
     * @param  \Closure|string|null  $concrete
     * @return void
     */
    public function singleton($abstract, $concrete = null);
}
```

#### ・具象クラスをバインド

SeriveProviderにて，ServiceContainerにクラスをバインドすることによって，ServiceContainerがインスタンスを生成できるようになる．Laravelでは，具象クラスはServiceContainerに自動的にバインドされており，以下の実装を行う必要はない．

**＊実装例＊**

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Domain\Entity\Example;

class ExampleServiceProvider extends ServiceProvider
{
    /**
     * コンテナにバインド
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(Example::class, function ($app) {
            return new Example1(new Example2, new Example3);
        });
    }
}
```

#### ・複数の具象クラスをバインド

**＊実装例＊**

```php
<?php

namespace App\Providers;

use App\Domain\Entity\Example1;
use App\Domain\Entity\Example2;
use App\Domain\Entity\Example3;
use Illuminate\Support\ServiceProvider;

class ExamplesServiceProvider extends ServiceProvider
{
     /**
     * 各registerメソッドをコール
     *
     * @return void
     */
    public function register()
    {
        $this->registerExample1();
        $this->registerExample2();
        $this->registerExample3();
    }
    
    /**
    * 一つ目のクラスをバインド
    */
    private function registerExample1()
    {
        $this->app->bind(Example1::class, function ($app) {
            return new Example1();
        });
    }
    
    /**
    * 二つ目のクラスをバインド
    */    
    private function registerExample2()
    {
        $this->app->bind(Example2::class, function ($app) {
            return new Example2();
        });
    }
    
    /**
    * 三つ目のクラスをバインド
    */
    private function registerExample3()
    {
        $this->app->bind(Example3::class, function ($app) {
            return new Example3();
        });
    }
}
```

#### ・インターフェース（抽象クラス）名をバインド

具象クラスは自動的にバインドされるが，インターフェース（抽象クラス）は，手動でバインドする必要がある．このバインドによって，インターフェースをコールすると実装インスタンスを生成できるようになる．

**＊実装例＊**

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Domain\ExampleRepository as ExampleRepositoryInterface;
use App\Infrastructure\ExampleRepository;

class ExampleServiceProvider extends ServiceProvider
{
    /**
     * コンテナにバインド
     *
     * @return void
     */
    public function register()
    {
        // Domain層とInfrastructure層のリポジトリの結合をバインド
        $this->app->bind(
            'App\Domain\Repositories\ArticleRepository',
            'App\Infrastructure\Repositories\ArticleRepository'
        );
    }
}
```



### ServiceContainerクラスからのリゾルブ（生成）

#### ・Appファサードの使用

コンストラクタの引数にクラスを渡しておく．Appクラスを経由してクラスを宣言することで，クラスのリゾルブを自動的に行う．

**＊実装例＊**

```php
<?php

namespace App\Domain\Entity\Example;

class Example extends Entity
{
    /**
     * サブクラス
     */
    protected $subExample;

    /**
     * コンストラクタインジェクション
     *
     * @param SubExmaple $subExample
     */
    public function __construct(SubExmaple $subExample)
    {
        $this->example = $subExample;
    }
}
```

```php
<?php

class Example
{
    public function method()
    {
        return "example";
    }
}

// Exampleクラスをリゾルブし，そのままmethodをコール
$result = app()->make(Example::class)->method();

// Exampleクラスをリゾルブ
$example = App::make(Example::class);
$result = $example->method();
```



## Routes

### artisanによる操作

#### ・ルーティング一覧

```bash
# ルーティングを一覧で表示
$ php artisan route:list
```

#### ・キャッシュ削除

```bash
$ php artisan route:clear
```



### 種類

#### ・api.php

RESTfulAPIとして扱うエンドポイントを実装する

#### ・web.php

API以外の場合，こちらにルーティング処理を実装する．第一引数にURL，第二引数に実行するメソッドを定義する．



### ルーティング

#### ・ルーティング定義

**＊実装例＊**

```php
<?php

Route::get($uri, $callback);
Route::post($uri, $callback);
Route::put($uri, $callback);
Route::patch($uri, $callback);
Route::delete($uri, $callback);
Route::options($uri, $callback);
```

```{コントローラ名}@{メソッド名}```で，コントローラに定義してあるメソッドをコールできる．

**＊実装例＊**

```php
Route::get('/user', 'UserController@index');
```

#### ・namespace

```group```メソッドと組み合わせて使用する．コントローラをコールする時に，グループ内で同じ名前空間を指定できる．

**＊実装例＊**

```php
<?php

Route::namespace('Admin')->group(function () {
    // "App\Http\Controllers\Admin\" 下にあるコントローラ
    Route::get('/user', 'UserController@index');
    Route::post('/user/{userId}', 'UserController@createUser');
});
```

#### ・where

パスパラメータの形式の制約を，正規表現で設定できる．

**＊実装例＊**

```php
<?php

Route::namespace('Admin')->group(function () {

    Route::get('/user', 'UserController@index')
    
    // userIdの形式を「0〜9が一つ以上」に設定
    Route::post('/user/{userId}', 'UserController@createUser')
        ->where('id', '[0-9]+');
});
```

RouteServiceProviderの```boot```メソッドにて，```pattern```メソッドで制約を設定することによって，ルーティング時にwhereを使用する必要がなくなる．

```php
<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Route;

class RouteServiceProvider extends ServiceProvider
{
    /**
     * ルートモデル結合、パターンフィルタなどの定義
     *
     * @return void
     */
    public function boot()
    {
        Route::pattern('articleId', '[0-9]+');

        parent::boot();
    }
}

```



### セキュリティ

#### ・CSRF対策

Laravelでは，CSRF対策のため，POST，PUT，DELETEメソッドを使用するルーティングでCSRFトークンによる照合を行う必要がある．そのために，View側でCSRFトークンフィールドを実装する．この実装により，セッションごとに，登録ユーザにCSRFトークンを付与できる．

**＊実装例＊**

```html
<form method="POST" action="/profile">
    @csrf
    ...
</form>
```

#### ・XSS対策

#### ・常時HTTPS化




## Migration

### artisanによる操作

#### ・マイグレーションの準備

```bash
# マイグレーションファイルを作成
$ php artisan make:migrate create_{テーブル名}_table
```

#### ・テーブル作成

```bash
# マイグレーションファイルを元にテーブを作成
$ php artisan migrate
```


#### ・テーブル削除

```bash
# 指定した数だけ，マイグレーションのロールバックを行う
$ php artisan migrate:rollback --step={ロールバック数}
```
```bash
# マイグレーションファイルを元に，全てのテーブルを削除
$ php artisan migrate:reset
```

#### ・テーブル削除＋作成

```bash
# migrate:reset + migrate を実行
$ php artisan migrate:refresh
```

```bash
# マイグレーションファイルに関係なく，全てのテーブルを削除 + migrate
$ php artisan migrate:fresh
```



### マイグレーションファイル

#### ・ファイル構造

```up```メソッドでテーブル，カラム，インデックスのCREATEを行う．```down```メソッドでCREATEのロールバックを行う．

**＊実装例＊**

```php
<?php
  
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateFlightsTable extends Migration
{
    /**
     * マイグレーション実行
     *
     * @return void
     */
    public function up()
    {
        Schema::create('flights', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('name');
            $table->string('airline');
            $table->timestamps();
        });
    }

    /**
     * マイグレーションを元に戻す
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('flights');
    }
}
```



## Factory，Seeder

### artisanによる操作

#### ・Factoryクラスの生成

```bash
# --model={モデル名}
$ php artisan make:factory ExampleFactory --model=Example
```
#### ・個別Seederクラスの生成
```bash
$ php artisan make:seeder UserSeeder
```

#### ・DatabaseSeederクラスの実行

```bash
# 事前に，Composerのオートローラを再生成
$ composer dump-autoload

# DatabaseSeederクラスを指定して実行
$ php artisan db:seed --class=DatabaseSeeder
```




### テストデータ

#### ・Factoryクラスによるデータ定義

**＊実装例＊**

```php
<?php

use App\User;
use Faker\Generator as Faker;
use Illuminate\Database\Eloquent\Factory;
use Illuminate\Support\Str;

/**
 * @var Factory $factory
 */

$factory->define(User::class, function (Faker $faker) {
    return [
        'name'              => $faker->name,
        'email'             => $faker->unique()->safeEmail,
        'email_verified_at' => now(),
        'password'          => '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', // password
        'remember_token'    => Str::random(10),
    ];
});
```

#### ・Seederクラスによるデータ作成

Factoryクラスにおける定義を基にして，指定した数だけデータを作成する．

**＊実装例＊**

```php
<?php

use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        factory(App\User::class, 50)->create();
    }
}
```

DatabaseSeederクラスにて，Seederクラスをまとめて実行する．

**＊実装例＊**

```php
<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * データベース初期値設定の実行
     *
     * @return void
     */
    public function run()
    {
        $this->call([
            UserSeeder::class,
        ]);
    }
}
```



## HTTP｜Middleware

### artisanによる操作

#### ・クラスの自動生成

```bash
# Middlewareクラスを自動生成
$ php artisan make:middleware {クラス名}
```



### Middlewareクラスの仕組み

#### ・Middlewareクラスの種類

ルーティング後にコントローラメソッドの前にコールされるBeforeMiddleと，レスポンスの実行時にコールされるAfterMiddlewareがある

![Laravelのミドルウェア](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/LaravelのMiddlewareクラスの仕組み.png)

#### ・BeforeMiddlewareクラス

ルーティング時のコントローラメソッドのコール前に実行する処理を設定できる．```$request```には，```Illuminate\Http\Request```オブジェクトが代入されている．

**＊実装例＊**

```php
<?php

namespace App\Http\Middleware;

use Closure;

class ExampleBeforeMiddleware
{
    public function handle($request, Closure $next)
    {
        // 何らかの処理

        return $next($request);
    }
}
```
#### ・AfterMiddlewareクラス

コントローラメソッドのレスポンスの実行後（テンプレートのレンダリングを含む）に実行する処理を設定できる．```$response```には，```Illuminate\Http\Response```オブジェクトが代入されている．

**＊実装例＊**


```php
<?php

namespace App\Http\Middleware;

use Closure;

class ExampleAfterMiddleware
{
    public function handle($request, Closure $next)
    {
        $response = $next($request);

        // 何らかの処理

        return $response;
    }
}
```



## HTTP｜Request

### artisanによる操作

#### ・クラスの自動生成

```bash
# フォームクラスを自動作成
$ php artisan make:request {クラス名}
```



### バリデーションルールの定義

#### ・```rules```メソッド，```validated```メソッド

FormRequestクラスを継承したクラスにて，```rules```メソッドを使用して，ルールを定義する．バリデーションルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```から対応するエラーメッセージを自動的に選択する．

**＊実装例＊**

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ExampleRequest extends FormRequest
{
    /**
     * リクエストに適用するバリデーションルールを取得
     *
     * @return array
     */
    public function rules()
    {
        return [
            'title' => 'required|unique:posts|max:255',
            'body'  => 'required',
        ];
    }
}
```

Controllerで，ExampleRequestクラスを型指定すると，コントローラのメソッドをコールする前にバリデーションが自動で行われる．そのため，コントローラの中では，```validated```メソッドでバリデーションを終えたデータをいきなり取得できる．バリデーションが失敗した場合，メソッドのコール前に，ExampleRequestクラスが元々のページにリダイレクトする処理を自動で実行する．

**＊実装例＊**

```php
/**
 * ブログポストの保存
 *
 * @param  ExampleRequest $request
 * @return Response
 */
// メソッドが実行される前にバリデーションが行われる．
public function store(ExampleRequest $request) 
{
    // バリデーション済みデータをいきなり取得
    $validated = $request->validated();
  
    ExampleRepository::update($validated);
}
```

#### ・```validate```メソッド

```Illuminate\Http\Request```インスタンスの```validate```メソッドを使用して，ルールを定義する．validationルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```から対応するエラーメッセージを自動的に選択する．

**＊実装例＊**

```php
/**
 *
 * @param Request $request
 * @return Response
 */
public
function store(Request $request)
{
    $validatedData = $request->validate([
        'title' => 'required|unique:posts|max:255',
        'body'  => 'required',
    ]);
}
```

validationルールは，配列で定義してよい．

**＊実装例＊**

```php
$validatedData = $request->validate([
    'title' => ['required', 'unique:posts', 'max:255'],
    'body' => ['required'],
]);
```

#### ・Validatorファサード

```Illuminate\Support\Facades\Validator```ファサードの```make```メソッドを使用して，ルールを定義する．第一引数で，バリデーションを行うリクエストデータを渡す．validationルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```から対応するエラーメッセージを自動的に選択する．

**＊実装例＊**

```php
<?php
  
namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ExampleController extends Controller
{
    /**
     * 新しいブログポストの保存
     *
     * @param  Request  $request
     * @return Response
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|unique:posts|max:255',
            'body' => 'required',
        ]);

        if ($validator->fails()) {
            return redirect('example/create')
                        ->withErrors($validator)
                        ->withInput();
        }

        // ブログポストの保存処理…
    }
}
```



### セッション

#### ・セッション変数の取得

```Illuminate\Http\Request```インスタンスの```session```メソッドを使用して，セッション変数を取得する．

**＊実装例＊**

```php
<?php
  
namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * 指定されたユーザーのプロフィールを表示
     *
     * @param  Request  $request
     * @param  int  $id
     * @return Response
     */
    public function show(Request $request, $id)
    {
        $value = $request->session()->get('key');
    }
}
```

全てのセッション変数を取得することもできる．

```php
$data = $request->session()->all();
```

#### ・フラッシュデータの設定

現在のセッションにおいて，今回と次回のリクエストだけで有効な一時データを設定できる．

```php
$request->session()->flash('status', 'Task was successful!');
```



### Requestの認証

#### ・```authorize```メソッド

ユーザがリソースに対してCRUD操作を行う権限を持っているかを，コントローラのメソッドを実行する前に，判定する．

**＊実装例＊**

```php
/**
 * ユーザーがこのリクエストの権限を持っているかを判断する
 *
 * @return bool
 */
public function authorize()
{
    $comment = Comment::find($this->route('comment'));

    return $comment && $this->user()->can('update', $comment);
}
```





## HTTP｜Controller

### artisanによる操作

#### ・クラスの自動生成

```bash
# コントローラクラスを自動作成
$ php artisan make:controller {クラス名}
```



### Requestクラスのコール

####  ・データの取得

```input```メソッドを用いて，リクエストボディに含まれるデータを取得できる．

**＊実装例＊**

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * 新しいユーザーを保存
     *
     * @param  Request  $request
     * @return Response
     */
    public function store(Request $request)
    {
        $name = $request->input('name');
    }
}
```

#### ・パスパラメータの取得

第二引数にパスパラメータ名を記述することで，パスパラメータの値を取得できる．

**＊実装例＊**

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UserController extends Controller
{
    /**
     * 指定したユーザーの更新
     *
     * @param  Request  $request
     * @param  string  $id
     * @return Response
     */
    public function update(Request $request, $id)
    {
        //
    }
```



### Responseクラスのコール

#### ・Json型データのレスポンス

```Symfony\Component\HttpFoundation\Response```を継承している．

**＊実装例＊**

```php
return response()->json([
    'name' => 'Abigail',
    'state' => 'CA'
]);
```

#### ・Viewテンプレートのレスポンス

**＊実装例＊**

```php
// データ，ステータスコード，ヘッダーなどを設定する場合
return response()
  ->view('hello', $data, 200)
  ->header('Content-Type', $type);
```

```php
// ステータスコードのみ設定する場合
return response()
  ->view('hello')
  ->setStatusCode(200);
```



## HTTP｜Auth

### artisanによる操作

#### ・Digest認証の環境構築

```bash
# ここにコマンド例
```

#### ・Oauth認証の環境構築

```/storage/oauth```キー，Personal Access Client，Password Grant Clientを生成する．

```bash
$ php artisan passport:install

Personal access client created successfully.
Client ID: 3
Client secret: xxxxxxxxxxxx
Password grant client created successfully.
Client ID: 4
Client secret: xxxxxxxxxxxx
```

ただし，生成コマンドを個別に実行してもよい．

```bash
# 暗号キーを生成
$ php artisan passport:keys

# クライアントを生成
## Persinal Access Tokenの場合
$ php artisan passport:client --personal
## Password Grant Tokenの場合
$ php artisan passport:client --password
```



### AuthファサードによるDigest認証

```attempt```メソッドを用いて，パスワードを自動的にハッシュ化し，データベースのハッシュ値と照合する．認証が終わると，認証セッションを開始する．```intended```メソッドで，ログイン後の初期ページにリダイレクトする．

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LoginController extends Controller
{
    /**
     * 認証を処理する
     *
     * @param  \Illuminate\Http\Request $request
     *
     * @return Response
     */
    public function authenticate(Request $request)
    {
        $credentials = $request->only('email', 'password');

        if (Auth::attempt($credentials)) {
            // 認証に成功した
            return redirect()->intended('dashboard');
        }
    }
}
```



### PassportによるAPIのOauth認証

#### ・Personal Access Token

開発環境で使用するアクセストークン．

1. 暗号キーとユーザを作成する．

```bash
$ php artisan passport:keys

$ php artisan passport:client --personal
```

2. 作成したユーザに，クライアントIDを付与する．

```php
/**
 * 全認証／認可の登録
 *
 * @return void
 */
public function boot()
{
    $this->registerPolicies();

    Passport::routes();

    Passport::personalAccessClientId('client-id');
}
```

3. ユーザからのリクエスト時，クライアントIDを元に『認証』を行い，アクセストークンをレスポンスする．

```php
$user = App\User::find(1);

// スコープ無しのトークンを作成する
$token = $user->createToken('Token Name')->accessToken;

// スコープ付きのトークンを作成する
$token = $user->createToken('My Token', ['place-orders'])->accessToken;
```

#### ・Password Grant Token

本番環境で使用するアクセストークン．

1. API側では，Oauth認証（認証フェーズ＋認可フェーズ）を行うために，auth.phpで，```driver```を```passport```に設定する．また，認証フェーズで使用するテーブル名を```provider```に設定する．

**＊実装例＊**

```php
<?php

// 一部省略

'guards' => [
    'web' => [
        'driver'   => 'session',
        'provider' => 'users',
    ],

    'api' => [
        'driver'   => 'passport',
        'provider' => 'users',
        'hash'     => false,
    ],
],
```

2. API側では，テーブルに対応するモデルのルーティングに対して，```middleware```メソッドによる認証ガードを行う．これにより，Oauth認証に成功したユーザのみがルーティングを行えるようになる．

**＊実装例＊**

```php
Route::get('user', 'UserController@index')->middleware('auth:api');
```
3. API側では，認証ガードを行ったモデルに対して，HasAPIToken，Notifiableのトレイトをコールするようにする．

**＊実装例＊**

```php
<?php
  
namespace App\Models;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;
    
    // 一部省略
}
```

4. API側では，Passportの```routes```メソッドをコールするようにする．これにより，認証フェーズでアクセストークンをリクエストするための全てのルーティング（``````/oauth/xxx``````）が有効になる．また，アクセストークンを発行できるよになる．

**＊実装例＊**

```php
<?php
  
use Laravel\Passport\Passport;

class AuthServiceProvider extends ServiceProvider
{
    // 一部省略

    public function boot()
    {
        $this->registerPolicies();

        Passport::routes();
    }
}
```

5. 以降，ユーザ側のアプリケーションにおける対応である．暗号キーとユーザを作成する．

```bash
$ php artisan passport:keys

$ php artisan passport:client --password
```

6. ユーザ側のアプリケーションでは，『認証』のために，アクセストークンのリクエストを送信する．ユーザ側のアプリケーションは，```/oauth/authorize```へリクエストを送信する必要がある．ここでは，リクエストGuzzleライブラリを使用して，リクエストを送信するものとする．

**＊実装例＊**

```php
<?php

$http = new GuzzleHttp\Client;

$response = $http->post('http://your-app.com/oauth/token', [
    'form_params' => [
        'grant_type'    => 'password',
        'client_id'     => 'client-id',
        'client_secret' => 'client-secret',
        'username'      => 'taylor@laravel.com',
        'password'      => 'my-password',
        'scope'         => '',
    ],
]);
```

7. ユーザ側のアプリケーションでは，ユーザ側のアプリケーションにアクセストークンを含むJSON型データを受信する．

**＊実装例＊**

```json
{
  "token_type":"Bearer",
  "expires_in":31536000,
  "access_token":"xxxxx"
}
```

8. ユーザ側のアプリケーションでは，ヘッダーにアクセストークンを含めて，認証ガードの設定されたAPI側のルーティングに対して，リクエストを送信する．レスポンスのリクエストボディからデータを取得する．

**＊実装例＊**

```php
<?php
  
$response = $client->request('GET', '/api/user', [
    'headers' => [
        'Accept'        => 'application/json',
        'Authorization' => 'Bearer xxxxx',
    ]
]);

return (string)$response->getBody();
```



## Views

### arisanによる操作

#### ・キャッシュの削除

```bash
$ php artisan view:clear
```



### データの出力

#### ・データの出力

Responseインスタンスから渡されたデータは，```{{ 変数名 }}``で取得できる．`

**＊実装例＊**

```html
<html>
    <body>
        <h1>Hello!! {{ $data }}</h1>
    </body>
</html>
```

#### ・validationメッセージの出力

**＊実装例＊**

```html
<!-- /resources/views/example/create.blade.php -->

<h1>ポスト作成</h1>

@if ($errors->any())
    <div class="alert alert-danger">
        <ul>
            
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
            
        </ul>
    </div>
@endif

<!-- ポスト作成フォーム -->
```



### 要素の共通化

#### ・@extends，@parent，@show

三つセットで使うことが多いので，同時に説明する．テンプレート間が親子関係にある時，子テンプレートで親テンプレート全体を読み込む```@extends```を用いる．子テンプレートに```@section```を継承しつつ，要素を追加する場合，```@endsection```ではなく```@show```を使用する．

**＊実装例＊**

```html
<!-- 親テンプレート -->

<html>
    <head>
        <title>共通のタイトルとなる要素</title>
    </head>
    <body>
        
        @section('sidebar')
            親テンプレートのサイドバーとなる要素
        @show

        <div class="container">
            共通の要素
        </div>
    </body>
</html>
```

```@parent```で親テンプレートの```@section```を継承する．

```html
<!-- 子テンプレート -->

@extends('layouts.app')

@section('sidebar')
    @parent
    <p>子テンレプートのサイドバーに追加される要素</p>
@endsection
```

#### ・@include（サブビュー）

読み込んだファイル全体を出力する．読み込むファイルに対して，変数を渡すこともできる．```@extentds```との使い分けとして，親子関係のないテンプレートの間で使用するのがよい．両者は，PHPでいう```extends```（クラスチェーン）と```require```（単なる読み込み）の関係に近い．

```html
<div>
    @include('shared.errors')
    <form><!-- フォームの内容 -->
    </form>
</div>
```



### 子テンプレートにおける要素の出力

#### ・@yield，@section

子テンプレートのレンダリング時に，HTMLの要素を動的に出力する場合に使用する．親テンプレートにて，```@yield('example')```を定義する．これを継承した子テンプレートのレンダリング時に，```@section('example')```-```@endsection```で定義した要素が，```@yieid()```部分に出力される．

**＊実装例＊**

```html
<!-- 親テンプレート -->

<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>アプリケーション</title>
    </head>
    <body>
        <h2>タイトル</h2>        
        @yield('content')
    </body>
</html>
```

```html
<!-- 子テンプレート -->

@extends('layouts.parent')

@section('content')
    <p>子テンプレートのレンダリング時に，yieldに出力される要素</p>
@endsection
```

子テンプレートは，レンダリング時に以下のように出力される．

```html
<!-- 子テンプレート -->

<!DOCTYPE html>
<html lang="ja">
    <head>
        <meta charset="utf-8">
        <title>アプリケーション</title>
    </head>
    <body>
        <h2>タイトル</h2>
        <p>子テンプレートのレンダリング時に，yieldに出力される要素</p>
    </body>
</html>
```



#### ・@stack，@push

子テンプレートのレンダリング時に，CSSとJavaScriptのファイルを動的に出力する場合に使用する．親テンプレートにて，```@stack('example')```を定義する．これを継承した子テンプレートのレンダリング時に，```@push('example')```-```@endpush```で定義した要素が，```@stack()```部分に出力される．

**＊実装例＊**

```html
<!-- 親テンプレート -->

<head>
    <!-- Headの内容 -->

    @stack('scripts')
</head>
```

```html
<!-- 子テンプレート -->

@push('scripts')
    <script src="/example.js"></script>
@endpush
```



### Twigとの互換

#### ・Bladeで実装した場合

**＊実装例＊**

```html
<!-- 親テンプレート -->

<html>
    <head>
        <title>@yield('title')</title>
    </head>
    <body>

        @section('sidebar')
            親テンプレートのサイドバーとなる要素
        @show

        <div class="container">
            @yield('content')
        </div>
    </body>
</html>
```

```html
<!-- 子テンプレート -->

@extends('layouts.master')

@section('title', '子テンプレートのタイトルになる要素')

@section('sidebar')
    @parent
    <p>子テンレプートのサイドバーに追加される要素</p>
@endsection

@section('content')
    <p>子テンプレートのコンテンツになる要素</p>
@endsection
```

#### ・Twigで実装した場合

**＊実装例＊**

```html
<!-- 親テンプレート -->

<html>
    <head>
        <title>{% block title %}{% endblock %}</title>
    </head>
    <body>

        {% block sidebar %} <!-- @section('sidebar') に相当 -->
            親テンプレートのサイドバーとなる要素
        {% endblock %}

        <div class="container">
            {% block content %}<!-- @yield('content') に相当 -->
            {% endblock %}
        </div>
    </body>
</html>
```
```html
<!-- 子テンプレート -->

{% extends "layouts.master" %} <!-- @extends('layouts.master') に相当 -->

{% block title %} <!-- @section('title', 'Page Title') に相当 -->
    子テンプレートのタイトルになる要素
{% endblock %}

{% block sidebar %} <!-- @section('sidebar') に相当 -->
    {{ parent() }} <!-- @parent に相当 -->
    <p>子テンレプートのサイドバーに追加される要素</p>
{% endblock %}

{% block content %} <!-- @section('content') に相当 -->
    <p>子テンプレートのコンテンツになる要素</p>
{% endblock %}
```

