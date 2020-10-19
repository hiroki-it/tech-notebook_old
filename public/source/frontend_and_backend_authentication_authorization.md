# 認証と認可

## 01. 認証スキーム（認証方式）

### Basic認証スキーム

#### ・Basic認証スキームとは

![Basic認証](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Basic認証.png)


| 役割         | 説明                                                         |
| ------------ | ------------------------------------------------------------ |
| クライアント | ユーザ側のアプリケーションのこと．                           |
| ユーザ       | クライアントアプリケーションを使用している人のこと．         |
| サーバ       | クライアントアプリケーションからリクエストを受信し，レスポンスを送信するアプリケーションのこと． |

1. 最初，クライアントは，認証後にアクセスできるページのリクエストをサーバに送信する．
2. サーバは，これ拒否し，```401```ステータスで認証領域を設定し，レスポンスを送信する．

```http
# レスポンスヘッダーについて，詳しくは以降の説明を参照せよ．
WWW-Authenticate: Basic realm="Server Name", charaset="UTF-8"
```

3. クライアントは，認証領域の値をユーザに示して，ユーザ名とパスワードの入力を求める．そして，これをエンコードし，リクエストを送信する．

```http
# リクエストヘッダーについて，詳しくは以降の説明を参照せよ．
Authorization: Basic bG9naW46cGFzc3dvcmQ=
```

4. サーバは，ユーザ名とパスワードを照合し，合致していれば，認証後ページのレスポンスを送信する．


#### ・認証と認可に用いられるHTTPヘッダー

リクエスト時，クライアントはAuthorizationヘッダーでBasicスキームを宣言し，Base64でエンコードされた「```<ユーザ名>:<パスワード>```」を設定する．サーバは，これを照合し，クライアントの認証を行う．Basicスキームの宣言と文字列の間には，半角スペースが必要である．ユーザに表示するための認証領域には，任意の値を持たせることができ，サイト名が設定されることが多い．

```http
# レスポンスヘッダー
WWW-Authenticate: Basic realm="<認証領域>", charaset="UTF-8"
```


```http
# リクエストヘッダー
Authorization: Basic <ユーザ名>:<パスワード>
```




### Digest認証スキーム

#### ・Digest認証スキームとは

#### ・認証と認可に用いられるHTTPヘッダー

```http
# レスポンスヘッダー
WWW-Authenticate: Basic realm="<認証領域>", charaset="UTF-8"
```

```http
# リクエストヘッダー
Authorization: Digest realm="<認証領域>" nonce="<サーバ側が生成した任意の文字列>" algorithm="<ハッシュ関数名>" qoq="auth"
```



### Bearer認証スキーム

#### ・Bearer認証スキームとは

Bearerトークンを使用した認証に用いる．

#### ・認証と認可に用いられるHTTPヘッダー

```http
# レスポンスヘッダー
WWW-Authenticate: Bearer realm="<認証領域>", charaset="UTF-8"
```

```http
# リクエストヘッダー
Authorization: Bearer <Bearerトークン，JWT，など>
```



## 02. 認可

### 認証と認可の違い

![アクセストークンを用いたセキュリティ仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/アクセストークンを用いたセキュリティの仕組み.jpg)

1. クライアント側が，HTTPリクエストにIDとパスワードを設定してリクエスト．
2. IdP：Identity Providerが，IDを『認証』し，クライアント側にアクセストークンを発行．
3. クライアント側が，HTTPリクエストのヘッダーにアクセストークンを設定してリクエスト．
4. アクセストークンが『認可』されれば，API側がデータをレスポンスする．

| 役割              | 説明                                                         | 具体例                                    |
| ----------------- | ------------------------------------------------------------ | ----------------------------------------- |
| Identity Provider | トークンを生成するサーバのこと．                             | Ouath認証の仕組みにおける認可サーバ．     |
| APIクライアント   | APIに対して，リクエストを送信したいサーバのこと．            | Ouath認証の仕組みにおけるクライアント．   |
| APIサーバ         | クライアントに対して，リソースのレスポンスを送信するサーバのこと． | Ouath認証の仕組みにおけるリソースサーバ． |



### Oauthプロトコル

#### ・Oauthプロトコル，Oauth認証とは

![Oauthの具体例](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Oauthの具体例.png)

認可で用いられるプロトコル．Oauthプロトコルによる認可を用いた認証認可フロー全体を，『Oauth認証』と呼ぶことに注意する．Oauthプロトコル```2.0```では，仕組みの中に，４つの役割が定義されている．

| 役割             | 説明                                                         | 具体例                                                       |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| クライアント     | リソースオーナに対するアクション機能を持つサーバのこと．     | 例えば，Facebookアカウントは，連携する他アプリケーションへのログインアクション機能を持っている． |
| リソースオーナー | クライアントを使用しているユーザのこと．                     | 例えば，Googleアカウントと他アプリケーションの連携時に，連携OKのボタンを押す． |
| 認可サーバ       | リソースサーバがリソースオーナーにアクセスできるトークンを生成するサーバのこと． | アクセストークンの種類については，以降の説明を参照せよ．     |
| リソースサーバ   | クライアントのアカウント情報を持っているサーバのこと．       | 例えば，Facebookから連携できるInstagram．                    |

#### ・使用される認証スキーム

Oauth認証では，Bear認証スキームが用いられることが多いが，AWSやGitHubは，独自の認証スキームを使用している．アクセストークンとしては，BearerトークンやJWTが用いられる．

```http
# レスポンスヘッダー
WWW-Authenticate: Bearer realm="<認証領域>", charaset="UTF-8"
```

```http
# リクエストヘッダー
Authorization: Bearer <Bearerトークン，JWT，など>
```



### OpenID Connect

#### ・OpenID Connectとは

要勉強．

#### ・使用される認証スキーム

要勉強



## 02-02. アクセストークンの種類

### Bearerトークン

#### ・Bearerトークンとは

単なる文字列で定義されたアクセストークン．認証と認可において，実際に認証された本人かどうかを判定する機能は無く，トークンを持っていれば，それを本人と見なす．そのため，トークンの文字列が流出してしまわないよう，厳重に管理する必要がある．

#### ・認証と認可に用いられるHTTPヘッダー

リクエスト時，Authorizationヘッダーで，Bearerスキームを宣言し，Bearerトークンの文字列を設定する．Bearerの宣言と文字列の間には，半角スペースが必要である．ユーザに表示するための認証領域には，任意の値を持たせることができ，サイト名が設定されることが多い．

```http
# レスポンスヘッダー
WWW-Authenticate: Bearer realm="<認証領域>", charaset="UTF-8"
```
```http
# リクエストヘッダー
Authorization: Bearer <Bearerトークンの文字列>
```



### JWT：JSON Web Token

#### ・JWTとは

JSON型で実装されたアクセストークン．Oauth認証のアクセストークンとして使用されることもある．

#### ・JWTの構造

JWTは，エンコードされたヘッダー，ペイロード，署名，から構成される．

**＊実装例＊**

```javascript
// JWTの構造
const token = base64urlEncoding(header) + '.' +
      base64urlEncoding(payload) + '.' +
      base64urlEncoding(signature)
```

```javascript
// ヘッダーの構造
const header = {
    "alg" : "HS256", // 署名アルゴリズムを宣言．他にRS256がある．
    "typ" : "JWT"    // JWTの使用を宣言．
}
```

```javascript
// ペイロードの構造
const payload = {
    "sub" : "例えばユーザID",
}
```

```js
// 署名の構造
const signature = HMACSHA256(
    base64urlEncoding(header) + '.' + base64urlEncoding(payload),
    secret
)
```

#### ・認証と認可に用いられるHTTPヘッダー

リクエスト時，Authorizationヘッダーで，Bearerスキームを宣言し，JWTの文字列を設定する．Bearerスキームの宣言と文字列の間には，半角スペースが必要である．ユーザに表示するための認証領域には，任意の値を持たせることができ，サイト名が設定されることが多い．

```http
# リクエストヘッダー
Authorization: Bearer <JWTの文字列>
```

```http
# レスポンスヘッダー
WWW-Authenticate: Bearer realm="<認証領域>", charaset="UTF-8"
```

#### ・JWTを用いた認証と認可

![JWT](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/JWT.png)