# Laravel



## Facade

### artisanによる操作

```bash
# ここにコマンド例
```



### 静的プロキシ

#### ・Facadeとは

Facadeに登録されたクラス（Facadeクラス）とServiceContainerを繋ぐ静的プロキシとして働く．メソッドをコールできるようになる．

#### ・Facadeを使用しない場合

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

#### ・ServiceContainerを通じてメソッドをコール

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



### 標準登録されたFacadeの種類

| Facade名             | クラスの実体                                                 | サービスコンテナ結合キー |
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



## App

### インスタンス生成

#### ・new演算子の省略

new演算子の代わりとしてmakeメソッドでインスタンスを生成する．

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

// makeメソッド経由でメソッドチェーン
$result = $app->make('Example')->method();

// makeメソッドをnew演算子の代わりに使用
$example = App::make('Example');
$result = $example->method();
```



## ServiceProvider

### artisan

```

```



### ServiceProviderの用途

| ServiceProvider名                                  | 用途                                                   |
| -------------------------------------------------- | ------------------------------------------------------ |
| AppServiceProvider                                 | ServiceContainerへの登録（バインド）と生成（リゾルブ） |
| EventServiceProvider                               | EventListenerとEventhandler関数の対応関係の定義        |
| RouteServiceProvider<br>（app.php，web.phpも使用） | ルーティングとコントローラの対応関係の定義             |



### ServiceContainerへの登録（バインド）と生成（リゾルブ）

#### ・ServiceContainerとは

クラス名を登録（バインド）しただけで新しいインスタンスを生成（リゾルブ）してくれるオブジェクトを『ServiceContainer』という．

```php
<?php

namespace Illuminate\Contracts\Container;

use Closure;
use Psr\Container\ContainerInterface;

interface Container extends ContainerInterface
{
    /**
     * 通常のバインディングとして，自身に登録する．
     * 第二引数は，クロージャー，もしくはクラス名前空間
     *
     * @param  string  $abstract
     * @param  \Closure|string|null  $concrete
     * @param  bool  $shared
     * @return void
     */
    public function bind($abstract, $concrete = null, $shared = false);
    
    /**
     * singletonとして，自身に登録する．
     *
     * @param  string  $abstract
     * @param  \Closure|string|null  $concrete
     * @return void
     */
    public function singleton($abstract, $concrete = null);
}
```

#### ・具象クラス名とインスタンスの関係を登録

SeriveProviderにて，ServiceContainerへの登録を行うことによって，ServiceContainerがインスタンスを生成できるようになる．Laravelでは，具象クラス名とインスタンスの関係は，ServiceContainerに自動的に登録されており，以下の実装を行う必要はない．

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Domain\Entity\Example;

class ExampleServiceProvider extends ServiceProvider
{
    /**
     * コンテナに登録
     *
     * @return void
     */
    public function register()
    {
        $this->app->bind(Example::class, function ($app) {
            return new Example();
        });
    }
}
```

#### ・複数の具象クラスとインスタンスの関係を登録

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
    * 一つ目のクラスを登録
    */
    private function registerExample1()
    {
        $this->app->bind(Example1::class, function ($app) {
            return new Example1();
        });
    }
    
    /**
    * 二つ目のクラスを登録
    */    
    private function registerExample2()
    {
        $this->app->bind(Example2::class, function ($app) {
            return new Example2();
        });
    }
    
    /**
    * 三つ目のクラスを登録
    */
    private function registerExample3()
    {
        $this->app->bind(Example3::class, function ($app) {
            return new Example3();
        });
    }
}
```

#### ・インターフェース（抽象クラス）と実装インスタンスの関係を登録

具象クラス名とインスタンスの関係は自動的に登録されるが，インターフェース（抽象クラス）と実装インスタンスの関係は，実装する必要がある．この登録によって，インターフェースをコールすると実装インスタンスを生成できるようになる．

```php
<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Domain\ExampleRepository as ExampleRepositoryInterface;
use App\Infrastructure\ExampleRepository;

class ExampleServiceProvider extends ServiceProvider
{
    /**
     * コンテナに登録
     *
     * @return void
     */
    public function register()
    {
        // Domain層とInfrastructure層のリポジトリの結合を登録
        $this->app->bind(ExampleRepositoryInterface::class, function ($app) {
            return new App\Infrastructure\ExampleRepository();
        });
    }
}
```



### ServiceProviderのコール

```config/app.php```のproviders配列にクラスの名前空間を実装すると，アプリケーションの起動時にServiceProviderをコールできるため，ServiceContainerへのクラスの登録が自動的に完了する．

**＊実装例＊**

```php
<?php

'providers' => [
    
    // 複数のServiceProviderが実装されている

    App\Providers\ComposerServiceProvider::class,
],
```



## Routes

### artisanによる操作

#### ・ルーティング一覧

```bash
# ルーティングを一覧で表示
$ php artisan route:list
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

#### ・名前空間

コントローラをコールする時に，名前空間の部分を共通化できる．

**＊実装例＊**

```php
<?php

Route::namespace('Admin')->group(function () {
    // "App\Http\Controllers\Admin"名前空間下のコントローラ
});
```

#### ・middleware

```

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

upメソッドでテーブル，カラム，インデックスのCREATEを行う．upメソッドでCREATEのロールバックを行う．

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

#### ・Factoryの生成

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

#### ・Factoryによるデータ定義

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

#### ・Seederによるデータ作成

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



## HTTP｜Request

### artisanによる操作

#### ・クラスの自動生成

```bash
# フォームクラスを自動作成
$ php artisan make:request {クラス名}
```



### validationルールの定義

#### ・rulesメソッド，validatedメソッド

FormRequestクラスを継承したクラスにて，rulesメソッドを使用して，ルールを定義する．validationルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```から対応するエラーメッセージを自動的に選択する．

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

Controllerで，ExampleRequestクラスからvalidatedメソッドをコールし，バリデーションを終えたデータを取得できる．

**＊実装例＊**

```php
/**
 * ブログポストの保存
 *
 * @param  ExampleRequest $request
 * @return Response
 */
public function store(ExampleRequest $request)
{
    // バリデーション済みデータの取得
    $validated = $request->validated();
  
    ExampleRepository::update($validated);
}
```



#### ・validateメソッド

```Illuminate\Http\Request```インスタンスのvalidateメソッドを使用して，ルールを定義する．validationルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```から対応するエラーメッセージを自動的に選択する．

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

```Illuminate\Support\Facades\Validator```ファサードのmakeメソッドを使用して，ルールを定義する．第一引数で，バリデーションを行うリクエストデータを渡す．validationルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```から対応するエラーメッセージを自動的に選択する．

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

```Illuminate\Http\Request```インスタンスのsessionメソッドを使用して，セッション変数を取得する．

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

#### ・authorizeメソッド

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



### Requestのコール

####  ・データの取得

inputメソッドを用いて，リクエストボディに含まれるデータを取得できる．

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



### Responseのコール

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

attemptメソッドを用いて，パスワードを自動的にハッシュ化し，データベースのハッシュ値と照合する．認証が終わると，認証セッションを開始する．intendedメソッドで，ログイン後の初期ページにリダイレクトする．

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

1. ユーザを作成する．

```bash
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

2. API側では，テーブルに対応するモデルのルーティングに対して，middlewareメソッドによる認証ガードを行う．これにより，Oauth認証に成功したユーザのみがルーティングを行えるようになる．

```php
Route::get('user', 'UserController@index')->middleware('auth:api');
```
3. API側では，認証ガードを行ったモデルに対して，HasAPIToken，Notifiableのトレイトをコールするようにする．

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

4. API側では，```Passport::routes()```をコールするようにする．これにより，認証フェーズでアクセストークンをリクエストするための全てのルーティング（``````/oauth/xxx``````）が有効になる．また，アクセストークンを発行できるよになる．

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

5. 以降，ユーザ側のアプリケーションにおける対応である．ユーザを作成する．

```bash
$ php artisan passport:client --password
```

6. ユーザ側のアプリケーションでは，『認証』のために，アクセストークンのリクエストを送信する．ユーザ側のアプリケーションは，```/oauth/authorize```へリクエストを送信する必要がある．ここでは，リクエストGuzzleライブラリを使用して，リクエストを送信するものとする．

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

```json
{
  "token_type":"Bearer",
  "expires_in":31536000,
  "access_token":"xxxxx"
}
```

8. ユーザ側のアプリケーションでは，ヘッダーにアクセストークンを含めて，認証ガードの設定されたAPI側のルーティングに対して，リクエストを送信する．レスポンスのリクエストボディからデータを取得する．

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



## Resources

### Views

#### ・データの出力

Responseインスタンスから渡されたデータは，```{{ 変数名 }}``で取得できる．`

```html
<html>
    <body>
        <h1>Hello, {{ $data }}</h1>
    </body>
</html>
```

#### ・validationメッセージの出力

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

