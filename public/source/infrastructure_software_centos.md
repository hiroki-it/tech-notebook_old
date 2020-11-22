# CentOSの構成

## 01. 基本ソフトウェア（広義のOS）

### 基本ソフトウェアの構成

![基本ソフトウェアの構成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/基本ソフトウェアの構成.png)

<br>

## 02. ユーティリティ

### ユーティリティの種類

#### ・Unixの場合

今回，以下に紹介するものをまとめる．

| ファイルシステム系 | プロセス管理系 | ネットワーク系 | テキスト処理系 | 環境変数系  | ハードウェア系 |
| ------------------ | -------------- | -------------- | -------------- | :---------- | -------------- |
| mkdir              | batch          | nslookup       | tail           | export      | df             |
| ls                 | ps             | curl           | vim            | printenv    | free           |
| cp                 | kill           | netstat        | grep           | timedatectl | -              |
| find               | systemctl      | route          | history        | -           | -              |
| chmod              | cron           | ssh            | -              | -           | -              |
| rm                 | -              | -              | -              | -           | -              |
| chown              | -              | -              | -              | -           | -              |
| ln                 | -              | -              | -              | -           | -              |
| od                 | -              | -              | -              | -           | -              |

#### ・Windowsの場合

Windowsは，GUIでユーティリティを使用する．よく使うものを記載する．

| システム系         | ストレージデバイス管理系 | ファイル管理系         | その他             |
| ------------------ | ------------------------ | ---------------------- | ------------------ |
| マネージャ         | デフラグメントツール     | ファイル圧縮プログラム | スクリーンセーバー |
| クリップボード     | アンインストーラー       | -                      | ファイアウォール   |
| レジストリクリーナ | -                        | -                      | -                  |
| アンチウイルス     | -                        | -                      | -                  |

<br>

### ユーティリティのバイナリファイル

####  ・バイナリファイルの配置場所

| バイナリファイルのディレクトリ | バイナリファイルの種類                                       |
| ------------------------------ | ------------------------------------------------------------ |
| ```/bin```                     | Unixユーティリティのバイナリファイルの多く．                 |
| ```/usr/bin```                 | 管理ユーティリティによってインストールされるバイナリファイルの多く． |
| ```/usr/local/bin```           | Unix外のソフトウェアによってインストールされたバイナリファイル．最初は空になっている． |
| ```/sbin```                    | Unixユーティリティのバイナリファイルうち，```sudo```権限が必要なもの． |
| ```/usr/sbin```                | 管理ユーティリティによってインストールされたバイナリファイルのうち，```sudo```権限が必要なもの． |
| ```/usr/local/sbin```          | Unix外のソフトウェアによってインストールされたバイナリファイルのうち，```sudo```権限が必要なもの．最初は空になっている． |

``` bash
# バイナリファイルが全ての場所で見つからないエラー
$ which python3
which: no python3 in (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin)

# バイナリファイルの場所
$ which python3 
/usr/bin/python3
```

<br>

### シェルスクリプト

#### ・シェルスクリプトとは

ユーティリティの処理を手続き的に実装したファイル．最初の「```#!```」をシェバンという．

**＊実装例＊**

```bash
#!/bin/bash

echo "Hello World!"
echo "Hello Japan!"
echo "Hello Tokyo!"
```

#### ・シェルスクリプトの実行方法

以下のいずれかの方法で実行する．

```bash
# sourceコマンド
$ source hello.sh
```

```bash
# bashコマンド
$ bash hello.sh
```

```bash
# ドット
$ . hello.sh
```

```bash
# 相対パスもしくは絶対パスでシェルスクリプトを指定
# カレントディレクトリにあるhello.shを実行することはできない
$ ./hello.sh
```

<br>

### pipeline

#### ・pipelineとは

複数のプログラムの入出力を繋ぐプロセス間通信の仕組み．

![pipeline](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/pipeline.png)

#### ・grepとの組み合わせ

「```|```」の縦棒記号のこと．コマンドの出力結果を表示せずに，次のコマンドの引数として渡す．例えば，```find```コマンドの出力結果を```grep```コマンドに渡し，フィルタリングを行う．

```bash
# find ---> grep
$ find /* -type f |xargs grep "<検索文字>"
```

#### ・killとの組み合わせ

フィルタリング結果に対して，```kill```コマンドを行う．

```bash
# フィルタリングされたプロセスを削除する．
$ sudo pgrep -f <コマンド名> | sudo xargs kill -9
```

<br>

## 02-02. ファイルシステム系



### chmod：change mode

#### ・<数字>

ファイルの権限を変更する．よく使用されるパーミッションのパターンは次の通り．

```bash
$ chmod 600 <ファイル名>
```

#### ・-R <数字>

ディレクトリ内のファイルに対して，再帰的に権限を付与する．

```bash
$ chmod -R 600 <ディレクトリ名>
```

#### ・100番刻みの規則性

所有者以外に全権限が与えられない．

| 数字 | 所有者 | グループ | その他 | 特徴                   |
| :--: | :----- | :------- | :----- | ---------------------- |
| 500  | r-x    | ---      | ---    | 所有者以外に全権限なし |
| 600  | rw-    | ---      | ---    | 所有者以外に全権限なし |
| 700  | rwx    | ---      | ---    | 所有者以外に全権限なし |

#### ・111番刻みの規則性

全てのパターンで同じ権限になる．

| 数字 | 所有者 | グループ | その他 | 特徴                 |
| :--: | :----- | :------- | :----- | -------------------- |
| 555  | r-x    | r-x      | r-x    | 全てにWrite権限なし  |
| 666  | rw-    | rw-      | rw-    | 全てにExecut権限なし |
| 777  | rwx    | rwx      | rwx    | 全てに全権限あり     |

#### ・その他でよく使う番号

| 数字 | 所有者 | グループ | その他 | 特徴                               |
| :--: | :----- | :------- | :----- | ---------------------------------- |
| 644  | rw-    | r--      | r--    | 所有者以外にWrite，Execute権限なし |
| 755  | rwx    | r-x      | r-x    | 所有者以外にWrite権限なし          |

<br>

### cp

#### ・-Rp

ディレクトリの属性情報も含めて，ディレクトリ構造とファイルを再帰的にコピー．

```bash
$ cp -Rp /<ディレクトリ名1>/<ディレクトリ名2> /<ディレクトリ名1>/<ディレクトリ名2>
```

```bash
# 隠しファイルも含めて，ディレクトリの中身を他のディレクトリ内にコピー
# 「アスタリスク」でなく「ドット」にする
$ cp -Rp /<ディレクトリ名>/. /<ディレクトリ名> 
```

#### ・-p

『ファイル名.YYYYmmdd』の形式でバックアップファイルを作成

```bash
$ cp -p <ファイル名> <ファイル名>.`date +'%Y%m%d'`
```

<br>

### echo

#### ・オプション無し

定義されたシェル変数を出力する．変数名には```$```マークを付ける．

```bash
$ <変数名>=<値>

$ echo $<変数名>
```

<br>

### find

#### ・-type

ファイルを検索するためのユーティリティ．アスタリスクを付けなくとも，自動的にワイルドカードが働く．

```bash
$ find /* -type f | xargs grep "<検索文字>"
```

```bash
# パーミッションエラーなどのログを破棄して検索．
$ find /* -type f | xargs grep "<検索文字>" 2> /dev/null
```

#### ・-name，-type

ルートディレクトリ以下で， example という文字をもち，ファイル名が .conf で終わるファイルを全て検索する．

```bash
$ find /* -name "*.conf" -type f | xargs grep "<検索文字>"
```

<br>

### ln

#### ・-s

カレントディレクトリに，シンボリックリンクを作成する．

```bash
$ ln -s <リンク先のファイル／ディレクトリまでのパス> <シンボリックリンク名> 
```

<br>

### ls

#### ・-l，-a

隠しファイルや隠しディレクトリも含めて，全ての詳細を表示する．

```bash
$ ls -l -a
```

<br>

### mkdir

#### ・-p

複数階層のディレクトリを作成する．

```bash
$ mkdir -p /<ディレクトリ名1>/<ディレクトリ名2>
```

<br>

### rm

#### ・-R

ディレクトリ自体と中のファイルを再帰的に削除する．

```bash
$ rm -R <ディレクトリ名> 
```

<br>

### od：octal dump

#### ・オプション無し

ファイルを8進数の機械語で出力する．

```bash
$ od <ファイル名>
```

#### ・-Ad，-tx

ファイルを16進数の機械語で出力する．

```bash
$ od -Ad -tx <ファイル名>
```

<br>

### set

#### ・オプション無し

現在設定されているシェル変数を一覧で表示する．

```bash
$ set
```

#### ・-n

シェルスクリプトの構文解析を行う．

```bash
$ set -n
```

#### ・-e

一連の処理の途中で```0```以外の終了ステータスが出力された場合，全ての処理を終了する．

```bash
$ set -e
```

#### ・-x

一連の処理をデバッグ情報として出力する．

```bash
$ set -x
```

#### ・-u

一連の処理の中で，未定義の変数が存在した場合，全ての処理を終了する．

```bash
$ set -u
```

#### ・-o pipefail

パイプライン（```|```）内の一連の処理の途中で，エラーが発生した場合，その終了ステータスを出力し，全ての処理を終了する．

```bash
$ set -o pipefail
```

<br>

### unlink

#### ・オプション無し

カレントディレクトリのシンボリックリンクを削除する．

```bash
$ unlink <シンボリックリンク名>
```

<br>

## 02-03. ネットワーク系

### ssh：secure shell

#### ・-l，-p，<ポート>，-i，-T

事前に，秘密鍵の権限は「600」にしておく．tty（擬似ターミナル）を使用する場合は，```-T```オプションをつける．

```bash
$ ssh -l <サーバのユーザ名>@<サーバのホスト名> -p 22 -i <秘密鍵のパス> -T
```

#### ・-l，-p，<ポート>，-i，-T，-vvv

```bash
# -vvv：ログを出力する
$ ssh -l <サーバのユーザ名>@<サーバのホスト名> -p 22 -i <秘密鍵のパス> -T -vvv
```

#### ・設定ファイル（```~/.ssh/config```）

設定が面倒な```ssh```コマンドのオプションの引数を，```~/.ssh/config```ファイルに記述しておく．

```
# サーバ１
Host <接続名1>
    User <サーバ１のユーザ名>
    Port 22
    HostName <サーバ１のホスト名>
    IdentityFile <秘密鍵へのパス>

# サーバ２
Host <接続名２>
    User <サーバ２のユーザ名>
    Port 22
    HostName <サーバ２のホスト名>
    IdentityFile <秘密へのパス>
```

これにより，コマンド実行時の値渡しを省略できる．tty（擬似ターミナル）を使用する場合は，-Tオプションをつける．

```bash
# 秘密鍵の権限は，事前に「600」にしておく
$ ssh <接続名> -T
```

<br>

## 02-04. プロセス系

### ps： process status

#### ・aux

稼働しているプロセスの詳細情報を表示するためのユーティリティ．

```bash
# 稼働しているプロセスのうち，詳細情報に「xxx」を含むものを表示する．
$ ps aux | grep "<検索文字>"
```

<br>

### systemctl：system control（旧service）

#### ・systemctlとは

デーモンを起動するsystemdを制御するためのユーティリティ．

#### ・list-unit-files

デーモンのUnitを一覧で確認する．

```bash
$ systemctl list-unit-files --type=service

crond.service           enabled  # enable：自動起動する
supervisord.service     disabled # disable：自動起動しない
systemd-reboot.service  static   # enable：他サービス依存
```

#### ・enable

マシン起動時にデーモンが自動起動するように設定する．

```bash
$ systemctl enable <プロセス名>

# 例：Cron，Apache
$ systemctl enable crond.service
$ systemctl enable httpd.service
```
#### ・disable

マシン起動時にデーモンが自動起動しないように設定する．

```bash
$ systemctl disable <プロセス名>

# 例：Cron，Apache
$ systemctl disable crond.service
$ systemctl disable httpd.service
```

#### ・systemd：system daemon のUnitの種類

各デーモンを，```/usr/lib/systemd/system```や```/etc/systemd/system```下でUnit別に管理し，Unitごとに起動する．Unitは拡張子の違いで判別する．

| Unitの拡張子 | 意味                                       | デーモン例         |
| ------------ | ------------------------------------------ | ------------------ |
| mount        | ファイルのマウントに関するデーモン．       |                    |
| service      | プロセス起動停止に関するデーモン．         | httpd：http daemon |
| socket       | ソケットとプロセスの紐づけに関するデーモン |                    |

### kill

#### ・-9

指定したPIDのプロセスを削除する．

```bash
$ kill -9 <プロセスID（PID）>
```

指定したコマンドによるプロセスを全て削除する．

```bash
$ sudo pgrep -f <コマンド名> | sudo xargs kill -9
```

<br>

### crontab

#### ・crontabとは

cronデーモンの動作が定義されたcrontabファイルを操作するためのユーティリティ．

#### ・オプション無し

作成したcronファイルを登録する．cron.dファイルは操作できない．

```bash
# crontab：command run on table
$ crontab <ファイルパス>
```

<br>

### crond

#### ・crondとは

cronデーモンを起動するためのプログラム

#### ・-n

フォアグラウンドプロセスとしてcronを起動

```bash
$ crond -n
```

#### ・cronファイル

| ファイル名<br>ディレクトリ名 | 利用者 | 主な用途                                               |
| ---------------------------- | ------ | ------------------------------------------------------ |
| /etc/crontab                 | root   | 毎時，毎日，毎月，毎週の自動タスクのメイン設定ファイル |
| /etc/cron.hourly             | root   | 毎時実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.daily              | root   | 毎日実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.monthly            | root   | 毎月実行される自動タスク設定ファイルを置くディレクトリ |
| /etc/cron.weekly             | root   | 毎週実行される自動タスク設定ファイルを置くディレクトリ |


**＊実装例＊**

1. あらかじめ，各ディレクトリにcronファイルを配置しておく．
2. cronとして登録するファイルを作成する．```run-parts```コマンドで，指定した時間に，各cronディレクトリ内のcronファイルを一括で実行するように記述しておく．

```bash
# 設定
SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO="hasegawafeedshop@gmail.com"
LANG=ja_JP.UTF-8
LC_ALL=ja_JP.UTF-8
CONTENT_TYPE=text/plain; charset=UTF-8

# For details see man 4 crontabs

# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  * user-name command to be executed

# run-parts
1 * * * * root run-parts /etc/cron.hourly # 毎時・1分
5 2 * * * root run-parts /etc/cron.daily # 毎日・2時5分
20 2 * * 0 root run-parts /etc/cron.weekly # 毎週日曜日・2時20分
40 2 1 * * root run-parts /etc/cron.monthly # 毎月一日・2時40分
@reboot make clean html # cron起動時に一度だけ
```

**＊実装例＊**

```bash
# 毎時・1分
1 * * * * root run-parts /etc/cron.hourly
```

```bash
# 毎日・2時5分
5 2 * * * root run-parts /etc/cron.daily
```

```bash
# 毎週日曜日・2時20分
20 2 * * 0 root run-parts /etc/cron.weekly
```

```bash
# 毎月一日・2時40分
40 2 1 * * root run-parts /etc/cron.monthly
```

```bash
# cron起動時に一度だけ
@reboot make clean html
```

3. このファイルをcrontabコマンドで登録する．cronファイルの実体はないことと，変更した場合は登録し直さなければいけないことに注意する．

```bash
$ crontab <ファイルパス>
```

4. 登録されている処理を確認する．

```bash
$ crontab -l
```

5. ログに表示されているかを確認．

```bash
$ cd /var/log
$ tail -f cron
```


#### ・cron.dファイル

複数のcronファイルで全ての一つのディレクトリで管理する場合に用いる．

| ディレクトリ名 | 利用者 | 主な用途                                           |
| -------------- | ------ | -------------------------------------------------- |
| /etc/cron.d    | root   | 上記以外の自動タスク設定ファイルを置くディレクトリ |

#### ・supervisorとの組み合わせ

ユーザーが，OS上のプロセスを制御できるようにするためのプログラム．

```bash
# インストール
$ pip3 install supervisor
```

```bash
# /etc/supervisor/supervisord.conf に設定ファイルを置いて起動．
$ /usr/local/bin/supervisord
```

以下に設定ファイルの例を示す．

**＊実装例＊**

```
[supervisord]
# 実行ユーザ
user=root
# フォアグラウンドで起動
nodaemon=true
# ログ
logfile=/var/log/supervisord.log
# Pid
pidfile=/var/tmp/supervisord.pid

[program:crond]
# 実行コマンド
command=/usr/sbin/crond -n
# プログラムの自動起動
autostart=true
# プログラム停止後の再起動
autorestart=true
# コマンドの実行ログ
stdout_logfile=/var/log/command.log
stderr_logfile=/var/log/command-error.log
# コマンドの実行ユーザ
user=root
# コマンドの実行ディレクトリ
directory=/var/www/tech-notebook
```

<br>

## 02-05. テキスト処理系

### vim：Vi Imitaion，Vi Improved  

#### ・オプション無し

vim上でファイルを開く．

```bash
$ vim <ファイル名>
```

<br>

### history

#### ・オプション無し

履歴1000件の中からコマンドを検索する．

```bash
$ history | grep <過去のコマンド>
```

<br>



## 02-06. 環境変数系


### export

#### ・オプション無し

基本的な手順としては，シェル変数を設定し，これを環境変数に追加する．

```bash
# シェル変数を設定
$ PATH=$PATH:<バイナリファイルへのあるディレクトリへの絶対パス>
# 環境変数に追加
$ export PATH
```

シェル変数の設定と，環境変数への追加は，以下の通り同時に記述できる．

```bash
# 環状変数として，指定したバイナリファイル（bin）のあるディレクトリへの絶対パスを追加．
# バイナリファイルを入力すると，絶対パス
$ export PATH=$PATH:<バイナリファイルへのあるディレクトリへの絶対パス>
```

```bash
# 不要なパスを削除したい場合はこちら
# 環状変数として，指定したバイナリファイル（bin）のあるディレクトリへの絶対パスを上書き
$ export PATH=/sbin:/bin:/usr/sbin:/usr/bin
```

#### ・```.bashrc```への追記


exportの結果は，OSの再起動で初期化されてしまう．そのため，再起動時に自動的に実行されるよう，```/home/centos/.bashrc```に追記しておく．

```bash
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# xxxバイナリファイルのパスを追加 を追加 <--- ここに追加
PATH=$PATH:/usr/local/sbin/xxxx

export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
```

<br>

### printenv

#### ・オプション無し

全ての環境変数を表示する．

```bash
$ printenv
```

<br>

### timedatactl

#### ・set-timezone

```bash
# タイムゾーンを日本時間に変更
$ timedatectl set-timezone Asia/Tokyo

# タイムゾーンが変更されたかを確認
$ date
```

<br>

## 02-07. ハードウェア系


### top

#### ・オプション無し

各プロセスの稼働情報（ユーザ名，CPU，メモリ）を確認する． CPU使用率昇順に並べる

```bash
$ top
```

#### ・-a

メモリ使用率昇順に並べる．

```bash
$ top -a
```

<br>

### free

#### ・-m，-total

物理メモリ，スワップ領域，の使用状況をメガバイトで確認する．

```bash
# m：Mega Bytes
# t: -total
$ free -m -total
```

<br>

### df

#### ・-h，-m，-t

ストレージの使用状況をメガバイトで確認する．

```bash
# h：--human-readable
# t: -total
$ df -h -m -t
```

<br>

### mkswap，swapon，swapoff

#### ・スワッピング方式

物理メモリのアドレス空間管理の方法の一つ．ハードウェアのノートを参照．

![スワッピング方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/スワッピング方式.png)

#### ・スワップ領域の作成方法

```bash
# 指定したディレクトリをスワップ領域として使用
$ mkswap /swap_volume
```
```bash
# スワップ領域を有効化
# 優先度のプログラムが，メモリからディレクトリに，一時的に退避されるようになる
$ swapon /swap_volume
```
```bash
# スワップ領域の使用状況を確認
$ swapon -s
```
```bash
# スワップ領域を無効化
$ swapoff /swap_volume
```

<br>

##  03. 管理ユーティリティ

### 管理ユーティリティの種類

#### ・管理ユーティリティの対象

様々なレベルを対象にした管理ユーティリティがある．

![ライブラリ，パッケージ，モジュールの違い](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ライブラリ，パッケージ，モジュールの違い.png)

#### ・ライブラリ管理ユーティリティ

| ユーティリティ名                  | 対象プログラミング言語 |
| --------------------------------- | ---------------------- |
| composer.phar：Composer           | PHP                    |
| pip：Package Installer for Python | Python                 |
| npm：Node Package Manager         | Node.js                |
| maven：Apache Maven               | Java                   |
| gem：Ruby Gems                    | Ruby                   |

#### ・パッケージ管理ユーティリティ

| ユーティリティ名                                        | 対象OS       | 依存関係のインストール可否 |
| ------------------------------------------------------- | ------------ | -------------------------- |
| Rpm：Red Hat Package Manager                            | RedHat系     | ✕                          |
| Yum：Yellow dog Updater Modified<br/>DNF：Dandified Yum | RedHat系     | 〇                         |
| Apt：Advanced Packaging Tool                            | Debian系     | 〇                         |
| Apk：Alpine Linux package management                    | Alpine Linux | 〇                         |

#### ・言語バージョン管理ユーティリティ

| ユーティリティ名 | 対象プログラミング言語 |
| ---------------- | ---------------------- |
| phpenv           | PHP                    |
| pyenv            | Python                 |
| rbenv            | Ruby                   |

<br>

## 03-02. ライブラリ管理ユーティリティ

### pip

#### ・install

指定したライブラリをインストールする．

```bash
# /usr/local 以下にインストール
$ pip install --user <ライブラリ名>
```
```bash
# requirements.txt を元にライブラリをインストール
$ pip install -r requirements.txt

# 指定したディレクトリにライブラリをインストール
pip install -r requirements.txt　--prefix=/usr/local
```

#### ・freeze

pipでインストールされたパッケージを元に，要件ファイルを作成する．

```bash
$ pip freeze > requirements.txt
```

#### ・show

pipでインストールしたパッケージ情報を表示する．

```bash
$ pip show sphinx

Name: Sphinx
Version: 3.2.1
Summary: Python documentation generator
Home-page: http://sphinx-doc.org/
Author: Georg Brandl
Author-email: georg@python.org
License: BSD
# インストール場所
Location: /usr/local/lib/python3.8/site-packages
# このパッケージの依存対象
Requires: sphinxcontrib-applehelp, imagesize, docutils, sphinxcontrib-serializinghtml, snowballstemmer, sphinxcontrib-htmlhelp, sphinxcontrib-devhelp, sphinxcontrib-jsmath, setuptools, packaging, Pygments, babel, alabaster, sphinxcontrib-qthelp, requests, Jinja2
# このパッケージを依存対象としているパッケージ
Required-by: sphinxcontrib.sqltable, sphinx-rtd-theme, recommonmark
```

<br>

### npm

#### ・入手方法

```bash
# リポジトリの作成
$ curl -sL https://rpm.nodesource.com/setup_<バージョン>.x | bash -

# nodejsのインストールにnpmも含まれる
$ yum install nodejs
```

#### ・init

package.jsonを生成する．

```bash
$ npm init
```

#### ・install

ディレクトリにパッケージをインストール

```bash
# ローカルディレクトリにパッケージをインストール
$ npm install <パッケージ名>
```

```bash
# グローバルディレクトリにインストール（あまり使わない）
$ npm install -g <パッケージ名>
```

<br>

## 03-03. パッケージ管理ユーティリティ

### rpm

#### ・-ivh

パッケージをインストールまたは更新する．一度に複数のオプションを組み合わせて記述する．インストール時にパッケージ間の依存関係を解決できないので注意．

```bash
# パッケージをインストール
# -ivh：--install -v --hash 
$ rpm -ivh <パッケージ名>
```

```bash
# パッケージを更新
# -Uvh：--upgrade -v --hash 
$ rpm -Uvh <パッケージ名>
```

#### ・-qa

インストールされた全てのパッケージの中で，指定した文字を名前に含むものを表示する．

```bash
# -qa：
$ rpm -qa | grep <検索文字>
```

#### ・-ql

指定したパッケージ名で，関連する全てのファイルの場所を表示する．

```bash
# -ql：
$ rpm -ql <パッケージ名>
```

#### ・-qi

指定したパッケージ名で，インストール日などの情報を表示する．

```bash
# -qi：
$ rpm -qi <パッケージ名>
```

<br>

### yum，dnf

#### ・install，reinstall

rpmと同様の使い方ができる．また，インストール時にパッケージ間の依存関係を解決できる．

```bash
# パッケージをインストール
$ yum install -y <パッケージ名>

# 再インストールする時は，reinstallとすること
$ yum reinstall -y <パッケージ名>
```

#### ・list

インストールされた全てのパッケージを表示する．

```bash
# 指定した文字を名前に含むものを表示．
$ yum list | grep <検索文字>
```

#### ・EPELリポジトリ，Remiリポジトリ

CentOS公式リポジトリはパッケージのバージョンが古いことがある．そこで，```--enablerepo```オプションを使用すると，CentOS公式リポジトリではなく，最新バージョンを扱う外部リポジトリ（EPEL，Remi）から，パッケージをインストールできる．外部リポジトリ間で依存関係にあるため，両方のリポジトリをインストールする必要がある．

1. CentOSのEPELリポジトリをインストール．インストール時の設定ファイルは，/etc/yu.repos.d/* に配置される．

```bash
# CentOS7系の場合
$ yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# CentOS8系の場合
$ dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# こちらでもよい
$ yum install -y epel-release でもよい
```
2. CentOSのRemiリポジトリをインストール．RemiバージョンはCentOSバージョンを要確認．インストール時の設定ファイルは，```/etc/yu.repos.d/*```に配置される．

```bash
# CentOS7系の場合
$ yum install -y https://rpms.remirepo.net/enterprise/remi-release-7.rpm

# CentOS8系の場合
$ dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
```

4. 設定ファイルへは，インストール先のリンクなどが自動的に書き込まれる．

```
[epel]
name=Extra Packages for Enterprise Linux 6 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch
failovermethod=priority
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 6 - $basearch - Debug
#baseurl=http://download.fedoraproject.org/pub/epel/6/$basearch/debug
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-6&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 6 - $basearch - Source
#baseurl=http://download.fedoraproject.org/pub/epel/6/SRPMS
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-source-6&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
gpgcheck=1
```

5. Remiリポジトリの有効化オプションを永続的に使用できるようにする．

```bash
# CentOS7の場合
$ yum install -y yum-utils
# 永続的に有効化
$ yum-config-manager --enable remi-php74


# CentOS8の場合（dnf moduleコマンドを使用）
$ dnf module enable php:remi-7.4
```

6. remiリポジトリを指定して，php，php-mbstring，php-mcryptをインストールする．Remiリポジトリを経由してインストールしたソフトウェアは```/opt/remi/*```に配置される．

```bash
# CentOS7の場合
# 一時的に有効化できるオプションを利用して，明示的にremiを指定
$ yum install --enablerepo=remi,remi-php74 -y php php-mbstring php-mcrypt


# CentOS8の場合
# リポジトリの認識に失敗することがあるのでオプションなし
$ dnf install -y php php-mbstring php-mcrypt
```

7. 再インストールする時は，reinstallとすること．

```bash
# CentOS7の場合
# 一時的に有効化できるオプションを利用して，明示的にremiを指定
$ yum reinstall --enablerepo=remi,remi-php74 -y php php-mbstring php-mcrypt


# CentOS8の場合
# リポジトリの認識に失敗することがあるのでオプションなし
$ dnf reinstall -y php php-mbstring php-mcrypt
```

<br>

## 03-04. 言語バージョン管理ユーティリティ

### pyenv

#### ・which

```bash
# pythonのインストールディレクトリを確認
$ pyenv which python
/.pyenv/versions/3.8.0/bin/python
```

<br>

## 04.  言語プロセッサ

### 言語プロセッサの例

#### ・アセンブラ

以降の説明を参照．

#### ・コンパイラ

以降の説明を参照．

#### ・インタプリタ

以降の説明を参照．



### 言語の種類

プログラム言語のソースコードは，言語プロセッサによって機械語に変換された後，CPUによって読み込まれる．そして，ソースコードに書かれた様々な処理が実行される．

#### ・コンパイラ型言語

C#など．コンパイラという言語プロセッサによって，コンパイラ方式で翻訳される言語．

#### ・インタプリタ型言語

PHP，Ruby，JavaScript，Python，など．インタプリタという言語プロセッサによって，インタプリタ方式で翻訳される言語をインタプリタ型言語という．

#### ・Java仮想マシン型言語

Scala，Groovy，Kotlin，など．Java仮想マシンによって，中間言語方式で翻訳される．

![コンパイル型とインタプリタ型言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/コンパイル型とインタプリタ型言語.jpg)

<br>

### 実行のエントリポイント

#### ・PHPの場合

動的型付け言語では，エントリポイントが指定プログラムの先頭行と決まっており，そこから枝分かれ状に処理が実行されていく．PHPでは，```index.php```ファイルがエントリポイントと決められている．その他のファイルにはエントリポイントは存在しない．

```PHP
<?php

use App\Kernel;
use Symfony\Component\ErrorHandler\Debug;
use Symfony\Component\HttpFoundation\Request;

// まず最初に，bootstrap.phpを読み込む．
require dirname(__DIR__) . '/config/bootstrap.php';

if ($_SERVER['APP_DEBUG']) {
    umask(0000);
    
    Debug::enable();
}

if ($trustedProxies = $_SERVER['TRUSTED_PROXIES']?? $_ENV['TRUSTED_PROXIES'] ?? false) {
    Request::setTrustedProxies(explode(',', $trustedProxies), Request::HEADER_X_FORWARDED_ALL ^ Request::HEADER_X_FORWARDED_HOST);
}

if ($trustedHosts = $_SERVER['TRUSTED_HOSTS'] ?? $_ENV['TRUSTED_HOSTS'] ?? false) {
    Request::setTrustedHosts([$trustedHosts]);
}

$kernel = new Kernel($_SERVER['APP_ENV'], (bool)$_SERVER['APP_DEBUG']);
$request = Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
```

#### ・Javaの場合

静的型付け言語では，エントリポイントが決まっておらず，自身で定義する必要がある．Javaでは，「```public static void main(String[] args)```メソッドを定義した場所がエントリポイントになる．

```java
public class Age
{
    // エントリポイントとなるメソッド
    public static void main(String[] args)
    {
        // 定数を定義．
        final int age = 20;
        System.out.println("私の年齢は" + age);

        // 定数は再定義できないので，エラーになる．
        age = 31;
        System.out.println("…いや，本当の年齢は" + age);
    }
}
```

<br>

## 04-02. コンパイラ型言語の機械語翻訳

### コンパイラ方式

#### ・機械語翻訳と実行のタイミング

コードを，バイナリ形式のオブジェクトコードとして，まとめて機械語に翻訳した後，CPUに対して命令が実行される．

![コンパイラ言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/コンパイラ言語.png)

#### ・ビルド（コンパイル＋リンク）

コンパイルによって，ソースコードは機械語からなるオブジェクトコードに変換される．その後，各オブジェクトコードはリンクされ．exeファイルとなる．この一連のプロセスを『ビルド』という．

![ビルドとコンパイル](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ビルドとコンパイル.jpg)

#### ・仕組み（じ，こ，い，さい，せい，リンク，実行）

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/字句解析，構文解析，意味解析，最適化.png)

1. **Lexical analysis（字句解析）**

   ソースコードの文字列を言語の最小単位（トークン）の列に分解． 以下に，トークンの分類方法の例を示す．

   ![構文規則と説明](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/構文規則と説明.png)

2. **Syntax analysis（構文解析）**

   トークンの列をツリー構造に変換．

3. **Semantics analysis（意味解析）**

   ツリー構造を基に，ソースコードに論理的な誤りがないか解析．

4. **Code optimization（コード最適化）**

   ソースコードの冗長な部分を削除または編集．機械語をより短くするこができる．

5. **Code generation（コード生成）**

   最適化されたコードをバイナリ形式のオブジェクトコードに変換．

6. **リンク**

   オブジェクトコードをリンクする．

7. **命令の実行**

   リンクされたオブジェクトコードを基に，命令が実行される．
   

<br>

### makeによるビルド

#### 1. パッケージをインストール

```bash
# パッケージを公式からインストールと解答
$ wget <パッケージのリンク>
$ tar <パッケージのフォルダ名>

# ビルド用ディレクトリの作成．
$ mkdir build
$ cd build
```

#### 2. ビルドのルールを定義

configureファイルを元に，ルールが定義されたMakefileを作成する．

```bash
# configureへのパスに注意．
$ ../configure --prefix="<ソースコードのインストール先のパス>"
```

#### 3. ビルド （コンパイル＋リンク）

パッケージのソースコードからexeファイルをビルドする．

```bash
# -j で使用するコア数を宣言し，処理の速度を上げられる．
$ make -j4
```

任意で，exeファイルのテストを行える．

```bash
$ make check
```

#### 4. exeファイルの実行

生成されたソースコードのファイルを，指定したディレクトリにコピー．

```bash
# installと命令するが，実際はコピー．sudoを付ける．
$ sudo make install
```

元となったソースコードやオブジェクトコードを削除．

```bash
$ make clean
```

<br>

## 04-03. インタプリタ型言語の機械語翻訳

### インタプリタ方式

#### ・機械語翻訳と実行のタイミング

コードを，一行ずつ機械語に変換し，その都度，CPUに対して命令が実行される．

![インタプリタ言語](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/インタプリタ言語.png)

コマンドラインでそのまま入力し，機械語翻訳と実行を行うことができる．

```bash
#===========
# PHPの場合
#===========

# PHPなので，処理終わりにセミコロンが必要
$ php -r '<何らかの処理>'

# Hello Worldを出力
$ php -r 'echo "Hello World";'

# phpinfoを出力
$ php -r 'phpinfo();'

# （おまけ）phpinfoの出力をテキストファイルに保存
$ php -r 'phpinfo();' > phpinfo.txt
```

```bash
# php.iniの読み込み状況を出力
$ php --ini
```

#### ・仕組み（じ，こ，い，実行）

![字句解析，構文解析，意味解析，最適化](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/字句解析，構文解析，意味解析，最適化.png)

1. **Lexical analysis（字句解析）**

   ソースコードの文字列を言語の最小単位（トークン）の列に分解． 以下に，トークンの分類方法の例を示す．

   ![構文規則と説明](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/構文規則と説明.png)

2. **Syntax analysis（構文解析）**

   トークンの列をツリー構造に変換．ソースコードから構造体を構築することを構文解析といい，htmlを構文解析してDOMツリーを構築する処理とは別物なので注意．

3. **Semantics analysis（意味解析）**

   ツリー構造を基に，ソースコードに論理的な誤りがないか解析．

4. **命令の実行**

   意味解析の結果を基に，命令が実行される．

5. **１から４をコード行ごとに繰り返す**

#### ・補足：JSの機械語翻訳について

Webサーバを仮想的に構築する時，PHPの言語プロセッサが同時に組み込まれるため，PHPのソースコードの変更はブラウザに反映される．しかし，JavaScriptの言語プロセッサは組み込まれない．そのため，JavaScriptのインタプリタは別に手動で起動する必要がある．

<br>

## 04-04. Java仮想マシン型言語の機械語翻訳

### 中間言語方式

#### ・中間言語方式の機械語翻訳の流れ

1. JavaまたはJVM型言語のソースコードを，Javaバイトコードを含むクラスファイルに変換する．
2. JVM：Java Virtual Machine内で，インタプリタによって，クラスデータを機械語に翻訳する．
3. 結果的に，OS（制御プログラム？）に依存せずに，命令を実行できる．（C言語）

![Javaによる言語処理_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Javaによる言語処理_1.png)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

![Javaによる言語処理_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Javaによる言語処理_2.png)

![矢印_80x82](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/矢印_80x82.jpg)

![Javaによる言語処理_3](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Javaによる言語処理_3.png)

#### ・C言語とJavaのOSへの依存度比較

![CとJavaのOSへの依存度比較](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CとJavaのOSへの依存度比較.png)

- JVM言語

ソースコード

<br>

## 05. 制御プログラム（カーネル）

### 制御プログラム（カーネル）の例

  カーネル，マイクロカーネル，モノリシックカーネル

<br>

### 通信管理

#### ・SELinux：Security Enhanced Linux

Linuxに標準で導入されているミドルウェア．ただし，アプリケーションと他のソフトウェアの通信を遮断してしまうことがあるため，基本的には無効にしておく．

1. SELinuxの状態を確認

```bash
$ getenforce

# 有効の場合
Enforcing
```

2. ```/etc/sellnux/config```を修正する．

```config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.

SELINUX=disabled <---- disabledに変更

# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

3. OSを再起動

OSを再起動しないと設定が反映されない．

<br>

### ジョブ管理

クライアントは，マスタスケジュールに対して，ジョブを実行するための命令を与える．

![ジョブ管理とタスク管理の概要](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ジョブ管理とタスク管理の概要.jpg)

<br>

### マスタスケジュラ，ジョブスケジュラ

ジョブとは，プロセスのセットのこと．マスタスケジュラは，ジョブスケジュラにジョブの実行を命令する．データをコンピュータに入力し，複数の処理が実行され，結果が出力されるまでの一連の処理のこと．『Task』と『Job』の定義は曖昧なので，『process』と『set of processes』を使うべきとのこと．

引用：https://stackoverflow.com/questions/3073948/job-task-and-process-whats-the-difference/31212568

複数のジョブ（プログラムやバッチ）の起動と終了を制御したり，ジョブの実行と終了を監視報告するソフトウェア．ややこしいことに，タスクスケジューラとも呼ぶ．

#### ・Reader

ジョブ待ち行列に登録

#### ・Initiator

ジョブステップに分解

#### ・Terminator

出力待ち行列に登録

#### ・Writer

優先度順に出力の処理フローを実行

<br>

### Initiatorによるジョブのジョブステップへの分解

Initiatorによって，ジョブはジョブステップに分解される．

![ジョブからジョブステップへの分解](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ジョブからジョブステップへの分解.png)

<br>

### タスク管理

![ジョブステップからタスクの生成](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ジョブステップからタスクの生成.png)

タスクとは，スレッドに似たような，単一のプロセスのこと．Initiatorによるジョブステップから，タスク管理によって，タスクが生成される．タスクが生成されると実行可能状態になる．ディスパッチャによって実行可能状態から実行状態になる．

#### ・優先順方式

各タスクに優先度を設定し，優先度の高いタスクから順に，ディスパッチしていく方式．

#### ・到着順方式

待ち行列に登録されたタスクから順に，ディスパッチしていく方式．

![到着順方式_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/到着順方式_1.png)

**＊具体例＊**

以下の様に，タスクがCPUに割り当てられていく．

![到着順方式_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/到着順方式_2.png)

#### ・Round robin 方式

Round robinは，『総当たり』の意味．一定時間（タイムクウォンタム）ごとに，実行状態にあるタスクが強制的に待ち行列に登録される．交代するように，他のタスクがディスパッチされる．

![ラウンドロビン方式](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/ラウンドロビン方式.png)

**＊具体例＊**

生成されたタスクの到着時刻と処理時間は以下のとおりである．強制的なディスパッチは，『20秒』ごとに起こるとする．

![優先順方式_1](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/優先順方式_1.png)

1. タスクAが0秒に待ち行列へ登録される．
2. 20秒間，タスクAは実行状態へ割り当てられる．
3. 20秒時点で，タスクAは実行状態から待ち行列に追加される．同時に，待ち行列の先頭にいるタスクBは，実行可能状態から実行状態にディスパッチされる．
4. 40秒時点で，タスクCは実行状態から待ち行列に追加される．同時に，待ち行列の先頭にいるタスクAは，実行可能状態から実行状態にディスパッチされる．

![優先順方式_2](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/優先順方式_2.png)

<br>

### 入出力管理

アプリケーションから低速な周辺機器へデータを出力する時，まず，CPUはスプーラにデータを出力する．Spoolerは，全てのデータをまとめて出力するのではなく，一時的に補助記憶装置（Spool）にためておきながら，少しずつ出力する（Spooling）．

![スプーリング](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/スプーリング.jpg)

