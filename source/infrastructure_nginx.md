# Nginx

### 01. WebサーバとしてのNginx

#### ・Nginxの仕組み

Webサーバのミドルウェアとして機能する．

![Nginxの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Nginxの仕組み.png)

#### ・実装方法

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
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    # リクエストのタウムアウト秒数
    keepalive_timeout 65;
    
    # リクエストメッセージを受信するサーバ
    server {
        # リクエスト受信ために開放するポート番号
        listen       80;
        # ドメイン名
        server_name  hiroki-it.work;
        # Rootとするディレクトリ
        root         /var/www/source;
        # エントリーポイント
        index        index.html index.htm;
        # リクエストメッセージの処理条件
        location / {
        
        }
    }
}
```

#### ・```location```ブロック

リクエストメッセージのURL内のルートごとに，異なる設定を適用できる．

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

| 優先順位 | prefix | ルートの一致条件                         | ルートの具体例 |
| :------: | :----: | ---------------------------------------- | ----------------------- |
|    1     |   =    | 指定したルートに一致する場合．           | ```http://example.com/``` |
|    2     |   ^~   | 指定したルートで始まる場合．             | ```http://example.com/images/aaa.gif``` |
|    3     |   ~    | 正規表現（大文字・小文字を区別する）．   | ```http://example.com/images/AAA.jpg``` |
|    4     |   ~*   | 正規表現（大文字・小文字を区別しない）． | ```http://example.com/images/aaa.jpg``` |
|    5     |  なし  | 指定したルートで始まる場合．             | ・```http://example.com/aaa.html```<br>・```http://example.com/docs/aaa.html``` |

### 02. リバースProxyサーバとしてのNginx

ネットワークのノートを参照せよ．