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

### オプション

#### ・```container_name```

コンテナ名の命名．

**＊実装例＊**

```yaml
container_name: www
```

#### ・```hostname```

**＊実装例＊**

他のコンテナからアクセスする時のホスト名を指定する．もし設定しなかった場合，サービス名またはコンテナ名が，ホスト名として設定される．

```yaml
hostname: www
```

#### ・```build: dockerfile```

Dockerfileの名前．パスごと指定する．

**＊実装例＊**

```yaml
build:
  dockerfile: ./infra/docker/www/Dockerfile
```

#### ・```build: target```

ビルドするステージ名．主に，マルチステージビルドの時に使用する．

**＊実装例＊**

```yaml
build:
  target: develop
```

#### ・```build: context```

指定したDockerfileのあるディレクトリをカレントディレクトリとして，Dockerデーモン（Dockerエンジン）に送信するディレクトリを指定する． 

**＊実装例＊**

```yaml
build:
  context: .
```

#### ・```tty```

```docker exec -it```に相当する．疑似ターミナルを割り当てるによって，```exit```の後もコンテナを起動させ続けられる．

**＊実装例＊**

```yaml
tty: true
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
      - db_volume:/var/www/lib/mysql
      
volumes:
  # volume名
  db_volume:
    # localで，ホストOSのDockerエリアを指定
    driver: local   
```

#### ・```environment```

mysqlイメージを使用した場合，環境変数を定義することによって，ルートユーザと一般ユーザを自動的に作成できる．ルートユーザ名は定義できず，「```root```」となる．

**＊実装例＊**

```yaml
environment:
  MYSQL_ROOT_PASSWORD: xxxxx # rootユーザのパス
  MYSQL_DATABASE: example # データベース名
  MYSQL_USER: example_user # 一般ユーザ名
  MYSQL_PASSWORD: xxxxx # 一般ユーザのパス
```


#### ・```depends_on```

コンテナが起動する順番．

**＊実装例＊**

```yaml
# ここに実装例
```

#### ・```networks```

作成使用する内部／外部ネットワークを設定．

![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerエンジン内の仮想ネットワーク.jpg)

**＊実装例＊**

バックエンドとフロントエンドが異なるdocker composeで管理されており，フロントエンドコンテナからバックエンドコンテナに接続する．

```yaml
# バックエンドのDocker-compose
services:
  app:
    container_name: backend-container
    
# --- 省略 --- #
    
networks:
  backend: # 作成したい外部ネットワーク名
    external: true  
```

```yaml
# フロントエンドのDocker-compose
services:
  app:
    container_name: frontend-container
    networks: # 接続した内部／外部ネットワークのいずれかを選択．
      - default
      - backend

# --- 省略 --- #

networks:
  default:
    external:
      name: backend # 接続したい外部ネットワーク
```

作成した内部／外部ネットワークは，以下のコマンドで確認できる．```xxx_default```という名前になる．

**＊コマンド例＊**

```bash
$ docker network ls

NETWORK ID       NAME                      DRIVER       SCOPE
xxxxxxxxxxxx     backend_default           bridge       local
xxxxxxxxxxxx     <プロジェクト名>_default     bridge      local
```

<br>

### docker-composeコマンド

#### ・up

すでに起動中／停止中コンテナがある場合，それをデタッチドモードで再起動する．

**＊コマンド例＊**

```bash
# イメージのビルド，コンテナレイヤー生成，コンテナ構築，コンテナ起動
$ docker-compose up -d
```

#### ・run

すでに起動中／停止中コンテナがあっても，それを残して新しいコンテナを構築し，デタッチドモードで起動する．古いコンテナが削除されずに残ってしまう．

**＊コマンド例＊**

```bash
# イメージのビルド，コンテナレイヤー生成，コンテナ構築，コンテナ起動 
$ docker-compose run -d -it <イメージ名>
```

#### ・stop

起動中のコンテナを全て停止する．

**＊コマンド例＊**

```bash
$ docker-compose stop
```

#### ・logs

コンテナ内に入ることなく，起動プロセスから出力されるログを確認することできる．

**＊コマンド例＊**

```bash
# コンテナ名でなくサービス名であることに注意
$ docker-compose logs <サービス名>

# フォアグラウンドでログを表示
$ docker-compose logs -f <サービス名>
```

<br>

## 03. Docker Swarm

![DockerSwarmの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/DockerSwarmの仕組み.png)

<br>

## 04. Google Kubernetes

![Kubernetesの仕組み](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Kubernetesの仕組み.png)

### Node

#### ・Master Node

Kubernetesが実行される物理サーバを指す．

#### ・Worker Node

Dockerが実行される仮想サーバを指す．

<br>

### Pod

#### ・Podとは

仮想サーバのホストOS上のコンテナをグループ化したもの．

#### ・Secret

セキュリティに関するデータを管理し，コンテナに選択的に提供するもの．

#### ・Replica Set（Replication Controller）

#### ・Kubectl

