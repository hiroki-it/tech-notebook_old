# 仮想サーバ(仮想マシン)とコンテナの構築

## 01-01. Providerによる仮想サーバ（仮想マシン）の構築

![Vagrantの仕組み_オリジナル](https://user-images.githubusercontent.com/42175286/60393574-b18de200-9b52-11e9-803d-ef44d6e50b08.png)



### :pushpin: Providerの操作

#### ・Providerとは

基本ソフトウェアにおける制御プログラムや一連のハードウェアを仮想的に構築できる．これを，仮想サーバ（仮想マシンとも）という．構築方法の違いによって，『ホスト型』，『ハイパーバイザ型』に分類できる．



### :pushpin: Provisionerの操作

#### ・Provisionerとは

Providerによって構築された仮想サーバに，Web開発のためのソフトウェアをインストールすることができる（構成管理することができる）．具体的には，プログラミング言語やファイアウォールをインストールする．



### :pushpin: VagrantによるProviderとProvisionerの操作

#### ・Vagrantとは

ProviderとProvisionerの操作を自動化できる．チームメンバーが別々に仮想サーバを構築する場合，ProviderとProvisionerの処理によって作られる仮想サーバの環境に，違いが生じてしまう．Vagrantを使う場合，ProviderとProvisionerによる処理方法は，Vagrantfileに記述されている．このために，Vagrantを用いれば，チームメンバーが同じソフトウェアの下で，仮想サーバを構築し，ソフトウェアをインストールすることができる．

#### ・サーバの情報の管理方法

サーバの情報は，ENVファイルで以下の様に管理する．

```php
#=======================================
# Webサーバ情報
#=======================================
WEB_HOST="XXX.X.X.X"

#=======================================
# データベースサーバ情報
#=======================================
DB_HOST="YYY.Y.Y.Y"
DB_NAME="example"
DB_USER="hiroki"
DB_PASSWORD="12345"
```

#### ・主な```vagrant```コマンド

| コマンド                        | 処理                       |
| ------------------------------- | :------------------------- |
| **```vagrant up```**            | 仮想サーバ起動             |
| **```vagrant halt```**          | 仮想サーバ停止             |
| **```vagrant ssh```**           | 仮想サーバへのリモート接続 |
| **```vagrant global-status```** | 起動中仮想サーバの一覧     |



## 02-01. Symfonyによるビルトインサーバの構築



## 03-01. Dockerによるコンテナの構築

### :pushpin: Dockerの操作

#### ・Dockerクライアント

Dockerクライアントは，ssh接続によって，Dockerデーモンを操作できる．

#### ・Dockerデーモン

ホストOS上で稼働し，Dockerの操作を担う．Dockerクライアントは，Dockerデーモンを通して，Docker全体を操作できる．

![Dockerの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerの仕組み.png)



## 03-02. コンテナにssh接続するまでの手順

### :pushpin: 手順の流れ

![Dockerfileの作成からコンテナ構築までの手順](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerfileの作成からコンテナ構築までの手順.png)

1. DockerHubから，ベースとなるDockerイメージをインストールする．
2. DockerfileがイメージレイヤーからなるDockerイメージをビルド．
3. コマンドによって，Dockerイメージ上にコンテナレイヤーを生成し，コンテナを構築．
4. コマンドによって，構築されたコンテナを起動．
5. コマンドによって，起動中のコンテナにssh接続．



### :pushpin: ベースとなるDockerイメージのインストール

#### ・DockerHubとは

DockerHubには，カスタマイズする上でのベースとなるDockerイメージが提供されている．

#### ・ベースとなるDockerイメージの種類

| Dockerイメージ   | 特徴                                                         | 相性の良いシステム例 |
| ---------------- | ------------------------------------------------------------ | -------------------- |
| **scratch**      | 以下の通り，何も持っていない<br>・OS：無<br>・パッケージ：無<br>・パッケージマネージャ：無 | ？                   |
| **BusyBox**      | ・OS：Linux（※ディストリビューションではない）<br>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：無 | 組み込みシステム     |
| **Alpine Linux** | ・OS：Linux（※ディストリビューションではない）<br/>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：Apk | ？                   |

#### ・ベースとなるDockerイメージに関するコマンド


| コマンド                                                     | 処理                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```docker search {イメージ名}```**                         | レジストリ側に保管されているDockerイメージを検索．           |
| **```docker pull {イメージ名}```**                           | レジストリ側のDockerイメージをクライアント側にインストール． |
| **```docker commit -a {作成者名} {コンテナ名} {DockerHubユーザ名}/{イメージ名}:{バージョンタグ}```** | コンテナからDockerイメージを作成．                           |
| **```docker push {DockerHubユーザ名}/{イメージ名}:{バージョンタグ}```** | ホストOSで作成したDockerイメージをレジストリ側にアップロード． |
| **```docker images```**                                      | ホストOSにインストールされたDockerイメージを確認．           |
| **```docker image prune```**                                 | 未使用のDockerイメージを一括で削除．                         |




### :pushpin: ベースとなるDockerイメージのカスタマイズとビルド

#### ・DockerイメージのカスタマイズとDockerfile

![イメージレイヤーからなるDockerイメージのビルド](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/イメージレイヤーからなるDockerイメージのビルド.png)

任意のDockerイメージをベースとして，新しいDockerイメージをビルドするためには，ベースのイメージの上に，他のイメージレイヤーを積み重ねる必要がある．この時，Dockerfileを用いて，各命令によってイメージレイヤーを積み重ねていく．

#### ・Dockerfileの記述方法

任意のDockerイメージをベースとして，新しいDockerイメージをビルドするためには，以下の5つ順番で命令を用いて，イメージレイヤーを積み重ねていく．命令は，慣例的に大文字で記述する．

| 命令             | 処理                                                         |
| ---------------- | ------------------------------------------------------------ |
| **```FROM```**   | ベースのDockerイメージを，コンテナにインストール.            |
| **```RUN```**    | ベースイメージ上に，ソフトウェアをインストール.              |
| **```COPY```**   | ホストOSのファイルをイメージレイヤー化し，コンテナの指定ディレクトリにコピー.マウントとは異なるので注意． |
| **```CMD```**    | イメージレイヤーをデーモン起動.                              |
| **```EXPOSE```** | 開放するポート番号を指定.                                    |

必須ではないその他の命令には，以下がある．

| 命令              | 処理                                                         |
| ----------------- | ------------------------------------------------------------ |
| **```ADD```**     | ・ホストOSのファイルを，コンテナの指定ディレクトリにコピー（**```COPY```と同じ**）<br>・インターネットからファイルをダウンロードし，解凍も行う． |
| **```WORKDIR```** | 絶対パスによる指定で，現在のディレクトリを変更.              |

**【nginxのDockerイメージの例】**

ubuntuのDockerイメージをベースとして，nginxのDockerイメージをビルドするためのDockerfileを示す．命令のパラメータの記述形式には，文字列形式，JSON形式がある．ここでは，JSON形式で記述する．

```dockerfile
# ベースのDockerイメージ（ubuntu）を，コンテナにインストール
FROM ubuntu:latest

# ubuntu上に，nginxをインストール
RUN apt-get update && apt-get install -y -q nginx

# ホストOSのindex.htmlファイルを，Dockerコンテナの指定ディレクトリにコピー
COPY index.html /var/www/html

# nginxをデーモン起動
CMD ["nginx -g daemon off"]

# ポート番号80（HTTP）を開放
EXPOSE 80
```

#### ・Dockerfileの記述方法の工夫

Dockerfileの各命令によって，イメージ レイヤーが一つ増えてしまうため，同じ命令に異なるパラメータを与える時は，これを一つにまとめてしまう方が良い．例えば，以下のような時，

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y isntall httpd
RUN yum -y install php
RUN yum -y install php-mbstring
RUN yum -y install php-pear
```

これは，以下のように一行でまとめられ...

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y install httpd php php-mbstring php-pear
```

さらに，これは以下のようにも書くことができる．

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y install\
     httpd\
     php\
     php-mbstring\
     php-pear
```

#### ・Dockerイメージのビルドを行うコマンド

| コマンド                                          | 処理                                                         | 注意点                         |
| ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------ |
| **```docker build -f Dockerfile --no-cache .```** | キャッシュ無しで，指定のDockerfileを基に，Dockerイメージをビルド | コマンド最後のドットを忘れない |

#### ・Dockerfileを使用するメリット

Dockerfileを用いない場合，各イメージレイヤーのインストールを手動で行わなければならない．しかし，Dockerfileを用いることで，これを自動化することができる．![Dockerfileのメリット](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerfileのメリット.png)



### :pushpin: コンテナレイヤーの生成，コンテナの構築

Dockerイメージの上にコンテナレイヤーを生成し，コンテナを構築する．

#### ・コンテナレイヤーの生成，コンテナの構築，に関するコマンド

| コマンド                      | 処理                                                     |
| ----------------------------- | -------------------------------------------------------- |
| **```create {イメージ名}```** | コンテナレイヤーを生成し，コンテナを構築．起動はしない． |

![Dockerイメージ上へのコンテナレイヤーの積み重ね](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerイメージ上へのコンテナレイヤーの積み重ね.png)


#### ・ビルドされるDockerイメージとコンテナの役割の対応例

| ビルドされるDockerイメージ | コンテナの役割               |
| :------------------------- | :--------------------------- |
| Redis                      | **NoSQL（非RDB）**           |
| MySQL                      | **RDBMS**                    |
| Nginx                      | **Webサーバソフトウェア**    |
| PHP-FPM                    | **APサーバソフトウェア**     |
| MailDev                    | **メールサーバソフトウェア** |



### :pushpin: 構築されたコンテナの起動／停止

#### ・構築されたコンテナの操作に関するコマンド

| コマンド               | 処理                       |
| :--------------------- | -------------------------- |
| **```docker start```** | 既存コンテナを起動         |
| **```docker stop```**  | 起動中コンテナを停止       |
| **```docker ps```**    | 起動中コンテナの一覧で表示 |



### :pushpin: 起動中のコンテナにssh接続

#### ・起動中のコンテナへのssh接続に関するコマンド

| コマンド                                    | 処理                      | 注意点                   |
| ------------------------------------------- | ------------------------- | ------------------------ |
| **```docker exec -it {コンテナ名} bash```** | 起動中のコンテナにssh接続 | i：interactive<br>t：tty |



## 03-03. コンテナ側に対するファイルのマウント方法

### :pushpin: ホストOSのマウント元のディレクトリの設定画面

以下の通り，ホストOSのマウント元のディレクトリにはいくつか選択肢がある．

![マウントされるホスト側のディレクトリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マウントされるホスト側のディレクトリ.png)



### :pushpin: Bindマウント

#### ・Bindマウントとは

ホストOSにある```/Users```ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，非推奨である．



### :pushpin: Volumeマウント

#### ・```/Volumes```とは

ホストOSの```/Volumes```には，開発途中にコンテナ側で作成されたデータのうち，ホストOSに永続化したいデータが保存される．Data Volumeともいう．

#### ・Volumeマウントとは

ホストOSにある```/Volumes```ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，推奨である．

#### ・Data Volumeコンテナによる永続化データの提供

一旦，Data Volumeをコンテナ （Data Volumeコンテナ）のディレクトリにマウントしておく．そして，他のコンテナでDataVolumeを使用したい時は，Data Volumeコンテナとディレクトリを共有することによって，データを要求する．




### :pushpin: 一時ファイルシステムマウント






## 03-04. コンテナ間の仮想ネットワーク

### :pushpin: bridgeネットワーク

#### ・bridgeネットワークとは

複数のコンテナ間に対して，仮想ネットワークで接続させる．また，仮想ネットワークを物理ネットワークとBridge接続する．ほとんどの場合，この方法を用いる．

![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerエンジン内の仮想ネットワーク.jpg)



### :pushpin: noneネットワーク

#### ・noneネットワークとは

特定のコンテナに対して，ホストOSや他のコンテナとは，ネットワーク接続しない．



### :pushpin: hostネットワーク

#### ・hostネットワークとは

特定のコンテナに対して，ホストOSと同じネットワーク情報をもたせる．



## 03-05. Docker Composeによるオーケストレーション

### :pushpin: docker-compose.yml

#### ・docker-compose.ymlとは 

異なるDockerfileを基にしたDockerイメージのビルド，コンテナレイヤーの生成，コンテナの構築，コンテナの起動，について，一連の手順を自動的に実行するための設定ファイル．

#### ・設定項目と記述例

| 記述項目                  | 意味                                                         |
| :------------------------ | :----------------------------------------------------------- |
| **```container_name:```** | コンテナ名の命名                                             |
| **```build:```**          | Dockerfileのディレクトリの相対パス．                         |
| **```tty:```** |  |
| **```image:```**          | ベースイメージをそのまま使用する場合の設定．                 |
| **```ports:```**           | ```{ホストOSのポート番号}:{コンテナのポート番号}```<br>マウントするディレクトリ間をマッピング．コンテナのみポート番号を指定した場合，ホストOSのポート番号はランダムになる． |
| **```volumes:```**         | ```{ホストOSのディレクトリ}:{コンテナのディレクトリ}```<br>ホストOSの```/var/lib/docker/volumes/```の下にDataVolumeのディレクトリを作成し，DataVolumeをマウントするコンテナ側のディレクトリをマッピング． |
| **```environment:```**     | DBコンテナに設定する環境変数．<br>・```MYSQL_ROOT_PASSWORD:```（rootパスワード）<br>・```MYSQL_DATABASE:```（データベース名）<br>・```MYSQL_USER:```（一般ユーザ名）<br>・```MYSQL_PASSWORD:（一般ユーザパスワード）``` |
| **```depends_on:```**      | コンテナが起動する順番．                                     |
| **```networks:```**        | コンテナ間のネットワークを設定．要勉強．  |

**【記述例】**

```yml
version: '3.7'
services:

  # DBコンテナ
  db:
    container_name: db
    image: mysql
    command: ["--default-authentication-plugin=mysql_native_password"]
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: XXXXX
      MYSQL_DATABASE: XXXXX
      MYSQL_USER: XXXXX
      MYSQL_PASSWORD: XXXXX
    networks:
      - db

  # APコンテナ
  php:
    container_name: php-fpm
    build: ./php-fpm
    ports:
      - "9000:9001"
    volumes:
      - ./symfony:/var/www/symfony:cached
      - ./logs/symfony:/var/www/symfony/var/log:cached
    depends_on:
      - db
    networks:
      - db
      - php

  # Webコンテナ
  nginx:
    container_name: nginx
    build: ./nginx
    ports:
      - "80:80"
    depends_on:
      - php
    networks:
      - php
    volumes:
      - ./logs/nginx:/var/log/nginx:cached
      - ./symfony:/var/www/symfony:cached
```

#### ・docker-compose.ymlを実行するコマンド

| コマンド                                         | 処理                                                         | 注意点                                                       |
| ------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```docker-compose up -d```**                   | ・Dockerfileを基にイメージのビルド<br>・全てのコンテナレイヤーを生成し，コンテナを構築<br>・コンテナを起動 | すでにコンテナがある場合，それを再起動                       |
| **```docker-compose run -d -it {イメージ名}```** | ・Dockerfileを基にイメージをビルド<br>・指定のコンテナレイヤーを生成し，コンテナを構築（※依存含む）<br>・コンテナを起動 | すでにコンテナがあっても，それを残して構築／起動．以前のコンテナが削除されずに残ってしまう． |
