# 目次

<!-- TOC -->

- [01-01. RESTful設計とWeb API](#01-01-restful設計とweb-api)
    - [:pushpin: REST](#pushpin-rest)
    - [:pushpin: RESTful API](#pushpin-restful-api)
- [02-01. フロントエンドとサーバサイドの間のRESTful API](#02-01-フロントエンドとサーバサイドの間のrestful-api)
    - [:pushpin: SilexフレームワークによるRESTful API](#pushpin-silexフレームワークによるrestful-api)
- [03-01. 異なるアプリケーション間のRESTful API](#03-01-異なるアプリケーション間のrestful-api)

<!-- /TOC -->

## 01-01. RESTful設計とWeb API

### :pushpin: REST

分散型システムにおける複数のソフトウェアを連携させるのに適したアーキテクチャスタイルをRESTという。また、アーキテクチャスタイルについては、オブジェクト指向分析・設計のノートを参照せよ。RESTは、以下の特徴を持つ。

- **Addressability**
- **Stateless**
- **Connectability**
- **Uniform Interface**



### :pushpin: RESTful API

RESTに基づいた設計をRESTfulという。RESTful設計が用いられたWebAPIをRESTful APIという。例えば、RESTful APIの場合、DBにおけるUserInfoのCRUDに対して、一つの「/UserInfo」というURLを対応づけている。

![RESTfulAPIを用いたリクエスト](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/markdown/image/RESTfulAPIを用いたリクエスト.png)

| **送信方法** | 使い分け                    | エンドポイント例                        | パラメータ | JSONデータ型 |
| :--------------: | --------------------------------------- | ---------------- | ---------------- | ---------------- |
|     **GET**      | DBデータのRead | http://www.example.co.jp/userInfo/{id}  | id | ```number``` |
|     **POST**     | DBデータのCreate、PDFの作成、画像やPDFの送信、ログインなど | http://www.example.co.jp/userInfo/     | なし | なし |
|     **PUT**      | DBデータのUpdate | http://www.example.co.jp/userInfo/{id} | id | ```number``` |
|    **DELETE**    | DBデータのDelete | http://www.example.co.jp/userInfo/{id} | Id | ```number``` |




## 02-01. フロントエンドとサーバサイドの間のRESTful API

### :pushpin: SilexフレームワークによるRESTful API

Silexフレームワークの```Application```クラスや```Route```クラスには、RESTful APIを実装するためのメソッドが用意されている。

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

