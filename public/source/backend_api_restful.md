# RESTful APIの概念と実装

## 01. RESTとRESTfulとは

### RESTとは

分散型アプリケーションを構築する時に，それぞれアプリケーションを連携させるのに適したアーキテクチャスタイルをRESTという．また，アーキテクチャスタイルについては，オブジェクト指向分析・設計のノートを参照せよ．RESTは，以下の特徴を持つ．

![REST](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/REST.jpg)

### RESTの４原則

#### ・Addressability
#### ・Stateless

クライアントに対してレスポンスを送信したら，クライアントの情報を保持せずに破棄する仕組みのこと．擬似的にStatefulな通信を行う時は，キャッシュ，Cookie，セッションIDを用いて，クライアントの情報を保持する．

| Statelessプロトコル | Statefulプロトコル |
| ------------------- | ------------------ |
| HTTP                | SSH                |
| HTTPS               | TLS/SSL            |
| -                   | SFTP               |

#### ・Connectability
#### ・Uniform Interface



### RESTful

#### ・RESTfulとRESTful APIとは

RESTに基づいた設計をRESTfulという．RESTful設計が用いられたWebAPIをRESTful APIという．例えば，RESTful APIの場合，DBにおけるUserInfoのCRUDに対して，一つの「/UserInfo」というURLを対応づけている．

![RESTfulAPIを用いたリクエスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/RESTfulAPIを用いたリクエスト.png)



## 02. RESTful APIへのリクエスト

### RESTfulにおけるデータの送信方法

#### ・エンドポイントとは

APIにリソースをリクエストするためのURLのこと．エンドポイント は，リソース1つごと，あるいはまとまりごとに割り振られる．

#### ・各送信方法の特徴

| **送信方法** | サーバ側の処理 | 使い分け                    | 特徴 | エンドポイント例                        | パスパラメータ |
| :--------------: | --------------------------------------- | ---------------- | ---------------- | ---------------- | ---------------- |
|     **GET**      |   読み  | DBデータのRead |  | ```http://www.example.co.jp/userInfo/{id}```  | id |
|     **POST**     |     書き     | ・DBのCreate操作<br>・DBのUpdate操作<br>・PDFの作成<br>・画像やPDFの送信<br>・ログイン | 冪等的でない | ```http://www.example.co.jp/userInfo/```     | なし |
|     **PUT**      |   書き    | ・DBのCreate操作<br/>・DBのUpdate操作 | 冪等的である | ```http://www.example.co.jp/userInfo/{id}``` | id |
|    **DELETE**    |    書き    | DBのDelete操作 |  | ```http://www.example.co.jp/userInfo/{id}``` | Id |

#### ・POST送信 vs PUT送信

POST送信とPUT送信の重要な違いについてまとめる．基本的には，POST送信とPUT送信の使い分けは，人によって線引きが異なり，保守性が悪い．基本的には，POST送信を使用すれば問題ない．

|                    | POST送信                                           | PUT送信                                           |
| ------------------ | -------------------------------------------------- | ------------------------------------------------- |
| データ作成の冪等性 | リクエスト1つにつき，1つのデータを作成（非冪等的） | リクエスト数に限らず，1つのデータを作成（冪等的） |
| 更新内容           | リクエストボディに格納（隠蔽可能）                 | パスパラメータに表示（隠蔽不可）                  |



### URLにおけるパスパラメータとクエリパラメータの使い分け（再掲）

パスパラメータはデータをリクエストするために用いる．また，クエリパラメータは，GET送信の時に，データの検索処理／フィルタ処理／ソート処理をリクエストするために用いる．GET送信については，リクエストメッセージの説明を参照せよ．

| 完全修飾ドメイン名             | 送信先のポート番号（```80```の場合は省略可） | ルート         | パスパラメータ | ？      | クエリパラメータ（GET送信時のみ） |
| ------------------------------ | -------------------------------------------- | -------------- | -------------- | ------- | --------------------------------- |
| ```http://www.example.co.jp``` | ```80```                                     | ```userInfo``` | ```{id}```     | ```?``` | ```text1=a&text2=b```             |

**＊具体例＊**

```
http://www.example.co.jp:80/userInfo/777?text1=a&text2=b
```



## 02-02. RESTful APIからのレスポンス

### スキーマ

#### ・スキーマとは

例えば，APIが，以下のようなJSON型データをレスポンスするとする．

```json
{
    "name": "山田太郎",
    "age": 42,
    "hobbies": ["野球", "柔道"]
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
        "hobbies": {
            "type": "array",
            "items": {
                "type": "string"
            }
        }
    },
    "required": ["name"]
}
```



### ステータスコード

#### ・```415``` Unsupported Media Type

※使いどころを要勉強

#### ・```422``` Unprocessable Entity

※使いどころを要勉強



## 03. RESTfulAPIではないAPI



