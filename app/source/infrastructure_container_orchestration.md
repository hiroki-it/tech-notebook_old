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

#### ・```container_name```

コンテナ名の命名

```yaml
# ここに実装例
```

#### ・```build```

Dockerfileのディレクトリの相対パス． 

```yaml
# ここに実装例
```

#### ・```tty```

```yaml
# ここに実装例
```

#### ・```image```
```yaml
# ここに実装例
```


#### ・```ports```

ホストOSとコンテナの間のポートフォワーディングを設定．コンテナのみポート番号を指定した場合，ホストOS側のポート番号はランダムになる．

```yaml
ports:
  - "8080:80" # {ホストOS側のポート番号}:{コンテナのポート番号}
```

#### ・```volumes```

ホストOSの```/var/lib/docker/volumes/```の下にDataVolumeのディレクトリを作成し，DataVolumeをマウントするコンテナ側のディレクトリをマッピング．


```yaml
volumes:
  - ./app:/var/www/app # {ホストOSのディレクトリ}:{コンテナのディレクトリ}
```

#### ・```environment```

DBコンテナに設定する環境変数．

```yaml
environment:
  MYSQL_ROOT_PASSWORD: xxxxx # Rootパス
  MYSQL_DATABASE: example # データベース名
  MYSQL_USER: example_user # ユーザ名
  MYSQL_PASSWORD: xxxxx # ユーザパス
```


#### ・```depends_on```

コンテナが起動する順番．

**【実装例】**

```yaml
# ここに実装例
```

#### ・```networks```

作成使用する内部／外部ネットワークを設定．

![Dockerエンジン内の仮想ネットワーク](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/Dockerエンジン内の仮想ネットワーク.jpg)

**【実装例】**

バックエンドとフロントエンドが異なるdocker composeで管理されており，フロントエンドコンテナからバックエンドコンテナに接続する．

```yaml
# バックエンドのDocker-compose
services:
  app:
    container_name: backend-container
    
# --- 省略 --- #
    
networks:
  backend: # 作成したい外部ネットワーク
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

```bash
$ docker network ls

NETWORK ID       NAME                      DRIVER       SCOPE
xxxxxxxxxxxx     backend_default           bridge       local
xxxxxxxxxxxx     {プロジェクト名}_default     bridge      local
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

