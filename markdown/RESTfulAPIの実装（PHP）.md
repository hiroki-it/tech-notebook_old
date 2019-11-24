<!-- TOC -->

- [01-01. RESTful設計のAPIに必要な実装](#01-01-restful設計のapiに必要な実装)
    - [◆ 送信方法](#◆-送信方法)
- [02-01. フロントエンドとサーバサイドの間のRESTful API](#02-01-フロントエンドとサーバサイドの間のrestful-api)
    - [◆ SilexフレームワークによるAPI](#◆-silexフレームワークによるapi)
- [03-01. 異なるアプリケーション間のRESTful API](#03-01-異なるアプリケーション間のrestful-api)

<!-- /TOC -->
## 01-01. RESTful設計のAPIに必要な実装

### ◆ 送信方法

| **主な送信方法** | 対応するリクエスト | パス例        |
| :--------------: | ------------------ | ------------- |
|     **GET**      | データの取得       | /example/{id} |
|     **POST**     | データの新規作成   | /example      |
|     **PUT**      | データの更新       | /example/{id} |
|    **DELETE**    | データの削除       | /example/{id} |



## 02-01. フロントエンドとサーバサイドの間のRESTful API

### ◆ SilexフレームワークによるAPI

Silexフレームワークの```Application```クラスや```Route```クラスには、RESTful設計を実装するためのメソッドが用意されている。

```PHP
namespace Silex;

class Application extends Container implements HttpKernelInterface, TerminableInterface
{
  /**
  * @param string $pattern Matched route pattern
  * @param mixed  $to      Callback that returns the response when matched
  *
  * @return Controller
  */
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
  /**
  * @param string $method The HTTP method name.Multiple methods can be
  * supplied, delimited by a pipe character '|', eg. 'GET|POST'
  *
  * @return Route $this The current Route instance
  */
  public function method($method)
  {
    $this->setMethods(explode('|', $method));
    return $this;
  }
}
```



## 03-01. 異なるアプリケーション間のRESTful API

