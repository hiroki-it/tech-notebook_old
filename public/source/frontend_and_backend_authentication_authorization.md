# Authenticate（認証）とAuthorization（認可）

## 01. HTTP認証

### HTTP認証

#### ・HTTP認証とは

ログイン時にHTTP通信の中で認証を行うこと．リクエストヘッダーとレスポンスヘッダーにおいて，認証方法としての認証スキームを選べる．認証スキームの種類には，「Basic認証」，「Digest認証」，「Bearer認証」などがある．

<br>

### Basic認証

#### ・Basic認証とは

![Basic認証](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Basic認証.png)


| 役割         | 説明                                                         |
| ------------ | ------------------------------------------------------------ |
| クライアント | ユーザ側のアプリケーションのこと．                           |
| ユーザ       | クライアントアプリケーションを使用している人のこと．         |
| サーバ       | クライアントアプリケーションからリクエストを受信し，レスポンスを送信するアプリケーションのこと． |

1. 最初，クライアントは，認証後にアクセスできるページのリクエストをサーバに送信する．
2. サーバは，これ拒否し，```401```ステータスで認証領域を設定し，レスポンスを送信する．

```http
# レスポンスヘッダーについて，詳しくは，以降の説明を参照せよ．
WWW-Authenticate: Basic realm="Server Name", charaset="UTF-8"
```

3. クライアントは，認証領域の値をユーザに示して，ユーザ名とパスワードの入力を求める．そして，これをエンコードし，リクエストを送信する．

```http
# リクエストヘッダーについて，詳しくは，以降の説明を参照せよ．
authorization: Basic bG9naW46cGFzc3dvcmQ=
```

4. サーバは，ユーザ名とパスワードを照合し，合致していれば，認証後ページのレスポンスを送信する．


#### ・照合情報の送信方法

リクエスト時，クライアントはAuthorizationヘッダーでBasic認証を宣言し，Base64でエンコードされた「```<ユーザ名>:<パスワード>```」を設定する．サーバは，これを照合し，クライアントの認証を行う．Basic認証の宣言と文字列の間には，半角スペースが必要である．ユーザに表示するための認証領域には，任意の値を持たせることができ，サイト名が設定されることが多い．

```http
# レスポンスヘッダー
WWW-Authenticate: Basic realm="<認証領域>", charaset="UTF-8"
```


```http
# リクエストヘッダー
authorization: Basic <ユーザ名>:<パスワード>
```

<br>


### Digest認証

#### ・Digest認証とは

#### ・照合情報の送信方法

```http
# レスポンスヘッダー
WWW-Authenticate: Basic realm="<認証領域>", charaset="UTF-8"
```

```http
# リクエストヘッダー
authorization: Digest realm="<認証領域>" nonce="<サーバ側が生成した任意の文字列>" algorithm="<ハッシュ関数名>" qoq="auth"
```

<br>

### Bearer認証

#### ・Bearer認証とは

ログイン時にBearerトークンを使用する認証スキームのこと．アクセストークンの種類については，後述の説明を参照せよ．

#### ・照合情報の送信方法

発行されたBearerトークンは，WWW-Authenticateヘッダーに割り当てられて返信される．

```http
# レスポンスヘッダー
WWW-Authenticate: Bearer realm="<認証領域>", charaset="UTF-8"
```

これを，Authorizationヘッダー，リクエストボディ，クエリパラメータのいずれかに割り当てて送信する．

```http
# リクエストヘッダー
authorization: Bearer <Bearerトークン，JWT，など>
```

<br>

### Oauth認証

#### ・Oauth認証とは

後述の説明を参考にせよ．

<br>

## 01-02. HTTP認証以外の認証方法

### Form認証

#### ・Form認証とは

ログイン時にセッションを使用する認証方法のこと．認証スキームには属していない．認証方法以外のセッションの仕様については，以下のノートを参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/backend_api_restful.html

#### ・Form認証の仕組み

1. 最初，ユーザ作成の段階で，クライアントがログイン情報をサーバに送信する．
2. サーバは，ログイン情報をデータベースに保存する．
3. 次回のログイン時に，再びユーザがログイン情報を送信する．
4. サーバは，データベースのログイン情報を照合し，ログインを許可する．
5. サーバは，セッションIDを生成する．また，レスポンスのSet-Cookieヘッダーを使用して，セッションIDをクライアントに送信する．

```http
# レスポンスヘッダーの場合
Set-Cookie: sessionId=<セッションID>
```

6. サーバは，セッションIDとユーザIDを紐づけてサーバ内に保存する．
7. さらに次回のログイン時，クライアントは，リクエストのCookieヘッダーを使用して，セッションIDをクライアントに送信する．サーバは，保存されたセッションIDに紐づくユーザIDから，ユーザを特定し，ログインを許可する．これにより，改めてログイン情報を送信せずに，素早くログインできるようになる．

```http
# リクエストヘッダーの場合
cookie: PHPSESSID=<セッションID>; csrftoken=u32t4o3tb3gg43; _gat=1
```

<br>

### APIキー認証

#### ・APIキー認証とは

事前にAPIキーとなる文字列を配布し，認証フェースは行わずに認可フェーズのみでクライアントを照合する方法のこと．API GatewayにおけるAPIキー認証については，以下を参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/infrastructure_cloud_computing_aws.html

#### ・照合情報の送信方法

独自ヘッダーとして，x-api-keyを定義し，これに割り当てて送信する．リクエストヘッダへのパラメータの割り当てについては，以下を参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/backend_api_restful.html

```http
# リクエストヘッダー
x-api-key: XXXXX（キー）
```

<br>

## 01-03. 複数の認証の組み合わせ

### Two Step Verification（二段階認証）

#### ・Two Step Verificationとは

ログイン時に段階的に二つの認証方法を設定し，クライアントを照合する方法のこと．

| 一段階目の認証例 | 二段階目の認証例 | 説明                                                         | 備考                                         |
| ---------------- | ---------------- | ------------------------------------------------------------ | -------------------------------------------- |
| IDとパスワード   | IDとパスワード   | IDとパスワードによる認証方法の後，別のIDとパスワードによる認証方法を設定する． |                                              |
|                  | 秘密の質問       | IDとパスワードによる認証方法の後，質問に対してあらかじめ設定した回答による認証方法を設定する． |                                              |
|                  | SMS              | IDとパスワードによる認証方法の後，SMS宛に送信した認証コードによる認証方法を設定する． | 異なる要素のため，これは二要素認証でもある． |
|                  | 指紋             | IDとパスワードによる認証方法の後，指紋の解析結果による認証方法を設定する． | 異なる要素のため，これは二要素認証でもある． |

<br>

### Two Factor Authorization（二要素認証）

#### ・Two Factor Authorizationとは

二段階認証のうちで特に，ログイン時に異なる要素の認証方法を使用して，段階的にクライアントを照合すること方法のこと．後述するOauth認証を組み込んでも良い．

| 一要素目の認証例       | 二要素目の認証例                                             |
| ---------------------- | ------------------------------------------------------------ |
| IDとパスワード（知識） | 事前登録された電話番号のSMSで受信したワンタイムパスワード（所持） |
|                        | 事前登録された電話番号のSMSで受信した認証コード（所持）      |
|                        | Oauth認証（所持）                                            |
|                        | 指紋（生体）                                                 |
| 暗証番号（知識）       | キャッシュカード（所持）                                     |

<br>

## 02. 認可フェーズ

### 認証フェーズと認可フェーズの違い

![アクセストークンを用いたセキュリティ仕組み](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/アクセストークンを用いたセキュリティの仕組み.jpg)

認証フェーズと認可フェーズでは，仕組みの中に，３つの役割が定義されている．

1. クライアントが，HTTPリクエストにIDとパスワードを設定してリクエスト．
2. IdP：Identity Providerが，IDを『認証』し，クライアント側にアクセストークンを発行．
3. クライアントが，HTTPリクエストのヘッダーにアクセストークンを設定してリクエスト．
4. アクセストークンが『認可』されれば，API側がデータをレスポンスする．

| 役割              | 説明                                                         | 具体例                                    |
| ----------------- | ------------------------------------------------------------ | ----------------------------------------- |
| Identity Provider | トークンを生成するサーバのこと．                             | Ouath認証の仕組みにおける認可サーバ．     |
| APIクライアント   | APIに対して，リクエストを送信したいサーバのこと．            | Ouath認証の仕組みにおけるクライアント．   |
| APIサーバ         | クライアントに対して，リソースのレスポンスを送信するサーバのこと． | Ouath認証の仕組みにおけるリソースサーバ． |

<br>

### Oauthプロトコル

#### ・Oauthプロトコル，Oauth認証とは

![Oauthの具体例](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Oauthの具体例.png)

認証認可フェーズ全体の中で，認可フェーズにOauthプロトコルを用いたクライアントの照合方法を『Oauth認証』と呼ぶ．認証フェーズと認可フェーズでは，３つの役割が定義されていることを説明したが，Oauthプロトコル```2.0```では，より具体的に４つの役割が定義されている．

| 役割                                  | 説明                                                         | 具体例                                                       |
| ------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| クライアントアプリ（APIクライアント） | リソースオーナに対するアクション機能を持つサーバのこと．     | 例えば，Facebookアカウントは，連携する他アプリケーションへのログインアクション機能を持っている． |
| リソースオーナー                      | クライアントを使用しているユーザのこと．                     | 例えば，Googleアカウントと他アプリケーションの連携時に，連携OKのボタンを押す． |
| 認可サーバ（Identity Provider）       | リソースサーバがリソースオーナーにアクセスできるトークンを生成するサーバのこと． | アクセストークンの種類については，後述の説明を参照せよ．なお，Oauth認証では認証スキーマとしてBearer認証が選ばれる傾向にあるため，認可サーバがBearerトークンを発行するように実装することが多い． |
| リソースサーバ（APIサーバ）           | クライアントのアカウント情報を持っているサーバのこと．       | 例えば，Facebookから連携できるInstagram．                    |

#### ・使用される認証スキーム

Oauth認証では，認証スキーマとしてBearer認証が選ばれることが多いが，AWSやGitHubは，独自の認証スキームを使用している．アクセストークンとしては，BearerトークンやJWTが用いられる．なお，認可サーバによって発行されたBearerトークンは，Authorizationヘッダー，リクエストボディ，クエリパラメータのいずれかに割り当てて送信できる．

```http
# レスポンスヘッダー
WWW-Authenticate: Bearer realm="<認証領域>", charaset="UTF-8"
```

```http
# リクエストヘッダー
authorization: Bearer <Bearerトークン，JWT，など>
```

#### ・付与タイプ

Oauth認証のトークンの付与方法には種類がある．

参考：https://oauth.net/2/grant-types/

| 付与タイプ名             | 説明                                                         | 使用例                          |
| ------------------------ | ------------------------------------------------------------ | ------------------------------- |
| Authorization Code Grant | アプリケーションが他のAPIにアクセスする場合に使用する．推奨されている．<br>参考：https://oauth.net/2/grant-types/authorization-code/ | 他のSNSアプリとのアカウント連携 |
| Client Credentials Grant | 推奨されている．<br/>参考：https://oauth.net/2/grant-types/client-credentials/ |                                 |
| Device Code              | 推奨されている．<br/>参考：https://oauth.net/2/grant-types/device-code/ |                                 |
| Implicit Grant           | 非推奨されている．<br/>参考：https://oauth.net/2/grant-types/implicit/ |                                 |
| Password Grant           | ユーザ名とパスワードを元に，トークンを付与する．非推奨されている．<br>参考：<br>・https://oauth.net/2/grant-types/password/<br>・https://developer.okta.com/blog/2018/06/29/what-is-the-oauth2-password-grant#the-oauth-20-password-grant |                                 |

<br>

### Personal Access Token

#### ・Personal Access Tokenとは

Personal Access Token（個人用アクセストークン）を使用する認証方法．Oauth認証では，認可フェーズ時にクライアントアプリがアクセストークンの付与を認可サーバにリクエストし，認証時にこれを送信してくれる．しかし，Personal Access Tokenでは，ユーザがアクセストークンの付与をリクエストし，また開示されたアクセストークンを送信する必要がある．作成時以降，アクセストークンを確認できなくなるため，ユーザがアクセストークンを管理する必要がある．

参考：https://www.contentful.com/help/personal-access-tokens/

| サービス例 | トークン名            | 説明                                                         |
| ---------- | --------------------- | ------------------------------------------------------------ |
| GitHub     | Personal access Token | HTTPSを使用して，プライベートリポジトリにリクエストを送信するために必要．HTTPSを使用する場面として，アプリの拡張機能のGitHub連携，リポジトリのライブラリ化，などがある．<br>参考：https://docs.github.com/ja/github/authenticating-to-github/creating-a-personal-access-token |

<br>

### OpenID Connect

#### ・OpenID Connectとは

要勉強．

#### ・使用される認証スキーム

要勉強

<br>

## 02-02. アクセストークンの種類

### Bearerトークン

#### ・Bearerトークンとは

単なる文字列で定義されたアクセストークン．認証フェーズと認可フェーズにおいて，実際に認証された本人かどうかを判定する機能は無く，トークンを持っていれば，それを本人と見なす．そのため，トークンの文字列が流出してしまわないよう，厳重に管理する必要がある．

#### ・照合情報の送信方法

リクエスト時，Authorizationヘッダーで，Bearer認証を宣言し，Bearerトークンの文字列を設定する．Bearerの宣言と文字列の間には，半角スペースが必要である．ユーザに表示するための認証領域には，任意の値を持たせることができ，サイト名が設定されることが多い．

```http
# レスポンスヘッダー
WWW-Authenticate: Bearer realm="<認証領域>", charaset="UTF-8"
```
```http
# リクエストヘッダー
authorization: Bearer <Bearerトークンの文字列>
```

<br>

### JWT：JSON Web Token

#### ・JWTとは

JSON型で実装されたアクセストークン．Oauth認証のアクセストークンとして使用されることもある．

#### ・JWTの構造

**＊実装例＊**

JWTは，エンコードされたヘッダー，ペイロード，署名，から構成される．

```javascript
const token = base64urlEncoding(header) + "." +
      base64urlEncoding(payload) + "." +
      base64urlEncoding(signature)
```

ここで，ヘッダーは以下の構造からなる．署名のための暗号化アルゴリズムは，「```HS256```」「```RS256```」「```ES256```」「```none```」から選択できる．

```javascript
const header = {
    "typ" : "JWT"    // JWTの使用
    "alg" : "HS256", // 署名のための暗号化アルゴリズム
}
```

ここで，ペイロードは以下の構造からなる．ペイロードには，実際に送信したいJSONを設定するようにする．必ず設定しなければならない「予約済みクレーム」と，ユーザ側が自由に定義できる「プライベートクレーム」がある．

| 予約済みクレーム名         | 役割                      | 例       |
| -------------------------- | ------------------------- | -------- |
| ```sub```：Subject         | 一意な識別子を設定する．  | ユーザID |
| ```iss```：Issuer          |                           |          |
| ```aud```：Audience        |                           |          |
| ```exp```：Expiration Time | JWTの有効期限を設定する． |          |
| ```jti```：JWT ID          |                           |          |

```javascript
const payload = {
    "sub" : "123456789",
}
```

ここで，署名は以下の構造からなる．

```javascript
const signature = HMACSHA256(
    base64urlEncoding(header) + "." + base64urlEncoding(payload),
    secret
)
```

#### ・照合情報の送信方法

リクエスト時，Authorizationヘッダーで，Bearer認証を宣言し，JWTの文字列を設定する．Bearer認証の宣言と文字列の間には，半角スペースが必要である．ユーザに表示するための認証領域には，任意の値を持たせることができ，サイト名が設定されることが多い．

```http
# リクエストヘッダー
authorization: Bearer <JWTの文字列>
```

```http
# レスポンスヘッダー
WWW-Authenticate: Bearer realm="<認証領域>", charaset="UTF-8"
```

#### ・JWTを用いた認証フェーズと認可フェーズ

![JWT](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/JWT.png)