

# ライブラリ

## 01-01. ライブラリの読み込み

### :pushpin: エントリポイントでの```autoload.php```の読み込み

ライブラリが，```vendor```ディレクトリ下に保存されていると仮定する．ライブラリを使用するたびに，各クラスでディレクトリを読み込むことは手間なので，エントリーポイント（```index.php```）あるいは```bootstrap.php```で，最初に読み込んでおき，クラスでは読み込まなくて良いようにする．

**【実装例】**

```PHP
require_once realpath(__DIR__ . '/vendor/autoload.php');
```



## 02-01. Doctrineライブラリ

### :pushpin: DoctrineによるRDBの操作

https://www.doctrine-project.org/projects/doctrine-dbal/en/2.10/reference/transactions.html

```beginTransaction()```，```commit()```，```rollBack()```を用いて，RDBを操作する．PDOによるRDBの操作については，DBの操作のノートを参照せよ．

**【実装例】**

```PHP
$conn = new Doctrine\DBAL\Connection

// トランザクションの開始 
$conn->beginTransaction();
try{
    // コミット
    $conn->commit();
} catch (\Exception $e) {
  
    // ロールバック
    $conn->rollBack();
    throw $e;
}
```



### :pushpin: トランザクション時のSQLの定義

#### 1. ```createQueryBuilder()```

https://www.doctrine-project.org/projects/doctrine-dbal/en/2.10/reference/query-builder.html

```QueryBuilder```は，CRUD操作に必要なSQLを保持し，トランザクションによってSQLを実行される．

**【実装例】**

```PHP
// QueryBuilderインスタンスを作成．
$queryBuilder = $this->createQueryBuilder();
```

#### 2. CREATE

```QueryBuilder```インスタンスにおける```insert()```に，値を設定する．

**【実装例】**

```PHP
$queryBuilder
    ->insert('mst_users')
```

#### 3. READ

```QueryBuilder```インスタンスにおける```select()```に，値を設定する．

**【実装例】**

```PHP
$queryBuilder
    ->select('id', 'name')
    ->from('mst_users');
```

#### 4. UPDATE

```QueryBuilder```インスタンスにおける```update()```に，値を設定する．

**【実装例】**

```PHP
$queryBuilder
    ->update('mst_users');
```

#### 5. DELETE

```QueryBuilder```インスタンスにおける```delete()```に，値を設定する．

**【実装例】**

```PHP
$queryBuilder
    ->delete('mst_users');
```

#### 6. データベースへの接続，SQLの実行 

データベース接続に関わる```getConnection()```を起点として，返り値から繰り返しメソッドを取得し，```fetchAll()```で，テーブルのクエリ名をキーとした連想配列が返される．

**【実装例】**

```PHP
// データベースに接続．
$queryBuilder->getConnection()
    // SQLを実行し，レコードを読み出す．
    ->executeQuery($queryBuilder->getSQL(),
          $queryBuilder->getParameters()
    )->fetchAll();
```



#### :pushpin: プレースホルダー（プリペアードステートメント）

プリペアードステートメントともいう．SQL中にパラメータを設定し，値をパラメータに渡した上で，SQLとして発行する方法．処理速度が速い．また，パラメータに誤ってSQLが渡されても，これを実行できなくなるため，SQLインジェクションの対策にもなる

**【実装例】**

```PHP
use Doctrine\DBAL\Connection;

class DogToyQuery
{
    // READ処理のSQLを定義するメソッド．
    public function read(Value $toyType): Array
    {
        // QueryBuilderインスタンスを作成．
        $queryBuilder = $this->createQueryBuilder();
        
        // SQLの定義
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
          ->where('dog_toy.type = :type')
          
          // プレースホルダーに値を設定する．ここでは，引数で渡す『$toyType』とする．
          ->setParameter('type', $toyType);
        
        // データベースに接続．
        return $queryBuilder->getConnection()
          
          // SQLを実行し，レコードを読み出す．
          ->executeQuery($queryBuilder->getSQL(),
            $queryBuilder->getParameters()
          )->fetchAll();
    }
}
```



## 03-01. Carbonライブラリ

### :pushpin: Date型

厳密にはデータ型ではないが，便宜上，データ型とする．タイムスタンプとは，協定世界時(UTC)を基準にした1970年1月1日の0時0分0秒からの経過秒数を表したもの．

| フォーマット         | 実装方法            | 備考                                                         |
| -------------------- | ------------------- | ------------------------------------------------------------ |
| 日付                 | 2019-07-07          | 区切り記号なし、ドット、スラッシュなども可能                 |
| 時間                 | 19:07:07            | 区切り記号なし、も可能                                       |
| 日時                 | 2019-07-07 19:07:07 | 同上                                                         |
| タイムスタンプ（秒） | 1562494027          | 1970年1月1日の0時0分0秒から2019-07-07 19:07:07 までの経過秒数 |



### :pushpin: ```instance()``` 

DateTimeインスタンスを引数として，Carbonインスタンスを作成する．

```PHP
$datetime = new \DateTime('2019-07-07 19:07:07');
$carbon = Carbon::instance($datetime);

echo $carbon; // 2019-07-07 19:07:07
```



### :pushpin: ```create()```

日時の文字列からCarbonインスタンスを作成する．

**【実装例】**

```PHP
$carbon = Carbon::create(2019, 07, 07, 19, 07, 07);

echo $carbon; // 2019-07-07 19:07:07
```



### :pushpin: ```createFromXXX()```

指定の文字列から，Carbonインスタンスを作成する．

#### ・日時数字から

**【実装例】**

```PHP
// 日時数字から，Carbonインスタンスを作成する．
$carbonFromeDate = Carbon::createFromDate(2019, 07, 07);

echo $carbonFromeDate; // 2019-07-07
```

#### ・時間数字から

**【実装例】**

```PHP
// 時間数字から，Carbonインスタンスを作成する．
$carbonFromTime = Carbon::createFromTime(19, 07, 07);

echo $carbonFromTime; // 19:07:07
```

#### ・日付，時間，日時フォーマットから

第一引数でフォーマットを指定する必要がある．

**【実装例】**

```PHP
// 日付，時間，日時フォーマットから，Carbonインスタンスを作成する．
// 第一引数でフォーマットを指定する必要がある．
$carbonFromFormat = Carbon::createFromFormat('Y-m-d H:m:s', '2019-07-07 19:07:07');

echo $carbonFromFormat; // 2019-07-07 19:07:07
```

#### ・タイムスタンプフォーマットから

**【実装例】**

```PHP
// タイムスタンプフォーマットから，Carbonインスタンスを作成する．
$carbonFromTimestamp = Carbon::createFromTimestamp(1562494027);

echo $carbonFromTimestamp; // 2019-07-07 19:07:07
```



### :pushpin: ```parse()```

日付，時間，日時フォーマットから，Carbonインスタンスを作成する．```createFromFormat()```とは異なり，フォーマットを指定する必要がない．

**【実装例】**

```PHP
$carbon = Carbon::parse('2019-07-07 19:07:07')
```



## 05-01. Pinqライブラリ

### :pushpin: ```Traversable::from()```

SQLの```SELECT```や```WHERE```といった単語を用いて，```foreach()```のように，配列データやオブジェクトデータを走査できる．

**【実装例】**

```PHP
use Pinq\Traversable;

class Example
{
    
    public function getData(array $entities)
    {
        
        return [
          'data' => Traversable::from($entities)
            // 一つずつ要素を取り出し，関数に渡す．
            ->select(
              function ($entity) {
                  return $this->convertToArray($entity);
              })
            // indexからなる配列として返却．
            ->asArray(),
        ];
    }
}
```



## 04-01. Guzzleライブラリ

通常、リクエストメッセージの送受信は，クライアントからサーバに対して，Postmanやcurl関数などを使用して行う。しかし、Guzzleライブラリを使えば、サーバから他サーバに対して，リクエストメッセージの送受信ができる。

### :pushpin: リクエストメッセージをGET送信

**【実装例】**

```PHP
$client = new Client();

// GET送信
$response = $client->request("GET", {アクセスしたいURL});
```

### :pushpin: レスポンスメッセージからボディを取得

**【実装例】**

```PHP
$client = new Client();

// POST送信
$response = $client->request("POST", {アクセスしたいURL});

// レスポンスメッセージからボディのみを取得
$body = json_decode($response->getBody(), true);
```



## 06-01. Respect/Validationライブラリ

リクエストされたデータが正しいかを，サーバサイド側で検証する．フロントエンドからリクエストされるデータに関しては，JavaScriptとPHPの両方によるバリデーションが必要である．

