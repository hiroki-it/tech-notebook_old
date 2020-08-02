# Apache


## 01. コマンド

#### 起動コマンド

#### ・設定ファイルのバリデーション

```bash
$ httpd -t
```

#### ・設定ファイルの反映と安全な再起動

```bash
$ httpd -k graceful
```



## 02. 実装方法

### SelfEnvIf

### ・nolog

ログを出力しない場合を設定できる．

**【実装例】**

```
SetEnvIf User-Agent "ELB-HealthChecker" nolog
```



### LogFormat

#### ・定義されている変数

| 変数           | 値                                  |
| -------------- | ----------------------------------- |
| %h             | リモートホスト                      |
| %l             | リモートログ名（基本”-“になる）     |
| %u             | リモートユーザ（Basic認証のユーザ） |
| %t             | リクエスト受付時刻                  |
| %r             | リクエストの最初の行                |
| %s             | ステータス                          |
| %{Referer}i    | リファラ                            |
| %{User-Agent}i | ユーザエージェント                  |

#### ・combine形式

**【実装例】**

```
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
```

上記の様に設定すると，以下のようなログになる．

```bash
118.86.194.71 - - [17/Aug/2011:23:04:03 +0900] "GET /home/name/category/web HTTP/1.1" 200 11815 "http://naoberry.com/home/name/" "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.112 Safari/535.1"
```



### RewriteCond

#### ・RewriteCondとは

ifの処理ができる．nginxのifブロックに相当する．

```
RewriteCond %変数名 条件
```

**【実装例】**

```
RewriteCond %{HTTP:X-Forwarded-Port} !^443$
```



### RewriteRule

#### ・RewriteRuleとは

if文と同じような処理ができる．

```
RewriteRule URL書換＆転送の記述
```

**【実装例】**

リクエストをHTTPSプロトコルに変換して，リダイレクトする．

```
RewriteRule ^(.*)?$ https://%{HTTP_HOST}$1 [R=301,L]
```

