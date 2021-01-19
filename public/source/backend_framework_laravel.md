# Laravel

## 01. コンポーネントのソースコード

Laravelの各コンポーネントには，似たような名前のメソッドが多く内蔵されている．そのため，同様の機能を実現するために，各々が異なるメソッドを使用しがちになる．その時，各メソッドがブラックボックスにならないように，処理の違いをソースコードから確認する必要がある．

参考：https://laravel.com/api/6.x/Illuminate.html

<br>

## 02. Application

### App

#### ・設定方法

```
APP_NAME=<サービス名>
APP_ENV=<環境名>
APP_KEY=<セッションの作成やパスワードの暗号化に使う認証キー>
APP_DEBUG=<デバッグモードの有効無効化>
APP_URL=<アプリケーションのURL>
```

#### ・アプリケーションの基本設定

```php
<?php

return [
    // アプリケーション名
    'name'            => env('APP_NAME', 'Laravel'),

    // 実行環境名
    'env'             => env('APP_ENV', 'production'),

    // エラー時のデバッグ画面の有効化
    'debug'           => (bool)env('APP_DEBUG', false),

    // アプリケーションのURL
    'url'             => env('APP_URL', 'http://localhost'),

    // assetヘルパーで付与するURL
    'asset_url'       => env('ASSET_URL', null),

    // タイムゾーン
    'timezone'        => 'UTC',

    // 言語設定
    'locale'          => 'ja',
    'fallback_locale' => 'en',
    'faker_locale'    => 'ja_JP',

    // セッションの作成やパスワードの暗号化に使う認証キー
    'key'             => env('APP_KEY'),

    // 暗号化アルゴリズム
    'cipher'          => 'AES-256-CBC',

    // サービスプロバイダー
    'providers'       => [

    ],

    // クラス名のエイリアス
    'aliases'         => [

    ],
];
```

<br>

## 03. Database

### データベース接続

#### ・設定方法

環境変数を```.env```ファイルに実装する．```database.php```ファイルから，指定された設定が選択される．

```
DB_CONNECTION=<RDB名>
DB_HOST=<ホスト名>
DB_PORT=<ポート番号>
DB_DATABASE=<データベース名>
DB_USERNAME=<アプリケーションユーザ名>
DB_PASSWORD=<アプリケーションユーザのパスワード>
```

#### ・RDBとRedisの選択

```php
<?php

return [

    // 使用するDBMSを設定
    'default'     => env('DB_CONNECTION', 'mysql'),

    'connections' => [

        // データベース接続情報（SQLite）
        'sqlite' => [

        ],

        // データベース接続情報（MySQL）
        'mysql'  => [

        ],

        // データベース接続情報（pgSQL）
        'pgsql'  => [

        ],

        // データベース接続情報（SQLSRV）
        'sqlsrv' => [

        ],
    ],

    // マイグレーションファイルのあるディレクトリ
    'migrations'  => 'migrations',

    // Redis接続情報
    'redis'       => [

    ],
];
```

<br>

## 04. Eloquent｜Domain

### artisanコマンドによる操作

#### ・クラスの自動生成

```sh
$ php artisan make:model <Model名>
```

<br>

### Active Recordパターン

#### ・Active Recordパターンとは

![ActiveRecord](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ActiveRecord.png)

#### ・他の類似するデザインパターンとの比較

| デザインパターン | Modelとテーブルの関連度合い                                 | 採用ライブラリ例 |
| ---------------- | ----------------------------------------------------------- | ---------------- |
| Active Record    | 非常に強い．基本的には，Modelとテーブルが一対一対応になる． | Eloquent         |
| Data Mapper      |                                                             | Doctrine         |
| Repository       | 各エンティティの粒度次第で強くも弱くもなる．                |                  |
| なし             | 非常に弱い                                                  | DBファサード     |

#### ・メリットとデメリット

| 項目   | メリット                                                     | デメリット                                                   |      |
| ------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ---- |
| 保守性 |                                                              |                                                              |      |
| 可読性 | ・複雑なデータアクセスロジックを実装する必要が無い．<br>・Modelにおけるデータアクセスロジックがどのテーブルに対して行われるのか推測しやすい．<br>・リレーションを理解する必要があまりなく，複数のテーブルに対して無秩序にSQLを発行するような設計実装になりにくい． | データアクセスロジックが複数のテーブルを跨ぐためには，関連付くテーブルを軸としたリレーションを行う必要がある．この時，カラムの不要な取得を行ってしまうことがある． |      |
| 拡張性 |                                                              | Modelの構成がテーブル構造に強く依存してしまうため，Modelのドメインロジックを柔軟に実装できなくなってしまう．そのため，ドメイン駆動設計との相性は悪い． |      |

<br>

### Modelとテーブルの対応

#### ・Modelの継承

Modelクラスを継承したクラスは，```INSERT```文や```UPDATE```文などのデータアクセスロジックを使用できるようになる．

**＊実装例＊**

````php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    // クラスチェーンによって，データアクセスロジックをコール
}
````


#### ・Modelとテーブルの関連付け

Eloquentは，Model自身の```table```プロパティに代入されている名前のテーブルに，Modelを関連付ける．ただし，```table```プロパティにテーブル名を代入する必要はない．Eloquentがクラス名の複数形をテーブル名と見なし，これをスネークケースにした文字列を```table```プロパティに自動的に代入する．また，テーブル名を独自で命名したい場合は，代入によるOverrideを行っても良い．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    /**
     * モデルと関連しているテーブル
     *
     * @var string
     */
    protected $table = 'examples';
}
```

#### ・Modelと主キーの関連付け

Eloquentは，```primaryKey```プロパティの値を主キーのカラム名と見なす．```keyType```で主キーのデータ型，また```incrementing```プロパティで主キーのAutoIncrementを有効化するか否か，を設定できる．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    
    /**
     * 主キーとするカラム
     * （デフォルトではidが主キーです）
     * 
     * @var string 
     */
    protected $primaryKey = 'example_id';
    
    /**
     * 主キーのデータ型
     * 
     * @var string 
     */
    protected $keyType = 'int';
    
    /**
     * 主キーのAutoIncrementの有効化します．
     * 
     * @var bool 
     */
    public $incrementing = true;
}
```

#### ・ModelとTIMESTAMP型カラムの関連付け

Eloquentは，```timestamps```プロパティの値が```true```の時に，Modelに関連付くテーブルの```created_at```カラムと```updated_at```カラムを自動的に更新する．また，TIMESTAMP型カラム名を独自で命名したい場合は，代入によるOverideを行っても良い．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    const CREATED_AT = 'created_date_time';
    const UPDATED_AT = 'updated_data_time';
    
    /**
     * モデルのタイムスタンプを更新するかの指示します．
     *
     * @var bool
     */
    protected $timestamps = true;
}
```


#### ・TIMESTAMP型カラム読み出し時のデータ型変換

データベースからタイムスタンプ型カラムを読み出すと同時に，CarbonのDateTimeクラスに変換したい場合，```data```プロパティにて，カラム名を設定する．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class User extends Model
{
    /**
     * CarbonのDateTimeクラスに自動変換したいカラム名
     *
     * @var array
     */
    protected $dates = [
        'created_at',
        'updated_at',
        'deleted_at'
    ];
}

```


#### ・カラムデフォルト値の設定

特定のカラムのデフォルト値を設定したい場合，```attributes```プロパティにて，カラム名と値を設定する．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    /**
     * カラム名とデフォルト値
     *
     * @var array
     */
    protected $attributes = [
        'is_deleted' => false,
    ];
}
```

#### ・テーブル間のリレーションシップの定義

Laravelでは，テーブル間のリレーションシップを，```hasOne```メソッド，```hasMany```メソッド，```belongsTo```メソッドを使用して定義する．これにより，JOIN句を使用せずに必要なデータを取得できる．

**＊実装例＊**

Departmentモデル側に，departmentテーブルとemployeeテーブルの間に，一対多の関係を定義する．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Department extends Model
{
    /**
     * 主キーとするカラム
     * 
     * @var string 
     */
    protected $primaryKey = "department_id";

     /**
     * 一対多の関係を定義します．
     * （デフォルトではemployee_idに関連付けます）
     * 
     * @return HasMany
     */
    public function hasManyEmployee() :HasMany
    {
        return $this->hasMany(Employee::class);
    }
}
```

また，Employeeモデル側に，多対一の関係を定義する．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Employee extends Model
{
    /**
     * 主キーとするカラム
     * 
     * @var string 
     */
    protected $primaryKey = "employee_id";

     /**
     * 多対一の関係を定義します．
     * （デフォルトではdepartment_idに関連付けます）
     * 
     * @return HasMany
     */
    public function belongsToDepartment() :BelongsTo
    {
        return $this->belongsTo(Department::class);
    }
}
```

```php
<?php

// Departmentオブジェクトを取得
$department = Department::find(1);

// 全てのemployeeオブジェクトをarray型で取得
$employees = $department->employees
```

#### ・変更可能／不可能なカラム名の設定

Model経由で変更可能なカラム名は，```fillable```プロパティで定義する．カラムが増えるたびに，実装する必要がある．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    /**
     * カラム名
     *
     * @var array
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'api_token'
    ];
}
```

もしくは，変更不可能なカラム名を```guarded```プロパティで定義する．これらのいずれかの設定は，Modelにおいて必須である．

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    /**
     * カラム名
     *
     * @var array
     */
    protected $guarded = [
        'xxx',
    ];
}
```

<br>

### 使用に注意する機能

#### ・セッター

Laravelでは，プロパティを定義しなくても，Modelからプロパティをコールすれば，処理の度に動的にプロパティを定義できる．しかし，この機能はプロパティがpublicアクセスである必要があるため，オブジェクト機能のメリットを享受できない．そのため，この機能を使用せずに，```constructor```メソッドを使用したコンストラクタインジェクション，またはセッターインジェクションを使用するようにする．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    /**
     * @var ExampleName
     */
    private ExampleName $exampleName;

    /**
     * 名前を取得します．
     *
     * @return string
     */
    public function __construct(ExampleName $exampleName)
    {
        $this->exampleName = $exampleName;
    }
}
```

#### ・ゲッター

Laravelでは，```getXxxxYyyyAttribute```という名前のメソッドを，```xxx_yyy```という名前でコールできる．一見，プロパティをコールしているように見えるため，注意が必要である．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class Example extends Model
{
    /**
     * @var ExampleName
     */
    private ExampleName $exampleName;

    /**
     * 名前を取得します．
     *
     * @return string
     */
    public function getNameAttribute()
    {
        return $this->exampleName . "です．";
    }
}
```

```php
<?php

$example = Example::find(1);

// nameプロパティを取得しているわけでなく，getNameAttributeメソッドを実行している．
$exmapleName = $example->name;
```

<br>

### データ型変換

#### ・シリアライズ

フロントエンドとバックエンド間，またバックエンドとデータベース間のデータ送信のために，配列型オブジェクトをJSONに変換する処理はシリアライズである．

**＊実装例＊**

```php
<?php

$collection = collect([
    [
        'user_id' => '1',
        'name'    => '佐藤太郎',
    ],
    [
        'user_id' => '2',
        'name'    => '山田次郎',
    ],
]);

// Array型に変換する
$collection->toArray();
```

```php
<?php

$users = App\User::all();

// Array型に変換する
return $users->toArray();
```

#### ・デシリアライズ

フロントエンドとバックエンド間，またバックエンドとデータベース間のデータ送信のために，JSONを配列型オブジェクトに変換する処理はデシリアライズである．

<br>

### フィルタリング

#### ・```filter```メソッド

コールバック関数の返却値が```true```であった要素を全て抽出する．

**＊実装例＊**

```php
$collection = collect([1, 2, 3, 4]);

// trueを返却した要素を全て抽出する
$filtered = $collection->filter(function ($value, $key) {
    return $value > 2;
});

$filtered->all();

// [3, 4]
```

ちなみに，複数の条件を設定したいときは，早期リターンを使用する必要がある．

**＊実装例＊**

```php
$collection = collect([1, 2, 3, 4, "yes"]);

// 複数の条件で抽出する．
$filtered = $collection->filter(function ($value, $key) {
    
    // まずはyesを検証する．
    if($value == "yes") {
        return true;
    }
    
    return $value > 2;
});

$filtered->all();

// [3, 4, "yes"]
```

#### ・```first```メソッド

コールバック関数の返却値が```true```であった最初の要素のみを抽出する．

**＊実装例＊**

```php
$collection = collect([1, 2, 3, 4]);

// trueを返却した要素のみ抽出する
$filtered = $collection->first(function ($value, $key) {
    return $value > 2;
});

// 3
```

<br>

## 04-02. Eloquent｜Data Access

### artisanコマンドによる操作

```sh

```

<br>

### ドメイン駆動設計との組み合わせ

ビジネスロジック用のエンティティと，EloquentのModelクラスを継承した詰め替えモデル（例：DTOクラス）を用意する．アプリケーション層から受け取ったエンティティが保持するデータを，DTOクラスに詰め替えるようにすると，エンティティが他の層に依存しなくなる．

<br>

### CREATE

#### ・```create```メソッド

INSERT文を実行する．Modelクラスが持つ```create```メソッドに挿入対象のカラムと値を設定する．または，Modelクラスの```fill```メソッドで挿入対象のカラムと値を設定し，```save```メソッドを実行する．Modelクラスにはfillableプロパティを設定しておく．UPDATE文の実行時と使用するメソッドは同じである．

参考：https://codelikes.com/laravel-eloquent-basic/#toc9

**＊実装例＊**

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\Example;
use App\Domain\Repositories\ExampleRepository as DomainExampleRepository;
use App\Infrastructure\DTO\ExampleDTO;

class ExampleRepository extends Repository implements DomainExampleRepository
{    
    /**
     * @var ExampleDTO
     */
    private ExampleDTO $exampleDTO;
    
    public function __construct(ExampleDTO $exampleDTO)
    {
        $this->exampleDTO = $exampleDTO;
    }   
    
    /**
     * Exampleエンティティを作成
     *
     * @param  Example $example
     * @return Response
     */
    public function create(Example $example)
    {
        // insert文を実行する．
        $this->exampleDTO
            ->create([
                'name'  => $example->name()
                'age'   => $example->age()
                'email' => $example->email()
            ]);
        
        // 以下の実装でよい．
        // $this->exampleDTO
        //    ->fill([
        //        'name'  => $example->name()
        //        'age'   => $example->age()
        //        'email' => $example->email()
        //    ])
        //    ->save();
    }
}
```

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class ExampleDTO extends Model
{
    // 更新可能なカラム
    protected $fillable = [
        'name',
        'age',
        'email',
    ];
}
```

<br>

### READ

#### ・```find```メソッド

SELECT文を実行する．引数としてプライマリキーを渡した場合，指定したプライマリキーを持つModelをModel型として返却する．```toArray```メソッドで配列型に変換できる．

**＊実装例＊**

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\Example;
use App\Domain\Repositories\ExampleRepository as DomainExampleRepository;
use App\Infrastructure\DTO\ExampleDTO;

class ExampleRepository extends Repository implements DomainExampleRepository
{
    /**
     * @var ExampleDTO
     */
    private ExampleDTO $exampleDTO;
    
    public function __construct(ExampleDTO $exampleDTO)
    {
        $this->exampleDTO = $exampleDTO;
    }   
  
    /**
     * 条件に合うExampleエンティティを読み出し
     *
     * @param Id $id
     * @return array
     */
    public function findOneByCriteria($id): array
    {
        return $this->exampleDTO
            ->find($id)
            ->toArray();
    }
}
```

#### ・```all```メソッド

SELECT文を実行する．全てのプライマリキーのModelをCollection型として返却する．```toArray```メソッドで配列型に再帰的に変換できる．

**＊実装例＊**

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\Example;
use App\Domain\Repositories\ExampleRepository as DomainExampleRepository;
use App\Infrastructure\DTO\ExampleDTO;

class ExampleRepository extends Repository implements DomainExampleRepository
{
    /**
     * @var ExampleDTO
     */
    private ExampleDTO $exampleDTO;
    
    public function __construct(ExampleDTO $exampleDTO)
    {
        $this->exampleDTO = $exampleDTO;
    }   
  
    /**
     * 全てのExampleエンティティを読み出し
     *
     * @return array 
     */
    public function findAll(): array
    {
        return $this->exampleDTO
            ->all()
            ->toArray();
    }
}
```

<br>

### UPDATE

#### ・```update```メソッド

UPDATE文を実行する．Modelクラスが```find```メソッドで更新対象のモデルを検索する．返却されたModelクラスの```fill```メソッドで，挿入対象のカラムと値を設定し，```save```メソッドを実行する．Modelクラスには```fillable```プロパティを設定しておく．UPDATE文の実行時と使用するメソッドは同じである．．

参考：https://codelikes.com/laravel-eloquent-basic/#toc9

**＊実装例＊**

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\Example;
use App\Domain\Repositories\ExampleRepository as DomainExampleRepository;
use App\Infrastructure\DTO\ExampleDTO;

class ExampleRepository extends Repository implements DomainExampleRepository
{
    /**
     * @var ExampleDTO
     */
    private ExampleDTO $exampleDTO;
    
    public function __construct(ExampleDTO $exampleDTO)
    {
        $this->exampleDTO = $exampleDTO;
    }   
    
    /**
     * Exampleエンティティを更新
     *
     * @param Example $example
     */
    public function save(Example $example)
    {
        $exampleData = $this->exampleDTO
            // 更新対象のモデルを取得する．
            ->find($id);
        
        // オブジェクトにデータを設定する．
        $exampleData->fill([
            'name'  => $example->name()
            'age'   => $example->age()
            'email' => $example->email()
        ])
        // update文を実行する．
        ->save();
    }
}
```

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;

class ExampleDTO extends Model
{
    // 更新可能なカラム
    protected $fillable = [
        'name',
        'age',
        'email',
    ];
}
```

<br>

### DELETE

#### ・```delete```メソッド（物理削除）

DELETE文を実行する．Modelクラスの```find```メソッドで削除対象のモデルを検索する．返却されたModelクラスの```delete```メソッドをコールし，自身を削除する．

**＊実装例＊**

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\Example;
use App\Domain\Repositories\ExampleRepository as DomainExampleRepository;
use App\Infrastructure\DTO\ExampleDTO;

class ExampleRepository extends Repository implements DomainExampleRepository
{
    /**
     * @var ExampleDTO
     */
    private ExampleDTO $exampleDTO;
    
    public function __construct(ExampleDTO $exampleDTO)
    {
        $this->exampleDTO = $exampleDTO;
    }   
  
    /**
     * Exampleエンティティを削除
     *
     * @param Id $id
     */
    public function delete(Id $id)
    {
        $exampleData = $this->exampleDTO
            // 削除対象のモデルを取得する．
            ->find($id);
        
        // delete文を実行し，物理削除する．
        $exampleData->delete();
        
        // 以下の実装でfindメソッドとdeleteメソッドを実行してもよい．
        // $this->exampleDTO->destroy($id);
    }
}
```

#### ・```delete```メソッドとSoftDeletesのTrait（論理削除）

削除フラグを更新するUPDATE文を実行する．テーブルに対応するモデルにて，SoftDeletesのTraitを読み込む．マイグレーション時に追加される```delete_at```カラムをSQLで取得する時に，DataTimeクラスに変換できるようにしておく．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ExampleDTO extends Model
{
    /**
    * Traitの読み込み
    */
    use SoftDeletes;

    /**
     * 読み出し時にCarbonのDateTimeクラスへ自動変換するカラム
     *
     * @var array
     */
    protected $dates = [
        'deleted_at'
    ];
}
```

マイグレーションファイルにて```softDeletes```メソッドを使用すると，削除フラグとして```deleted_at```カラムが追加されるようになる．```deleted_at```カラムのデフォルト値は```NULL```である．

```php
<?php
  
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateExampleTable extends Migration
{
    /**
     * マイグレート
     *
     * @return void
     */
    public function up()
    {
        Schema::create('example', function (Blueprint $table) {
            
            // ～ 省略
            
            // deleted_atカラムを追加する．
            $table->softDeletes();
            
            // ～ 省略
            
        });
    }

    /**
     * ロールバック
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('example');
    }
}
```

上記の状態で，同様に```delete```メソッドを使用して，自身を削除する．物理削除ではなく，```deleled_at```カラムが更新されるようになる．```find```メソッドは，```deleled_at```カラムが```NULL```でないデータを読み出さないため，論理削除を実現できる．

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\Example;
use App\Domain\Repositories\ExampleRepository as DomainExampleRepository;
use App\Infrastructure\DTO\ExampleDTO;

class ExampleRepository extends Repository implements DomainExampleRepository
{
    /**
     * @var ExampleDTO
     */
    private ExampleDTO $exampleDTO;
    
    public function __construct(ExampleDTO $exampleDTO)
    {
        $this->exampleDTO = $exampleDTO;
    }   
    
    /**
     * Exampleエンティティを削除
     *
     * @param Id $id
     */
    public function delete(Id $id)
    {
        $exampleData = $this->exampleDTO
            // 削除対象のモデルを取得する．
            ->find($id);
            
        // delete文を実行し，論理削除する．
        $exampleData->delete();
        
        // 以下の実装でfindメソッドとdeleteメソッドを実行してもよい．
        // $this->exampleDTO->destroy($id);        
    }
}
```

<br>

### DBファサード

#### ・DBファサードとは

データベースを操作する処理を実行する．Eloquentの代わりに，DBファサードを使用しても良い．Active Recordのロジックを持たないため，Repositoryパターンのロジックとして使用できる．

#### ・```transaction```メソッド

一連のトランザクション処理を実行する．引数として渡した無名関数が例外を返却した場合，ロールバックを自動的に実行する．例外が発生しなかった場合，無名関数の返却値が，そのまま```transaction```メソッドの返却値になる．ちなみに，トランザクション処理は必須ではなく，使用するとアプリケーションがデータベースを操作するために要する時間が増えるため，使用しなくても良い．

参考：https://rightcode.co.jp/blog/information-technology/node-js-mongodb-transaction-function-use#i-5

**＊実装例＊**

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\Example;
use App\Domain\Repositories\ExampleRepository as DomainExampleRepository;
use App\Infrastructure\DTO\ExampleDTO;

class ExampleRepository extends Repository implements DomainExampleRepository
{
    /**
     * @var ExampleDTO
     */
    private ExampleDTO $exampleDTO;
    
    public function __construct(ExampleDTO $exampleDTO)
    {
        $this->exampleDTO = $exampleDTO;
    }   
    
    /**
     * Exampleエンティティを更新
     *
     * @param Id $id
     */
    public function save(Example $example)
    {
        $exampleData = $this->exampleDTO
            // 更新対象のモデルを取得する．
            ->find($id);
        
        // 一連のトランザクション処理を実行する．
        DB::transaction(function () use ($exampleData){
            
            // オブジェクトにデータを設定する．
            $exampleData->fill([
                'name'  => $example->name(),
                'age'   => $example->age(),
                'email' => $example->email()
            ])
            // update文を実行する．
            ->save();
            
        });
    }
}
```

#### ・```beginTransaction```メソッド，```commit```メソッド，```rollback```メソッド，

トランザクション処理の各操作を実行する．基本的には，```transaction```メソッドを使用してトランザクション処理を実行すれば良い．

**＊実装例＊**

```php
<?php

namespace App\Infrastructure\Repositories;

use App\Domain\Entity\Example;
use App\Domain\Repositories\ExampleRepository as DomainExampleRepository;
use App\Infrastructure\DTO\ExampleDTO;

class ExampleRepository extends Repository implements DomainExampleRepository
{
    /**
     * @var ExampleDTO
     */
    private ExampleDTO $exampleDTO;
    
    public function __construct(ExampleDTO $exampleDTO)
    {
        $this->exampleDTO = $exampleDTO;
    }   
    
    /**
     * Exampleエンティティを更新
     *
     * @param Id $id
     */
    public function save(Example $example)
    {
        // トランザクション処理を開始する．
        DB::beginTransaction();
        
        try {
            $this->exampleDTO
            // 更新対象のモデルを取得する．
            ->find($id)
            // オブジェクトにデータを設定する．
            ->fill([
                'name'  => $example->name(),
                'age'   => $example->age(),
                'email' => $example->email()
            ])
            // update文を実行する．
            ->save();            
            
            // コミットメントを実行する．
            DB::commit();
        } catch (\Exception $e) {
            
            // ロールバックを実行する．
            DB::rollback();
        }
    }
}
```

<br>

## 	05. Event

### Model Event

#### ・データベースアクセス系

Modelがデータベースに対して処理を行う前後にイベントを定義できる．例えば，```create```メソッド，```save```メソッド，```update```メソッド，```delete```メソッド，の実行後にイベントを定義するためには，```created```メソッド，```saved```メソッド，```updated```メソッド，```deleted```メソッド，を使用する．

**＊実装例＊**

```php
<?php

namespace Illuminate\Database\Eloquent\Concerns;

use Illuminate\Contracts\Events\Dispatcher;
use Illuminate\Events\NullDispatcher;
use Illuminate\Support\Arr;
use InvalidArgumentException;

trait HasEvents
{
 
    // ～ 省略 ～    
    
    /**
     * モデルのイベントをDispatcherに登録します．
     *
     * @param  string  $event
     * @param  \Closure|string  $callback
     * @return void
     */
    protected static function registerModelEvent($event, $callback)
    {
        if (isset(static::$dispatcher)) {
            $name = static::class;

            static::$dispatcher->listen("eloquent.{$event}: {$name}", $callback);
        }
    }
    
    /**
     * モデルのイベントをDispatcherに登録します．
     *    
     * @param  \Closure|string  $callback
     * @return void
     */
    public static function saved($callback)
    {
        static::registerModelEvent('saved', $callback);
    }

    /**
     * モデルのsaveメソッド実行後イベントをDispatcherに登録します．
     *    
     * @param  \Closure|string  $callback
     * @return void
     */
    public static function updated($callback)
    {
        static::registerModelEvent('updated', $callback);
    }

    /**
     * モデルのcreateメソッド実行後イベントをDispatcherに登録します．
     *    
     * @param  \Closure|string  $callback
     * @return void
     */
    public static function created($callback)
    {
        static::registerModelEvent('created', $callback);
    }

    /**
     * モデルのdeleteメソッド実行後イベントをDispatcherに登録します．
     *    
     * @param  \Closure|string  $callback
     * @return void
     */
    public static function deleted($callback)
    {
        static::registerModelEvent('deleted', $callback);
    }
    
    // ～ 省略 ～       
    
}
```

#### ・Traitを使用したイベントの発火

Laravelの多くのコンポーネントに，```boot```メソッドが定義されている．Modelクラスでは，インスタンス生成時に```boot```メソッドがコールされ，これによりに```bootTraits```メソッドが実行される．Traitに```boot+<クラス名>```という名前の静的メソッドが定義されていると，```bootTraits```メソッドはこれをコールする．

**＊実装例＊**

```php
<?php

namespace Illuminate\Database\Eloquent;

// ～ 省略 ～

abstract class Model implements Arrayable, ArrayAccess, Jsonable, JsonSerializable, QueueableEntity, UrlRoutable
{
    public function __construct(array $attributes = [])
    {
        // bootメソッドが実行されていなければコール
        $this->bootIfNotBooted();

        $this->initializeTraits();

        $this->syncOriginal();

        $this->fill($attributes);
    }

    protected function bootIfNotBooted()
    {
        if (! isset(static::$booted[static::class])) {
            static::$booted[static::class] = true;

            $this->fireModelEvent('booting', false);

            // bootメソッドをコール
            static::boot();

            $this->fireModelEvent('booted', false);
        }
    }

    protected static function boot()
    {
        // bootTraitsをコール
        static::bootTraits();
    }
    
    protected static function bootTraits()
    {
        $class = static::class;

        $booted = [];

        static::$traitInitializers[$class] = [];

        foreach (class_uses_recursive($class) as $trait) {
            
            // useされたTraitにboot+<クラス名>のメソッドが存在するかを判定．
            $method = 'boot'.class_basename($trait);
            if (method_exists($class, $method) && ! in_array($method, $booted)) {
                
                // 指定した静的メソッドをコール．
                forward_static_call([$class, $method]);

                $booted[] = $method;
            }

            if (method_exists($class, $method = 'initialize'.class_basename($trait))) {
                static::$traitInitializers[$class][] = $method;

                static::$traitInitializers[$class] = array_unique(
                    static::$traitInitializers[$class]
                );
            }
        }
    }    
    
// ～ 省略 ～

}
```

コールされるTraitでは，```saved```メソッドにModel更新イベントを登録する．

```php
<?php

namespace App\Models\Traits;

use Illuminate\Database\Eloquent\Model;
use App\Events\UpdatedModelEvent;

trait UpdatedModelTrait
{
    /**
     * イベントを発火させます．
     *
     * @return void
     */
    protected static function bootUpdatedModelTrait(): void
    {
        static::saved(function (Model $updatedModel) {
            event(new UpdatedModelEvent($updatedModel));
        });

        static::deleted(function (Model $updatedModel) {
            event(new UpdatedModelEvent($updatedModel));
        });
    }
    
    /**
     * イベントを発火させずにモデルを保存します．
     *
     * @return void
     */
    protected static function saveWithoutEvents(): void
    {
        // 無限ループを防ぐために，save実行時にイベントが発火しないようにする．
        return static::withoutEvents(function () use ($options) {
            
            // プロパティの変更を保存．
            return $this->save($options);
        });
    }    
}
```

```php
<?php

namespace App\Events;

class UpdatedModelEvent
{
    /**
     * @var Model
     */
    public $updatedModel;

    /**
     * @param Model
     */
    public function __construct(Model $updatedModel)
    {
        $this->$updatedModel = $updatedModel;
    }
}
```

Model更新イベントが発火してコールされるリスナーでは，```create_by```カラムまたは```updated_by```カラムを指定した更新者名に更新できるようにする．なお，イベントとリスナーの対応関係は，EventServiceProviderで登録する．

```php
<?php

namespace App\Listeners;

use App\Events\UpdatedModelEvent;
use App\Constants\ExecutorConstant;

class UpdatedModelListener
{
    /**
     * @param UpdatedModelEvent
     * @return void
     */
    public function handle(UpdatedModelEvent $updatedModelEvent): void
    {
        $by = $this->getModelUpdater();

        // create_byプロパティに値が設定されているかを判定．
        if (is_null($updatedModelEvent->updatedModel->created_by)) {     
            $updatedModelEvent->updatedModel->created_by = $by;
        }

        $updatedModelEvent->updatedModel->updated_by = $by;
        
        $updatedModelEvent->updatedModel->saveWithoutEvents();
    }
    
    /**
     * 更新処理の実行者を取得します．
     *
     * @return string
     */
    private function getModelUpdater(): string
    {
        // コンソール経由で実行されたかを判定．
        if (app()->runningInConsole()) {
            return ExecutorConstant::ARTISAN_COMMAND;
        }

        // API認証に成功したかを判定．
        if (auth()->check()) {
            return ExecutorConstant::STAFF . ':' . auth()->id();
        }
        
        return ExecutorConstant::GUEST;
    }    
}
```

実行者名は，定数として管理しておくとよい．

```php
<?php

namespace App\Constants;

/**
 * 実行者定数クラス
 */
class ExecutorConstant
{
    /**
     * Artisanコマンド
     */
    public const ARTISAN_COMMAND = 'Artisan Command';

    /**
     * スタッフ
     */
    public const STAFF = 'Staff';
    
    /**
     * ゲスト
     */
    public const GUEST = 'Guest';    
}
```

<br>

## 06. Facade

### 静的プロキシ

#### ・Facadeとは

Facadeに登録されたクラス（Facadeクラス）とServiceContainerを繋ぐ静的プロキシとして働く．メソッドをコールできるようになる．

#### ・Facadeを使用しない場合

new演算子でインスタンスを作成する．

**＊実装例＊**

```php
<?php
  
namespace 
    
class Example
{
    public function method()
    {
        return "example";
    }
}
```
```php
<?php
    
// 通常
$example = new Example();
$example->method();
```

#### ・Facadeの静的プロキシ機能を使用する場合

静的メソッドの記法でコールできる．ただし，自作クラスをFacadeの機能を使用してインスタンス化すると，スパゲッティな「Composition（合成）」の依存関係を生じさせてしまう．例えば，Facadeの中でも，```Route```のような，代替するよりもFacadeを使ったほうが断然便利である部分以外は，使用しないほうがよい．

**＊実装例＊**

Facadeとして使用したいクラスを定義する．

```php
<?php

namespace App\Domain\DTO;

class Example
{
    public function method()
    {
        return "example";
    }
}
```

エイリアス名とクラスの名前空間を```config/app.php```ファイルを```aliases```キーに登録すると，そのエイリアス名でインスタンス化とメソッドコールを行えるようになる．

```php
<?php
  
'aliases' => [
    'Example' => App\Domain\Entity\Example::class,
]
```

インスタンス化とメソッドコールを行う．

```php
<?php

use Illuminate\Support\Facades\Example;
    
// Facade利用
$result = Example::method();
```

#### ・標準登録されたFacadeクラスの種類

以下のクラスは，デフォルトで登録されているFacadeである．

| エイリアス名         | クラス名                                                     | サービスコンテナ結合キー |
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

<br>

## 07. Factory

### artisanコマンドによる操作

#### ・Factoryの生成

```sh
$ php artisan make:factory <Factory名> --model=<対象とするModel名>
```

<br>

### 初期ダミーデータの定義

#### ・Fakerライブラリのformatters

Fakerはダミーデータを作成するためのライブラリである．Farkerクラスは，プロパティにランダムなデータを保持している．このプロパティを特に，Formattersという．

参考：https://github.com/fzaninotto/Faker

#### ・Fakerによるダミーデータ定義

**＊実装例＊**

ユーザのダミーデータを定義する．

```php
<?php

use App\Domain\Auth\User;
use App\Domain\ValueObject\Type\UserType;
use Faker\Generator as Faker;
use Illuminate\Database\Eloquent\Factory;

/**
 * @var Factory $factory
 */
$factory->define(User::class, function (Faker $faker) {
    
    return [
        'user_name'             => $faker->name,
        'tel_number'            => $faker->phoneNumber,
        'email'                 => $faker->unique()->safeEmail,
        'password'              => 'test',
        'user_type'             => UserType::getRandomValue(),
        'remember_token'        => Str::random(10),
        'email_verified_at'     => NOW(),
        'last_authenticated_at' => NOW(),
    ];
});
```

他に，商品の初期ダミーデータを定義する．

```php
<?php

use App\Domain\Entity\Product;
use App\Domain\ValueObject\Type\ProductType
use Faker\Generator as Faker;
use Illuminate\Database\Eloquent\Factory;

/**
 * @var Factory $factory
 */
$factory->define(User::class, function (Faker $faker) {

    return [
        'product_name' => $faker->word,
        'price'        => $faker->randomNumber(4),
        'product_type' => ProductType::getRandomValue(),
    ];
});
```

#### ・Seederによるダミーデータ量産

Factoryにおける定義を基にして，指定した数だけダミーデータを量産する．

**＊実装例＊**

DummyUsersSeederを定義し，50個のダミーユーザデータを量産する．

```php
<?php

use App\Domain\Entity\User;
use Illuminate\Database\Seeder;

class DummyUsersSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        factory(User::class, 50)->create();
    }
}
```

また，DummyProductsSeederを定義し，50個のダミーユーザデータを量産する．

```php
<?php

use App\Domain\Entity\Product;
use Illuminate\Database\Seeder;

class DummyProductsSeeder extends Seeder
{
    /**
     * Seederを実行します．
     *
     * @return void
     */
    public function run()
    {
        factory(Product::class, 50)->create();
    }
}
```

DatabaseSeederにて，全てのSeederをまとめて実行する．

```php
<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seederを実行します．
     *
     * @return void
     */
    public function run()
    {
        // 開発環境用の初期データ
        if (App::environment('local')) {
            $this->call([
                // ダミーデータ
                DummyUsersSeeder::class,
                DummyProductsSeeder::class
            ]);
        }
        
        // ステージング環境用の初期データ
        if (App::environment('staging')) {
            $this->call([
                // リアルデータ
            ]);
        }
        
        // 本番環境用の初期データ
        if (App::environment('production')) {
            $this->call([
                // リアルデータ
            ]);
        }
    }
}
```

<br>

## 08. File Systems

### ファイルの操作

#### ・ローカルストレージ（非公開）の場合

ファイルを```/storage/app```ディレクトリに保存する．このファイルは非公開であり，リクエストによってアクセスできない．事前に，シンボリックリンクを作成する必要がある．

```sh
$ php artisan storage:link
```

```php
return [

    'default' => env('FILESYSTEM_DRIVER', 'local'),
    
     // ～ 省略 ～

    'disks' => [

        'local' => [
            'driver' => 'local',
            'root'   => storage_path('app'),
        ],
        
     // ～ 省略 ～
        
    // シンボリックリンクの関係を定義
    'links' => [
        
        // 「/var/www/project/public/storage」から「/var/www/project/storage/app/public」へのリンク
        public_path('storage') => storage_path('app/public'),
    ],
];
```

**＊実装例＊**

Storageファサードの```disk```メソッドを用いてlocalディスクを指定する．```file.txt```ファイルを```storage/app/file.txt```として保存する．

```php
Storage::disk('local')->put('file.txt', 'file.txt');
```

ただし，```filesytems.php```ファイルでデフォルトディスクは```local```になっているため，```put```メソッドを直接使用できる．

```php
Storage::put('file.txt', 'file.txt');
```

#### ・ローカルストレージ（公開）の場合

ファイルを```storage/app/public```ディレクトリに保存する．このファイルは公開であり，リクエストによってアクセスできる．

```php
return [

    'default' => env('FILESYSTEM_DRIVER', 'local'),
    
     // ～ 省略 ～

    'disks' => [
        
        // ～ 省略 ～

        'public' => [
            'driver'     => 'local',
            'root'       => storage_path('app/public'),
            'url'        => env('APP_URL') . '/storage',
            'visibility' => 'public',
        ],

        // ～ 省略 ～
        
    ],
];
```

**＊実装例＊**

Storageファサードの```disk```メソッドを用いてpublicディスクを指定する．また，```file.txt```ファイルを```storage/app/public/file.txt```として保存する．

```php
Storage::disk('s3')->put('file.txt', 'file.txt');
```

ただし，環境変数を使用して，```filesytems.php```ファイルでデフォルトディスクを```s3```に変更すると，```put```メソッドを直接使用できる．

```php
FILESYSTEM_DRIVER=s3
```

```php
Storage::put('file.txt', 'file.txt');
```

**＊実装例＊**


```php
<?php

namespace App\Http\Controllers;

use Storage;

class FileSystemPublicController extends Controller
{
    /**
     * ファイルをpublicディスクに保存する
     */
    public function putContentsInPublicDisk()
    {
        // 保存先をpublicに設定する．
        $disk = Storage::disk('public');

        // 保存対象のファイルを読み込む
        $file_path = '/path/to/public/example.jpg'
        $contents = file_get_contents($file_path);

        // 保存先パス（ディレクトリ＋ファイル名）
        $saved_file_path = '/images/example.jpg';

        // example.jpgを「/images/example.jpg」に保存
        // ルートディレクトリは「/storage/app/public」
        $disk->put($saved_file_path, $contents);
    }
}
```

#### ・クラウドストレージの場合

ファイルをS3バケット内のディレクトリに保存する．環境変数を```.env```ファイルに実装する．```filesystems.php```ファイルから，指定された設定が選択される．AWSアカウントの認証情報を環境変数として設定するか，またはS3アクセスポリシーをEC2やECSタスクに付与することにより，S3にアクセスできるようになる．

```
# S3アクセスポリシーをEC2やECSタスクに付与してもよい
AWS_ACCESS_KEY_ID=<アクセスキー>
AWS_SECRET_ACCESS_KEY=<シークレットアクセスキー>
AWS_DEFAULT_REGION=<リージョン>

# 必須
AWS_BUCKET=<バケット名>
```

```php
return [

    'default' => env('FILESYSTEM_DRIVER', 'local'),
    
     // ～ 省略 ～
    
    'disks' => [

        // ～ 省略 ～

        's3' => [
            'driver'   => 's3',
            'key'      => env('AWS_ACCESS_KEY_ID'),
            'secret'   => env('AWS_SECRET_ACCESS_KEY'),
            'region'   => env('AWS_DEFAULT_REGION'),
            'bucket'   => env('AWS_BUCKET'),
            'url'      => env('AWS_URL'),
            'endpoint' => env('AWS_ENDPOINT'),
        ],
    ],
];
```

**＊実装例＊**

Storageファサードの```disk```メソッドを用いてs3ディスクを指定する．また，```file.txt```ファイルをS3バケットのルートに```file.txt```として保存する．

```php
Storage::disk('s3')->put('file.txt', 'file.txt');
```

ただし，環境変数を使用して，```filesytems.php```ファイルでデフォルトディスクを```s3```に変更すると，```put```メソッドを直接使用できる．

```php
FILESYSTEM_DRIVER=s3
```

```php
Storage::put('file.txt', 'file.txt');
```

<br>

## 09. HTTP｜Middleware

### artisanコマンドによる操作

#### ・クラスの自動生成

```sh
# Middlewareを自動生成
$ php artisan make:middleware <Middleware名>
```

<br>

### Middlewareの仕組み

#### ・Middlewareの種類

ルーティング後にコントローラメソッドの前にコールされるBeforeMiddleと，レスポンスの実行時にコールされるAfterMiddlewareがある

![Laravelのミドルウェア](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/LaravelのMiddlewareクラスの仕組み.png)

#### ・BeforeMiddleware

ルーティング時のコントローラメソッドのコール前に実行する処理を設定できる．```$request```には，Requestクラスが代入されている．

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

#### ・AfterMiddleware

コントローラメソッドのレスポンスの実行後（テンプレートのレンダリングを含む）に実行する処理を設定できる．

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

<br>

## 09-02. HTTP｜Request

### artisanコマンドによる操作

#### ・クラスの自動生成

```sh
# フォームクラスを自動作成
$ php artisan make:request <Request名>
```

<br>

### FormRequest

#### ・```rules```メソッド

FormRequestクラスの```rules```メソッドを使用して，ルールを定義する．ルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```ファイルから対応するエラーメッセージを自動的に選択する．また，

**＊実装例＊**

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ExampleRequest extends FormRequest
{
    /**
     * ルールを返却します．
     *
     * @return array
     */
    public function rules()
    {
        // ルールの定義
        return [
            'title' => 'required|unique:posts|max:255',
            'body'  => 'required',
        ];
    }
}
```

#### ・```validated```メソッド

Requestクラスの```validated```メソッドを使用して，バリデーションを実行する．Controllerで，Requestクラスを引数に指定すると，コントローラのメソッドをコールする前にバリデーションを自動的に実行する．そのため，コントローラの中では，```validated```メソッドでバリデーションを終えたデータをいきなり取得できる．バリデーションでエラーが起こった場合，Handlerクラスの```invalid```メソッドがコールされ，元々のページにリダイレクトされる．

**＊実装例＊**

```php
<?php
  
namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ExampleController extends Controller
{
    /**
     * 新しいブログポストの保存
     *
     * @param  Request  $request
     */
    public function update(Request $request)
    {
        // バリデーションの実行
        // エラーが起こった場合は元々のページにリダイレクト
        $validated = $request->validated();
  
        $exampleRepository = new ExampleRepository;
        $exampleRepository->update($validated);
        
        // バリデーション時にエラーが起こらなかった場合
        return response()
            ->view('example')
            ->setStatusCode(200);
    }
}
```

#### ・```validate```メソッド

同じくRequestクラスの```validate```メソッドを使用して，ルールを定義し，さらにバリデーションを実行する．```validated```メソッドと間違わないように注意する．ルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```ファイルから対応するエラーメッセージを自動的に選択する．バリデーションでエラーが起こった場合，Handlerクラスの```invalid```メソッドがコールされ，元々のページにリダイレクトされる．

**＊実装例＊**

```php
<?php
  
namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ExampleController extends Controller
{
    /**
     * 新しいブログポストの保存
     *
     * @param  Request  $request
     */
    public function update(Request $request)
    {
        // ルールの定義，バリデーションの実行
        // エラーが起こった場合は元々のページにリダイレクト
        $validated = $request->validate([
            'title' => 'required|unique:posts|max:255',
            'body'  => 'required',
        ]);
  
        $exampleRepository = new ExampleRepository;
        $exampleRepository->update($validated);
        
        // バリデーション時にエラーが起こらなかった場合
        return response()
            ->view('example')
            ->setStatusCode(200);
    }
}
```

なお，ルールは，配列で定義してよい．

**＊実装例＊**

```php
<?php
  
namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ExampleController extends Controller
{
    /**
     * 新しいブログポストの保存
     *
     * @param  Request  $request
     */
    public function update(Request $request)
    {
        // ルールの定義，バリデーションの実行
        // エラーが起こった場合は元々のページにリダイレクト
        $validated = $request->validate([
            'title' => ['required', 'unique:posts', 'max:255'],
            'body'  => ['required'],
        ]);
  
        $exampleRepository = new ExampleRepository;
        $exampleRepository->update($validated);
        
        // バリデーション時にエラーが起こらなかった場合
        return response()
            ->view('example')
            ->setStatusCode(200);
    }
}
```

#### ・エラーメッセージの出力

バリデーションでエラーがあった場合，Handlerクラスの```invalid```メソッドがコールされ，MessageBagクラスがViewに渡される．

参考：

https://laravel.com/api/6.x/Illuminate/Foundation/Exceptions/Handler.html#method_invalid

https://laravel.com/api/6.x/Illuminate/Support/MessageBag.html

<br>

### Validatorファサード

#### ・Validatorファサードとは

ルールを定義し，バリデーションを実行する．Requestクラスの```validated```メソッドや```validate```メソッドの代わりに，Validatorファサードを使用しても良い．

#### ・Validatorクラス，```fails```メソッド

Validateファサードの```make```メソッドを使用して，ルールを定義する．この時，第一引数で，バリデーションを行うリクエストデータを渡す．ルールに反すると，一つ目のルール名（例えば```required```）に基づき，```validation.php```ファイルから対応するエラーメッセージを自動的に選択する．次に，```fails```メソッドを使用して，バリデーションでエラーが起こった場合の処理を定義する．

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
     */
    public function update(Request $request)
    {
        // ルールの定義
        $validator = Validator::make($request->all(), [
            'title' => 'required|unique:posts|max:255',
            'body'  => 'required',
        ]);

        // バリデーション時にエラーが起こった場合
        if ($validator->fails()) {
            // 指定したページにリダイレクト
            return redirect('error')
                // validatorを渡すことでエラーメッセージをViewに渡せる．
                ->withErrors($validator)
                ->withInput();
        }

        $exampleRepository = new ExampleRepository;
        $exampleRepository->update($validated);
        
        return response()
            ->view('example')
            ->setStatusCode(200);
    }
}
```

#### ・```validate```メソッド

Validatorクラスの```validate```メソッドを使用すると，Requestクラスの```validate```メソッドと同様の処理が実行される．バリデーションでエラーが起こった場合，Handlerクラスの```invalid```メソッドがコールされ，元々のページにリダイレクトされる．

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
     */
    public function update(Request $request)
    {  
        // 元のページにリダイレクトする場合は，validateメソッドを使用する．
        $validator = Validator::make($request->all(), [
           'title' => 'required|unique:posts|max:255',
           'body'  => 'required',
        ])
        ->validate();

        // バリデーション時にエラーが起こった場合
        if ($validator->fails()) {
            // 指定したページにリダイレクト
            return redirect('error')
                // validatorを渡すことでエラーメッセージをViewに渡せる．
                ->withErrors($validator)
                ->withInput();
        }

        $exampleRepository = new ExampleRepository;
        $exampleRepository->update($validated);
        
        return response()
            ->view('example')
            ->setStatusCode(200);
    }
}
```

<br>

### セッション

#### ・セッション変数の取得

Requestクラスの```session```メソッドを使用して，セッション変数を取得する．

**＊実装例＊**

```php
<?php
  
namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ExampleController extends Controller
{
    /**
     * @param  Request  $request
     * @param  int  $id
     */
    public function show(Request $request, $id)
    {
        $session = $request->session()->get('key');
    }
}
```

全てのセッション変数を取得することもできる．

```php
$session = $request->session()->all();
```

#### ・フラッシュデータの設定

現在のセッションにおいて，今回と次回のリクエストだけで有効な一時データを設定できる．

```php
$request->session()->flash('status', 'Task was successful!');
```

<br>

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

<br>

## 09-03. HTTP｜Controller

### artisanコマンドによる操作

#### ・クラスの自動生成

```sh
# コントローラクラスを自動作成
$ php artisan make:controller <Controller名>
```

<br>

### Requestクラス

####  ・データの取得

Requestクラスの```input```メソッドを用いて，リクエストボディに含まれるデータを取得できる．

**＊実装例＊**

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ExampleController extends Controller
{
    /**
     * 新しいユーザーを保存
     *
     * @param  Request  $request
     * @return Response
     */
    public function update(Request $request)
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

class ExampleController extends Controller
{
    /**
     * 指定したユーザーの更新
     *
     * @param  Request  $request
     * @param  string  $id
     * @return Response
     */
    public function save(Request $request, $id)
    {
        //
    }
}    
```

<br>

## 09-04. HTTP｜Auth

### artisanコマンドによる操作

#### ・Digest認証の環境構築

```sh
# ここにコマンド例
```

#### ・Oauth認証の環境構築

コマンド実行により，```/storage/oauth```キー，Personal Access Client，Password Grant Clientを生成する．

```sh
$ php artisan passport:install

Personal access client created successfully.
Client ID: 3
Client secret: xxxxxxxxxxxx
Password grant client created successfully.
Client ID: 4
Client secret: xxxxxxxxxxxx
```

ただし，生成コマンドを個別に実行してもよい．

```sh
# 暗号キーを生成
$ php artisan passport:keys

# クライアントを生成
## Persinal Access Tokenの場合
$ php artisan passport:client --personal
## Password Grant Tokenの場合
$ php artisan passport:client --password
```

<br>

### Authファサードによる認証

#### ・Authファサードとは

Laravelからあらかじめ提供されている認証を使用しない場合，Authファサードを使用して，認証ロジックを実装できる．

#### ・Digest認証

パスワードを```attempt```メソッドを用いて自動的にハッシュ化し，データベースのハッシュ値と照合する．認証が終わると，認証セッションを開始する．```intended```メソッドで，ログイン後の初期ページにリダイレクトする．

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

<br>

### PassportライブラリによるOauth認証

#### ・Passportライブラリとは

Laravelから提供されており，Oauth認証のための認可サーバが実装されたライブラリ．```composer.json```ファイルを使用して，インストールする必要がある．

参考：https://github.com/laravel/passport

```json
{
    // ～ 省略 ～
    
    "require": {

        "laravel/passport": "^10.0",
        
    },
    
    // ～ 省略 ～
}
```

#### ・Personal Access Token

開発環境で使用するアクセストークン．

1. 暗号キーとユーザを作成する．

```sh
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
$user = User::find(1);

// スコープ無しのトークンを作成する
$token = $user->createToken('Token Name')->accessToken;

// スコープ付きのトークンを作成する
$token = $user->createToken('My Token', ['place-orders'])->accessToken;
```

#### ・Password Grant Token

本番環境で使用するアクセストークン．

1. ```guards```キーにて，認証方式を設定する．web guardの場合，セッションを使用して，ユーザを認証する．一方で，api guardの場合，アクセストークンを使用して認証する．ここでは，```api```を設定する．認証方法については，認証と認可のノートを参照せよ．

```php
return [

    // ～ 省略 ～

    'defaults' => [
        'guard' => 'api',
        'passwords' => 'users',
    ],

    // ～ 省略 ～
];
```

2. バックエンド側では，Oauth認証（認証フェーズ＋認可フェーズ）を行うために，```auth.php```ファイルで，```driver```キーにpassportドライバを設定する．また，```provider```キーで，usersプロバイダーを設定する．

**＊実装例＊**

```php
return [
    
    // ～ 省略 ～
    
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

    // ～ 省略 ～
];
```

3. バックエンド側では，```auth.php```ファイルにて，```driver```キーにeloquentドライバを設定する．また，```model```キーで認証情報テーブルに対応するEloquentモデルを設定する．ここでは，Userモデルを設定する．Laravelでは，モデルに対応するテーブル名はクラス名の複数形になるため，usersテーブルに認証情報が格納されることになる．もしDBファサードのクエリビルダを使用したい場合は，```database```ドライバを指定する．

```php
return [

    // ～ 省略 ～

    'providers' => [
        'users' => [
            'driver' => 'eloquent',
            // Eloquestモデルは自由に指定できる．
            'model'  => App\Domain\Auth\User::class,
        ],

        // 'users' => [
        //     'driver' => 'database',
        //     'table' => 'users',
        // ],
    ],

    // ～ 省略 ～
];
```

4. バックエンド側では，Userモデルへのルーティング時に，```middleware```メソッドによる認証ガードを行う．これにより，Oauth認証に成功したユーザのみがルーティングを行えるようになる．

**＊実装例＊**

```php
Route::get('user', 'UserController@index')->middleware('auth:api');
```

5. バックエンド側では，認証ガードを行ったモデルに対して，HasAPIToken，NotifiableのTraitをコールするようにする．

**＊実装例＊**

```php
<?php
  
namespace App\Domain\DTO;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;
    
    // ～ 省略 ～
}
```

6. バックエンド側では，Passportの```routes```メソッドをコールするようにする．これにより，認証フェーズでアクセストークンをリクエストするための全てのルーティング（``````/oauth/xxx``````）が有効になる．また，アクセストークンを発行できるよになる．

**＊実装例＊**

```php
<?php
  
use Laravel\Passport\Passport;

class AuthServiceProvider extends ServiceProvider
{
    // ～ 省略 ～

    public function boot()
    {
        $this->registerPolicies();

        Passport::routes();
    }
}
```

7. バックエンド側では，暗号キーとユーザを作成する．

```sh
$ php artisan passport:keys

$ php artisan passport:client --password
```

8. 以降，ユーザ側のアプリケーションでの作業となる．『認証』のために，アクセストークンのリクエストを送信する．ユーザ側のアプリケーションは，```/oauth/authorize```へリクエストを送信する必要がある．ここでは，リクエストGuzzleライブラリを使用して，リクエストを送信するものとする．

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

8. ユーザ側のアプリケーションでは，ユーザ側のアプリケーションにアクセストークンを含むJSON型データを受信する．

**＊実装例＊**

```json
{
  "token_type":"Bearer",
  "expires_in":31536000,
  "access_token":"xxxxx"
}
```

9. ユーザ側のアプリケーションでは，ヘッダーにアクセストークンを含めて，認証ガードの設定されたバックエンド側のルーティングに対して，リクエストを送信する．レスポンスのリクエストボディからデータを取得する．

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

<br>

## 10. Logging

### Log  Channels

#### ・設定方法

環境変数を```.env```ファイルに実装する．```logging.php```ファイルから，指定された設定が選択される．

```
LOG_CHANNEL=<オプション名>
```

#### ・```stack```キー

```php
return [

    // ～ 省略 ～    

    'default'  => env('LOG_CHANNEL', 'stack'),
    'channels' => [
        'stack' => [
            'driver'            => 'stack',
            'channels'          => ['single'],
            'ignore_exceptions' => false,
        ],

        // ～ 省略 ～

    ]
];
```

#### ・```single```キー

全てのログを```/storage/logs/laravel.log```ファイルに対して出力する．

```php
return [

    // ～ 省略 ～    

    'default'  => env('LOG_CHANNEL', 'stack'),
    'channels' => [
        'daily' => [
            'driver' => 'daily',
            'path'   => storage_path('logs/laravel.log'),
            'level'  => env('LOG_LEVEL', 'debug'),
            'days'   => 14,
        ],

        // ～ 省略 ～

    ]
];
```

#### ・```daily```キー

全てのログを```/storage/logs/laravel-<日付>.log```ファイルに対して出力する．

```php
return [

    // ～ 省略 ～    

    'default'  => env('LOG_CHANNEL', 'stack'),
    'channels' => [
        'stderr' => [
            'driver'    => 'monolog',
            'handler'   => StreamHandler::class,
            'formatter' => env('LOG_STDERR_FORMATTER'),
            'with'      => [
                'stream' => 'php://stderr',
            ],
        ],

        // ～ 省略 ～

    ]
];
```

#### ・```stderr```キー

全てのログを標準エラー出力に対して出力する．Docker上でLaravelを稼働させる場合は，これを選択する．

```php
return [

    // ～ 省略 ～

    'default'  => env('LOG_CHANNEL', 'stack'),
    'channels' => [
        'stderr' => [
            'driver'    => 'monolog',
            'handler'   => StreamHandler::class,
            'formatter' => env('LOG_STDERR_FORMATTER'),
            'with'      => [
                'stream' => 'php://stderr',
            ],
        ],

        // ～ 省略 ～

    ]
];
```

<br>


## 11. Migration

### artisanコマンドによる操作

#### ・マイグレーションファイルを作成

```sh
$ php artisan make:migrate create_<テーブル名>_table
```

#### ・テーブル作成

マイグレーションファイルを元にテーブルを作成する．

```sh
$ php artisan migrate
```

#### ・マイグレーションの結果を確認

```sh
$ php artisan migrate:status
```

#### ・指定した履歴数だけテーブルを元に戻す

指定した履歴数だけ，ロールバックを行う

```sh
$ php artisan migrate:rollback --step=<ロールバック数>
```

実際の使用場面として，マイグレーションに失敗した場合に，一つ前の状態にロールバックしてマイグレーションファイルを修正した後，再びマイグレーションを行う．

```sh
# マイグレーションに失敗したので，一つ前の状態にロールバック．
$ php artisan migrate:rollback --step=1

# ファイル修正後にマイグレーションを実行
$ php artisan migrate
```

#### ・初期の状態までテーブルを元に戻す

初期の状態まで，全てロールバックを行う．

```sh
$ php artisan migrate:reset
```

#### ・テーブルを元に戻してから再作成

まず```migrate:reset```を行い，次いで```migrate```を実行する．

```sh
$ php artisan migrate:refresh
```
#### ・テーブルを削除してから再作成

全てのテーブルを削除と```migrate```を実行する．マイグレーションファイルの構文チェックを行わずに，強制的に実行される．

```sh
$ php artisan migrate:fresh
```

<br>

### テーブルの作成と削除

#### ・```up```メソッド，```down```メソッド

コマンドによるマイグレーション時にコールされる．```up```メソッドでテーブル，カラム，インデックスのCREATEを行う．```down```メソッドでCREATEのロールバックを行う．

**＊実装例＊**

```php
<?php
  
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateExampleTable extends Migration
{
    /**
     * マイグレート
     *
     * @return void
     */
    public function up()
    {
        Schema::create('examples', function (Blueprint $table) {
            $table->bigIncrements('example_id')
                ->comment('ID');
            $table->string('name')
                ->comment('名前');
            
            // MigrationMacroServiceProviderのメソッドを使用する．
            $table->systemColumns();
            
            // deleted_atカラムを追加する．
            $table->softDeletes();
        });
    }

    /**
     * ロールバック
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('examples');
    }
}
```

#### ・api guard用のテーブル作成

```php
<?php
  
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUsersTable extends Migration
{
    /**
     * マイグレート
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('user_id');
                ->comment('ユーザID');
            $table->string('name')
                ->comment('ユーザ名');
            $table->string('api_token')
                ->unique()
                ->comment('APIトークン');      
            
            // MigrationMacroServiceProviderのメソッドを使用する．
            $table->systemColumns();
            
            // deleted_atカラムを追加する．
            $table->softDeletes();
        });
    }

    /**
     * ロールバック
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('users');
    }
}
```

<br>

### よく使うカラムタイプ

#### ・```bigIncrements```メソッド

AutoIncrementのINT型カラムを作成する．

**＊実装例＊**

```php
Schema::create('examples', function (Blueprint $table) {
    
    // ～ 省略 ～
    
    $table->bigIncrements('example_id');
    
    // ～ 省略 ～
    
});
```

#### ・```string```メソッド

VARCHAR型カラムを作成する．

**＊実装例＊**

```php
Schema::create('examples', function (Blueprint $table) {
  
    // ～ 省略 ～    
    
    $table->string('name');
    
    // ～ 省略 ～
    
});
```

#### ・```timestamp```メソッド

TIMESTAMP型カラムを作成する．

**＊実装例＊**

```php
Schema::create('examples', function (Blueprint $table) {
    
    // ～ 省略 ～
    
    $table->timestamp('created_at');
    
    // ～ 省略 ～
});
```

<br>

## 12. Resource

### artisanコマンドによる操作

#### ・Resourceの生成

```sh
$ php artisan make:resource <Resource名>
```

<br>

### データ型変換

#### ・Modelの配列化

一つのModelを配列に変換する．Resourceクラスの```toArray```メソッドにて，```this```変数は自身ではなく，Resourceクラス名につくModel名になる．また，```this```変数からゲッターを経由せずに直接プロパティにアクセスできる．

**＊実装例＊**

Exampleクラスからデータを取り出し，配列化する．

```php
<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ExampleJsonResource extends JsonResource
{
    /**
     * オブジェクトを配列に変換します．
     *
     * @param  Request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'id'       => $this->id,
            'name'     => $this->name,
            'email'    => $this->email,
            'password' => $this->password
        ];
    }
}
```

Controllerにて，ResouceクラスにModelを渡すようにする．Laravelはレスポンス時に，```toArray```メソッドをコールし，さらにこの返却値をJSONデータに変換する．

```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ExampleController extends Controller
{
    /**
     * クライアントにデータを返却します．
     *
     * @param  Request  $request
     * @return Response
     */
    public function index(Request $request)
    {
        // ここに，Modelをデータベースから取得する処理
        
        // Modelを渡す．
        return new ExampleResource($example);
    }
}
```

#### ・Collection型の配列化

ModelのCollection型を配列に変換する．

```php
// ここに実装例
```

<br>

## 13. Routing

### artisanコマンドによる操作

#### ・ルーティング一覧

```sh
# ルーティングを一覧で表示
$ php artisan route:list
```

#### ・キャッシュ削除

```sh
# ルーティングのキャッシュを削除
$ php artisan route:clear

# 全てのキャッシュを削除
$ php artisan optimize:clear
```

<br>

### ルーティングファイルの種類

#### ・```api.php```ファイル

APIのエンドポイントとして働くルーティング処理を実装する．基本的に，RouteServiceProviderでAPI認証を定義し，特定のクライアントしかルーティングされないようにする．

#### ・```web.php```ファイル

API以外の場合，こちらにルーティング処理を実装する．第一引数にURL，第二引数に実行するメソッドを定義する．

#### ・```guest.php```ファイル

ヘルスチェックなど，API認証が不要なルーティング処理を実装する．

<br>

### Routeファサード

#### ・Routeファサードとは

コントローラへのルーティングを定義する．

#### ・```namespace```メソッド

コントローラをコールする時に，グループ内で同じ名前空間を指定する．「```App\Http\Controllers```」は内部で読み込まれているので，これ以下の名前空間を指定すればよい．

**＊実装例＊**

```php
<?php

// 「App\Http\Controllers」は内部で読み込まれる．
Route::namespace('Auth')->group(function () {
    
    // 「App\Http\Controllers\Auth\」 以下にあるコントローラを指定できる．
    Route::get('/user', 'UserController@index');
    Route::post('/user/{userId}', 'UserController@createUser');
});
```

#### ・```middleware```メソッド

コントローラへのルーティング時に実行するMiddlewareクラスを設定する．引数として，```App\Http\Kernel.php```ファイルで定義されたMiddlewareクラスのエイリアス名を設定する．

**＊実装例＊**

認証方法としてweb guardを使用する場合，```auth```エイリアスを設定する．

```php
<?php

// authエイリアスのMiddlewareクラスが使用される．
Route::middleware('auth')->group(function () {
    
    Route::get('/user', 'App\Http\Controllers\Auth\UserController@index');
    Route::post('/user/{userId}', 'App\Http\Controllers\Auth\UserController@createUser');
});
```

デフォルトでは，```App\Http\Kernel.php```ファイルにて，```auth```エイリアスに```\App\Http\Middleware\Authenticate```クラスが関連付けられている．


```php
<?php

namespace App\Http;

use App\Http\Middleware\BeforeMiddleware\ArticleIdConverterMiddleware;
use Illuminate\Foundation\Http\Kernel as HttpKernel;

class Kernel extends HttpKernel
{
    
    // ～ 省略 ～
    
    protected $routeMiddleware = [
        'auth'                 => \App\Http\Middleware\Authenticate::class,
        'auth.basic'           => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'bindings'             => \Illuminate\Routing\Middleware\SubstituteBindings::class,
        'cache.headers'        => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can'                  => \Illuminate\Auth\Middleware\Authorize::class,
        'guest'                => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'password.confirm'     => \Illuminate\Auth\Middleware\RequirePassword::class,
        'signed'               => \Illuminate\Routing\Middleware\ValidateSignature::class,
        'throttle'             => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified'             => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
    ];
    
    // ～ 省略 ～    
    
}
```

一方で，認証方法としてapi guardを使用する場合，```auth:api```エイリアスを設定する．

```php
<?php

// authエイリアスのMiddlewareクラスが使用される．
Route::middleware('auth:api')->group(function () {
    // 何らのルーティング
});
```

#### ・```group```メソッド

複数のグループを組み合わせる場合，```group```メソッドを使用する．

**＊実装例＊**

```php
<?php

// 複数のグループを組み合わせる．
Route::group(['namespace' => 'Auth' , 'middleware' => 'auth'])->group(function () {
    
    // 「App\Http\Controllers\Auth\」 以下にあるコントローラを指定できる．
    // authエイリアスのMiddlewareクラスが使用される．
    Route::get('/user', 'UserController@index');
    Route::post('/user/{userId}', 'UserController@createUser');
});
```

#### ・```http```メソッド

Routeクラスには，各HTTPメソッドをルーティングできるメソッドが用意されている．

```php
<?php

Route::get($uri, $callback);
Route::post($uri, $callback);
Route::put($uri, $callback);
Route::patch($uri, $callback);
Route::delete($uri, $callback);
Route::options($uri, $callback);
```

各メソッドの第二引数として，「```{コントローラ名}@{メソッド名}```」を渡すと，コントローラに定義してあるメソッドをコールできる．

**＊実装例＊**

```php
Route::get('/user', 'UserController@index');
```

#### ・```where```メソッド

パスパラメータの形式の制約を，正規表現で設定できる．

**＊実装例＊**

userIdの形式を「0〜9が一つ以上」に設定している．

```php
<?php

Route::namespace('Auth')->group(function () {

    Route::get('/user', 'UserController@index')
    
    // userIdの形式を「0〜9が一つ以上」に設定
    Route::post('/user/{userId}', 'UserController@createUser')
        ->where('user_id', '[0-9]+');
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

<br>

### ヘルスチェック

#### ・単純な```200```レスポンス

ALBやGlobal Acceleratorから```/healthcheck```パスに対してヘルスチェックを設定した上で，```200```ステータスのレスポンスを送信するようにする．Nginxでヘルスチェックを実装することもできるが，アプリケーションの死活管理としては，Laravelに実装する方が適切である．RouteServiceProviderも参照せよ．

**＊実装例＊**

```php
<?php

Route::get('/healthcheck', function () {
    return response('success', 200);
});
```

<br>

## 14. Seeder

### artisanコマンドによる操作

#### ・Seederの生成

```sh
$ php artisan make:seeder <Seeder名>
```

#### ・Seederの実行

```sh
# 事前に，Composerのオートローラを再生成
$ composer dump-autoload

# 特定のSeederを実行
$ php artisan db:seed --class=<Seeder名>

# DatabaseSeederを指定して，全てのSeederを実行
$ php artisan db:seed --class=<Seeder名>
```

<br>

### 初期リアルデータの定義

#### ・配列による定義

```php
<?php

use Illuminate\Database\Seeder;
use App\Constants\ExecutorConstant;

class ProductsSeeder extends Seeder
{
    /**
     * Seederを実行します．
     *
     * @return void
     */
    public function run()
    {
        DB::table('products')->insert([
            [
                'product_name' => 'シャープペンシル',
                'price'        => 300,
                'product_type' => '1',
                'created_by'   => ExecutorConstant::ARTISAN_COMMAND,
                'updated_by'   => ExecutorConstant::ARTISAN_COMMAND,            
                'created_at'   => NOW(),
                'updated_at'   => NOW(),
                'deleted_at'   => NULL
            ],
            [
                'product_name' => 'ノート',
                'price'        => 200,
                'product_type' => '2',
                'created_by'   => ExecutorConstant::ARTISAN_COMMAND,
                'updated_by'   => ExecutorConstant::ARTISAN_COMMAND,            
                'created_at'   => NOW(),
                'updated_at'   => NOW(),
                'deleted_at'   => NULL                
            ],            
            [
                'product_name' => '消しゴム',
                'price'        => 100,
                'product_type' => '3',
                'created_by'   => ExecutorConstant::ARTISAN_COMMAND,
                'updated_by'   => ExecutorConstant::ARTISAN_COMMAND,            
                'created_at'   => NOW(),
                'updated_at'   => NOW(),
                'deleted_at'   => NULL                
            ],
            
            // ～ 省略 ～
            
        ]);
    }
}
```

実行者名は，定数として管理しておくとよい．

```php
<?php

namespace App\Constants;

/**
 * 実行者定数クラス
 */
class ExecutorConstant
{
    /**
     * Artisanコマンド
     */
    public const ARTISAN_COMMAND = 'Artisan Command';

    /**
     * スタッフ
     */
    public const STAFF = 'Staff';
    
    /**
     * ゲスト
     */
    public const GUEST = 'Guest';    
}
```

<br>

#### ・CSVファイルによる定義

```php
// ここに実装例
```

<br>

### Seederの実行

DatabaseSeederにて，全てのSeederをまとめて実行する．

```php
<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seederを実行します．
     *
     * @return void
     */
    public function run()
    {
        // 開発環境用の初期データ
        if (App::environment('local')) {
            $this->call([
                // ダミーデータ
            ]);
        }
        
        // ステージング環境用の初期データ
        if (App::environment('staging')) {
            $this->call([
                // リアルデータ
                ProductsSeeder::class
            ]);
        }
        
        // 本番環境用の初期データ
        if (App::environment('production')) {
            $this->call([
                // リアルデータ
                ProductsSeeder::class
            ]);
        }
    }
}
```

<br>

## 15. ServiceProvider

### artisanコマンドによる操作

#### ・クラスの自動生成

```sh
$ php artisan make:provider <クラス名>
```

<br>

### ServiceProvider

#### ・ServiceProviderの用途

| 用途の種類                                                   | 説明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| AppServiceProvider                                           | ・ServiceContainerへのクラスのバインド（登録）<br>・ServiceContainerからのインスタンスのリゾルブ（生成） |
| MacroServiceProvider                                         | ServiceContainerへのメソッドのバインド（登録）               |
| RouteServiceProvider<br>（```app.php```，```web.php```も使用） | ルーティングとコントローラの対応関係の定義                   |
| EventServiceProvider                                         | EventListenerとEventhandler関数の対応関係の定義              |

#### ・ServiceProviderのコール

クラスの名前空間を，```config/app.php```ファイルの```providers```配列に登録すると，アプリケーションの起動時にServiceProviderをコールできるため，ServiceContainerへのクラスのバインドが自動的に完了する．

**＊実装例＊**

```php
<?php

'providers' => [
    
    // 複数のServiceProviderが実装されている

    App\Providers\ComposerServiceProvider::class,
],
```

<br>

### AppServiceProvider

#### ・ServiceContainer，バインド，リゾルブ

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

AppSeriveProviderにて，ServiceContainerにクラスをバインドすることによって，ServiceContainerがインスタンスを生成できるようになる．Laravelでは，具象クラスはServiceContainerに自動的にバインドされており，以下の実装を行う必要はない．

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

#### ・インターフェース（または抽象クラス）をバインド

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

#### ・ServiceContainerからのリゾルブ

コンストラクタの引数にクラスを渡しておく．Appファサードを使用してクラスを宣言することで，クラスのリゾルブを自動的に行う．

**＊実装例＊**

```php
<?php

namespace App\Domain\DTO;

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

<br>

### MigrationMacroServiceProvider

複数のテーブルに共通のカラムを構築するマイグレーション処理を提供する．

```php
<?php

declare(strict_types=1);

namespace App\Providers;

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\ServiceProvider;

/**
 * マイグレーションマクロサービスプロバイダクラス
 */
class MigrationMacroServiceProvider extends ServiceProvider
{
    /**
     * サービスコンテナにマイグレーションメソッドをバインドします．
     *
     * @return void
     */
    public function register()
    {
        Blueprint::macro('systemColumns', function () {
            $this->string('created_by')
                ->comment('レコードの作成者')
                ->nullable();
            $this->string('updated_by')
                ->comment('レコードの最終更新者')
                ->nullable();
            $this->timestamp('created_at')
                ->comment('レコードの作成日')
                ->nullable();
            $this->timestamp('updated_at')
                ->comment('レコードの最終更新日')
                ->nullable();
            $this->timestamp('deleted_at')
                ->comment('レコードの削除日')
                ->nullable();
        });
        
        Blueprint::macro('dropSystemColumns', function () {
            $this->dropColumn(
                'created_by',
                'updated_by',                
                'created_at',
                'updated_at',
                'deleted_at'
            );
        });        
    }
}
```

マイグレーションファイルにて，定義した```systemColumn```メソッドをコールする．```softDeletes```メソッドについては，以降の説明を参照せよ．

```php
<?php
  
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateExampleTable extends Migration
{
    /**
     * マイグレート
     *
     * @return void
     */
    public function up()
    {
        Schema::create('examples', function (Blueprint $table) {
            $table->bigIncrements('example_id')
                ->comment('ID');
            $table->string('name')
                ->comment('名前');
            
            // MigrationMacroServiceProviderのメソッドを使用する．
            $table->systemColumns();
            
            // deleted_atカラムを追加する．
            $table->softDeletes();
        });
    }

    /**
     * ロールバック
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('examples');
    }
}
```

<br>

### RouteServiceProvider

ルーティングファイルの設定を定義する．

```php
<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Route;

class RouteServiceProvider extends ServiceProvider
{
    /**
     * コントローラの名前空間を定義します．
     */
    protected $namespace = 'App\Http\Controllers';

    public const HOME = '/home';

    /**
     * パターンフィルタを定義します．
     *
     * @return void
     */
    public function boot()
    {
        Route::pattern('user_id', '[0-9]+');

        parent::boot();
    }

    public function map()
    {
        $this->mapApiRoutes();

        $this->mapWebRoutes();
    }

    /**
     * Webルーティングファイルのパスを定義します
     *
     * @return void
     */  
    protected function mapWebRoutes()
    {
        Route::middleware('web')
             ->namespace($this->namespace)
             ->group(base_path('routes/web.php'));
    }

    /**
     * Apiルーティングファイルのパスを定義します．
     *
     * @return void
     */  
    protected function mapApiRoutes()
    {
        # API認証用のルーティングファイル．特定のクライアントのみルーティング可能．
        Route::middleware(['api', 'auth:api'])
             ->namespace($this->namespace)
             ->group(base_path('routes/api.php'));
        
        # API認証不要のヘルスチェック用ルーティングファイル
        Route::middleware('api')
             ->namespace($this->namespace)
             ->group(base_path('routes/guest.php'));
    }
}

```

<br>

### EventServiceProvider

#### ・EventとListenerの登録

EventとListenerの対応関係を定義する．なお，Eventを発火させてListenerを実行する方法は，Eventコンポーネントを参照せよ．

```php
<?php

namespace App\Providers;

use App\Events\UpdatedModelEvent;
use App\Listeners\UpdatedModelListener;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

class EventServiceProvider extends ServiceProvider
{
    /**
     * イベントとリスナーの対応関係を配列で定義します．
     * [イベント => リスナー]
     *
     * @var array
     */
    protected $listen = [
        // Model更新イベント
        UpdatedModelEvent::class => [
            UpdatedModelListener::class,
        ],
    ];

    /**
     * @return void
     */
    public function boot()
    {
    }
}
```

<br>

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

<br>

### MySQL

#### ・単一のデータベースの場合

単一のデータベースに接続する場合，```DB_HOST```を一つだけ設定する．

```php
<?php

return [

    // ～ 省略 ～    

    'default' => env('DB_CONNECTION', 'mysql'),

    'connections' => [

        // ～ 省略 ～

        'mysql' => [
            'driver'         => 'mysql',
            'url'            => env('DATABASE_URL'),
            'host'           => env('DB_HOST', '127.0.0.1'),
            'port'           => env('DB_PORT', 3306),
            'database'       => env('DB_DATABASE', 'forge'),
            'username'       => env('DB_USERNAME', 'forge'),
            'password'       => env('DB_PASSWORD', ''),
            'unix_socket'    => env('DB_SOCKET', ''),
            'charset'        => 'utf8mb4',
            'collation'      => 'utf8mb4_unicode_ci',
            'prefix'         => '',
            'prefix_indexes' => true,
            'strict'         => true,
            'engine'         => null,
            'options'        => extension_loaded('pdo_mysql') ? array_filter([
                PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
            ]) : [],
        ],
    ],

    // ～ 省略 ～        

];
```

#### ・RDSクラスターの場合

RDSクラスターに接続する場合，書き込み処理をプライマリインスタンスに向け，また読み出し処理をリードレプリカインスタンスに向けることにより，負荷を分散できる．この場合，環境変数に二つのインスタンスのホストを実装する必要がある．

```
DB_HOST_PRIMARY=<プライマリインスタンスのホスト>
DB_HOST_READ=<リードレプリカインスタンスのホスト>
```

なお，```sticky```キーを有効化しておくとよい．プライマリインスタンスにおけるデータ更新がリードレプリカインスタンスに同期される前に，リードレプリカインスタンスに対して読み出し処理が起こるような場合，これを防げる．

```php
<?php
    
return [

    // ～ 省略 ～

    'default' => env('DB_CONNECTION', 'mysql'),

    'connections' => [

        // ～ 省略 ～

        'mysql' => [
            'driver'         => 'mysql',
            'url'            => env('DATABASE_URL'),
            'read'           => [
                'host' => [
                    env('DB_HOST_PRIMARY', '127.0.0.1'),
                ],
            ],
            'write'          => [
                'host' => [
                    env('DB_HOST_READ', '127.0.0.1'),
                ],
            ],
            # stickyキーは有効化しておいたほうがよい．
            'sticky'         => true,
            'port'           => env('DB_PORT', 3306),
            'database'       => env('DB_DATABASE', 'forge'),
            'username'       => env('DB_USERNAME', 'forge'),
            'password'       => env('DB_PASSWORD', ''),
            'unix_socket'    => env('DB_SOCKET', ''),
            'charset'        => 'utf8mb4',
            'collation'      => 'utf8mb4_unicode_ci',
            'prefix'         => '',
            'prefix_indexes' => true,
            'strict'         => true,
            'engine'         => null,
            'options'        => extension_loaded('pdo_mysql') ? array_filter([
                PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
            ]) : [],
        ],
    ],

    // ～ 省略 ～

];
```

<br>

## 16. Views

### arisanによる操作

#### ・キャッシュの削除

```sh
# ビューのキャッシュを削除
$ php artisan view:clear

# 全てのキャッシュを削除
$ php artisan optimize:clear
```

<br>

### データの出力

#### ・データの出力

Controllerクラスから返却されたデータは，```{{ 変数名 }}```で取得できる．`

**＊実装例＊**

```html
<html>
    <body>
        <h1>Hello!! {{ $data }}</h1>
    </body>
</html>
```

#### ・バリデーションメッセージの出力

バリデーションでエラーが起こった場合，バリデーションでエラーがあった場合，Handlerクラスの```invalid```メソッドがコールされ，MessageBagクラスがViewに渡される．MessageBagクラスは，Blade上で```errors```変数に格納されており，各メソッドをコールしてエラーメッセージを出力できる．

参考：https://laravel.com/api/6.x/Illuminate/Support/MessageBag.html

**＊実装例＊**

MessageBagクラスの```all```メソッドで，全てのエラーメッセージを出力する．

```html
<!-- /resources/views/example/create.blade.php -->

<h1>ポスト作成</h1>

@if ($errors->any())
    <div>
        @foreach ($errors->all() as $error)
            <p class="alert alert-danger">{{ $error }}</p>
        @endforeach        
    </div>
@endif

@isset ($status)
    <div class="complete">
        <p>登録が完了しました．</p>
    </div>
@endisset

<!-- ポスト作成フォーム -->
```

```css
.errors {
    /* 何らかのデザイン */
}

.complete {
    /* 何らかのデザイン */
}
```

<br>

### 要素の共通化

#### ・```@extends```，```@parent```，```@show```

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

子テンプレートの```@parent```にて，親テンプレートの```@section```を継承する．

```html
<!-- 子テンプレート -->

@extends('layouts.app')

@section('sidebar')
    @parent
    <p>子テンレプートのサイドバーに追加される要素</p>
@endsection
```

#### ・```@include```（サブビュー）

読み込んだファイル全体を出力する．読み込むファイルに対して，変数を渡すこともできる．```@extentds```との使い分けとして，親子関係のないテンプレートの間で使用するのがよい．両者は，PHPでいう```extends```（クラスチェーン）と```require```（単なる読み込み）の関係に近い．

**＊実装例＊**

```html
<div>
    @include('shared.errors')
    <form><!-- フォームの内容 -->
    </form>
</div>
```

<br>

### 子テンプレートにおける要素の出力

#### ・```@yield```，```@section```

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

<br>

#### ・```@stack```，```@push```

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

<br>

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

<br>

## 17. よく使うグローバルヘルパー関数

### 一覧

以下リンクを参照せよ．

https://readouble.com/laravel/6.x/ja/helpers.html#method-view

<br>

### ```config```ヘルパー

#### ・環境変数ファイルの読み込み

環境変数ファイル名とキー名をドットで指定し，事前に設定された値を出力する．

**＊実装例＊**

標準で搭載されている```app.php```ファイルの```timezone```キーの値を出力する．

```php
<?php

$value = config('app.timezone');
```

#### ・独自環境変数ファイルの作成と読み込み

configディレクトリに任意の名前のphp形式を作成しておく．これは，configヘルパーで読み込むことができる．

**＊実装例＊**


```php
<?php

$requestUrl = config('api.example1.endpoint_url');
```


```php
<?php

return [
    'example1' => [
        'endpoint_url' => env('ENDPOINT_URL', ''),
        'api_key'      => env('SQUID_API_KEY'),
    ],
    'example2' => [
        'endpoint_url' => env('ENDPOINT_URL', ''),
        'api_key'      => env('SQUID_API_KEY'),
    ]
];
```
<br>

### ```response```ヘルパー

#### ・ソースコード

https://github.com/laravel/framework/blob/6.x/src/Illuminate/Contracts/Routing/ResponseFactory.php

#### ・Json型データのレスポンス

返却されるResponseFactoryクラスの```json```メソッドにレンダリングしたいJSONデータを設定する．

**＊実装例＊**

```php
<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Response;

class ExampleController extends Controller
{
    public function index()
    {

        // ～ 省略 ～

        return response()
            ->json([
                'name'  => 'Abigail',
                'state' => 'CA'
            ]);
    }
}
```

#### ・Viewテンプレートのレスポンス

返却されるResponseFactoryクラスの```view```メソッドに，レンダリングしたいデータ（テンプレート，array型データ，ステータスコードなど）を設定する．また，Viewクラスの```header```メソッドにHTTPヘッダーの値を設定する．

**＊実装例＊**

```php
<?php

namespace App\Http\Controllers\Example;

use App\Http\Controllers\Controller;
use Illuminate\Http\Response;

class ExampleController extends Controller
{
    public function index()
    {
        // ～ 省略 ～

        // データ，ステータスコード，ヘッダーなどを設定する場合
        return response()
            ->view(
              'example',
              $data,
              200
            )->header(
              'Content-Type',
              $type
            );
    }
}
```

```php
<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Response;

class ExampleController extends Controller
{
    public function index()
    {
        // ～ 省略 ～

        // ステータスコードのみ設定する場合
        return response()
            ->view('example')
            ->setStatusCode(200);
    }
}
```

#### ・ロギング

返却されるResponseFactoryクラスの```error```メソッドに，エラーメッセージを設定するようにする．この時，```sprintf```メソッドを使用すると便利である．

**＊実装例＊**

外部のAPIに対してリクエストを送信し，データを取得する．取得したJSONデータを，クライアントにレスポンスする．この時，リクエスト処理のために，Guzzleライブラリを使用している．

```php
<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\GuzzleException;
use Illuminate\Http\Response;

class ExampleController extends Controller
{
    public function index()
    {
        $client = new Client();
        $requestUrl = config('api.example1.endpoint_url');
        
        try {
            
            $response = $client->request(
                'GET',
                $requestUrl,
                [
                    'headers' => [
                        'Content-Type' => 'application/json',
                        'X-API-Key'    => 'api.example1.api_key',
                    ]
                ]
            );
            
            // JSONをクライアントにレスポンス
            return $response->getBody()->getContents();
            
        } catch (GuzzleException $e) {
            
            return response()
                ->error(sprintf(
                    '%s : %s at %s line %s',
                    get_class($e),
                    $e->getMessage(),
                    $e->getFile(),
                    $e->getLine()
                ));
        }
    }
}
```

```php
<?php

return [
    'example1' => [
        'endpoint_url' => env('ENDPOINT_URL', ''),
        'api_key'      => env('SQUID_API_KEY'),
    ],
    'example2' => [
        'endpoint_url' => env('ENDPOINT_URL', ''),
        'api_key'      => env('SQUID_API_KEY'),
    ]
];
```

<br>

### ```path```系ヘルパー

#### ・```base_path```ヘルパー

引数を設定しない場合，projectルートディレクトリの絶対パスを生成する．また，projectルートディレクトリからの相対パスを引数として，絶対パスを生成する．

```php
<?php

// /var/www/project
$path = base_path();

// /var/www/project/vendor/bin
$path = base_path('vendor/bin');
```

#### ・```public_path```ヘルパー

引数を設定しない場合，publicディレクトリの絶対パスを生成する．また，publicディレクトリからの相対パスを引数として，絶対パスを生成する．

```php
<?php

// /var/www/project/public
$path = public_path();

// /var/www/project/public/css/app.css
$path = public_path('css/app.css');
```

#### ・```storage_path```ヘルパー

引数を設定しない場合，storageディレクトリの絶対パスを生成する．まあ，storageディレクトリからの相対パスを引数として，絶対パスを生成する．

```php
<?php

// /var/www/project/storage
$path = storage_path();

// /var/www/project/storage/app/file.txt
$path = storage_path('app/file.txt');
```

<br>

## 18. 外部ライブラリ

### Enum

#### ・ソースコード

参考：https://github.com/BenSampo/laravel-enum

#### ・Enumクラスの定義

BenSampoのEnumクラスを継承し，区分値と判定メソッドを実装する．

**＊実装例＊**

```php
<?php

namespace App\Domain\ValueObject\Type;

use BenSampo\Enum\Enum;

class RoleType extends Enum
{
    public const CALL_ROLE = '1';        // コールセンター職  
    public const DEVELOPMENT_ROLE = '2'; // 開発職    
    public const FINANCE_ROLE = '3';     // 経理職     
    public const PLAN_ROLE = '4';        // 企画職       
    public const SALES_ROLE = '5';       // 営業職
    
    /**
     * コールセンター職の区分値をもつかどうかを判定します．
     */    
    public function isCallRole()
    {
        return $this->is(self::CALL_ROLE);
    }
    
    /**
     * 開発職の区分値をもつかを判定します．
     */       
    public function isDevelopmentRole()
    {
        return $this->is(self::DEVELOPMENT_ROLE);
    }
    
    /**
     * 経理職の区分値をもつかどうかを判定します．
     */       
    public function isFinanceRole()
    {
        return $this->is(self::FINANCE_ROLE);
    }
    
    /**
     * 企画職の区分値をもつかどうかを判定します．
     */       
    public function isPlanRole()
    {
        return $this->is(self::PLAN_ROLE);
    }  
    
    /**
     * 営業職の区分値をもつかどうかを判定します．
     */       
    public function isSalesRole()
    {
        return $this->is(self::SALES_ROLE);
    }        
}
```

#### ・Enumクラスの使い方

**＊実装例＊**

データベースから区分値をSELECTした後，これを元にEnumクラスを作成する．

```php
<?php

// Staffモデル
$staff = new Staff();
 
// データベースから取得した区分値（開発職：2）からEnumクラスを作成
$staff->roleType = new RoleType($fetched['role_type']);
// 以下の方法でもよい．
// $staff->roleType = RoleType::fromValue($fetched['role_type']);

// StaffモデルがいずれのRoleTypeをもつか
$staff->roleType->isDevelopmentRole(); // true
$staff->roleType->isSalesRole(); // false
```

**＊実装例＊**

リクエストメッセージからデータを取り出した後，これを元にEnumクラスを作成する．

```

```

