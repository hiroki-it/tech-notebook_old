# Nginx

## 01. コマンド

### 起動コマンド

#### ・設定ファイルのバリデーション

```bash
nginx -t
```

#### ・設定ファイルの反映と安全な再起動

```bash
kill -s HUP NINGXPID
```



## 02. WebサーバとしてのNginx

### Nginxの仕組み

Webサーバのミドルウェアとして機能する．

![Nginxの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Nginxの仕組み.png)

### 設定ファイル例

**【実装例】**

```nginx
# 実行ユーザ
user nginx;
# プロセス数
worker_processes auto;
pid /var/run/nginx.pid;

events {
    # workerプロセスが同時に処理可能なコネクション最大数
    worker_connections 1024;
}

http {
    #=====================================
    # 情報の非公開
    #=====================================
    # Nginxバージョンの非表示
    server_tokens off;

    #=====================================
    # ログ
    #=====================================
    log_format        main '$remote_addr - $remote_user [$time_local] "$request" '
                           '$status $body_bytes_sent "$http_referer" '
                           '"$http_user_agent" "$http_x_forwarded_for"'; 
    access_log        /var/log/nginx/access.log main;
    error_log         /var/log/nginx/error.log warn;
    
    #=====================================
    # その他
    #===================================== 
    # リクエストのタウムアウト秒数
    keepalive_timeout 65;
    include           /etc/nginx/mime.types;
    
    #=====================================
    # wwwサーバ
    #=====================================
    # リクエストメッセージを受信するサーバ
    server {
        # リクエスト受信ために開放するポート番号
        listen       80;
        # ドメイン名
        server_name  hiroki-it.work;
        # Rootとするディレクトリ
        root         /var/www/tech-notebook/build/html;
        # エントリーポイント
        index        index.html;
        # ページが存在しない場合，index.htmlにレスポンス．index.htmlもなければ，404レスポンス．
        location / {
            try_files $uri $uri/ =404;
        }
    }
}
```



## 02-02. ディレクティブブロック

### ディレクティブブロックとは

Nginxでは，モジュールを読み込むことで，様々な機能を利用できる．ディレクティブブロックは，ディレクティブモジューリを用いて設定することできる．

| ディレクティブブロック |      | ディレクティブモジュール |
| :--------------------: | :--: | :----------------------: |
|  ```events```ブロック  |  ⇄   |  ```events```モジュール  |
|   ```http```ブロック   |  ⇄   |   ```http```モジュール   |
|  ```server```ブロック  |  ⇄   |  ```server```モジュール  |
| ```location```ブロック |  ⇄   | ```location```モジュール |



### ```events```ブロックのディレクティブ

#### ・```worker_connections```ディレクティブ

workerプロセスが同時に処理可能なコネクションの最大数を設定する．

```nginx
events {
    worker_connections 1024;
}
```

### ```server```ブロックのディレクティブ

#### ・```listen```ディレクティブ

ポート```80```で受信．

```nginx
listen 80
```

ポート```443```で受信．

```nginx
listen 443 ssl;
```

#### ・```ssl```ディレクティブ

NginxでHTTPSプロトコルを受信する場合，sslプロトコルを有効にする必要がある．

```nginx
ssl on;
```

#### ・```ssl_certificate```ディレクティブ

PEM証明書のパスを設定する．

```nginx
ssl_certificate /etc/nginx/ssl/server.crt;
```

#### ・```ssl_certificate_key```ディレクティブ

PEM秘密鍵のパスを設定する．

```nginx
ssl_certificate_key /etc/nginx/ssl/server.key;
```



###  ```location```ブロックのディレクティブ

リクエストメッセージのURL内のルートごとに，異なる処理を設定する．

**【実装例】**

```nginx
# 1. ルートが『/』のみの場合．
location = / {

}

# 2. ルートが『/images/』で始まる場合．
location ^~ /images/ {

}

# 3と4. ルートの末尾が、『gif，jpg，jpegの形式』 の場合．
location ~* \.(gif|jpg|jpeg)$ {

}

# 5-1. ルートが『/docs/』で始まる全ての場合．
location /docs/ {

}

# 5-2. ルートが『/』で始まる全ての場合
location / {
    # 『/.aaa.html』を探し，『/.aaa.html/』もなければ，『/index.html』で200レスポンス
    # 全てがない場合，404レスポンス．
    try_files $uri $uri/ /index.html =404;
}
```

ルートの一致条件は，以下の通りである．

| 優先順位 | prefix | ルートの一致条件                         | ルートの具体例                                               |
| :------: | :----: | ---------------------------------------- | ------------------------------------------------------------ |
|    1     |   =    | 指定したルートに一致する場合．           | ```http://example.com/```                                    |
|    2     |   ^~   | 指定したルートで始まる場合．             | ```http://example.com/images/aaa.gif```                      |
|    3     |   ~    | 正規表現（大文字・小文字を区別する）．   | ```http://example.com/images/AAA.jpg```                      |
|    4     |   ~*   | 正規表現（大文字・小文字を区別しない）． | ```http://example.com/images/aaa.jpg```                      |
|    5     |  なし  | 指定したルートで始まる場合．             | ・```http://example.com/aaa.html```<br>・```http://example.com/docs/aaa.html``` |



## 02-03. メインブロック

### メインブロックとは

ディレクティブブロック以外の部分のこと．メインブロックは，メインモジュールを用いて設定することできる．

| ディレクティブブロック |      | ディレクティブモジュール |
| :--------------------: | :--: | :----------------------: |
|   メインブロック   |  ⇄   |   メインモジュール   |



### メインブロックのディレクティブ

#### ・```user```ディレクティブ

本設定ファイルの実行ユーザを設定する．

```nginx
user nginx;
```


#### ・```include```ディレクティブ

他のファイルの設定を読み込む．

```nginx
include /etc/nginx/mime.types;
```

ワイルドカードも可能

```nginx
include /etc/nginx/*.types;
```



## 03. リバースProxyサーバとしてのNginx

ネットワークのノートを参照せよ．