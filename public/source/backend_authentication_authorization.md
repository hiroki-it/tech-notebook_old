# 認証と認可

## 01. Basic認証

## 01-02. セッション認証

## 01-03. Digest認証



## 02. アクセストークンを用いた認証と認可

### 認証／認可とは

1. クライアント側が，HTTPリクエストにIDとパスワードを設定してリクエスト．
2. アイデンティティプロバイダー（IdP）がIDを『認証』し，クライアント側にアクセストークンを発行．
3. クライアント側が，HTTPリクエストのヘッダーにアクセストークンを設定してリクエスト．
4. アクセストークンが『認可』されれば，API側がデータをレスポンスする．

![アクセストークンを用いたセキュリティ仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/アクセストークンを用いたセキュリティの仕組み.jpg)

### Json Web Token：JWT

#### ・仕組み

最もよく使われているAPIのアクセスとして，JSONをベースとしたアクセストークンを用いるJWTがある．

![JWT](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/JWT.png)