# 仮想サーバ(仮想マシン)とコンテナ

## 01-01. Providerによる仮想サーバ（仮想マシン）の構築

![Vagrantの仕組み_オリジナル](https://user-images.githubusercontent.com/42175286/60393574-b18de200-9b52-11e9-803d-ef44d6e50b08.png)



### Providerの操作

#### ・Providerとは

基本ソフトウェアにおける制御プログラムや一連のハードウェアを仮想的に構築できる．これを，仮想サーバ（仮想マシンとも）という．構築方法の違いによって，『ホスト型』，『ハイパーバイザ型』に分類できる．



### Provisionerの操作

#### ・Provisionerとは

Providerによって構築された仮想サーバに，Web開発のためのソフトウェアをインストールすることができる（構成管理することができる）．具体的には，プログラミング言語やファイアウォールをインストールする．



### VagrantによるProviderとProvisionerの操作

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

### Dockerの操作

#### ・Dockerクライアント

Dockerクライアントは，ssh接続によって，Dockerデーモンを操作できる．

#### ・Dockerデーモン

ホストOS上で稼働し，Dockerの操作を担う．Dockerクライアントは，Dockerデーモンを通して，Docker全体を操作できる．

![Dockerの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerの仕組み.png)



## 03-02. コンテナにssh接続するまでの手順

### 手順の流れ

![Dockerfileの作成からコンテナ構築までの手順](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerfileの作成からコンテナ構築までの手順.png)

1. DockerHubから，ベースとなるDockerイメージをインストールする．
2. DockerfileがイメージレイヤーからなるDockerイメージをビルド．
3. コマンドによって，Dockerイメージ上にコンテナレイヤーを生成し，コンテナを構築．
4. コマンドによって，構築されたコンテナを起動．
5. コマンドによって，起動中のコンテナにssh接続．



### ベースとなるDockerイメージのインストール

#### ・DockerHubとは

DockerHubには，カスタマイズする上でのベースとなるDockerイメージが提供されている．

#### ・ベースとなるDockerイメージの種類

| Dockerイメージ   | 特徴                                                         | 相性の良いシステム例 |
| ---------------- | ------------------------------------------------------------ | -------------------- |
| **scratch**      | 以下の通り，何も持っていない<br>・OS：無<br>・パッケージ：無<br>・パッケージマネージャ：無 | ？                   |
| **BusyBox**      | ・OS：Linux（※ディストリビューションではない）<br>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：無 | 組み込みシステム     |
| **Alpine Linux** | ・OS：Linux（※ディストリビューションではない）<br/>・パッケージ：基本ユーティリティツール<br>・パッケージマネージャ：Apk | ？                   |

#### ・ベースとなるDockerイメージをインストールするコマンド


| コマンド                                                     | 処理                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```docker search {イメージ名}```**                         | レジストリ側に保管されているDockerイメージを検索．           |
| **```docker pull {イメージ名}```**                           | レジストリ側のDockerイメージをクライアント側にインストール． |
| **```docker images```**                                      | ホストOSにインストールされたDockerイメージを確認．           |

#### ・Dockerイメージを削除するコマンド

| コマンド                                                     | 処理                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------ |
| **```docker image prune```**                                 | コンテナに使用されていないDockerイメージを一括で削除． |
| **```docker rmi --force $(sudo docker images --filter "dangling=true" --all --quiet)```** | タグ名のないイメージのみを全て削除．                   |



### ベースとなるDockerイメージのカスタマイズとビルド

#### ・DockerイメージのカスタマイズとDockerfile

![イメージレイヤーからなるDockerイメージのビルド](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/イメージレイヤーからなるDockerイメージのビルド.png)

任意のDockerイメージをベースとして，新しいDockerイメージをビルドするためには，ベースのイメージの上に，他のイメージレイヤーを積み重ねる必要がある．この時，Dockerfileを用いて，各命令によってイメージレイヤーを積み重ねていく．

#### ・Dockerfileの記述方法

任意のDockerイメージをベースとして，新しいDockerイメージをビルドするためには，以下の5つ順番で命令を用いて，イメージレイヤーを積み重ねていく．命令は，慣例的に大文字で記述する．

| 命令             | 処理                                                         |
| ---------------- | ------------------------------------------------------------ |
| **```FROM```**   | ベースのDockerイメージを，コンテナにインストール.            |
| **```RUN```**    | ベースイメージ上に，ソフトウェアをインストール.              |
| **```COPY```**   | ・ホストOSのファイルをイメージレイヤー化し，コンテナの指定ディレクトリにコピー.<br>・イメージのビルド時にコピーされるだけで，ビルド後のコードの変更は反映されない． |
| **```CMD```**    | イメージレイヤーをデーモン起動.                              |
| **```VOLUME```** | Volumeマウントを行う．```COPY```とは異なり，ビルド後のコードの変更が反映される．Docker Composeで記述した方が良い． |
| **```EXPOSE```** | 処理は発生しない．開放するポート番号をドキュメンテーションとして記載する． |

必須ではないその他の命令には，以下がある．

| 命令              | 処理                                                         |
| ----------------- | ------------------------------------------------------------ |
| **```ADD```**     | ・ホストOSのファイルを，コンテナの指定ディレクトリにコピー（**```COPY```と同じ**）<br>・インターネットからファイルをダウンロードし，解凍も行う．<br>・イメージのビルド時にコピーされるだけで，ビルド後のコードの変更は反映されない． |
| **```WORKDIR```** | 絶対パスによる指定で，現在のディレクトリを変更.              |

**【nginxのDockerイメージの例】**

ubuntuのDockerイメージをベースとして，nginxのDockerイメージをビルドするためのDockerfileを示す．命令のパラメータの記述形式には，文字列形式，JSON形式がある．ここでは，JSON形式で記述する．

```dockerfile
# ベースのDockerイメージ（ubuntu）を，コンテナにインストール
FROM centos:latest

# ubuntu上に，nginxをインストール
RUN yum update -y && yum install -y nginx

# ホストOSの設定ファイルを，コンテナ側の指定ディレクトリにコピー
COPY infra/docker/web/nginx.conf /etc/nginx/nginx.conf

# nginxをデーモン起動
CMD ["nginx -g daemon off"]

# 処理は発生しない．ポート番号80（HTTP）をドキュメンテーションとして記載
EXPOSE 80
```

#### ・Dockerイメージのビルドを行うコマンド

| コマンド                                                     | 処理                                                         | 注意点                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------ |
| **```docker build --file Dockerfile --tag tech-notebook:latest --force-rm=true --no-cache .```** | キャッシュ無しで，指定のDockerfileを基に，Dockerイメージをビルド．失敗したときは削除する． | コマンド最後のドットを忘れない |

#### ・ビルドしたDockerイメージをDockerHubに登録するコマンド

| コマンド                                                     | 処理                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```docker commit -a {作成者名} {コンテナ名} {DockerHubユーザ名}/{イメージ名}:{バージョンタグ}```** | コンテナからDockerイメージを作成．                           |
| **```docker push {DockerHubユーザ名}/{イメージ名}:{バージョンタグ}```** | ホストOSで作成したDockerイメージをレジストリ側にアップロード． |

#### ・Dockerfileを使用するメリット

Dockerfileを用いない場合，各イメージレイヤーのインストールを手動で行わなければならない．しかし，Dockerfileを用いることで，これを自動化することができる．![Dockerfileのメリット](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerfileのメリット.png)



### Dockerイメージの軽量化

#### ・```RUN```コマンドをまとめる．

Dockerfileの各命令によって，イメージ レイヤーが一つ増えてしまうため，同じ命令に異なるパラメータを与える時は，これを一つにまとめてしまう方が良い．例えば，以下のような時，

```dockerfile
# ベースイメージ上に，複数のソフトウェアをインストール
RUN yum -y isntall httpd
RUN yum -y install php
RUN yum -y install php-mbstring
RUN yum -y install php-pear
```

これは，以下のように一行でまとめられる．イメージレイヤーが少なくなり，Dockerイメージを軽量化することができる．

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

#### ・マルチステージビルド

```dockerfile
# ここに記述例
```



### Dockerイメージ上でのコンテナレイヤーの生成，コンテナの構築

#### ・コンテナレイヤー生成，コンテナ構築，を行うコマンド

| コマンド                             | 処理                                                     |
| ------------------------------------ | -------------------------------------------------------- |
| **```docker create {イメージ名}```** | コンテナレイヤーを生成し，コンテナを構築．起動はしない． |

![Dockerイメージ上へのコンテナレイヤーの積み重ね](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerイメージ上へのコンテナレイヤーの積み重ね.png)

#### ・構築に失敗した時のデバッグを行うコマンド

| コマンド                                                    | 処理                                   |
| ----------------------------------------------------------- | -------------------------------------- |
| **```docker logs --follow=true --tail=500 {コンテナ名}```** | 指定した行数だけ，ログを出力し続ける． |


#### ・ビルドされるDockerイメージとコンテナの役割の対応例

| ビルドされるDockerイメージ | コンテナの役割               |
| :------------------------- | :--------------------------- |
| Redis                      | **NoSQL（非RDB）**           |
| MySQL                      | **RDBMS**                    |
| Nginx                      | **Webサーバソフトウェア**    |
| PHP-FPM                    | **APサーバソフトウェア**     |
| MailDev                    | **メールサーバソフトウェア** |



### 構築されたコンテナの操作

#### ・コンテナ起動／停止／削除を行うコマンド

| コマンド                                               | 処理                                 |
| :----------------------------------------------------- | ------------------------------------ |
| **```docker start```**                                 | 既存コンテナを起動                   |
| **```docker stop```**                                  | 起動中コンテナを停止                 |
| **```docker stop $(docker ps --all --quiet)```**       | 全てのコンテナを停止                 |
| **```docker container prune```**                       | 停止中のコンテナのみを全て削除       |
| **```docker rm --force $(docker ps --all --quiet)```** | 起動中／停止中の全てコンテナを削除   |
#### ・コンテナ情報表示を行うコマンド

| コマンド                                               | 処理                                 |
| :----------------------------------------------------- | ------------------------------------ |
| **```docker ps```**                                    | 起動中コンテナのIDなどを一覧で表示   |
| **```docker inspect {コンテナID}```**                  | 起動中コンテナの全ての設定内容を表示 |




### 起動中のコンテナにssh接続

#### ・ssh接続を行うコマンド

| コマンド                                    | 処理                      | 注意点                   |
| ------------------------------------------- | ------------------------- | ------------------------ |
| **```docker exec -it {コンテナ名} bash```** | 起動中のコンテナにssh接続 | i：interactive<br>t：tty |



## 03-03. コンテナ側に対するファイルのマウント方法

### ホストOSのマウント元のディレクトリの設定画面

以下の通り，ホストOSのマウント元のディレクトリにはいくつか選択肢がある．

![マウントされるホスト側のディレクトリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/マウントされるホスト側のディレクトリ.png)



### Bindマウント

#### ・Bindマウントとは

ホストOSにある```/Users```ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，非推奨である．



### Volumeマウント

#### ・```/Volumes```とは

ホストOSの```/Volumes```には，開発途中にコンテナ側で作成されたデータのうち，ホストOSに永続化したいデータが保存される．Data Volumeともいう．

#### ・Volumeマウントとは

ホストOSにある```/Volumes```ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，推奨である．

#### ・Data Volumeコンテナによる永続化データの提供

一旦，Data Volumeをコンテナ （Data Volumeコンテナ）のディレクトリにマウントしておく．そして，他のコンテナでDataVolumeを使用したい時は，Data Volumeコンテナとディレクトリを共有することによって，データを要求する．




### 一時ファイルシステムマウント






## 03-04. ホストとコンテナの間のネットワーク接続

### bridgeネットワーク

#### ・bridgeネットワークとは

複数のコンテナ間に対して，仮想ネットワークで接続させる．また，仮想ネットワークを物理ネットワークの間を，仮想ブリッジを用いてbridge接続する．ほとんどの場合，この方法を用いる．

![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Dockerエンジン内の仮想ネットワーク.jpg)

#### ・物理サーバへのリクエストメッセージがコンテナに届くまで

| 順番  | リクエストメッセージの流れ         | IPアドレス例       | ポート番号例 |
| :---: | :--------------------------------- | :----------------- | ------------ |
| **4** | コンテナのプライベートIPアドレス   | ```127.0.0.1```    | ```:80```    |
|       | ↑                                  |                    |              |
| **3** | 仮想ネットワーク                   | ```172.XX.XX.XX``` |              |
|       | ↑                                  |                    |              |
| **2** | 仮想ブリッジ                       |                    |              |
|       | ↑                                  |                    |              |
| **1** | ホストOS側のプライベートIPアドレス | ```192.168.3.2```  | ```:8080```  |

#### ・bridge接続可否の確認方法

DHCPによって，自身のパソコンに動的にプライベートIPアドレスが割り当てられる．ネットワーク設定でプライベートIPアドレスを確認する．その後，コンテナにSSH接続し，コンテナ側からホストOS側にリクエストメッセージを送信することで，接続の確認を行うことができる．

```bash
user@ee84f5a213ee:/var/www/xxx$ curl http://192.168.3.2:8080/

# curl: (52) Empty reply from server
```



### noneネットワーク

#### ・noneネットワークとは

特定のコンテナに対して，ホストOSや他のコンテナとは，ネットワーク接続しない．



### hostネットワーク

#### ・hostネットワークとは

特定のコンテナに対して，ホストOSと同じネットワーク情報をもたせる．



## 04-01. コンテナオーケストレーション

### コンテナオーケストレーションの種類

#### ・単一ホストOS上のコンテナオーケストレーション

単一ホストOS上のコンテナが対象である．異なるDockerfileに基づいて，Dockerイメージのビルド，コンテナレイヤーの生成，コンテナの構築，コンテナの起動，を実行できる．

| 名前           |      |
| -------------- | ---- |
| Docker Compose |      |
|                |      |
|                |      |

#### ・複数ホストOSに渡るコンテナオーケストレーション

複数ホストOS上のコンテナが対象である．どのホストOSのDockerデーモンに対して，どのコンテナに関する操作を行うのかを選択的に命令できる．

| 名前                          |      |
| ----------------------------- | ---- |
| Docker Swarm                  |      |
| Google Kubernetes             |      |
| AWS Elastic Container Service |      |



### Docker Compose

#### ・設定項目

| 記述項目                  | 意味                                                         |
| :------------------------ | :----------------------------------------------------------- |
| **```container_name:```** | コンテナ名の命名                                             |
| **```build:```**          | Dockerfileのディレクトリの相対パス．                         |
| **```tty:```** |  |
| **```image:```**          | ベースイメージをそのまま使用する場合の設定．                 |
| **```ports:```**           | ```{ホストOS側のポート番号}:{コンテナのポート番号}```<br>マウントするディレクトリ間をマッピング．コンテナのみポート番号を指定した場合，ホストOS側のポート番号はランダムになる． |
| **```volumes:```**         | ```{ホストOSのディレクトリ}:{コンテナのディレクトリ}```<br>ホストOSの```/var/lib/docker/volumes/```の下にDataVolumeのディレクトリを作成し，DataVolumeをマウントするコンテナ側のディレクトリをマッピング． |
| **```environment:```**     | DBコンテナに設定する環境変数．<br>・```MYSQL_ROOT_PASSWORD:```（rootパスワード）<br>・```MYSQL_DATABASE:```（データベース名）<br>・```MYSQL_USER:```（一般ユーザ名）<br>・```MYSQL_PASSWORD:（一般ユーザパスワード）``` |
| **```depends_on:```**      | コンテナが起動する順番．                                     |
| **```networks:```**        | コンテナ間のネットワークを設定．要勉強．  |

#### ・実装例

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

#### ・```docker-compose```：

| コマンド                                         | 処理                                                         | 注意点                                                       |
| ------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```docker-compose up -d```**                   | ・Dockerfileを基にイメージのビルド<br>・全てのコンテナレイヤーを生成し，コンテナを構築<br>・コンテナを起動 | すでにコンテナがある場合，それを再起動                       |
| **```docker-compose run -d -it {イメージ名}```** | ・Dockerfileを基にイメージをビルド<br>・指定のコンテナレイヤーを生成し，コンテナを構築（※依存含む）<br>・コンテナを起動 | すでにコンテナがあっても，それを残して構築／起動．以前のコンテナが削除されずに残ってしまう． |



### Docker Swarm

![DockerSwarmの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/DockerSwarmの仕組み.png)



### Google Kubernetes

![Kubernetesの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/Kubernetesの仕組み.png)

#### ・Master Node

Kubernetesが実行される物理サーバを指す．

#### ・Worker Node

Dockerが実行される仮想サーバを指す．

#### ・Pod

仮想サーバのホストOS上のコンテナをグループ化したもの．

#### ・Secret

セキュリティに関するデータを管理し，コンテナに選択的に提供するもの．

#### ・Replica Set（Replication Controller）

#### ・Kubectl