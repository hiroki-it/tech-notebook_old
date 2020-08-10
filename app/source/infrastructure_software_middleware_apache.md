# Apache


## 01. コマンド

#### 起動コマンド

#### ・設定ファイルのバリデーション

```bash
$ systemctl httpd configtest
```

#### ・強制的な再起動

```bash
$ systemctl httpd restart
```

#### ・安全な再起動

```bash
$ systemctl httpd graceful
```



## 02. Coreにおける設定ディレクティブ

### VirtualHost

#### ・VirtualHostとは

ディレクティブを囲うディレクティブの一つ．特定のホスト名やIPアドレスにリクエストがあった時に実行するディレクティブを定義する．VirtualHostという名前の通り，1 つのサーバ上で，仮想的に複数のドメインを扱うような処理も定義できる．複数のVirtualHostを設定した場合，一つ目がデフォルト設定として認識される．

```apacheconf
Listen 80
NameVirtualHost *:80

# Defaultサーバとして扱う．
<VirtualHost *:80>
    DocumentRoot /www/example1
    ServerName www.example.com
</VirtualHost>

<VirtualHost *:80>
    DocumentRoot /www/example2
    ServerName www.example.org
</VirtualHost>
```
#### ・IPベースVirtualHost

各ドメインに異なるIPアドレスを割り振るバーチャルホスト．

#### ・名前ベースVirtualHost
全てのドメインに同じIPアドレスを割り振るバーチャルホスト．



### DocumentRoot

#### ・DocumentRootとは

ドキュメントのルートディレクトリを指定する．ドキュメントルートに「index.html」というファイルを置くと，ファイル名を指定しなくとも，ルートディレクトリ内のindex.htmlが，エントリーポイントとして自動的に認識されて表示される．

```apacheconf
<VirtualHost *:80>
    DocumentRoot /www/example1
    ServerName www.example.com
</VirtualHost>
```

index.html以外の名前をエントリーポイントにする場合，ファイル名を指定する必要がある．

```apacheconf
<VirtualHost *:80>
    DocumentRoot /www/example1/start-up.html
    ServerName www.example.com
</VirtualHost>
```



### Directory

#### ・Directoryとは

ディレクティブを囲うディレクティブの一つ．指定したディレクトリ内にリクエストがあった時に実行するディレクティブを定義する．



## 03. mod_dirにおける設定ディレクティブ

### DirectoryIndex

#### ・DirectoryIndexとは

indexファイルを指定する．

```apacheconf
<Directory "/example">
    DirectoryIndex index.html index.php
</Directory>
```

```apacheconf
<Directory "/example">
    DirectoryIndex index.html
    DirectoryIndex index.php
</Directory>
```

### AllowOverride

#### ・AllowOverrideとは

htaccessファイルで有効化するディレクティブを定義する．

```apacheconf
<Directory "/example">
    DirectoryIndex index.php
    AllowOverride All
</Directory>
```

#### ・All

htaccessファイルで実装可能なディレクティブを全て有効化する．

```apacheconf
AllowOverride All
```

#### ・None

全て無効化する．

```apacheconf
AllowOverride None
```

#### ・Indexes

htaccessファイルでDirectoryIndexを有効化する．

```apacheconf
AllowOverride Indexes
```



## 03-02. mod_writeにおける設定ディレクティブ

### RewriteCond

#### ・RewriteCondとは

条件分岐と，それによる処理を定義する．

```apacheconf
RewriteCond %変数名 条件
```

**【実装例】**

```apacheconf
RewriteCond %{HTTP:X-Forwarded-Port} !^443$
```


### RewriteRule

#### ・RewriteRuleとは

条件分岐による処理を定義する．

```apacheconf
RewriteRule URL書換＆転送の記述
```

**【実装例】**

リクエストをHTTPSプロトコルに変換して，リダイレクトする．

```apacheconf
RewriteRule ^(.*)?$ https://%{HTTP_HOST}$1 [R=301,L]
```



## 03-03. mod_setenvifにおける設定ディレクティブ

### SetEnvIf

#### ・SetEnvIfとは

条件分岐と環境変数の設定を定義する．

```apacheconf
# クエリパラメータが以下の拡張子の場合に，
SetEnvIf Request_URI "\.(gif|jpe?g|png|js|css)$" object-is-ignore
```

#### ・nolog

ログを出力しない場合を設定できる．



## 03-04. mod_log_configにおける設定ディレクティブ

### LogFormat

#### ・LogFormatとは

アクセスログファイルの書式を定義する．

#### ・アクセスログ形式と出力内容

アクセスログの出力先ログファイルとフォーマットを合わせて定義する．

```apacheconf
# common形式
CustomLog logs/access_log common
LogFormat "%h %l %u %t "%r" %>s %b" common

# combine形式
CustomLog logs/access_log combined
LogFormat "%h %l %u %t "%r" %>s %b "%{Referer}i" "%{User-Agent}i"" combined
```

以下のようなログになる．

```
# common形式
118.86.194.71 - - [17/Aug/2011:23:04:03 +0900] "GET /home/name/category/web HTTP/1.1" 200 11815

# combine形式
118.86.194.71 - - [17/Aug/2011:23:04:03 +0900] "GET /home/name/category/web HTTP/1.1" 200 11815 "http://naoberry.com/home/name/" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.112 Safari/535.1"
```

#### ・ログの変数一覧

| 変数           | 値                                  | 例                                                           |
| -------------- | ----------------------------------- | ------------------------------------------------------------ |
| %h             | リモートホスト                      | 118.86.194.71                                                |
| %l             | リモートログ名（基本”-“になる）     | -                                                            |
| %u             | リモートユーザ（Basic認証のユーザ） | -                                                            |
| %t             | リクエスト受付時刻                  | [17/Aug/2011:23:04:03 +0900]                                 |
| %r             | リクエストの最初の行                | GET /home/name/category/web HTTP/1.1                         |
| %s             | ステータス                          | 200                                                          |
| %b             | レスポンスのバイト数                | 11815                                                        |
| %{Referer}i    | リファラ                            | http://naoberry.com/home/name/                               |
| %{User-Agent}i | ユーザエージェント                  | Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.112 Safari/535.1 |



### ErrorLog

#### ・ErrorLogとは

エラーログファイルの書式を定義する．

#### ・エラーログ形式と出力内容

エラーログの出力先を定義する．

```apacheconf
ErrorLog /var/log/httpd/error_log
```



### LogLevel

#### ・LogLevelとは

どのレベルまでログを出力するかを定義する．

| ログレベル | 意味                                   | 設定の目安       |
| ---------- | -------------------------------------- | ---------------- |
| emerg      | サーバが稼動できないほどの重大なエラー |                  |
| alert      | critよりも重大なエラー                 |                  |
| crit       | 重大なエラー                           |                  |
| error      | エラー                                 |                  |
| warn       | 警告                                   | 本番環境         |
| notice     | 通知メッセージ                         |                  |
| info       | サーバ情報                             | ステージング環境 |
| debug      | デバック用の情報                       |                  |



## 03-05. mod_sslにおける設定ディレクティブ 

### SSLCertificateFile

#### ・SSLCertificateFileとは

PKIにおける公開鍵の検証に必要なSSLサーバ証明書のディレクトリを定義する．

```apacheconf
SSLCertificateFile /etc/httpd/conf.d/server.crt
```

### SSLCertificateKeyFile

#### ・SSLCertificateKeyFileとは

PKIにおける公開鍵の検証に必要な秘密鍵のディレクトリを定義する．

```apacheconf
SSLCertificateKeyFile /etc/httpd/conf.d/server.key
```



## 04. htaccess

### 影響範囲

#### ・ルートディレクトリの場合

全てのファイルに対して，ディレクティブが適用される．

![htaccess影響範囲](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/htaccess影響範囲.png)

#### ・それ以外のディレクトリの場合

設置したディレクトリ以下の階層のファイルに対して適用される．

![htaccess影響範囲_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/htaccess影響範囲_2.png)

