# Nginx

## 01. 概論

### WebサーバのミドルウェアとしてのNginx

![Webサーバ，APサーバ，DBサーバ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Webサーバ，APサーバ，DBサーバ.png)



### コマンド

#### ・起動／停止

```bash
$ systemctl start nginx
$ systemctl stop nginx
```



#### ・設定ファイルのバリデーション

```bash
$ service nginx configtest
```

#### ・設定ファイルの反映と安全な再起動

```bash
$ kill -s HUP NINGXPID
```



## 02-01. ```Main```モジュール

**【実装例】**

```nginx
user                  www www;
worker_processes      5;
error_log             logs/error.log;
pid                   logs/nginx.pid;
worker_rlimit_nofile  8192;
```



### ```user```ディレクティブ 

本設定ファイルの実行ユーザとグループを設定する．

```nginx
user  www www;
```



### ```worker_processes```ディレクティブ 

```nginx
worker_processes  5;
```



### ```error_log```ディレクティブ 

```nginx
error_log  logs/error.log;
```



### ```pid```ディレクティブ 

```nginx
pid  logs/nginx.pid;
```



### ```worker_rlimit_nofile```ディレクティブ 

```nginx
worker_rlimit_nofile  8192;
```



## 02-02. Configurationモジュール

### ```include```ディレクティブ

#### ・mime.typesの読み込み

他のファイルの設定を読み込む．

```nginx
include  /etc/nginx/mime.types;
```

ワイルドカードも可能

```nginx
include  /etc/nginx/*.types;
```

#### ・modulesの読み込み

```nginx
include  /usr/share/nginx/modules/*.conf;
```



## 02-03. Eventsモジュール

### ```events```ブロック

**【実装例】**

```nginx
events {
  worker_connections  1024;
}
```

#### ・```worker_connections```ディレクティブ

workerプロセスが同時に処理可能なコネクションの最大数を設定する．

```nginx
worker_connections  1024;
```



## 02-04. HTTPCoreモジュール

### ```http```ブロック

```nginx
http {
    server_names_hash_bucket_size 128;
    
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log warn;
    
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    default_type application/octet-stream;

    include /etc/nginx/mime.types;
    include /etc/nginx/conf.d/*.conf;
        
    #----- 省略 -----#
}
```



### ```server```ブロック

#### ・WebサーバとしてのNginx

![Nginxの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Nginxの仕組み.png)

**【実装例】**

FastCGIを用いて，APサーバにリクエストを転送し，受信する．

```nginx
#-------------------------------------
# HTTPリクエスト
#-------------------------------------
server {
    listen 80;
    server_name example.com;
    root /var/www/example/public;
    index index.php index.html;

    include /etc/nginx/default/xxx.conf;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    #--------------------------------------
    # FastCGIを用いたAPサーバへの転送，受信
    #--------------------------------------
    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/run/php-fpm/www.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;

        include fastcgi_params;
    }
}
```

#### ・ロードバランサ－として

**【実装例】**

HTTPプロトコルで受信したリクエストを，HTTPSプロトコルに変換して転送する．

```nginx
#-------------------------------------
# HTTPリクエスト
#-------------------------------------
server {
    server_name example.com;
    listen 80;
    return 301 https://$host$request_uri;
}

#-------------------------------------
# HTTPSリクエスト
#-------------------------------------
server {
    server_name example.com;
    listen 443 ssl http2;
    index index.php index.html;

    #-------------------------------------
    # SSL
    #-------------------------------------
    ssl on;
    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;
    add_header Strict-Transport-Security 'max-age=86400';

    location / {
        proxy_pass http://app1;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Port $remote_port;
    }
}
```

#### ・リバースProxyとして

**【実装例】**

前提として，ロードバランサ－から転送されたHTTPリクエストを受信するとする．静的コンテンツのリクエストは，リバースProxy（Nginx）でレスポンスする．Webサーバは，必ずリバースProxyを経由して，動的リクエストを受信する．

```nginx
#-------------------------------------
# HTTPリクエスト
#-------------------------------------
server {
    server_name example.com;
    listen 80;
    return 301 https://$host$request_uri;
    
    #-------------------------------------
    # 静的ファイルであればNginxでレスポンス
    #-------------------------------------
    location ~ ^/(images|javascript|js|css|flash|media|static)/ {
        root root /var/www/example/static;
        expires 30d;
    }

    #-------------------------------------
    # 動的ファイルであればWebサーバに転送
    #-------------------------------------
    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

#### ・```listen```ディレクティブ

開放するポート```80```を設定する．

```nginx
listen 80
```

開放するポート```443```を設定する．

```nginx
listen 443 ssl;
```


#### ・```server_name```ディレクティブ

パブリックIPアドレスに紐づくドメイン名を設定する．

```nginx
server_name hiroki-it.work;
```

パブリックIPアドレスを直接記述してもよい．

```nginx
server_name 192.168.0.0;
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



### ```location```ブロック

リクエストメッセージのURLごとに，異なる処理を設定する．

**【実装例】**

```nginx
# 1. ドキュメントルートを指定したリクエストの場合
location = / {

}

# 2. 『/images/』で始まるリクエストの場合
location ^~ /images/ {

}

# 3と4. 末尾が、『gif，jpg，jpegの形式』 のリクエストの場合
location ~* \.(gif|jpg|jpeg)$ {

}

# 5-1. 『/docs/』で始まる全てのリクエストの場合
location /docs/ {

}

# 5-2. 『/』で始まる全てのリクエストの場合
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



### ```upstream```ブロック

**【実装例】**

```nginx
upstream big_server_com {
    server 127.0.0.3:8000 weight=5;
    server 127.0.0.3:8001 weight=5;
    server 192.168.0.1:8000;
    server 192.168.0.1:8001;
}
```
