# 継続的な ビルド／テスト／デプロイ の流れ

## 01. CI/CDの流れ

### CI：Continuous Integration，CD：Continuous Deliveryとは

Code > Build > Test > Code > Build > Test ・・・ のサイクルを高速に回して，システムの品質を継続的に担保することを，『Continuous Integration』という．また，変更内容をステージング環境などに自動的に反映し，継続的にリリースすることを，『Continuous Delivery』という．

![cicdツールの種類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/cicdツールの種類.png)



## 02. CIツールによるビルドフェイズとテストフェイズの自動実行

### CircleCI

#### ・PHPUnitの自動実行

1. テストクラスを実装したうえで，新機能を設計実装する．

2. リポジトリへPushすると，CIツールがGituHubからブランチの状態を取得する．

3. CIツールによって，DockerHubから取得したDockerfileのビルド，PHPUnitなどが自動実行される．

4. 結果を通知することも可能．

![継続的インテグレーション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/継続的インテグレーション.png)

#### ・PHPStanの自動実行



## 03. CircleCI

### 設定ファイルの参考ドキュメント

https://circleci.com/docs/ja/2.0/configuration-reference/



### 各種コマンド

#### ・設定ファイルの静的解析

ホストOS側で，以下のコマンドを実行する．

```bash
$ circleci config validate

# 以下の文章が表示されれば問題ない．
# Config file at .circleci/config.yml is valid.
```

#### ・ビルド

ローカルでビルドを行う．

```bash
$ circleci build .circleci/config.yml
```



## 03-02. version

### versionとは

CircleCIのバージョンを宣言．

**【実装例】**

```yaml
version: 2.1
```



## 03-03. orbs

### orbsとは

CircleCIから提供される汎用的なパッケージの使用を読み込む．

**【実装例】**

```yaml
version: 2.1
orbs:
    hello: circleci/hello-build@0.0.5
    
workflows:
    "Hello Workflow":
        jobs:
          - hello/hello-build
```

以下のAWS認証情報は，CircleCIのデフォルト名と同じ環境変数名で登録しておけば，ここでせってしなくても，自動で補完してくれる．

**【実装例】**

```yaml
version: 2.1
orbs:
  aws-ecr: circleci/aws-ecr@6.9.0
  
workflows:
  version: 2.1
  build-push:
    - aws-ecr/build-and-push-image:
        account-url: AWS_ECR_ACCOUNT_URL
        aws-access-key-id: AWS_ACCESS_KEY_ID
        aws-secret-access-key: AWS_SECRET_KEY_ID
        region: AWS_REGION
```



## 03-04. jobs

### jobsとは

```Job```を定義する．Workflowsを使わない場合は，少なくとも一つの```job```には```build```という名前を使用しなければならない．



### docker，machine

#### ・docker

Docker環境で，同じくDockerイメージをビルドする場合，CircleCIコンテナの外でこれをビルドする必要がある．本環境の場合，DockerfileのCOPYコマンドが機能しないので注意．

**【実装例】**


```yaml
version: 2
jobs:
 build:
   docker:
     - image: circleci/xxx
   steps:
     - checkout
     - setup_remote_docker
     - run: | # DockerHubへのログイン
         echo "$DOCKER_PASS" | docker login --username $DOCKER_USER --password-stdin
         docker run -d --name db company/proprietary-db:1.2.3

     # Dockerイメージのビルド
     - run: docker build -t company/app:$CIRCLE_BRANCH .

     # DockerイメージのDockerHubへのデプロイ
     - run: docker push company/app:$CIRCLE_BRANCH
```

#### ・machine

**【実装例】**

```yaml
version: 2
jobs:
 build:
   machine: true
   steps:
     - checkout
     - run: | # DockerHubへのログイン
         echo "$DOCKER_PASS" | docker login --username $DOCKER_USER --password-stdin
         docker run -d --name db company/proprietary-db:1.2.3

     # Dockerイメージのビルド
     - run: docker build -t company/app:$CIRCLE_BRANCH .

     # DockerイメージのDockerHubへのデプロイ
     - run: docker push company/app:$CIRCLE_BRANCH
```



### parameters

引数を与えなかった場合の値を設定できる．再利用する時，「```引数名: 値```」で引数を渡す．

#### ・Bool型

**【実装例】**

引数がTrueの場合のみstepsを実行したい時に用いる．Jobで呼び出した時にBool値を渡す．

```yaml
jobs:
  deploy:
    parameters:
      production: # 引数名
         type: boolean
         default: false
    steps: # 以下で何らかの処理
```

#### ・Enum型

**【実装例】**

特定の文字列や整数のみを引数として許可したいときに用いる．Jobで呼び出した時に，Enumのいずれかを引数として渡す．

```yaml
jobs:
  deploy:
    parameters:
      environment: # 引数名
        default: "staging"
        type: enum
        enum: ["staging", "production"]
    steps:
      - run:
        name: Deploy to << parameters.env >>
```



### steps

#### ・when

**【実装例】**

```yaml
version: 2.1

jobs:
  custom_checkout:
    parameters:
      custom_checkout_parameters:
        type: bool
        default: false
    machine: true
    steps:
      - when: # 引数がtrueの場合
          condition: <<parameters.custom_checkout_parameters>>
          steps:
            - run: echo "独自のチェックアウト処理"
      - unless: # 引数がfalseの場合
          condition: <<parameters.custom_checkout_parameters>>
          steps:
            - checkout
            
workflows:
  build-test-deploy:
    jobs:
      - custom_checkout:
          custom_checkout_parameters: true
      - custom_checkout:
          custom_checkout_parameters: false
```


#### ・restore_cache，save_cache

![CircleCIキャッシュ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CircleCIキャッシュ.png)

生成したファイルをキャッシュとして保存する．使い所として，例えば，ライブラリはcomposer.jsonの設定が変更されない限り，同じライブラリがインストールされる．しかし，CircleCIのWorkflowのたびに，ライブラリをインストールするのは非効率である．そこで，composer.jsonが変更されない限り，前回のWorkflow時に生成されたvendorディレクトリを繰り返し利用するようにする．また，一つのWorkflowの中でも，繰り返し利用できる．

**【実装例】**

```yaml
steps:
   # composer.jsonが変更されている場合は処理をスキップ．
   - restore_cache:
     key:
       - v1-dependecies-{{ checksum composer.json }}
   # 取得したcomposer.jsonを元に，差分のvendorをインストール
   - run: composer install
   # 最新のvendorを保存
   - save_cache:
     key: v1-dependecies-{{ checksum composer.json }}
     paths:
       - /vendor
```

ただ，この機能はcommandsで共通化した方が可読性が良い．

**【実装例】**

```yaml
commands:
  restore_vendor:
    steps:
      # composer.jsonが変更されている場合は処理をスキップ．
      - restore_cache:
          key:
            - v1-dependecies-{{ checksum composer.json }}
  # 取得したcomposer.jsonを元に，差分のvendorをインストール
  install_vendor:
     steps:
       - run: composer install
  save_vendor:
    steps:
      # 最新のvendorを保存
      - save_cache:
          key: v1-dependecies-{{ checksum composer.json }}
          paths:
            - /vendor
```



## 03-05. command

### commandとは

設定を部品化し，異なる```Job```で繰り返し利用できる．

**【実装例】**

```yaml
commands:
  sayhello:
    description: "デモ用のごく簡単なコマンドです"
    parameters:
      text:
        type: string
        default: "Hello World"
    steps:
      - run: echo << parameters.text >> # parametersから渡されたtextを渡す
      
jobs:
  myjob:
    docker:
      - image: "circleci/node:9.6.1"
    steps:
      - sayhello: # command名
          text: "Lev" # 引数名: 値
```



## 03-06. executors

### executorsとは

ホストOS環境に関する設定を部品化し，異なる```Job```で繰り返し利用できる．

```yaml
version: 2.1
executors:
  my-executor: # ホストOS環境名
    docker: # ホストOS環境
      - image: circleci/ruby:2.5.1-node-browsers

jobs:
  my-job:
    executor: my-executor
    steps:
      - run: echo "Executor の外で定義しました"
```



## 04. CDツールによるデプロイフェイズの自動実行

### Capistrano

#### ・クラウドデプロイサーバにおけるデプロイ

1. 自身のパソコンからクラウドデプロイサーバにリモート接続する．
2. クラウドデプロイサーバの自動デプロイツール（例：Capistrano）が，クラウドデプロイサーバからクラウドWebサーバにリモート接続する．
3. 自動デプロイツールが，クラウドWebサーバのGitを操作し，```pull```あるいは```clone```を実行する．その結果，GitHubからクラウドデプロイサーバに指定のブランチの状態が取り込まれる．

![デプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/デプロイ.png)



### AWS CodeDeploy

#### ・デプロイ

![CodeDeployを用いた自動デプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CodeDeployを用いた自動デプロイ.png)

