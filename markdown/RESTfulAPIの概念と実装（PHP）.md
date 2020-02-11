# 目次

<!-- TOC -->

- [01-01. RESTful設計とWeb API](#01-01-restful設計とweb-api)
    - [:pushpin: REST](#pushpin-rest)
    - [:pushpin: RESTful API へのリクエスト](#pushpin-restful-api-へのリクエスト)
    - [:pushpin: RESTful APIからのレスポンス](#pushpin-restful-apiからのレスポンス)
- [02-01. フロントエンドとサーバサイドの間のRESTful API](#02-01-フロントエンドとサーバサイドの間のrestful-api)
    - [:pushpin: SilexフレームワークによるRESTful API](#pushpin-silexフレームワークによるrestful-api)
- [03-01. 異なるアプリケーション間のRESTful API](#03-01-異なるアプリケーション間のrestful-api)

<!-- /TOC -->

## 01-01. RESTful設計とWeb API

### :pushpin: REST

分散型システムにおける複数のソフトウェアを連携させるのに適したアーキテクチャスタイルをRESTという．また，アーキテクチャスタイルについては，オブジェクト指向分析・設計のノートを参照せよ．RESTは，以下の特徴を持つ．

- **Addressability**
- **Stateless**
- **Connectability**
- **Uniform Interface**



### :pushpin: RESTful API へのリクエスト

- **RESTful APIとは**

RESTに基づいた設計をRESTfulという．RESTful設計が用いられたWebAPIをRESTful APIという．例えば，RESTful APIの場合，DBにおけるUserInfoのCRUDに対して，一つの「/UserInfo」というURLを対応づけている．

- **URLにおけるパスパラメータとクエリパラメータの使い分け（再掲）**

パスパラメータはデータをリクエストするために用いる．また，クエリパラメータは，GET送信の時に，データの検索処理／フィルタ処理／ソート処理をリクエストするために用いる．GET送信については，リクエストメッセージの説明を参照せよ．

| 完全修飾ドメイン名             | ルート         | パスパラメータ | ？      | クエリパラメータ（GET送信時のみ） |
| ------------------------------ | -------------- | -------------- | ------- | --------------------------------- |
| ```http://www.example.co.jp``` | ```userInfo``` | ```{id}```     | ```?``` | ```text1=a&text2=b```             |

**【URLの具体例】**

```
http://www.example.co.jp/userInfo/777?text1=a&text2=b
```

- **エンドポイント**

APIにリソースをリクエストするためのURLのこと．エンドポイント は，リソース1つごと，あるいはまとまりごとに割り振られる．

![RESTfulAPIを用いたリクエスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/RESTfulAPIを用いたリクエスト.png)

| **送信方法** | 分類 | 使い分け                    | エンドポイント例                        | パスパラメータ | JSONデータ型 |
| :--------------: | --------------------------------------- | ---------------- | ---------------- | ---------------- | ---------------- |
|     **GET**      |   読み  | DBデータのRead | ```http://www.example.co.jp/userInfo/{id}```  | id | ```number``` |
|     **POST**     |     書き     | ・DBのCreate操作<br>・PDFの作成<br>・画像やPDFの送信<br>・ログイン | ```http://www.example.co.jp/userInfo/```     | なし | なし |
|     **PUT**      |   書き    | DBのUpdate操作 | ```http://www.example.co.jp/userInfo/{id}``` | id | ```number``` |
|    **DELETE**    |    書き    | DBのDelete操作 | ```http://www.example.co.jp/userInfo/{id}``` | Id | ```number``` |



### :pushpin: RESTful APIからのレスポンス

- **スキーマ**

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




## 02-01. フロントエンドとサーバサイドの間のRESTful API

### :pushpin: SilexフレームワークによるRESTful API

Silexフレームワークの```Application```クラスや```Route```クラスには，RESTful APIを実装するためのメソッドが用意されている．

```PHP
namespace Silex;

class Application extends Container implements HttpKernelInterface, TerminableInterface
{
  public function match($pattern, $to = null)
  {
    return $this['controllers']->match($pattern, $to);
  }
}
```

```PHP
namespace Silex;

class Route extends BaseRoute
{
  public function method($method)
  {
    $this->setMethods(explode('|', $method));
    return $this;
  }
}
```



## 03-01. 異なるアプリケーション間のRESTful API

