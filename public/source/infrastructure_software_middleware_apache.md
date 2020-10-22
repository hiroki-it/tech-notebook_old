# Apache

## 01. Tips

### コマンド

#### ・設定ファイルのバリデーション

```bash
# systemctlコマンドは無い
$ service httpd configtest
$ apachectl configtest
$ apachectl -t
```

#### ・強制的な起動／停止／再起動

```bash
$ systemctl start httpd

$ systemctl stop httpd

$ systemctl restart httpd
```

#### ・安全な再起動

```bash
$ apachectl -k graceful
```

<br>

## 02. Apacheの用途

### Webサーバのミドルウェアとして

![Webサーバ，APサーバ，DBサーバ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Webサーバ，APサーバ，DBサーバ.png)

<br>

## 03. Coreにおける設定ディレクティブ

### ServerRoot

#### ・ServerRootとは

他の設定ディレクティブで，相対パスが設定されている場合に適用される．そのルートディレクトリを定義する．

**＊実装例＊**

通常であれば，etcディレクトリ以下にconfファイルが配置される．

```apacheconf
ServerRoot /etc/httpd
```

CentOSのEPELリポジトリ経由でインストールした場合，Apacheのインストール後に，optディレクトリ以下にconfファイルが設置される．

```apacheconf
ServerRoot /opt/rh/httpd24/root/etc/httpd
```

<br>

### VirtualHost

#### ・VirtualHostとは

ディレクティブを囲うディレクティブの一つ．特定のホスト名やIPアドレスにリクエストがあった時に実行するディレクティブを定義する．VirtualHostという名前の通り，1 つのサーバ上で，仮想的に複数のドメインを扱うような処理も定義できる．複数のVirtualHostを設定した場合，一つ目がデフォルト設定として認識される．

**＊実装例＊**

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

<br>

### DocumentRoot

#### ・DocumentRootとは

ドキュメントのルートディレクトリを定義する．ドキュメントルートに「```index.html```」というファイルを置くと，ファイル名を指定しなくとも，ルートディレクトリ内の```index.html```が，エントリーポイントとして自動的に認識されて表示される．

**＊実装例＊**

```apacheconf
<VirtualHost *:80>
    DocumentRoot /www/example1
    ServerName www.example.com
</VirtualHost>
```

index.html以外の名前をエントリーポイントにする場合，ファイル名を指定する必要がある．

**＊実装例＊**

```apacheconf
<VirtualHost *:80>
    DocumentRoot /www/example1/start-up.html
    ServerName www.example.com
</VirtualHost>
```



### Directory

#### ・Directoryとは

ディレクティブを囲うディレクティブの一つ．指定したディレクトリ内にリクエストがあった時に実行するディレクティブを定義する．

**＊実装例＊**

```apacheconf
<Directory "/var/www/example">
    DirectoryIndex index.php
    AllowOverride All
</Directory>
```

<br>

### User，Group

#### ・Userとは

httpdプロセスのユーザ名を定義する．httpdプロセスによって作成されたファイルの所有者名は，このディレクティブで定義したものになる．

**＊実装例＊**

```apacheconf
User apache
```

#### ・Groupとは

httpdプロセスのグループ名を定義する．httpdプロセスによって作成されたファイルのグループ名は，このディレクティブで定義したものになる．

**＊実装例＊**

```apacheconf
Group apache
```

<br>

### KeepAlive，MaxKeepAliveRequests，KeepAliveTimeout

#### ・KeepAliveとは

HTTPプロトコルのリクエストのクライアントに対して，セッションIDを付与するかどうか，を定義する．

**＊実装例＊**

```apacheconf
KeepAlive On
```

#### ・KeepAliveTimeout

セッションIDを付与中のクライアントにおいて，再びリクエストを送信するまでに何秒間空いたら，セッションIDを破棄するか，を定義する．

**＊実装例＊**

```apacheconf
# KeepAliveがOnの時のみ
KeepAliveTimeout 5
```

#### ・MaxKeepAliveRequests

セッションIDを付与中のクライアントにおいて，リクエストのファイルの最大数を定義する．

**＊実装例＊**

```apacheconf
# KeepAliveがOnの時のみ
MaxKeepAliveRequests 1000
```

<br>

## 04. mod_soにおける設定ディレクティブ

### LoadModule

#### ・LoadModule

モジュールを読み込み，設定ディレクティブを宣言できるようにする．

**＊実装例＊**

相対パスを指定し，ServerRootを適用させる．これにより，httpdディレクトリのmodulesディレクトリが参照される．

```apacheconf
# ServerRoot が /opt/rh/httpd24/root/etc/httpd だとする．

LoadModule dir_module modules/mod_dir.so
```

<br>

## 04-02. mod_dirにおける設定ディレクティブ

### DirectoryIndex

#### ・DirectoryIndexとは

Directoryディレクティブによってリクエストされたディレクトリのインデックスファイルをレスポンスする．

**＊実装例＊**

```apacheconf
<Directory "/var/www/example">
    DirectoryIndex index.html index.php
</Directory>
```
**＊実装例＊**

```apacheconf
<Directory "/var/www/example">
    DirectoryIndex index.html
    DirectoryIndex index.php
</Directory>
```

### AllowOverride

#### ・AllowOverrideとは

```htaccess```ファイルで有効化するディレクティブを定義する．

**＊実装例＊**

```apacheconf
<Directory "/var/www/example">
    DirectoryIndex index.php
    AllowOverride All
</Directory>
```

#### ・All

```htaccess```ファイルで実装可能なディレクティブを全て有効化する．

**＊実装例＊**

```apacheconf
AllowOverride All
```

#### ・None

全て無効化する．

**＊実装例＊**

```apacheconf
AllowOverride None
```

#### ・Indexes

htaccessファイルでDirectoryIndexを有効化する．

**＊実装例＊**

```apacheconf
AllowOverride Indexes
```

<br>

## 04-03. mod_writeにおける設定ディレクティブ

### RewriteCond

#### ・RewriteCondとは

条件分岐と，それによる処理を定義する．

**＊実装例＊**

```apacheconf
RewriteCond %変数名 条件
```

**＊実装例＊**

```apacheconf
RewriteCond %{HTTP:X-Forwarded-Port} !^443$
```


### RewriteRule

#### ・RewriteRuleとは

条件分岐による処理を定義する．

```apacheconf
RewriteRule URL書換＆転送の記述
```

**＊実装例＊**

リクエストをHTTPSプロトコルに変換して，リダイレクトする．

```apacheconf
RewriteRule ^(.*)?$ https://%{HTTP_HOST}$1 [R=301,L]
```

<br>

## 04-04. mod_setenvifにおける設定ディレクティブ

### SetEnvIf

#### ・SetEnvIfとは

条件分岐と環境変数の設定を定義する．

```apacheconf
# クエリパラメータが以下の拡張子の場合に，
SetEnvIf Request_URI "\.(gif|jpe?g|png|js|css)$" object-is-ignore
```

#### ・nolog

ログを出力しない場合を設定できる．

<br>

## 04-05. mod_log_configにおける設定ディレクティブ

### LogFormat

#### ・LogFormatとは

アクセスログファイルの書式を定義する．

#### ・アクセスログ形式と出力内容

アクセスログの出力先ログファイルとフォーマットを合わせて定義する．

**＊実装例＊**

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

<br>

### ErrorLog

#### ・ErrorLogとは

エラーログファイルの書式を定義する．

#### ・エラーログ形式と出力内容

エラーログの出力先を定義する．

**＊実装例＊**

```apacheconf
ErrorLog /var/log/httpd/error_log
```

<br>

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

<br>

## 04-06. mod_sslにおける設定ディレクティブ 

### SSLCertificateFile

#### ・SSLCertificateFileとは

PKIにおける公開鍵の検証に必要なSSLサーバ証明書のディレクトリを定義する．本番環境ではAWSのACM証明書を用いることが多いため，基本的な用途としては，ローカル開発でのオレオレ証明書読み込みのために用いる．

**＊実装例＊**

```apacheconf
SSLCertificateFile /etc/httpd/conf.d/server.crt
```

### SSLCertificateKeyFile

#### ・SSLCertificateKeyFileとは

PKIにおける公開鍵の検証に必要な秘密鍵のディレクトリを定義する．

**＊実装例＊**

```apacheconf
SSLCertificateKeyFile /etc/httpd/conf.d/server.key
```

<br>

## 05. htaccess

### 影響範囲

#### ・ルートディレクトリの場合

全てのファイルに対して，ディレクティブが適用される．

![htaccess影響範囲](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/htaccess影響範囲.png)

#### ・それ以外のディレクトリの場合

設置したディレクトリ以下の階層のファイルに対して適用される．

![htaccess影響範囲_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/htaccess影響範囲_2.png)

