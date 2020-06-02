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



## 02-02. CircleCI

### 設定ファイルの書き方

#### ・Version

```yml
# バージョン
version: 2.1
```

#### ・Orbs

汎用的なパッケージの使用を宣言する．

```yml
# AWS-ECRパッケージを使用．
orbs:
  aws-ecr: circleci/aws-ecr@4.0.4
```

```Commands```や```Executors```を用いて設定を部品化し，異なる```Job```で繰り返し利用できる．

```yml
# ホスト（CircleCI）側の環境の設定
executors:
  setup-executor:
    # 環境タイプの設定
    machine: true
    # -- Fix: CircleCIのディレクトリは，/root/project(=tech-notebook)/
    working_directory: ~/tech-notebook
```

また，```Job```において，特定のオプション（例```aws-ecr/build-and-push-image```）を宣言し．その機能を使える．

```yml
  push-builder-to-ecr:
    executor: setup-executor
    steps:
      - checkout
      # -- Fix: env_var_name型とstring型の間で，変数展開の記述方法が異なる
      - aws-ecr/build-and-push-image:
          account-url: AWS_ACCOUNT_URL
          aws-access-key-id: AWS_ACCESS_KEY
          aws-secret-access-key: AWS_SECRET_KEY
          dockerfile: "infra/docker/builder/Dockerfile"  # -f に相当
          path: "." # PATHに相当
          region: AWS_REGION
          repo: ${REPOSITORY_NAME_BUILDER}
          tag: ${VERSION}
```

#### ・Jobs

```Job```を定義する．少なくとも一つの```job```には```build```という名前を使用しなければならない．

```yml
# ジョブの設定
jobs:
  push-images:
    # 部品化したexecutorを使用
    executor: setup-executor
    steps:
      - run:
          # -- Fix: checkoutが日本語を認識できないので対処
          name: Setup git config
          command: |
            git config --global core.quotepath false
      - checkout
      - run:
          name: Build builder
          command: |
            docker build -f infra/docker/builder/Dockerfile -t ${DOCKER_USER}/${REPOSITORY_NAME_BUILDER} .
      - run:
          name: Build www
          command: |
            docker build -f infra/docker/www/Dockerfile -t ${DOCKER_USER}/${REPOSITORY_NAME_WWW} .
      - run:
          name: Login to docker hub
          command: |
            echo ${DOCKER_PASS} |
            docker login -u ${DOCKER_USER} --password-stdin
      - run:
          name: Push builder
          command: |
            docker push ${DOCKER_USER}/${REPOSITORY_NAME_BUILDER}:${VERSION}
      - run:
          name: Push www
          command: |
            docker push ${DOCKER_USER}/${REPOSITORY_NAME_WWW}:${VERSION}
  
  push-builder-to-ecr:
    executor: setup-executor
    steps:
      - checkout
      # -- Fix: env_var_name型とstring型の間で，変数展開の記述方法が異なる
      - aws-ecr/build-and-push-image:
          account-url: AWS_ACCOUNT_URL
          aws-access-key-id: AWS_ACCESS_KEY
          aws-secret-access-key: AWS_SECRET_KEY
          dockerfile: "infra/docker/builder/Dockerfile"
          path: "."
          region: AWS_REGION
          repo: ${REPOSITORY_NAME_BUILDER}
          tag: ${VERSION}
  
  push-www-to-ecr:
    executor: setup-executor
    steps:
      - checkout
      # -- Fix: env_var_name型とstring型の間で，変数展開の記述方法が異なる
      - aws-ecr/build-and-push-image:
          account-url: AWS_ACCOUNT_URL
          aws-access-key-id: AWS_ACCESS_KEY
          aws-secret-access-key: AWS_SECRET_KEY
          dockerfile: "infra/docker/www/Dockerfile"
          path: "."
          region: AWS_REGION
          repo: ${REPOSITORY_NAME_WWW}
          tag: ${VERSION}
    
  build:
    docker:
      - image: ${DOCKER_USER}/${REPOSITORY_NAME_BUILDER}:${VERSION}
    steps:
      - run:
          # -- Fix: checkoutが日本語を認識できないので対処
          name: Setup git config
          command: |
            git config --global core.quotepath false
      - checkout
      - run:
          # Htmlの生成
          name: Build html
          command: |
            make html
      - run:
          # 格納ディレクトリの掃除
          name: Clean up html
          command: |
            make clean
```

#### ・Workflow

```job```をどのような順番で行うかなどを定義する．並列的に実行することも可能．

```yml
# 実行の順番を定義
workflows:
  version: 2.1
  build-push:
    jobs:
      # Docker Hub
      - push-images
      # AWS ECR builder
      - push-builder-to-ecr:
          requires:
            - build
      # AWS ECR www
      - push-www-to-ecr:
          requires:
            - build
      - build:
          requires:
            - push-images

```



### 各種コマンド

#### ・設定ファイルの静的解析

ホストOS側で，以下のコマンドを実行する．

```bash
circleci config validate

# 以下の文章が表示されれば問題ない．
# Config file at .circleci/config.yml is valid.
```

#### ・ビルド

ローカルでビルドを行う．

```bash
circleci build .circleci/config.yml
```



## 03. CDツールによるデプロイフェイズの自動実行

### Capistrano

#### ・クラウドデプロイサーバにおけるデプロイ

1. 自身のパソコンからクラウドデプロイサーバにリモート接続する．
2. クラウドデプロイサーバの自動デプロイツール（例：Capistrano）が，クラウドデプロイサーバからクラウドWebサーバにリモート接続する．
3. 自動デプロイツールが，クラウドWebサーバのGitを操作し，```pull```あるいは```clone```を実行する．その結果，GitHubからクラウドデプロイサーバに指定のブランチの状態が取り込まれる．

![デプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/デプロイ.png)



### AWS CodeDeploy

#### ・デプロイ

![CodeDeployを用いた自動デプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/source/images/CodeDeployを用いた自動デプロイ.png)

