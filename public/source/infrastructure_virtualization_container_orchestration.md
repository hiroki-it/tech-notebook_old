# コンテナオーケストレーション

## 01. コンテナオーケストレーションの種類

### 単一ホストOS上のコンテナオーケストレーション

単一ホストOS上のコンテナが対象である．異なるDockerfileに基づいて，Dockerイメージのビルド，コンテナレイヤーの生成，コンテナの構築，コンテナの起動，を実行できる．

| ツール名       | ベンダー |
| -------------- | -------- |
| Docker Compose | Docker   |

<br>

### 複数ホストOSに渡るコンテナオーケストレーション

複数ホストOS上のコンテナが対象である．どのホストOSのDockerデーモンに対して，どのコンテナに関する操作を行うのかを選択的に命令できる．

| ツール名                      | ベンダー |
| ----------------------------- | -------- |
| Docker Swarm                  | Docker   |
| Google Kubernetes             | Google   |
| AWS Elastic Container Service | Amazon   |

<br>

## 02. Docker Compose

### コマンド

#### ・config

バリデーションとして，```docker-compose.yml```ファイルを展開する．ファイル内で，相対パスや変数を使用している場合，これらが正しく設定されているかを確認できる．

```shell
$ docker-compose config
```

#### ・up 

指定したサービスのイメージのビルド，コンテナレイヤー生成，コンテナ構築，コンテナ起動を行う．コンテナ構築までが完了していて停止中が存在する場合，これをコンテナを起動する．また起動中のコンテナがあれば，これを再起動する．オプションにより起動モードが異なる．

**＊コマンド例＊**

指定したサービスのイメージのビルド，コンテナレイヤー生成，コンテナ構築，コンテナ起動を行う．アタッチモードでコンテナを起動する．

```shell
# アタッチモード
$ docker-compose up <サービス名>
```

**＊コマンド例＊**

指定したサービスのイメージのビルド，コンテナレイヤー生成，コンテナ構築，コンテナ起動を行う．デタッチドモードでコンテナを起動する．

```shell
# デタッチモード
$ docker-compose up -d <サービス名>
```

#### ・run

すでに停止中または起動中のコンテナが存在していても，これとは別にコンテナを新しく構築し，起動する．さらにそのコンテナ内でコマンドを実行する．起動時に```shell```プロセスや```bash```プロセスを実行すると，コンテナに接続できる．何も渡さない場合は，デフォルトのプロセスとして```shell```プロセスが実行される．```run```コマンドでは，アタッチモードとデタッチモードを選ぶことができる．新しく起動したコンテナを停止後に自動削除する場合は，```rm```オプションを付けるようにする．```service-ports```オプションを使用しないと，ホストOSとコンテナ間のポートフォワーディングを有効化できないため注意する．

**＊コマンド例＊**

既存コンテナを残して，指定したサービスの新しいコンテナをアタッチモードで起動する．また，ホストOSとコンテナ間のポートフォワーディングを有効化する．

```shell
# アタッチモード
$ docker-compose run --rm --service-ports <サービス名>
```

**＊コマンド例＊**

既存コンテナを残して，指定したサービスの新しいコンテナをデタッチドモードで起動する．また，ホストOSとコンテナ間のポートフォワーディングを有効化する．

```shell
# デタッチモード
$ docker-compose run --rm -d --service-ports <サービス名>
```

#### ・stop

指定したサービスの起動中コンテナを全て停止する．

**＊コマンド例＊**

```shell
$ docker-compose stop <サービス名>
```

#### ・logs

コンテナ内に入ることなく，起動プロセスから出力されるログを確認することできる．

**＊コマンド例＊**

バックグラウンドでログを表示する．

```shell
$ docker-compose logs <サービス名>
```

**＊コマンド例＊**

フォアグラウンドでログを表示する．

```shell
$ docker-compose logs -f <サービス名>
```

<br>

### services

#### ・```services```とは

コンテナオーケストレーションにおける一つのコンテナを定義する．オプション一覧は以下を参考にせよ．

参考：https://docs.docker.jp/compose/compose-file.html

#### ・```args```

Dockerfileの```ARGS```に展開する変数を定義する．Dockerfileに直接実装することとの使い分けとして，Dockerfileの実装は簡単に変更できないが，```docker-compose.yml```ファイルにおける定義は変更しやすい．そのため，使用者に変更して欲しくない変数はDockerfileに実装し，変更しても問題ない変数はこのオプションを使用する．他に，マルチステージビルドを使用しており，全てのステージで共通した変数を展開したい場合，このオプションを使用すると展開する変数を共通化できる．

**＊実装例＊**

```yaml
build:
  args:
    - PARAM=$PARAM
```

```dockerfile
ARG PARAM

ENV PARAM=${PARAM}
```

**＊実装例＊**

```yaml
# ここに実装例
```

#### ・```build: dockerfile```

Dockerfileの名前．パスごと指定する．

**＊実装例＊**

```yaml
build:
  dockerfile: ./infra/docker/www/Dockerfile
```

#### ・```build: context```

指定したDockerfileのあるディレクトリをカレントディレクトリとして，Dockerデーモン（Dockerエンジン）に送信するディレクトリを指定する． 

**＊実装例＊**

```yaml
build:
  context: .
```

#### ・```build: target```

ビルドするステージ名．主に，マルチステージビルドの時に使用する．

**＊実装例＊**

```yaml
build:
  target: develop
```

#### ・```container_name```

コンテナ名を命名する．

**＊実装例＊**

```yaml
container_name: www
```

#### ・```depends_on```

コンテナが起動する順番を設定する．

**＊実装例＊**

DBコンテナの起動後に，該当するコンテナを起動するようにする．

```yaml
depends_on:
  - db
```

#### ・```env_file```，```environment```

コンテナで展開する環境変数を定義する．Dockerfile内での環境変数とは異なり，マルチステージビルドの全ステージで使用できる．dotenv系ライブラリを使用しなくてもよくなる．mysqlイメージを使用した場合，環境変数を定義することによって，ルートユーザと一般ユーザを自動的に作成できる．ルートユーザ名は定義できず，『```root```』となる．GitHubに公開しない値は```env_file```キーで定義する．公開してもよい固定値は```environment```キーまたはDockerfile内で定義するようにする．

**＊実装例＊**

```shell
# .docker.envファイル
MYSQL_ROOT_PASSWORD: xxxxx # rootユーザのパス
MYSQL_DATABASE: example # データベース名
MYSQL_USER: example_user # 一般ユーザ名
MYSQL_PASSWORD: xxxxx # 一般ユーザのパス
```

```yaml
env_file:
  - .docker.env
```

**＊実装例＊**

```yaml
environment:
  MYSQL_ROOT_PASSWORD: xxxxx # rootユーザのパス
  MYSQL_DATABASE: example # データベース名
  MYSQL_USER: example_user # 一般ユーザ名
  MYSQL_PASSWORD: xxxxx # 一般ユーザのパス
```

#### ・```extra_host```

コンテナに，ユーザ定義のプライベートIPアドレスと，これにマッピングされたホスト名を設定する．マッピングは，```/etc/hosts```ファイルに書き込まれる．もし設定しなかった場合，サービス名またはコンテナ名がホスト名として扱われる．

```yaml
extra_hosts:
 - www:162.242.195.82
```

```shell
$ cat /etc/hosts

127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
# ユーザ定義のプライベートIPアドレスと，これにマッピングされたホスト名
162.242.195.82       www
172.23.0.3      c9bd8ace335d
```

#### ・```hostname```

**＊実装例＊**

コンテナに割り当てられるプライベートIPアドレスに，指定したホスト名をマッピングする．マッピングは，```/etc/hosts```ファイルに書き込まれる．もし設定しなかった場合，サービス名またはコンテナ名がホスト名として扱われる．

**＊実装例＊**

```yaml
hostname: www
```

```shell
$ cat /etc/hosts

127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
# プライベートIPアドレスにマッピングされたホスト名
172.18.0.3      www
```

#### ・```networks```

![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Dockerエンジン内の仮想ネットワーク.jpg)

コンテナを接続する内部／外部ネットワークのエイリアス名を設定する．ネットワーク名ではなく，エイリアス名を指定することに注意する．

**＊実装例＊**

```yaml
networks:
  # 内部／外部ネットワークのエイリアス名を指定する．
  - example-network
```

ネットワークに接続されているコンテナはコマンドで確認できる．

```sh
# 指定したネットワークに接続するコンテナを確認する．
$ docker network inspect example-network

[
    {
        "Name": "example-network",
        
        〜 省略 〜
        
        "Containers": {
            "e681fb35e6aa5c94c85acf3522a324d7d75aad8eada13ed1779a4f8417c3fb44": {
                "Name": "<コンテナ名>",
                "EndpointID": "ef04da88901646359086eeb45aab81d2393c2f71b4266ccadc042ae49d684409",
                "MacAddress": "xx:xx:xx:xx:xx:xx",
                "IPv4Address": "nnn.nn.n.n/nn",
                "IPv6Address": ""
            "33632947e4210126874a7c26dce281642a6040e1acbebbdbbe8ba333c281dff8": {
                "Name": "<コンテナ名>",
                "EndpointID": "ef04da88901646359086eeb45aab81d2393c2f71b4266ccadc042ae49d684409",
                "MacAddress": "xx:xx:xx:xx:xx:xx",
                "IPv4Address": "nnn.nn.n.n/nn",
                "IPv6Address": ""            
            }
        },
        
        〜 省略 〜
        
        "Labels": {
            "com.docker.compose.network": "example-network",
            "com.docker.compose.project": "<プロジェクト名>",
            "com.docker.compose.version": "1.29.0"
        }
    }
]
```

なお，接続するネットワークは明示的に指定しなくてもよい．その場合，『<プロジェクト名>_default』というネットワークが，『default』というエイリアス名で作成される．

```yaml
networks:
  # defaultは，明示的に指定してもしなくてもどちらでもよい．
  - default
```

```shell
$ docker network inspect <プロジェクト名>_default

[
    {
        "Name": "<プロジェクト名>_default",
        
        〜 省略 〜
        
        "Containers": {
            "e681fb35e6aa5c94c85acf3522a324d7d75aad8eada13ed1779a4f8417c3fb44": {
                "Name": "<コンテナ名>",
                "EndpointID": "ef04da88901646359086eeb45aab81d2393c2f71b4266ccadc042ae49d684409",
                "MacAddress": "xx:xx:xx:xx:xx:xx",
                "IPv4Address": "nnn.nn.n.n/nn",
                "IPv6Address": ""
            "33632947e4210126874a7c26dce281642a6040e1acbebbdbbe8ba333c281dff8": {
                "Name": "<コンテナ名>",
                "EndpointID": "ef04da88901646359086eeb45aab81d2393c2f71b4266ccadc042ae49d684409",
                "MacAddress": "xx:xx:xx:xx:xx:xx",
                "IPv4Address": "nnn.nn.n.n/nn",
                "IPv6Address": ""            
            }
        },
        
        〜 省略 〜
        
        "Labels": {
            "com.docker.compose.network": "default",
            "com.docker.compose.project": "<プロジェクト名>",
            "com.docker.compose.version": "1.29.0"
        }
    }
]
```

#### ・```image```

**＊実装例＊**

```yaml
image: tech-notebook-www:<タグ名>
```

#### ・```ports```

ホストOSとコンテナの間のポートフォワーディングを設定する．コンテナのみポート番号を指定した場合，ホストOS側のポート番号はランダムになる．

**＊実装例＊**

```yaml
ports:
  - "8080:80" # <ホストOS側のポート番号>:<コンテナのポート番号>
```

#### ・```stdin_open```

内部的な```run```コマンドの実行時に```i```オプションを有効化する．

**＊実装例＊**

```yaml
stdin_open: true
```

#### ・```tty```

内部的な```run```コマンドの実行時に```t```オプションを有効化する．疑似ターミナルを割り当てるによって，```exit```の後もバックグラウンドでコンテナを起動させ続けられる．

**＊実装例＊**

```yaml
tty: true
```

#### ・```volumes```（Bindマウント）

最上層と```service```内で，異なるVolume名を記述した場合，Bindマウントを定義する．ホストOSにある```/Users```ディレクトリをコンテナ側にマウントする．

**＊実装例＊**


```yaml
volumes:
  - ./app:/var/www/app # <ホストOSのディレクトリ>:<コンテナのディレクトリ>
```

#### ・```volumes```（Volumeマウント）

最上層と```service```内の両方に，同じVolume名を記述した場合，Volumeマウントを定義する．DockerエリアにVolumeが作成され，```service```オプション内に設定した```volumes```オプションでVolumeマウントを行う．

**＊実装例＊**

```yaml
service:
  db:
    volumes:
      # volumeマウント
      - mysql_volume:/var/www/lib/mysql
      
volumes:
  # volume名
  mysql_volume:
    # localで，ホストOSのDockerエリアを指定
    driver: local   
```

#### ・変数展開

環境変数を```docker-compose.yml```ファイルに展開する．変数の展開にあたり，```docker-compose.yml```ファイルと同じ階層にある```.env```ファイルが自動的に読み込まれる．この展開に```env_file```オプションを使用することはできない．そのため，例えば```.env```ファイル以外の名前の環境変数ファイルを変数展開のために使用することはできない．

**＊実装例＊**

```yaml
build:
  # 出力元の値は，.envファイルに定義しなければならない．
  target: ${APP_ENV}

image: ${APP_ENV}-example-app
```

<br>

### networks

#### ・```networks```とは

標準のネットワークを作成する．ただし定義しなくとも自動的に構築される．ネットワーク名は，指定しない場合に『<プロジェクト名>_default』になる．

#### ・```default - name```

ネットワーク名をユーザ定義名にする．

```yaml
networks:
  default:
    # ユーザ定義のネットワーク名とエイリアス名
    name: example-network
```

なお，このネットワークを明示的に設定する場合は，エイリアス名（default）で指定する．

```yaml
networks:
  # defaultは，明示的に指定してもしなくてもどちらでもよい．
  - default
```

```shell
$ docker network ls

NETWORK ID       NAME                DRIVER     SCOPE
xxxxxxxxxxxx     example-network     bridge     local
```

```shell
$ docker network inspect example-network

[
    {
        "Name": "example-network",
        
        〜 省略 〜
        
        "Containers": {
            "e681fb35e6aa5c94c85acf3522a324d7d75aad8eada13ed1779a4f8417c3fb44": {
                "Name": "<コンテナ名>",
                "EndpointID": "ef04da88901646359086eeb45aab81d2393c2f71b4266ccadc042ae49d684409",
                "MacAddress": "xx:xx:xx:xx:xx:xx",
                "IPv4Address": "nnn.nn.n.n/nn",
                "IPv6Address": ""
            "33632947e4210126874a7c26dce281642a6040e1acbebbdbbe8ba333c281dff8": {
                "Name": "<コンテナ名>",
                "EndpointID": "ef04da88901646359086eeb45aab81d2393c2f71b4266ccadc042ae49d684409",
                "MacAddress": "xx:xx:xx:xx:xx:xx",
                "IPv4Address": "nnn.nn.n.n/nn",
                "IPv6Address": ""            
            }
        },
        
        〜 省略 〜
        
        "Labels": {
            "com.docker.compose.network": "example-network",
            "com.docker.compose.project": "<プロジェクト名>",
            "com.docker.compose.version": "1.29.0"
        }
    }
]
```

#### ・```external```

異なる```docker-compose.yml```ファイルから接続できるネットワークを作成する．作成されるネットワーク名とエイリアス名は，```external```キーの上部で設定したものになる．

**＊実装例＊**

バックエンドとフロントエンドが異なる```docker-compose.yml```ファイルで管理されている．フロントエンドコンテナからバックエンドコンテナに接続できるように，ネットワークを作成する．

```yaml
# バックエンドのDocker-compose
services:
  app:
    container_name: backend-container
    
# --- 省略 --- #
    
networks:
  # 作成したい外部ネットワーク名とエイリアス名
  backend:
    external: true  
```

フロントエンドコンテナにて，エイリアス名にネットワーク名を指定して，

```yaml
# フロントエンドのDocker-compose
services:
  app:
    container_name: frontend-container
    # 内部／外部ネットワークのいずれかのエイリアス名を指定する．
    networks:
      - backend

# --- 省略 --- #

networks:
  default:
    external:
      # 接続したい外部ネットワーク名とエイリアス名
      name: backend
```

作成した内部／外部ネットワークは，コマンドで確認できる．『<エイリアス名>_default』というネットワーク名になる．

**＊コマンド例＊**

```shell
$ docker network ls

NETWORK ID       NAME        DRIVER     SCOPE
xxxxxxxxxxxx     backend     bridge     local
```

<br>

### Tips

#### ・mysqlコンテナのビルド時に処理実行

mysqlコンテナには```docker-entrypoint-initdb.d```ディレクトリがある．このディレクトリに配置された```sql```ファイルや```shell```プロセスは，mysqlコンテナのビルド時に```docker-entrypoint.sh```ファイルによって実行される．そのため，Bindマウントを用いてこのディレクトリにファイルを置くことで，初期データの投入や複数データベースの作成を実現できる．具体的な実行タイミングについては，以下を参考にせよ．

参考：https://github.com/docker-library/mysql/blob/master/8.0/Dockerfile.debian#L92-L93

**＊実装例＊**

mysqlコンテナに，PHPUnitの実行時のみ使用するデータベースを追加する．以下のような，```docker-compose.yml```ファイルを作成する．

```yml
version: "3.7"

services:

  db:
    container_name: example-mysql
    hostname: example-mysql
    image: mysql:5.7
    ports:
      - "3307:3306"
    volumes:
      - mysql_volume:/var/www/lib/mysql
      # docker-entrypoint-initdb.dディレクトリにBindマウントを行う．
      - ./infra/docker/mysql/init:/docker-entrypoint-initdb.d
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: example
      MYSQL_USER: example
      MYSQL_PASSWORD: example
      TZ: "Asia/Tokyo"
    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci
    networks:
      - default
      
  volumes:
    mysql_volume:
```

また，```docker-entrypoint-initdb.d```ディレクトリに配置するファイルとして，以下の```sql```ファイルを作成する．このファイルでは，```test```というデータベースを作成するためのSQLを実装する．これにより，mysqlの起動時に

```sql
-- /infra/docker/mysql/initにSQLファイルを置く．
CREATE DATABASE IF NOT EXISTS `test` COLLATE 'utf8mb4_general_ci' CHARACTER SET 'utf8mb4';
GRANT ALL ON *.* TO 'example'@'%' ;
```

PHPUnitで接続するデータベースを指定する方法については，以下を参考にせよ．

参考：https://hiroki-it.github.io/tech-notebook-gitbook/public/backend_testing.html

<br>

## 03. Docker Swarm

![DockerSwarmの仕組み](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/DockerSwarmの仕組み.png)

<br>

## 04. Google Kubernetes

![Kubernetesの仕組み](https://raw.githubusercontent.com/hiroki-it/tech-notebook/master/images/Kubernetesの仕組み.png)

### Node

#### ・Master Node

Kubernetesが実行される物理サーバを指す．

#### ・Worker Node

Dockerが実行される仮想サーバを指す．

<br>

### Pod

#### ・Podとは

仮想サーバのホストOS上のコンテナをグループ単位のこと．Pod内の一部のコンテナを起動／停止させることはできず，全てのコンテナを起動／停止する必要がある．

#### ・Secret

セキュリティに関するデータを管理し，コンテナに選択的に提供するもの．

#### ・Replica Set（Replication Controller）

#### ・Kubectl

<br>

### Istio

#### ・Istioとは

マイクロサービスの各アプリケーションを管理するソフトウェアのこと．機能『A ---> B ---> C ---> D』を持つモノリシックアプリケーションがあるとする．これをマイクロサービス化して，ABCDを別々のアプリケーションに分割する．それぞれのアプリケーションがPod上で稼働することになる．しかし，これだけではABCDが独立しておらず，各機能は一つ前の機能に依存している．この依存関係を解決するのがIstioである．

#### ・Istiod

Envoyを管理する機能のこと．Envoyは，各アプリケーションから通信を委譲され，アプリケーション間の通信を代理で行う．

