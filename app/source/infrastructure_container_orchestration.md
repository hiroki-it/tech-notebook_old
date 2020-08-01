# コンテナオーケストレーション

## 01. コンテナオーケストレーションの種類

### 単一ホストOS上のコンテナオーケストレーション

単一ホストOS上のコンテナが対象である．異なるDockerfileに基づいて，Dockerイメージのビルド，コンテナレイヤーの生成，コンテナの構築，コンテナの起動，を実行できる．

| 名前           |      |
| -------------- | ---- |
| Docker Compose |      |

### 複数ホストOSに渡るコンテナオーケストレーション

複数ホストOS上のコンテナが対象である．どのホストOSのDockerデーモンに対して，どのコンテナに関する操作を行うのかを選択的に命令できる．

| 名前                          |      |
| ----------------------------- | ---- |
| Docker Swarm                  |      |
| Google Kubernetes             |      |
| AWS Elastic Container Service |      |



## 02. Docker Compose

### docker-compose.yml

#### ・各項目の意味

| 記述項目                  | 意味                                                         |
| :------------------------ | :----------------------------------------------------------- |
| **```container_name:```** | コンテナ名の命名                                             |
| **```build:```**          | Dockerfileのディレクトリの相対パス．                         |
| **```tty:```**            |                                                              |
| **```image:```**          | ベースイメージをそのまま使用する場合の設定．                 |
| **```ports:```**          | ```{ホストOS側のポート番号}:{コンテナのポート番号}```<br>マウントするディレクトリ間をマッピング．コンテナのみポート番号を指定した場合，ホストOS側のポート番号はランダムになる． |
| **```volumes:```**        | ```{ホストOSのディレクトリ}:{コンテナのディレクトリ}```<br>ホストOSの```/var/lib/docker/volumes/```の下にDataVolumeのディレクトリを作成し，DataVolumeをマウントするコンテナ側のディレクトリをマッピング． |
| **```environment:```**    | DBコンテナに設定する環境変数．<br>・```MYSQL_ROOT_PASSWORD:```（rootパスワード）<br>・```MYSQL_DATABASE:```（データベース名）<br>・```MYSQL_USER:```（一般ユーザ名）<br>・```MYSQL_PASSWORD:（一般ユーザパスワード）``` |
| **```depends_on:```**     | コンテナが起動する順番．                                     |
| **```networks:```**       | コンテナ間のネットワークを設定．要勉強．                     |

#### ・実装例

```yaml
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

### ```docker-compose```コマンド

| コマンド                                         | 処理                                                         | 注意点                                                       |
| ------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **```docker-compose up -d```**                   | ・Dockerfileを基にイメージのビルド<br>・全てのコンテナレイヤーを生成し，コンテナを構築<br>・コンテナを起動 | すでにコンテナがある場合，それを再起動                       |
| **```docker-compose run -d -it {イメージ名}```** | ・Dockerfileを基にイメージをビルド<br>・指定のコンテナレイヤーを生成し，コンテナを構築（※依存含む）<br>・コンテナを起動 | すでにコンテナがあっても，それを残して構築／起動．以前のコンテナが削除されずに残ってしまう． |

```bash
$ docker-compose up -d

$ docker-compose run -d -it {イメージ名}
```



## 03. Docker Swarm

![DockerSwarmの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DockerSwarmの仕組み.png)



## 04. Google Kubernetes

![Kubernetesの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Kubernetesの仕組み.png)

### Node

#### 

#### ・Master Node

Kubernetesが実行される物理サーバを指す．

#### ・Worker Node

Dockerが実行される仮想サーバを指す．

### Pod

#### ・Podとは

仮想サーバのホストOS上のコンテナをグループ化したもの．

#### ・Secret

セキュリティに関するデータを管理し，コンテナに選択的に提供するもの．

#### ・Replica Set（Replication Controller）

#### ・Kubectl

