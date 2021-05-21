# コンテナ

## 01. Dockerによるコンテナの構築

### Dockerの操作

#### ・Dockerクライアント

Dockerクライアントは，接続によって，Dockerデーモンを操作できる．

#### ・Dockerデーモン

ホストOS上で稼働し，Dockerの操作を担う．Dockerクライアントは，Dockerデーモンを通して，Docker全体を操作できる．

![docker-daemon](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/docker-daemon.png)

<br>

## 02. コンテナに接続するまでの手順

### 手順の流れ

1. Docker Hubから，ベースとなるイメージをインストールする．
2. Dockerfileがイメージレイヤーからなるイメージをビルド．
3. コマンドによって，イメージ上にコンテナレイヤーを生成し，コンテナを構築．
4. コマンドによって，停止中のコンテナを起動．
5. コマンドによって，起動中のコンテナに接続．

![Dockerfileの作成からコンテナ構築までの手順](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Dockerfileの作成からコンテナ構築までの手順.png)

<br>

## 02-02. イメージのインストール

### ベースとなるイメージ（ベースイメージ）のインストール

#### ・Docker Hubとは

イメージは，実行OSによらずに一貫してビルドできるため，配布できる．Docker Hubには，カスタマイズする上でのベースとなるイメージが提供されている．

#### ・ベースイメージの種類

| イメージ   | 特徴                                                         | 相性の良いシステム例 |
| ---------------- | ------------------------------------------------------------ | -------------------- |
| **scratch**      | 以下の通り，何も持っていない<br>・OS：無<br>・パッケージ：無<br>・パッケージマネージャ：無 | ？                   |
| **BusyBox**      | ・OS：Linux（※ディストリビューションではない）<br>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：無 | 組み込みシステム     |
| **Alpine Linux** | ・OS：Linux（※ディストリビューションではない）<br/>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：Apk | ？                   |

#### ・対応可能なCPUアーキテクチャの種類

Dockerは全てのPCで稼働できるわけではなく，対応可能なCPUアーキテクチャ（AMD系，ARM系，など）がある．同じOSでも，機種ごとに搭載されるCPUアーキテクチャは異なる．例えば，MacBook 2020 にはIntel，またMacBook 2021（M1 Mac）にはARMベースの独自CPUが搭載されている．

参考：https://github.com/docker-library/official-images#architectures-other-than-amd64

#### ・バージョン

イメージのバージョンには種類があり，追跡できるバージョンアップが異なる．ここでは，composerのイメージを例に挙げる．

参考：https://hub.docker.com/_/composer/?tab=description&page=1&ordering=last_updated

| composerバージョンタグ | 追跡できるバージョンアップ                                   |
| ---------------------- | ------------------------------------------------------------ |
| ```2.0.9```            | バージョンを直指定し，追跡しない．                           |
| ```2.0```              | 「```2.0.X```」のマイナーアップデートのみを追跡する．        |
| ```2```                | 「```2.X```」と「```2.0.X```」のマイナーアップデートのみを追跡する． |
| ```latest```           | メジャーアップデートとマイナーアップデートを追跡する．       |

#### ・ベースイメージをインストール

**＊コマンド例＊**

レジストリ側に保管されているイメージを検索する．

```shell
$ docker search <イメージ名>
```

**＊コマンド例＊**

レジストリ側のイメージをクライアント側にインストールする．

```shell
$ docker pull <イメージ名>:<バージョン>
```

**＊コマンド例＊**

ホストOSにインストールされたイメージを確認する．

```shell
$ docker images
```

#### ・イメージを削除

**＊コマンド例＊**

コンテナに使用されていないイメージを一括で削除

```shell
$ docker image prune
```

**＊コマンド例＊**

タグ名のないイメージのみを全て削除する．

```shell
$ docker rmi --force $(sudo docker images --filter "dangling=true" --all --quiet)
```

<br>

## 02-03. イメージのビルド

### コマンド

#### ・イメージのビルド

**＊コマンド例＊**

キャッシュ無しで，指定のDockerfileを基に，イメージをビルドする．失敗した時は削除するように，```--force-rm```オプションを有効化する．

```shell
$ docker build --file Dockerfile \
--tag tech-notebook:latest \
--force-rm=true \
--no-cache \
.
```

#### ・Docker Hubに登録

**＊コマンド例＊**

ホストOSで作成したイメージをレジストリ側にアップロードする．

```shell
$ docker push <Docker Hubユーザ名>/<イメージ名>:<バージョンタグ>
```

#### ・イメージのデバッグ

**＊コマンド例＊**

ビルドに失敗したイメージからコンテナを構築し，接続する．```rm```オプションを設定し，接続の切断後にコンテナを削除する．Dockerfileにおいて，イメージのプロセスの起動コマンドを```ENTRYPOINT```で設定している場合は，後から上書きできなくなるため，```run```コマンドの引数として新しいコマンドを渡せずに，デバッグができないことがある．

```shell
$ docker run --rm -it <ビルドに失敗したイメージID> /bin/bash

# コンテナの中
root@xxxxxxxxxx: 
```

<br>

### イメージレイヤーの積み重ね

#### ・Dockerfileの仕組み

![イメージレイヤーからなるイメージのビルド](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/イメージのビルド.png)

任意のイメージをベースとして，新しいイメージをビルドするためには，ベースのイメージの上に，他のイメージレイヤーを積み重ねる必要がある．この時，Dockerfileを用いて，各命令によってイメージレイヤーを積み重ねていく．


#### ・Dockerfileの記述方法

任意のイメージをベースとして，新しいイメージをビルドするためには，以下の5つ順番で命令を用いて，イメージレイヤーを積み重ねていく．命令は，慣例的に大文字で記述する．

**＊実装例＊**

NginxのイメージをビルドするためのDockerfileを示す．命令のパラメータの記述形式には，文字列形式，JSON形式がある．ここでは，JSON形式で記述する．

```dockerfile
# ベースのイメージ（CentOS）を，コンテナにインストール
FROM centos:8

# ubuntu上に，nginxをインストール
RUN yum update -y \
   && yum install -y \
　　    nginx

# ホストOSの設定ファイルを，コンテナ側の指定ディレクトリにコピー
COPY infra/docker/web/nginx.conf /etc/nginx/nginx.conf

# nginxをデーモン起動
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

# 処理は発生しない．コンテナのポート番号80（HTTP）をドキュメンテーションとして記載
EXPOSE 80
```

| 命令                 | 処理                                                         |
| -------------------- | ------------------------------------------------------------ |
| **```FROM```**       | ベースのイメージを，コンテナにインストール.            |
| **```RUN```**        | ベースイメージ上に，ソフトウェアをインストール.              |
| **```COPY```**       | ・ホストOSのファイルをイメージレイヤー化し，コンテナの指定ディレクトリにコピー.<br>・イメージのビルド時にコピーされるだけで，ビルド後のコードの変更は反映されない．<br>・nginx.confファイル，php.iniファイル，などの設定ファイルをホストOSからコンテナにコピーしたい時によく使う． |
| **```CMD```**        | イメージのプロセスの起動コマンドを実行．```run```コマンドの引数として，上書きできる． |
| **```VOLUME```**     | Volumeマウントを行う．```COPY```とは異なり，ビルド後のコードの変更が反映される．Docker Composeで記述した方が良い． |
| **```EXPOSE```**     | 処理は発生しない．コンテナのポート番号をドキュメンテーションとして記載する． |
| **```ENTRYPOINT```** | イメージのプロセスの起動コマンドを実行．```CMD```とは異なり，後から上書き実行できない．使用者に，コンテナの起動方法を強制させたい場合に適する． |
| **```ENV```**        | OS上のコマンド処理で扱える変数を定義する．Dockerfileの命令では扱えない．```ARG```との違いの具体例については下記． |
| **```ARG```**        | Dockerfikeの命令で扱える変数を定義する．OS上のコマンド処理では扱えない．```ENV```との違いの具体例については下記． |
| **```ADD```**     | ・ホストOSのファイルを，コンテナの指定ディレクトリにコピー（**```COPY```と同じ**）<br>・インターネットからファイルをダウンロードし，解凍も行う．<br>・イメージのビルド時にコピーされるだけで，ビルド後のコードの変更は反映されない． |
| **```WORKDIR```** | 絶対パスによる指定で，現在のディレクトリを変更.              |

#### ・CMDの決め方

Dockerfileで```CMD```を指定しない場合，イメージのデフォルトのバイナリファイルが割り当てられる．一旦，デフォルトのバイナリファイルを確認した後に，これをDockerfileに明示的に実装するようにする．

```shell
CONTAINER ID   IMAGE   COMMAND     CREATED          STATUS         PORTS                    NAMES
2b2d3dfafee8   xxxxx   "/bin/sh"   11 seconds ago   Up 8 seconds   0.0.0.0:8000->8000/tcp   xxxxx
```

静的型付け言語ではプロセスの起動時に，代わりにアーティファクトのバイナリファイルを実行しても良い．その場合，```bin```ディレクトリにバイナリファイルとしてのアーティファクトを配置することになる．しかし，```bin```ディレクトリへのアクセス権限がないことがあるため，その場合は，一つ下にディレクトリを作成し，そこにバイナリファイルを置くようにする．

```shell
# /go/bin にアクセスできない時は，/go/bin/cmdにアーティファクトを置く．
ERROR: for xxx-container  Cannot start service go: OCI runtime create failed: container_linux.go:367: starting container process caused: exec: "/go/bin": permission denied: unknown

```

#### ・ENTRYPOINTの注意点

イメージのプロセスの起動コマンドを後から上書きできなくなるため，```run```コマンドの引数として新しいコマンドを渡せずに，デバッグができないことがある．

```shell
# 上書きできず，失敗してしまう．
$ docker run --rm -it <イメージ名> /bin/bash
```

#### ・ENVとARGの違い

一つ目に，```ENV```が使えて，```ARG```が使えない例．

```dockerfile
# ENVは，OS上のコマンド処理で扱える変数を定義
ARG PYTHON_VERSION="3.8.0"
RUN pyenv install ${PYTHON_VERSION}

# ARGは，OS上のコマンド処理では扱えない
ARG PYTHON_VERSION="3.8.0"
RUN pyenv install ${PYTHON_VERSION} # ===> 変数を展開できない
```

二つ目に，```ARG```が使えて，```ENV```が使えない例．

```dockerfile
# ARGは,Dockerfikeの命令で扱える変数を定義
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}

# ENVは，OS上のコマンド処理では扱えない
ENV OS_VERSION "8"
FROM centos:${OS_VERSION} # ===> 変数を展開できない
```

三つ目に，これらの違いによる可読性の悪さの対策として，```ENV```と```ARG```を組み合わせた例．

```dockerfile
# 最初に全て，ARGで定義
ARG CENTOS_VERSION="8"
ARG PYTHON_VERSION="3.8.0"

# 変数展開できる
FROM centos:${OS_VERSION}

# ARGを事前に宣言
ARG PYTHON_VERSION
# 必要に応じて，事前にENVに詰め替える．
ENV PYTHON_VERSION ${PYTHON_VERSION}

# 変数展開できる
RUN pyenv install ${PYTHON_VERSION}
```


#### ・Docker Hubに対する継続的インテグレーション

| 方法                  | 仕組み                                            |
| --------------------- | ------------------------------------------------- |
| GitHub Actions        | GitHubが，Docker Hubに対して，pushを行う．        |
| Circle CI             | GitHubが，Circle CIに対して，送信WebHookを行う．  |
| Docker Hub Auto Build | GitHubが，Docker Hubに対して，送信WebHookを行う． |

#### ・Dockerfileを使用するメリット

Dockerfileを用いない場合，各イメージレイヤーのインストールを手動で行わなければならない．しかし，Dockerfileを用いることで，これを自動化することができる．

![Dockerfileのメリット](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Dockerfileのメリット.png)

## 02-04 イメージの軽量化

### プロセス単位によるDockerfileの分割

これは，Dockerの原則である．アプリケーションを稼働させるには，最低限，Webサーバミドルウェア，アプリケーション，DBMSが必要である．これらを，個別のコンテナで稼働させ，ネットワークで接続するようにする．

![プロセス単位のコンテナ](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/プロセス単位のコンテナ.png)

<br>

### キャッシュを削除

Unixユーティリティをインストールすると，キャッシュが残る．

**＊実装例＊**


```dockerfile
FROM centos:8

RUN dnf upgrade -y \
  && dnf install -y \
      curl \
  # メタデータ削除
  && dnf clean all \
  # キャッシュ削除
  && rm -rf /var/cache/dnf
```

<br>


### ```RUN```コマンドをまとめる

Dockerfileの各命令によって，イメージ レイヤーが一つ増えてしまうため，同じ命令に異なるパラメータを与える時は，これを一つにまとめてしまう方が良い．例えば，以下のような時，

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y isntall httpd
RUN yum -y install php
RUN yum -y install php-mbstring
RUN yum -y install php-pear
```

これは，以下のように一行でまとめられる．イメージレイヤーが少なくなり，イメージを軽量化することができる．

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y install httpd php php-mbstring php-pear
```

さらに，これは以下のようにも書くことができる．

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y install \
     httpd \
     php \
     php-mbstring \
     php-pear
```

<br>

### マルチステージビルド

#### ・マルチステージビルドとは

一つのDockerfile内に複数の独立したステージを定義する方法．以下の手順で作成する．

1. シングルステージビルドに成功するDockerfileを作成する．
2. ビルドによって生成されたバイナリファイルがどこに配置されるかを場所を調べる．
3. Dockerfileで，二つ目の```FROM```を宣言する．
4. 一つ目のステージで，バイナリファイルをコンパイルするだけで終わらせる．
5. 二つ目のステージで，Unixユーティリティをインストールする．また，バイナリファイルを一つ目のステージからコピーする．

#### ・コンパイルされたバイナリファイルを再利用

**＊実装例＊**

```dockerfile
# 中間イメージ
FROM golang:1.7.3 AS builder
WORKDIR /go/src/github.com/alexellis/href-counter/
RUN go get -d -v golang.org/x/net/html  
COPY app.go    .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# 最終イメージ
FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/alexellis/href-counter/app .
CMD ["./app"]  
```

#### ・実行環境別にステージを分ける

**＊実装例＊**

```dockerfile
#===================
# Global ARG
#===================
ARG NGINX_VERSION="1.19"
ARG LABEL="Hiroki <hasegawafeedshop@gmail.com>"

#===================
# Build Stage
#===================
FROM nginx:${NGINX_VERSION} as build

RUN apt-get update -y \
  && apt-get install -y \
     curl \
     vim \
  # キャッシュ削除
  && apt-get clean

#===================
# Develop Stage
#===================
FROM build as develop
LABEL mantainer=${LABEL}

COPY ./infra/docker/www/develop.nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

#===================
# Production Stage
#===================
FROM build as production
LABEL mantainer=${LABEL}

COPY ./infra/docker/www/production.nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

```

<br>

### 可能な限りOSイメージをベースとしない

#### ・OSイメージをベースとした場合（悪い例）

OSベンダーが提供するベースイメージを使用すると，不要なバイナリファイルが含まれてしまう．原則として，一つのコンテナで一つのプロセスしか実行せず，OS全体のシステムは不要なため，OSイメージをベースとしないようにする．

**＊実装例＊**

```dockerfile
# CentOSイメージを，コンテナにインストール
FROM centos:8

# PHPをインストールするために，EPELとRemiリポジトリをインストールして有効化．
RUN dnf upgrade -y \
  && dnf install -y \
      https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
      https://rpms.remirepo.net/enterprise/remi-release-8.rpm \
  && dnf module enable php:remi-${PHP_VERSION} \
  # フレームワークの要件のPHP拡張機能をインストール
  && dnf install -y \
      php \
      php-bcmath \
      php-ctype \
      php-fileinfo \
      php-json \
      php-mbstring \
      php-openssl \
      php-pdo \
      php-tokenizer \
      php-xml \
  && dnf clean all \
  && rm -Rf /var/cache/dnf

# DockerHubのComposerイメージからバイナリファイルを取得
COPY --from=composer /usr/bin/composer /usr/bin/composer
```

**＊実装例＊**

```dockerfile
# CentOSイメージを，コンテナにインストール
FROM centos:8

# nginxをインストール
RUN dnf upgrade -y \
　　&& dnf install -y \
　　   nginx \
　　   curl \
　　&& dnf clean all \
　　&& rm -Rf /var/cache/dnf

COPY infra/docker/web/nginx.conf /etc/nginx/nginx.conf

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

EXPOSE 80
```

#### ・ミドルウェアイメージをベースとした場合（良い例）

代わりに，ミドルウェアベンダーが提供するベースイメージを使用するようにする．

**＊実装例＊**

```dockerfile
# Nginxイメージを，コンテナにインストール
FROM nginx:1.19

# NginxイメージがUbuntuベースなためにapt-getコマンド
RUN apt-get updatedocke -y \
  && apt-get install -y \
     curl \
  && apt-get clean

COPY ./infra/docker/www/production.nginx.conf /etc/nginx/nginx.conf
```

#### ・言語イメージをベースとした場合

代わりに，言語ベンダーが提供するベースイメージを使用するようにする．

```dockerfile
# ここに実装例
```

#### ・alpineイメージをベースとした場合

```dockerfile
# ここに実装例
```

<br>

## 02-05. イメージ上でのコンテナレイヤーの生成，コンテナの構築

### コンテナレイヤーの生成

#### ・コンテナレイヤーとは

イメージレイヤーの上に積み重ねられる

![イメージ上へのコンテナレイヤーの積み重ね](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/イメージ上へのコンテナレイヤーの積み重ね.png)

<br>

### コマンド

#### ・コンテナレイヤー生成，コンテナ構築

**＊コマンド例＊**

コンテナレイヤーを生成し，コンテナを構築．起動はしない．

```shell
$ docker create <コンテナ名> <使用イメージ名>:<タグ>
```

#### ・停止中のコンテナを起動

コンテナを起動する．```start```コマンドでは，アタッチモードによる起動しかできない．

**＊コマンド例＊**

停止中コンテナをアタッチモードによって起動する．

```shell
$ docker start -i <停止中コンテナ名>
```

#### ・停止中のコンテナを削除

**＊コマンド例＊**

停止中のコンテナのみを全て削除する．

```shell
$ docker container prune
```

起動中／停止中の全てコンテナを削除する．

```shell
$ docker rm --force $(docker ps --all --quiet)
```

#### ・停止中のコンテナからイメージを作成

**＊コマンド例＊**

コンテナからイメージを作成する．

```shell
$ docker commit <コンテナ名> <コンテナID>

$ docker commit <コンテナ名> <Docker Hubユーザ名>/<イメージ名>:<バージョンタグ>
```

<br>

## 02-06. 起動中のコンテナの操作

### コマンド

#### ・起動中のコンテナ情報を表示

**＊コマンド例＊**

コンテナの起動と停止にかかわらず，IDなどを一覧で表示．

```shell
$ docker ps -a
```

**＊コマンド例＊**

起動中コンテナの全ての設定内容を表示する．```grep```とも組み合わせられる．

```shell
$ docker inspect <コンテナID>
$ docker inspect <コンテナID> | grep IPAddress
```

#### ・起動中のコンテナを停止

**＊コマンド例＊**

起動中コンテナを停止する．

```shell
$ docker stop <起動中コンテナ名>
```

**＊コマンド例＊**

全てのコンテナを停止する．

```shell
$ docker stop $(docker ps --all --quiet)
```

#### ・起動中のコンテナに接続

**＊コマンド例＊**

デタッチドモードによって，起動中のコンテナに接続する．

```shell
$ docker attach <起動中コンテナ名>
```

#### ・起動中のコンテナ内でコマンドを実行

**＊コマンド例＊**

デタッチドモードによって，起動中のコンテナ内でコマンドを実行する．実行するコマンドが```shell```や```bash```の場合，コンテナに接続できる．

```shell
# i：interactive，t：tty（対話モード）
$ docker exec -it <起動中コンテナ名> /bin/bash

# イメージ内に/bin/bash がない場合
$ docker exec -it <起動中コンテナ名> /bin/sh
```

#### ・起動中のコンテナにホストOSのファイルをコピー

Dockerfileの```COPY```コマンドを使用してコンテナ内に配置しているファイルに関して，変更のたびにイメージをビルドを行うことは面倒のため，ホストOSからコンテナにコピーし，再読み込みを行う．ただし，コンテナを再構築すると元に戻ってしまうことに注意．

**＊コマンド例＊**

```shell
# ホストのファイルをコンテナにコピー
$ docker cp ./docker/www/nginx.conf <コンテナID>:/etc/nginx/nginx.conf

# コンテナに接続後に，nginxの設定ファイルを再読み込み．
$ docker exec -it <コンテナ名> bin/bash # もしくはbin/sh
[root@<ホスト名>:~] $ nginx -s reload
[root@<ホスト名>:~] $ exit

# アクセスログを確認
$ docker logs <コンテナ名>
```

<br>

### 接続コマンドの違い

#### ・attach

**＊コマンド例＊**

起動中のコンテナに接続する．```exit```コマンドを使用して，コンテナとの接続を切断した後，コンテナが停止してしまう．

```shell
# デタッチドモードによる起動
$ docker run -d -it --name <コンテナ名> <使用イメージ名>:<タグ> /bin/bash

# デタッチドモードによって起動中のコンテナに接続
$ docker attach <起動中コンテナ名>

# PID=1で，1つの/bin/bashプロセスが稼働していることが確認できる
[root@<ホスト名>:~] ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  16152  3872 pts/0    Ss+  18:06   0:00 /bin/bash
root        33  0.0  0.1  45696  3732 pts/1    R+   18:22   0:00 ps aux

# コンテナとの接続を切断
[root@<ホスト名>:~] exit

# コンテナの状態を確認
$ docker container ps -a --no-trunc # ==> コンテナのSTATUSがEXITedになっている
```

#### ・exe

**＊コマンド例＊**

起動中のコンテナでコマンドを実行する．実行するコマンドが```shell```や```bash```の場合，コンテナに接続できる．```exit```コマンドを使用して，コンテナとの接続を切断した後でも，コンテナが起動し続ける．

```shell
# デタッチドモードによる起動
$ docker run -d -it --name <コンテナ名> <使用イメージ名>:<タグ> /bin/bash

# 対話モードを使用して，デタッチドモードによって起動中のコンテナに接続
$ docker exec -it <起動中コンテナ名> /bin/bash # もしくはbin/sh

# PID=1,17で，2つの/bin/bashプロセスが稼働していることが確認できる
[root@<ホスト名>:~] ps aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.1  16152  3872 pts/0    Ss+  18:06   0:00 /bin/bash
root        17  0.0  0.1  16152  4032 pts/1    Ss   18:21   0:00 /bin/bash
root        34  0.0  0.1  45696  3732 pts/1    R+   18:22   0:00 ps aux

# コンテナとの接続を切断
[root@<ホスト名>:~] exit

# コンテナの状態を確認
$ docker container ps -a --no-trunc # ==> コンテナのSTATUSがUPになっている
```

<br>

## 02-07. コンテナ構築とコンテナ操作

### コマンド

#### ・コンテナを新しく構築し，コンテナ内でコマンドを実行

すでに停止中または起動中のコンテナが存在していても，これとは別にコンテナを新しく構築し，起動する．さらにそのコンテナ内でコマンドを実行する．起動時に```shell```プロセスや```bash```プロセスを実行すると，コンテナに接続できる．何も渡さない場合は，デフォルトのプロセスとして```shell```プロセスが実行される．```run```コマンドでは，アタッチモードとデタッチモードを選ぶことができる．新しく起動したコンテナを停止後に自動削除する場合は，```rm```オプションを付けるようにする．

**＊コマンド例＊**

```shell
# アタッチモードによる起動．フォアグラウンドで起動する．
$ docker run -a -it --rm --name <コンテナ名> <使用イメージ名>:<タグ> /bin/bash

# デタッチドモードによる起動．バックグラウンドで起動する．
$ docker run -d -it --rm --name <コンテナ名> <使用イメージ名>:<タグ> /bin/bash
```

コンテナを起動する時に，```bash```プロセスを実行すると以下のようなエラーが出ることがある．その場合は，```shell```プロセスを実行するようにする．

```shell
docker: Error response from daemon: OCI runtime create failed: container_linux.go:370: starting container process caused: exec: "/bin/bash": stat /bin/bash: no such file or directory: unknown.
```

<br>

### 起動モードの違い

#### ・アタッチモード起動

アタッチモードは，フォアグラウンド起動である．ターミナルにプロセスのログが表示されないため，同一ターミナルで他のコマンドを入力できる．

**＊コマンド例＊**

```shell
# -a：atattch mode
$ docker run -a -it --name <コンテナ名> <使用イメージ名>:<タグ> /bin/bash
```

#### ・デタッチドモード起動

デタッチドモードは，バックグラウンド起動である．ターミナルにプロセスのログが表示され続けるため，同一ターミナルで他のコマンドを入力できない．プロセスのログを監視できるが，他のプロセスを入力するためには，そのターミナル上でコンテナを停止させる必要がある．

**＊コマンド例＊**


```shell
# -d；detached mode
$ docker run -d -it --name <コンテナ名> <使用イメージ名>:<タグ> /bin/bash
```

<br>

## 03. コンテナ側に対するマウント方法

### Bindマウント

#### ・Bindマウントとは

ホストOSの```/Users```ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，非推奨である．また，Dockerfileまたはdocker-composeファイルに記述する方法があるが，後者が推奨である．

![bindマウント](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/bindマウント.png)

**＊コマンド例＊**

```shell
# ホストOSをコンテナ側にbindマウント
$ docker run -d -it --name <コンテナ名> /bin/bash \
--mount type=bind, src=home/projects/<ホストOS側のディレクトリ名>, dst=/var/www/<コンテナ側のディレクトリ名>
```

#### ・マウント元として指定できるディレクトリ

以下の通り，ホストOSのマウント元のディレクトリにはいくつか選択肢がある．

![マウントされるホスト側のディレクトリ](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/マウントされるホスト側のディレクトリ.png)

<br>

### Volumeマウント

#### ・Volume（Data Volume），Dockerエリアとは

ホストOSのDockerエリア（```/var/lib/docker/volumes```ディレクトリ）に保存される永続データのこと．Data Volumeともいう．Volumeへのパス（```/var/lib/docker/volumes/<Volume名>/_data```）は，マウントポイントという．

#### ・Volumeマウントとは

ホストOSにあるDockerエリアのマウントポイントをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として推奨である．

![volumeマウント](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/volumeマウント.png)

**＊コマンド例＊**

Docker Composeで行うことが推奨されている．

```shell
# ホストOSのDockerエリアにVolumeを作成
$ docker volume create <Volume名>
```
```shell
# DockerエリアのVolumeの一覧を表示
$ docker volume ls
```
```shell
# DockerエリアのVolumeを削除
$ docker volume rm <Volume名>
```
```shell
# DockerエリアのVolumeの詳細を表示
$ docker volume inspect <Volume名>

[
    {
        "CreatedAt": "2020-09-06T15:04:02Z",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.project": "<プロジェクト名>",
            "com.docker.compose.version": "1.26.2",
            "com.docker.compose.volume": "xxx"
        },
        "Mountpoint": "/var/lib/docker/volumes/<プロジェクト名>_xxx/_data",
        "Name": "<プロジェクト名>_xxx",
        "Options": null,
        "Scope": "local"
    }
]
```
```shell
# DockerエリアをVolumeマウントして起動
# マウントポイントのVolume名を使用
$ docker run -d -it --name <コンテナ名> /bin/bash \
--mount type=volume, src=<ホストOS側Volume名> volume-driver=local, dst=<コンテナ側ディレクトリ>
```

**＊実装例＊**

DockerfileでVolumeマウントを行う場合，マウント先のコンテナ側ディレクトリ名を指定する．Dockerエリアのマウントポイントは，自動的に作成される．Docker Composeで行うことが推奨されている．

```dockerfile
FROM ubuntu
RUN mkdir /myvol
RUN echo "hello world" > /myvol/greeting

# マウント先のコンテナ側ディレクトリ名
VOLUME /myvol
```

#### ・Data Volumeコンテナによる永続化データの提供

Volumeを使用する場合のコンテナ配置手法の一つ．DockerエリアのVolumeをData Volumeをコンテナ （Data Volumeコンテナ）のディレクトリにマウントしておく．Volumeを使用する時は，Dockerエリアを参照するのではなく，Data Volumeコンテナを参照するようにする．

![data-volumeコンテナ](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/data-volumeコンテナ.png)

**＊実装例＊**

```yaml
# ここに実装例
```

<br>

### 一時ファイルシステムマウント

<br>


## 04. ホストとコンテナの間のネットワーク接続

### bridgeネットワーク

#### ・bridgeネットワークとは

複数のコンテナ間に対して，仮想ネットワークで接続させる．また，仮想ネットワークを物理ネットワークの間を，仮想ブリッジを用いてbridge接続する．ほとんどの場合，この方法を用いる．

![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Dockerエンジン内の仮想ネットワーク.jpg)

物理サーバへのリクエストメッセージがコンテナに届くまでを以下に示す．ホストOSの```8080```番ポートと，WWWコンテナの```80```番ポートのアプリケーションの間で，ポートフォワーディングを行う．これにより，```http://<ホストOSのプライベートIPアドレス（localhost）>:8080```にリクエストを送信すると，WWWコンテナのポート番号に転送されるようになる．

| 順番  | リクエストメッセージの流れ | プライベートIPアドレス例                             | ポート番号例 |
| :---: | :------------------------- | :--------------------------------------------------- | ------------ |
| **4** | WWWコンテナ                | ・```127.0.0.1```（localhost）<br>・hostnameの設定値 | ```:80```    |
|       | ↑                          |                                                      |              |
| **3** | 仮想ネットワーク           | ```172.XX.XX.XX```                                   |              |
|       | ↑                          |                                                      |              |
| **2** | 仮想ブリッジ               |                                                      |              |
|       | ↑                          |                                                      |              |
| **1** | ホストOS                   | ```127.0.0.1```（localhost）                         | ```:8080```  |

#### ・ネットワークの接続方法確認

**＊コマンド例＊**

```shell
$ docker network ls

NETWORK ID          NAME                    DRIVER              SCOPE
ae25b9b7740b        bridge                  bridge              local
aeef782b227d        tech-notebook_default   bridge              local
```

#### ・コンテナへのホスト名割り当て

コンテナ内の```etc/hosts```ファイルで，コンテナのプライベートIPアドレスを確認できる．```--hostname```オプションで命名していればその名前，指定していなければランダムな文字列が割り当てられる．

**＊コマンド例＊**

```shell
$ docker run -d -it --hostname <ホスト名> --name <コンテナ名> <使用するイメージ名>:<タグ> /bin/bash
$ docker exec -it <起動中コンテナ名> /bin/bash

[root@<ホスト名>:/] cat /etc/hosts

127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.18.0.2	<ホスト名>
```

#### ・未使用のネットワークを削除

```sh
$ docker network prune
```

#### ・ネットワークに接続するコンテナを確認

複数のコンテナが起動している時に，コンテナがいずれのネットワークを使用しているかを確認する．

```shell
$ docker network inspect <ネットワーク名>
```

<br>

### noneネットワーク

#### ・noneネットワークとは

特定のコンテナを，ホストOSや他のコンテナとは，ネットワーク接続させない．

**＊コマンド例＊**


```shell
$ docker network list

NETWORK ID          NAME                    DRIVER              SCOPE
7edf2be856d7        none                    null                local
```

<br>


### hostネットワーク

#### ・hostネットワークとは

特定のコンテナに対して，ホストOSと同じネットワーク情報をもたせる．

**＊コマンド例＊**

```shell
$ docker network list

NETWORK ID          NAME                    DRIVER              SCOPE
ac017dda93d6        host                    host                local
```

<br>

### コンテナ間の接続方法

#### ・『ホストOS』から『ホストOS（```localhost```）』にリクエスト

『ホストOS』から『ホストOS』に対して，アウトバウンドなリクエストを送信する．ここでのホストOSのホスト名は，『```localhost```』となる．リクエストは，ポートフォワーディングされたコンテナに転送される．ホストOSとコンテナの間のネットワーク接続の成否を確認できる．

**＊コマンド例＊**

『ホストOS』から『ホストOS』に対してアウトバウンドなリクエストを送信し，ホストOSとappコンテナの間の成否を確認する．

```shell
# ホストOSで実行
$ curl --fail http://localhost:8080/
```

#### ・『コンテナ』から『コンテナ』にリクエスト

『コンテナ』から『コンテナ』に対して，アウトバウンドなリクエストを送信する．ここでのコンテナのホスト名は，コンテナ内の『```/etc/hosts```』に定義されたものとなる．リクエストはホストOSを経由せず，そのままコンテナに送信される．コンテナ間のネットワーク接続の成否を確認できる．コンテナのホスト名の定義方法については，以下を参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/infrastructure_virtualization_container_orchestration.html

**＊コマンド例＊**

『appコンテナ』から『nginxコンテナ』に対して，アウトバウンドなリクエストを送信し，appコンテナとnginxコンテナの間の成否を確認する．

```shell
# コンテナ内で実行
$ curl --fail http://<nginxコンテナに割り当てたホスト名>:80/
```

#### ・『コンテナ』から『ホストOS（```host.docker.internal```）』にリクエスト

『コンテナ』から『ホストOS』に対して，アウトバウンドなリクエストを送信する．ここでのホストOSのホスト名は，『```host.docker.internal```』になる．リクエストは，ホストOSを経由して，ポートフォワーディングされたコンテナに転送される．ホストOSとコンテナの間のネットワーク接続の成否を確認できる．

```shell
# コンテナ内で実行
$ curl --fail http://host.docker.internal:8080/
```

<br>

## 05. プラグイン

### Volumeプラグイン

#### ・NFSストレージ

NFSプラグインを使用することで，永続化データを```/var/lib/docker/volumes```ではなく，NFSストレージに保存する．

**＊実装例＊**

以下にdocker-composeを使用した場合を示す．docker-composeについては，コンテナオーケストレーションのノートを参照．

```yaml
version: "3.7"

services:
  app:
    build: # 省略
    ports: # 省略
    depends_on: # 省略
    volumes:
      - example:/data # 下方のオプションが適用される．
      
volumes:
  example:
    driver_opts: # NFSプラグインを使用し，NFSストレージに保存．
      type: "nfs"
      o: "addr=10.40.0.199,nolock,soft,rw"
      device: ":/nfs/example"
```

<br>

## 06. ロギング

### 各ベンダーのイメージのログ出力先

#### ・nginxイメージ

公式のnginxイメージは，```/dev/stdout```というシンボリックリンクを，```/var/log/nginx/access.log```に作成している．また，```/dev/stderr```というシンボリックリンクを，```/var/log/nginx/error.log```に作成している．これにより，これらのファイルに対するログの出力は，```/dev/stdout```と```/dev/stderr```に転送される．

#### ・php-fpmイメージ

要勉強．

<br>

### コマンド

#### ・docker logsの参照先ディレクトリ

コンテナ内の```/dev/stdout```と```/dev/stderr```に出力されたログをまとめて表示する．

#### ・指定したコンテナのログを確認

**＊コマンド例＊**

```shell
# 指定した行数だけ，ログを表示する．
$ docker logs --follow=true --tail=500 <コンテナ名>
```

<br>

### ロギングドライバー

#### ・ロギングドライバーとは

コンテナ内の```/dev/stdout```と```/dev/stderr```に出力されたログを，ファイルやAPIに対して出力する．

| ロギングドライバー名 | ログの出力先                                                 | 備考                                      |
| -------------------- | ------------------------------------------------------------ | ----------------------------------------- |
| json-file            | ```/var/lib/docker/containers/＜コンテナID＞/＜コンテナID＞-json.log```ファイル | デフォルトの設定．                        |
| none                 | ログを記録しない．                                           |                                           |
| awslogs              | CloudWatch LogsのAPI                                         | ```docker logs```コマンドで確認できない． |
| gcplogs              | Google Cloud LoggingのAPI                                    | ```docker logs```コマンドで確認できない． |

