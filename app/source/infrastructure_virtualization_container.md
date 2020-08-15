

# コンテナ

## 01. Dockerによるコンテナの構築

### Dockerの操作

#### ・Dockerクライアント

Dockerクライアントは，ssh接続によって，Dockerデーモンを操作できる．

#### ・Dockerデーモン

ホストOS上で稼働し，Dockerの操作を担う．Dockerクライアントは，Dockerデーモンを通して，Docker全体を操作できる．

![Dockerの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerの仕組み.png)



## 02. コンテナにssh接続するまでの手順

### 手順の流れ

![Dockerfileの作成からコンテナ構築までの手順](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerfileの作成からコンテナ構築までの手順.png)

1. Docker Hubから，ベースとなるDockerイメージをインストールする．
2. DockerfileがイメージレイヤーからなるDockerイメージをビルド．
3. コマンドによって，Dockerイメージ上にコンテナレイヤーを生成し，コンテナを構築．
4. コマンドによって，構築されたコンテナを起動．
5. コマンドによって，起動中のコンテナにssh接続．



### ベースとなるDockerイメージのインストール

#### ・Docker Hubとは

Dockerイメージは，実行OSによらずに一貫してビルドできるため，配布できる．Docker Hubには，カスタマイズする上でのベースとなるDockerイメージが提供されている．

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

```bash
$ docker search {イメージ名}

$ docker pull {イメージ名}

$ docker images
```

#### ・Dockerイメージを削除するコマンド

| コマンド                                                     | 処理                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------ |
| **```docker image prune```**                                 | コンテナに使用されていないDockerイメージを一括で削除． |
| **```docker rmi --force $(sudo docker images --filter "dangling=true" --all --quiet)```** | タグ名のないイメージのみを全て削除．                   |

```bash
$ docker image prune

$ docker rmi --force $(sudo docker images --filter "dangling=true" --all --quiet)
```



### ベースとなるDockerイメージのカスタマイズとビルド

#### ・DockerイメージのカスタマイズとDockerfile

![イメージレイヤーからなるDockerイメージのビルド](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/イメージレイヤーからなるDockerイメージのビルド.png)

任意のDockerイメージをベースとして，新しいDockerイメージをビルドするためには，ベースのイメージの上に，他のイメージレイヤーを積み重ねる必要がある．この時，Dockerfileを用いて，各命令によってイメージレイヤーを積み重ねていく．

#### ・Dockerfileの記述方法

任意のDockerイメージをベースとして，新しいDockerイメージをビルドするためには，以下の5つ順番で命令を用いて，イメージレイヤーを積み重ねていく．命令は，慣例的に大文字で記述する．

| 命令                 | 処理                                                         |
| -------------------- | ------------------------------------------------------------ |
| **```FROM```**       | ベースのDockerイメージを，コンテナにインストール.            |
| **```RUN```**        | ベースイメージ上に，ソフトウェアをインストール.              |
| **```COPY```**       | ・ホストOSのファイルをイメージレイヤー化し，コンテナの指定ディレクトリにコピー.<br>・イメージのビルド時にコピーされるだけで，ビルド後のコードの変更は反映されない． |
| **```CMD```**        | イメージレイヤーをデーモン起動.                              |
| **```VOLUME```**     | Volumeマウントを行う．```COPY```とは異なり，ビルド後のコードの変更が反映される．Docker Composeで記述した方が良い． |
| **```EXPOSE```**     | 処理は発生しない．アプリケーションのポート番号をドキュメンテーションとして記載する． |
| **```ENTRYPOINT```** | 指定されたスクリプトを実行し，終了するとコンテナを停止する．常駐スクリプトのために用いる． |

必須ではないその他の命令には，以下がある．

| 命令              | 処理                                                         |
| ----------------- | ------------------------------------------------------------ |
| **```ADD```**     | ・ホストOSのファイルを，コンテナの指定ディレクトリにコピー（**```COPY```と同じ**）<br>・インターネットからファイルをダウンロードし，解凍も行う．<br>・イメージのビルド時にコピーされるだけで，ビルド後のコードの変更は反映されない． |
| **```WORKDIR```** | 絶対パスによる指定で，現在のディレクトリを変更.              |

#### ・Dockerイメージのビルドを行うコマンド


| コマンド                                                     | 処理                                                         | 注意点                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------ |
| **```docker build --file Dockerfile --tag tech-notebook:latest --force-rm=true --no-cache .```** | キャッシュ無しで，指定のDockerfileを基に，Dockerイメージをビルド．失敗したときは削除する． | コマンド最後のドットを忘れない |

```bash
$ docker build --file Dockerfile --tag tech-notebook:latest --force-rm=true --no-cache .
```

#### ・ビルドしたDockerイメージをDocker Hubに登録するコマンド

| コマンド                                                     | 処理                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```docker commit -a {作成者名} {コンテナ名} {Docker Hubユーザ名}/{イメージ名}:{バージョンタグ}```** | コンテナからDockerイメージを作成．                           |
| **```docker push {Docker Hubユーザ名}/{イメージ名}:{バージョンタグ}```** | ホストOSで作成したDockerイメージをレジストリ側にアップロード． |

```bash
$ docker commit -a {作成者名} {コンテナ名} {Docker Hubユーザ名}/{イメージ名}:{バージョンタグ}

$ docker push {Docker Hubユーザ名}/{イメージ名}:{バージョンタグ}
```

#### ・Docker Hub上での継続的インテグレーション

| 方法                  | 仕組み                                            |
| --------------------- | ------------------------------------------------- |
| GitHub Actions        | GitHubが，Docker Hubに対して，pushを行う．        |
| Circle CI             | GitHubが，Circle CIに対して，送信WebHookを行う．  |
| Docker Hub Auto Build | GitHubが，Docker Hubに対して，送信WebHookを行う． |

#### ・Dockerfileを使用するメリット

Dockerfileを用いない場合，各イメージレイヤーのインストールを手動で行わなければならない．しかし，Dockerfileを用いることで，これを自動化することができる．

![Dockerfileのメリット](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerfileのメリット.png)



### Dockerfileの例

#### ・NginxのDockerイメージの例

ubuntuのDockerイメージをベースとして，nginxのDockerイメージをビルドするためのDockerfileを示す．命令のパラメータの記述形式には，文字列形式，JSON形式がある．ここでは，JSON形式で記述する．

**【実装例】**

```dockerfile
# ベースのDockerイメージ（ubuntu）を，コンテナにインストール
FROM centos:latest

# ubuntu上に，nginxをインストール
RUN yum update -y && yum install -y nginx

# ホストOSの設定ファイルを，コンテナ側の指定ディレクトリにコピー
COPY infra/docker/web/nginx.conf /etc/nginx/nginx.conf

# nginxをデーモン起動
CMD ["nginx -g daemon off"]

# 処理は発生しない．アプリケーションのポート番号80（HTTP）をドキュメンテーションとして記載
EXPOSE 80
```

#### ・静的ファイルBuilderのDockerイメージの例

例として，Python製ドキュメントジェネレーターSphinxのDockerfileである．

**【実装例】**

```dockerfile
# ベースイメージのインストール
ARG OS_VERSION="8"
FROM centos:${OS_VERSION}
LABEL mantainer="Hiroki <hasegawafeedshop@gmail.com>"

RUN dnf upgrade -y \
  && dnf install -y \
      # システム全体要件
      curl \
      git \
      langpacks-ja \
      make \
      unzip \
      vim \
      # Pyenv要件
      bzip2 \
      bzip2-devel \
      gcc \
      gcc-c++ \
      libffi-devel \
      openssl-devel \
      readline-devel \
      sqlite-devel \
      zlib-devel \
  # メタデータ削除
  && dnf clean all \
  # キャッシュ削除
  && rm -rf /var/cache/dnf

# Pyenvインストール
RUN git clone https://github.com/pyenv/pyenv.git /.pyenv
# 環境変数PATHの設定
ENV PYENV_ROOT /.pyenv
ENV PATH ${PATH}:/${PYENV_ROOT}/bin

# バージョン
ENV PYTHON_VERSION_38 "3.8.0"

RUN pyenv install ${PYTHON_VERSION_38} \
  # Pythonバージョン切り替え
  && pyenv global ${PYTHON_VERSION_38} \
  && dnf install -y \
      # PIP
      python3-pip \
  && pip3 install \
      # NOTE: sphinx-buildが認識されない問題への対処
      sphinx --upgrade --ignore-installed six \
      # テーマ
      sphinx_rtd_theme \
      # 拡張機能
      sphinx-autobuild \
      recommonmark \
      sphinx_markdown_tables \
      sphinxcontrib-sqltable \
      sphinx_fontawesome

CMD ["/bin/bash"]
```



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

#### ・プロセス単位によるDockerfileの分割



### Dockerイメージ上でのコンテナレイヤーの生成，コンテナの構築

#### ・コンテナレイヤー生成，コンテナ構築，を行うコマンド

| コマンド                             | 処理                                                     |
| ------------------------------------ | -------------------------------------------------------- |
| **```docker create {イメージ名}```** | コンテナレイヤーを生成し，コンテナを構築．起動はしない． |

```bash
$ docker create {イメージ名}
```

![Dockerイメージ上へのコンテナレイヤーの積み重ね](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerイメージ上へのコンテナレイヤーの積み重ね.png)

#### ・構築に失敗した時のデバッグを行うコマンド

| コマンド                                                    | 処理                                   |
| ----------------------------------------------------------- | -------------------------------------- |
| **```docker logs --follow=true --tail=500 {コンテナ名}```** | 指定した行数だけ，ログを出力し続ける． |

```bash
$ docker logs --follow=true --tail=500 {コンテナ名}
```

#### ・ビルドされるDockerイメージとコンテナの役割の対応例

| ビルドされるDockerイメージ | コンテナの役割               |
| :------------------------- | :--------------------------- |
| Redis                      | **NoSQL（非RDB）**           |
| MySQL                      | **RDBMS**                    |
| Nginx                      | **Webサーバソフトウェア**    |
| PHP-FPM                    | **APサーバソフトウェア**     |
| MailDev                    | **メールサーバソフトウェア** |



### 構築されたコンテナの操作

#### ・構築されたコンテナ起動／停止／削除を行うコマンド

| コマンド                                               | 処理                                                     |
| :----------------------------------------------------- | -------------------------------------------------------- |
| **```docker start```**                                 | 事前にコンテナ構築が成功していること．既存コンテナを起動 |
| **```docker stop```**                                  | 起動中コンテナを停止                                     |
| **```docker stop $(docker ps --all --quiet)```**       | 全てのコンテナを停止                                     |
| **```docker container prune```**                       | 停止中のコンテナのみを全て削除                           |
| **```docker rm --force $(docker ps --all --quiet)```** | 起動中／停止中の全てコンテナを削除                       |
```bash
$ docker start

$ docker stop

$ docker stop $(docker ps --all --quiet)

$ docker container prune

$ docker rm --force $(docker ps --all --quiet)
```

### 起動中のコンテナの操作

#### ・起動中のコンテナ情報表示を行うコマンド

| コマンド                              | 処理                                                         |
| :------------------------------------ | ------------------------------------------------------------ |
| **```docker ps -a```**                | 事前に，コンテナ起動が成功していること．エラーも含めて，起動中コンテナのIDなどを一覧で表示． |
| **```docker inspect {コンテナID}```** | 起動中コンテナの全ての設定内容を表示                         |

```bash
$ docker ps -a

$ docker inspect {コンテナID}
$ docker inspect {コンテナID} | grep IPAddress # grepとも組み合わせられる．
```

#### ・起動中のコンテナにssh接続


| コマンド                                    | 処理                      | 注意点                   |
| ------------------------------------------- | ------------------------- | ------------------------ |
| **```docker exec -it {コンテナ名} bash```** | 起動中のコンテナにssh接続 | i：interactive<br>t：tty |

```bash
$ docker exec -it {コンテナ名} /bin/bash
```

#### ・起動中のコンテナにホストOSのファイルをコピー

Dockerfileの```COPY```コマンドを使用してコンテナ内に配置しているファイルに関して，変更のたびにDockerイメージをビルドを行うことは面倒のため，ホストOSからコンテナにコピーし，再読み込みを行う．

```bash
$ docker cp ./docker/www/nginx.conf {コンテナID}:/etc/nginx/nginx.conf

# コンテナにSSH接続後に，nginxの設定ファイルを再読み込み．
$ docker exec -it {コンテナ名} bin/bash
$ nginx -s reload
```



## 03. コンテナ側に対するファイルのマウント方法

### ホストOSのマウント元のディレクトリの設定画面

以下の通り，ホストOSのマウント元のディレクトリにはいくつか選択肢がある．

![マウントされるホスト側のディレクトリ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/マウントされるホスト側のディレクトリ.png)



### Bindマウント

#### ・Bindマウントとは

ホストOSにある```/Users```ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，非推奨である．



### Volumeマウント

#### ・```/Volumes```とは

ホストOSの```/Volumes```（```/var/lib/docker/volumes```）ディレクトリには，開発途中にコンテナ側で作成されたデータのうち，ホストOSに永続化したいデータが保存される．Data Volumeともいう．

#### ・Volumeマウントとは

ホストOSにある```/Volumes```（```/var/lib/docker/volumes```）ディレクトリをコンテナ側にマウントする方法．コンテナで作成されたデータをホストOSに永続化する方法として，推奨である．Dockerfileまたはdocker-composeファイルに記述する方法があるが，後者が推奨である．

#### ・Data Volumeコンテナによる永続化データの提供

一旦，Data Volumeをコンテナ （Data Volumeコンテナ）のディレクトリにマウントしておく．そして，他のコンテナでDataVolumeを使用したい時は，Data Volumeコンテナとディレクトリを共有することによって，データを要求する．

### 一時ファイルシステムマウント






## 04. ホストとコンテナの間のネットワーク接続

### bridgeネットワーク

#### ・bridgeネットワークとは

複数のコンテナ間に対して，仮想ネットワークで接続させる．また，仮想ネットワークを物理ネットワークの間を，仮想ブリッジを用いてbridge接続する．ほとんどの場合，この方法を用いる．

```bash
$ docker network list

NETWORK ID          NAME                    DRIVER              SCOPE
ae25b9b7740b        bridge                  bridge              local
aeef782b227d        tech-notebook_default   bridge              local
```



![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerエンジン内の仮想ネットワーク.jpg)

#### ・物理サーバへのリクエストメッセージがコンテナに届くまで

ホストOSの```8080```番ポートと，WWWコンテナの```80```番ポートのアプリケーションの間で，ポートフォワーディングを行う．これにより，```http://{ホストOSのプライベートIPアドレス（localhost）}:8080```にリクエストを送信すると，WWWコンテナのポート番号のアプリケーションに転送されるようになる．

| 順番  | リクエストメッセージの流れ | プライベートIPアドレス例       | アプリケーションのポート番号例 |
| :---: | :------------------------- | :----------------------------- | ------------------------------ |
| **4** | WWWコンテナ                | ```127.0.0.1```                | ```:80```                      |
|       | ↑                          |                                |                                |
| **3** | 仮想ネットワーク           | ```172.XX.XX.XX```             |                                |
|       | ↑                          |                                |                                |
| **2** | 仮想ブリッジ               |                                |                                |
|       | ↑                          |                                |                                |
| **1** | ホストOS                   | ```192.168.3.2```（localhost） | ```:8080```                    |



### noneネットワーク

#### ・noneネットワークとは

特定のコンテナを，ホストOSや他のコンテナとは，ネットワーク接続させない．


```bash
$ docker network list

NETWORK ID          NAME                    DRIVER              SCOPE
7edf2be856d7        none                    null                local
```




### hostネットワーク

#### ・hostネットワークとは

特定のコンテナに対して，ホストOSと同じネットワーク情報をもたせる．

```bash
$ docker network list

NETWORK ID          NAME                    DRIVER              SCOPE
ac017dda93d6        host                    host                local
```



### ネットワーク接続成否の確認方法

#### ・ホストOS ---> コンテナ

ホストOSから，自身のポート番号8080に対してリクエストメッセージを送信することによって，ホストOSとコンテナの間のネットワーク接続の成否を確認できる．

```bash
# ホストOSから，自身のポート番号8080に対してリクエスト
$ curl --fail http://{nginxに登録したドメイン名}:8080/
```

#### ・コンテナ内部 ---> アプリケーション

bridge接続を経由してコンテナにSSH接続し，コンテナ内部からアプリケーションにリクエストメッセージを送信することによって，アプリケーションの成否を確認することができる．

```bash
# コンテナの中で，ポート番号80のアプリケーションに対してリクエスト
$ curl --fail http://{nginxに登録したドメイン名}:80/
```



## 05. プラグイン

### ボリュームプラグイン

#### ・NFSストレージ

NFSプラグインを使用することで，永続化データを```/var/lib/docker/volumes```ではなく，NFSストレージに保存する．

**【実装例】**

以下にdocker-composeを使用した場合を示す．docker-composeについては，コンテナオーケストレーションのノートを参照．

```yaml
version: '3.7'

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

