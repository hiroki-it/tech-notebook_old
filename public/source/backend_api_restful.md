# RESTful APIの概念と実装

## 01. RESTとRESTfulとは

### REST

#### ・RESTとは

分散型アプリケーションを構築する時に，それぞれアプリケーションを連携させるのに適したアーキテクチャスタイルをRESTという．また，アーキテクチャスタイルについては，オブジェクト指向分析・設計のノートを参照せよ．RESTは，以下の特徴を持つ．

![REST](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/REST.jpg)

#### ・RESTfulとRESTful APIとは

RESTに基づいた設計をRESTfulという．RESTful設計が用いられたWebAPIをRESTful APIという．例えば，RESTful APIの場合，DBにおけるUserInfoのCRUDに対して，一つの「/UserInfo」というURIを対応づけている．

![RESTfulAPIを用いたリクエスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/RESTfulAPIを用いたリクエスト.png)



### RESTの４原則

#### ・Stateless

クライアントに対してレスポンスを送信したら，クライアントの情報を保持せずに破棄する仕組みのこと．擬似的にStatefulな通信を行う時は，キャッシュ，Cookie，セッションIDを用いて，クライアントの情報を保持する．

| Statelessプロトコル | Statefulプロトコル |
| ------------------- | ------------------ |
| HTTP                | SSH                |
| HTTPS               | TLS/SSL            |
| -                   | SFTP               |

#### ・Connectability
#### ・Uniform Interface

HTTPプロトコルを使用したリクエストを，「リソースに対する操作」とらえ，リクエストにHTTPメソッドを対応づけるようにする．

#### ・Addressability

エンドポイントによって，特定のリソースを操作できること．




## 02. Uniform Interface

### リクエストとHTTPメソッドの対応関係

#### ・各HTTPメソッドの特徴

| **HTTPメソッド** | 操作                | 読み出し／書き込み | 特徴 |
| :--------------- | ---------------- | --------------------------------------- | ---------------- |
|     **GET**      | READ |   読み  |  |
|     **POST**     | ・CREATE<br>・UPDATE<br>・PDF作成<br>・ファイルデータ送信<br>・ログイン |     書き     | 非冪等的 |
|     **PUT**      | ・CREATE<br/>・UPDATE |   書き    | 冪等的 |
|    **DELETE**    | DELETE |    書き    |  |


#### ・POST送信 vs PUT送信

POST送信とPUT送信の重要な違いについてまとめる．データを作成するときはPOST送信，データを更新するときは，PUT送信を使用するようにする．

|                    | POST送信                                           | PUT送信                                           |
| ------------------ | -------------------------------------------------- | ------------------------------------------------- |
| データ作成の冪等性 | リクエスト1つにつき，1つのデータを作成（非冪等的） | リクエスト数に限らず，1つのデータを作成（冪等的） |
| 更新内容           | リクエストボディに格納（隠蔽可能）                 | パスパラメータに表示（隠蔽不可）                  |



## 02-02. Addressability

### エンドポイント

#### ・エンドポイントとは

特定のリソースを操作するための固有のURIのこと．エンドポイント は，リソース1つごと，あるいはまとまりごとに割り振られる．

#### ・HTTPメソッドに対応するエンドポイント

RESTfulAPIでは，全てのHTTPメソッドの内，主に以下の4つを使用して，データ処理の方法をリクエストする．


```http
GET http://www.example.co.jp/users/{id}
```

```http
POST http://www.example.co.jp/users
```

```http
PUT http://www.example.co.jp/users/{id}
```

```http
DELETE http://www.example.co.jp/users/{id}
```

#### ・エンドポイントの違い

| HTTPメソッド | エンドポイントの有無 |
| ------------ | -------------------- |
| GET          | あり／なし           |
| POST         | なし                 |
| PUT          | あり                 |
| DELETE       | なし                 |




### パスパラメータとクエリパラメータ

#### ・パスパラメータ，クエリパラメータとは

URIの構造のうち，以下の部分を指す．

```
http://www.example.co.jp:80/users/777?text1=a&text2=b
```

| 完全修飾ドメイン名             | 送信先のポート番号（```80```の場合は省略可） | ルート      | パスパラメータ | ？      | クエリパラメータ（GET送信時のみ） |
| ------------------------------ | -------------------------------------------- | ----------- | -------------- | ------- | --------------------------------- |
| ```http://www.example.co.jp``` | ```80```                                     | ```users``` | ```{id}```     | ```?``` | ```text1=a&text2=b```             |

#### ・使い分け（再掲）

| データの送信対象         | パスパラメータ | クエリパラメータ |
| ------------------------ | :------------: | :--------------: |
| 単一条件で決まる検索処理 |       ◯        |        △         |
| 複数条件で決まる検索処理 |       ✕        |        ◯         |
| フィルタリング処理       |       ✕        |        ◯         |
| ソーティング処理         |       ✕        |        ◯         |



### エンドポイントの作り方

#### ・短くすること

**＊悪い実装例＊**

ここで，```service```，```api```，といったキーワードは，なくても問題ない．


```http
GET http://www.example.co.jp/service/api/users/12345
```

#### ・略称を使わないこと

**＊悪い実装例＊**

ここで，```users```を意味する```u```といった略称は，当時の設計者しかわからないため，不要である．

```http
GET http://www.example.co.jp/u/12345
```

#### ・小文字を使うこと

**＊悪い実装例＊**

```http
GET http://www.example.co.jp/Users/12345
```

#### ・ケバブケースを使うこと

**＊悪い実装例＊**

スネークケースやキャメケースを使わない

```http
GET http://www.example.co.jp/users_id/12345
```

ただ，そもそもケバブ方式も利用しないのも手である

```http
GET http://www.example.co.jp/users/id/12345
```

#### ・複数形を使用すること

**＊悪い実装例＊**

```users```という集合の中に，```id```が存在しているため，単数形は使わない．

```http
GET http://www.example.co.jp/user/12345
```

#### ・システムの設計方法がバレないURIにすること

**＊悪い実装例＊**

悪意のあるユーザに，脆弱性を狙われる可能性があるため，システムの設計方法がばれないアーキテクチャにすること．ミドルウェアにCGIプログラムが使用されていることや，phpを使用していることがばれてしまう．

```http
GET http://www.example.co.jp/cgi-bin/get_users.php
```

#### ・HTTPメソッドの名前を使用しないこと

**＊悪い実装例＊**

メソッドから，処理の目的はわかるので，URIに対応する動詞名を実装する必要はない．

```http
GET http://www.example.co.jp/user/get/12345
```

```http
POST http://www.example.co.jp/user/create/12345
```


```http
PUT http://www.example.co.jp/user/update/12345
```

```http
DELETE http://www.example.co.jp/user/delete/12345
```

#### ・数字，バージョン番号を使用しないこと

**悪い実装例＊**

ここで，```alpha```，```v2```，といったキーワードは，当時の設計者しかわからないため，あまり良くない．ただし，利便上，使う場合もある．

```http
GET http://www.example.co.jp/v2/users/12345
```

リクエストヘッダーの```X-api-Version```にバージョン情報を格納する方法がより良い．

```
X-Api-Version: 1
```



#### ・異なるHTTPメソッドの間でルールを統一すること

**＊悪い実装例＊**

GET送信とPOST送信の間で，IDパラメータのHTTPメソッドが統一されていない．

```http
GET http://www.example.co.jp/users/?id=12345
```

```http
POST http://www.example.co.jp/users/12345/messages
```

**＊良い実装例＊**

以下のように，異なるHTTPメソッドの間でも統一する．


```http
GET http://www.example.co.jp/users/12345
```

```http
POST http://www.example.co.jp/users/12345/messages
```



## 03. オブジェクトデータの送受信

### オブジェクトデータ型

#### ・データ型

XML，JSON，JSONP

#### ・データ型の指定方法

最も良い方法は，送信時にリクエストヘッダーの```Content-Type```に，```application/json```を格納することである．

```
Content-Type: application/json
```

他に，URIでデータ型を記述する方法がある．

```
http://www.example.co.jp/users/12345?format=json
```

### オブジェクトデータ構造の作り方

#### ・フラットなデータ構造にすること

JSON型オブジェクトの場合，入れ子構造にすると，データ容量が増えてしまう．

**＊具体例＊**

```json
{
    "name": "Taro Yamada",
    "age": 10,
    "interest": {
      "sports":["soccer", "baseball"],
      "subjects": "math"
    }
}
```

そこで，できるだけ，データ構造をフラットにする．

**＊具体例＊**

```json
{
    "name": "Taro Yamada",
    "age": 10,
    "sports":["soccer", "baseball"],
    "subjects": "math"
}
```

#### ・日付データの形式に気をつけること

RFC3339（W3C-DTF）形式でオブジェクトデータに含めて送受信すること．

**＊具体例＊**

````
2020-07-07T12:00:00+09:00
````

ただし，日付をリクエストパラメータで送受信する時，RFC3339（W3C-DTF）形式を正規表現で設定する必要があるので注意．

**＊具体例＊**

```
http://www.example.co.jp/users/12345?date=2020-07-07T12:00:00%2B09:00
```

#### ・エラーメッセージを含めること

バリデーションの文言などのメッセージは，オブジェクトデータに含めること．

```json
{
  "message": "エラー：入力に不備があります。"
}
```



### HTTPステータスの種類

#### ・100番台：継続

#### ・200番台：リクエスト成功

#### ・300番台：リダイレクトに関するステータス

#### ・400番台：リクエスト失敗

#### ・500番台：サーバーエラー



## 05. Statelessプロトコルにおける擬似Stateful化

### Cookie，Cookie情報（キー名／値）

#### ・Cookie，Cookie情報とは

クライアントからの次回のリクエスト時でも，Cookie情報（キー名／値）を用いて，同一クライアントと認識できる仕組みCookieという．HTTPはStatelessプロトコルであるが，Cookie情報を用いると，擬似的にStatefulな通信を行える．

#### ・Cookie情報に関わるヘッダー

最初，サーバからのレスポンス時，Set-Cookieヘッダーを用いて送信される．反対に，クライアントからのリクエスト時，Cookie情報は，Cookieヘッダーを用いて送信される．


| HTTPメッセージの種類 | ヘッダー名 | 属性     | 内容                                                         |
| -------------------- | ---------- | -------- | ------------------------------------------------------------ |
| レスポンスメッセージ | Set-Cookie | Name     | Cookie名と値                                                 |
|                      |            | Expires  | Cookieの有効期限（日数）                                     |
|                      |            | Max-Age  | Cookieの有効期限（秒数）                                     |
|                      |            | Domain   | クライアントがリクエストする時のCookie送信先ドメイン名       |
|                      |            | Path     | クライアントがリクエストする時のCookie送信先ディレクトリ     |
|                      |            | Secure   | クライアントからのリクエストでSSLプロトコルが使用されている時のみ，リクエストを送信できるようにする． |
|                      |            | HttpOnly | クライアント側で，JavaScriptがCookieを使用できないようにする．XSS攻撃の対策になる． |
| リクエストメッセージ | Cookie     |          | セッションIDなどのCookie情報                                 |
クライアントから送信されてきたリクエストメッセージのCookieヘッダーの内容は，グローバル変数に格納されている．

```php
<?php
    
$_COOKIE = ['Cookie名' => '値']
```


#### ・Cookie情報の送受信の仕組み

1. 最初，ブラウザはリクエストでデータを送信する．
2. サーバは，レスポンスヘッダーのSet-CookieヘッダーにCookie情報を埋め込んで送信する．

```php
<?php

setcookie(Cookie名, Cookie値, 有効日時, パス, ドメイン, HTTPS接続のみ, Javascript無効）
```

3. ブラウザは，そのCookie情報を保存する．
4. 2回目以降のリクエストでは，ブラウザは，リクエストヘッダーのCookieヘッダーにCookie情報を埋め込んでサーバに送信する．サーバは，Cookie情報に紐づくクライアントのデータをReadする．

![Cookieの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Cookieの仕組み.png)



### セッションID

#### ・セッション，セッションIDとは

クライアントからの次回のリクエスト時でも，セッションIDを用いて，同一クライアントと認識できる仕組みをセッションという．セッションIDは，Cookie情報の一つとして，CookieヘッダーとSet-Cookieヘッダーによって送受信される．HTTPはStatelessプロトコルであるが，セッションIDを用いると，擬似的にStatefulな通信を行える．

```
# （例）Cookie: PHPSESSID={セッションID}; csrftoken=u32t4o3tb3gg43; _gat=1
```


```
# （例）Set-Cookie: sessionId={セッションID}
```

#### ・セッションIDの発行，セッションファイルの生成

session_startメソッドを用いることで，セッションを開始し，クライアントにセッションIDを発行する．グローバル変数に値を代入することによって，セッションファイルを作成する．もしクライアントに既にセッションIDが発行されている場合，セッションファイルを参照する．

**＊実装例＊**

```php
<?php

// セッションの開始．セッションIDを発行する．
session_start();

// セッションファイルを作成
$_SESSION['名前'] = 値
```

#### ・セッションファイルの保存場所

```/etc/php.ini```ファイルでセッションファイルの保存場所を定義できる．セッションファイルは，```sess_xxxxx```ファイルとして保存される．

```ini
session.save_path = "/tmp"
```

例えば，これをAmazonRedisのソケットとすれば，Redisに保存できる．

```ini
session.save_path = "tcp://xxxxx-redis.r9ecnn.ng.0001.apne1.cache.amazonaws.com:6379"
```

#### ・セッションIDの送受信の仕組み

1. 最初，ブラウザはリクエストでデータを送信する．セッションIDを発行し，セッションIDごとに```sess_xxxxx```ファイルを生成．
2. サーバは，レスポンスヘッダ情報のCookieヘッダーにセッションIDを埋め込んで送信する．
3. ブラウザは，そのセッションIDを保存する．
4. 2回目以降のリクエストでは，ブラウザは，リクエストヘッダ情報のCookieヘッダーにセッションIDを埋め込んでサーバに送信する．サーバは，セッションIDに紐づくクライアントのデータをReadする．

![セッションIDの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/セッションIDの仕組み.png)

#### ・ページ遷移とセッションID引継ぎ

![セッションIdとページ遷移](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/セッションIdとページ遷移.png)



## 06. API仕様書

### スキーマ

#### ・スキーマとは

例えば，APIが，以下のようなJSON型データをレスポンスするとする．

```json
{
    "name": "Taro Yamada",
    "age": 10,
    "sports":["soccer", "baseball"],
    "subjects": "math"
}
```

ここで，以下のように，レスポンスデータの各データ型をJSON型（あるいはYAML型）で記述しておく．これをスキーマという，スキーマは，レスポンスデータのバリデーションを行う時に用いる．

```json
{
    "type": "object",
    "properties": {
        "name": {
            "type": "string"
        },
        "age": {
            "type": "integer",
            "minimum": 0
        },
        "sports": {
            "type": "array",
            "items": {
                "type": "string"
            }
        },
        "subjects": {
            "type": "string"
        }
    },
    "required": ["name"]
}
```
