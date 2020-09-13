# Laravel

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

```php
Route::get($uri, $callback);
Route::post($uri, $callback);
Route::put($uri, $callback);
Route::patch($uri, $callback);
Route::delete($uri, $callback);
Route::options($uri, $callback);
```

```{コントローラ名}@{メソッド名}```で，コントローラに定義してあるメソッドをコールできる．

```php
Route::get('/user', 'UserController@index');
```

#### ・名前空間

コントローラをコールする時に，名前空間の部分を共通化できる．

```php
Route::namespace('Admin')->group(function () {
    // "App\Http\Controllers\Admin"名前空間下のコントローラ
});
```



### CSRF対策

POST，PUT，DELETEメソッドを使用するルーティングでは，Viewテンプレート側でCSRFトークンフィールドを実装する必要がある．この実装により，セッションごとに，登録ユーザにCSRFトークンを付与できる．

```html
<form method="POST" action="/profile">
    @csrf
    ...
</form>
```



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

```bash
# migrate:reset + migrate を実行
$ php artisan migrate:refresh
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
```bash
# マイグレーションファイルに関係なく，全てのテーブルを削除
$ php artisan migrate:fresh
```



### マイグレーションファイル

#### ・ファイル構造

upメソッドでテーブル，カラム，インデックスのCREATEを行う．upメソッドでCREATEのロールバックを行う．

```php
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





## Http｜Request

### artisanによる操作

#### ・クラスの自動生成

```bash
# フォームクラスを自動作成
$ php artisan make:request {クラス名}
```



### validationルールの定義

#### ・validationメソッド

```Illuminate\Http\Request```インスタンスのvalidateメソッドを使用して，ルールを定義する．validationルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```から対応するエラーメッセージを自動的に選択する．

```php
/**
 * 新ブログポストの保存
 *
 * @param  Request  $request
 * @return Response
 */
public function store(Request $request)
{
    $validatedData = $request->validate([
        'title' => 'required|unique:posts|max:255',
        'body' => 'required',
    ]);

    // ブログポストは有効
}
```

validationルールは，配列で定義してよい．

```php
$validatedData = $request->validate([
    'title' => ['required', 'unique:posts', 'max:255'],
    'body' => ['required'],
]);
```

#### ・Validatorファサード

```Illuminate\Support\Facades\Validator```ファサードのmakeメソッドを使用して，ルールを定義する．第一引数で，バリデーションを行うリクエストデータを渡す．

```php
namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PostController extends Controller
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
            return redirect('post/create')
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

```php
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

        //
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

        //
    }
}
```

#### ・パスパラメータの取得

第二引数にパスパラメータ名を記述することで，パスパラメータの値を取得できる．

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

```php
return response()->json([
    'name' => 'Abigail',
    'state' => 'CA'
]);
```

#### ・Viewテンプレートのレスポンス

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

#### ・Password Grant Token

本番環境で使用するアクセストークン．

1. API側では，Oauth認証（認証フェーズ＋認可フェーズ）を行うために，auth.phpで，```driver```を```passport```に設定する．また，認証フェーズで使用するテーブル名を```provider```に設定する．

```php
// 一部省略

'guards' => [
    'web' => [
        'driver' => 'session',
        'provider' => 'users',
    ],
    
    'api' => [
        'driver' => 'passport',
        'provider' => 'users',
        'hash' => false,
    ],
],
```

2. API側では，テーブルに対応するモデルのルーティングに対して，middlewareメソッドによる認証ガードを行う．これにより，Oauth認証に成功したユーザのみがルーティングを行えるようになる．

```php
Route::get('user', 'UserController@index')->middleware('auth:api');
```
3. API側では，認証ガードを行ったモデルに対して，HasAPIToken，Notifiableのトレイトをコールするようにする．

```php
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
$http = new GuzzleHttp\Client;

$response = $http->post('http://your-app.com/oauth/token', [
    'form_params' => [
        'grant_type' => 'password',
        'client_id' => 'client-id',
        'client_secret' => 'client-secret',
        'username' => 'taylor@laravel.com',
        'password' => 'my-password',
        'scope' => '',
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
$response = $client->request('GET', '/api/user', [
    'headers' => [
        'Accept' => 'application/json',
        'Authorization' => 'Bearer xxxxx',
    ]
]);

return (string) $response->getBody();
```

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
<!-- /resources/views/post/create.blade.php -->

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

