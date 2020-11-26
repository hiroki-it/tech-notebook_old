# CircleCI，Capistrano

## 01. CI/CDの流れ

### CI：Continuous Integration，CD：Continuous Deliveryとは

Code > Build > Test > Code > Build > Test ・・・ のサイクルを高速に回して，システムの品質を継続的に担保することを，『Continuous Integration』という．また，変更内容をステージング環境などに自動的に反映し，継続的にリリースすることを，『Continuous Delivery』という．

![cicdツールの種類](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/cicdツールの種類.png)

<br>

## 02. CircleCI

### 設定ファイルの参考ドキュメント

https://circleci.com/docs/reference-2-1/#circleci-2-1-reference

<br>

### 設定ファイルのデバッグ

#### ・デバッグの事前準備

デバッグでは行数がわからない仕様になっている．そこで，Workflowのjobのどこで失敗しているのかを特定するために，検証しないjobをコメントアウトしておく．

```yaml
workflows:
  version: 2.1
  # build以外を実行しないようにすることで，buildのみを検証できる．
  build-test-and-deploy:
    jobs:
      - build
#      - test1:
#          requires:
#            - build
#      - test2:
#          requires:
#            - test1
#      - deploy:
#          requires:
#            - test2
```


#### ・バリデーション

ホストOS側で，以下のコマンドを実行する．

```bash
$ circleci config validate

# 以下の文章が表示されれば問題ない．
# Config file at .circleci/config.yml is valid.
```

#### ・処理の展開

設定ファイルを実行した時の処理を展開し，ファイルに出力できる

```bash
$ circleci config process .circleci/config.yml > .circleci/process.yml
```

#### ・ローカルテスト

コマンドにより，テストに必要なDockerイメージをpullし，コンテナを構築する．続いて，コンテナ内でCircleCIを実行する．バージョン2.1以降では，事前に，設定ファイルの処理を展開しておく必要がある．

```bash
# バージョン2.1の設定ファイルの処理を展開
$ circleci config process .circleci/config.yml > .circleci/process.yml

# 専用のDockerコンテナを構築し，展開ファイルを元にテストを実行
$ circleci local execute -c .circleci/process.yml --job <job名>
```

#### ・CircleCIコンテナにssh接続

CircleCIコンテナにssh接続し，コンテナ内で生成されたファイルを確認することができる．

```bash
$ <CircleCIから提示されたコマンドをコピペ> -i ~/.ssh/<秘密鍵名>
```

<br>

### PHPUnitの自動実行

#### ・仕組み

1. テストクラスを実装したうえで，新機能を設計実装する．

2. リポジトリへPushすると，CIツールがGituHubからブランチの状態を取得する．

3. CIツールによって，DockerHubから取得したDockerfileのビルド，PHPUnitなどが自動実行される．

4. 結果を通知することも可能．

![継続的インテグレーション](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/継続的インテグレーション.png)

### PHPStanの自動実行

#### ・仕組み

<br>

## 02-02. version

### versionとは

CircleCIのバージョンを宣言．

**＊実装例＊**

```yaml
version: 2.1
```

<br>

## 02-03. parameters

### parametersとは

#### ・各定義方法の参照範囲

| 方法                | 参照範囲                                                     | 値を設定する場所 |
| ------------------- | ------------------------------------------------------------ | ---------------- |
| command parameters  | ```command```内で定義する．定義された```command```内のみで定義できる． | ```workflows```  |
| job parameters      | ```job```内で定義する．定義された```job```内のみで参照できる． | ```workflows```  |
| executors parameter | ```executors```内で定義する．定義された```executos```内のみで参照できる． | ```job```        |
| pipeline parameters | トップレベルで定義する．リポジトリ内でのみ参照できる．       | ```workflows```  |

<br>

### command parameters

#### ・値の出力方法

引数名を使用して，```parameters```から値を出力する．

```
<< parameters.xxxxx >>
```

#### ・job parameterを参照

定義できるデータ型は，job parameterと同じ．定義された```command```内のみで定義できる．

```yaml
version: 2.1
commands:
  sayhello:
    description: "Echo hello world"
    # 引数の定義
    parameters:
      to:
        type: string
        # デフォルト値
        default: "Hello World"
    steps:
      - run: echo << parameters.to >>
```

<br>

### job parameters

#### ・値の出力方法

引数名を使用して，```parameters```から値を出力する．

```
<< parameters.xxxxx >>
```

#### ・デフォルト値について

引数が与えられなかった場合に適用される```default```を設定できる．```default```を設定しない場合，引数が必須と見なされる．

```yaml
version: 2.1
commands:
  sayhello:
    description: "Echo hello world"
    parameters:
      to:
        type: string
        default: "Hello World"
    steps:
      - run: echo << parameters.to >>
```

#### ・string型

引数として，任意の文字列を渡したいときに使用する．```workflows```にて，値を設定する．

**＊実装例＊**

```yaml
version: 2.1

commands:
  print:
    # 引数を定義
    parameters:
      message:
        # デフォルト値が無い場合は必須
        type: string
    steps:
      - run: echo << parameters.message >>

jobs:
  cat-file:
    parameters:
      file:
        type: string
    steps:
      - print:
          # parametersの値を渡す
          message: Printing << parameters.file >>
      - run: cat << parameters.file >>

workflows:
  my-workflow:
    jobs:
      - cat-file:
          # workflowにて文字列型の値を設定
          file: test.txt
```

#### ・boolean型

多くの場合，引数がTrueの場合のみ，特定の```step```を実行したい時に用いる．```job```で定義した後，```workflows```にて値を設定する．```workflows```にて，値を設定する．

**＊実装例＊**

```yaml
version: 2.1

jobs:
  job_with_optional_custom_checkout:
    # 引数の定義
    parameters:
      custom_checkout:
        type: boolean
        # デフォルト値
        default: false
    machine: true
    steps:
      - when:
          # 引数がtrueの場合
          condition: << parameters.custom_checkout >>
          steps:
            - run: echo "my custom checkout"
      - unless:
          # 引数のfalseの場合
          condition: << parameters.custom_checkout >>
          steps:
            - checkout
            
workflows:
  build-test-deploy:
    jobs:
      - job_with_optional_custom_checkout:
          # workflowにてbool型の値を設定
          custom_checkout: true
```

#### ・enum型

引数として，特定の文字列や整数のみを渡したいときに用いる．```workflows```にて，値を設定する．

**＊実装例＊**

``` yaml
version: 2.1

jobs:
  deploy:
    parameters:
      # 引数を定義
      environment:
        # デフォルト値
        default: "test"
        type: enum
        enum: ["test", "staging", "production"]
    steps:
      - run:
        # デフォルト値testを与えるときは何も設定しない
        name: Deploy to << parameters.environment >>
        command:
        # 何らかの処理
    
workflows:
  deploy:
    jobs:
      - deploy:
          # workflowにてenum型の値を設定
          environment: "staging"
```

<br>

### executors parameter

#### ・値の出力方法

引数名を使用して，```parameters```から値を出力する．

```
<< parameters.xxxxx >>
```

#### ・job parametersを参照

引数として，任意の文字列を```executors```に渡したいときに使用する．他のparametersとは異なり，```job```にて，値を設定する．

```yaml 
version: 2.1

executors:
  python:
    # 引数の定義
    parameters:
      tag:
        type: string
        # デフォルト値
        default: latest
      myspecialvar:
        type: string
    docker:
      - image: circleci/python:<< parameters.tag >>
    environment:
      MYPRECIOUS: << parameters.myspecialvar >>
      
jobs:
  build:
    executor:
      name: python
      tag: "2.7"
      # jobにて文字列型の値を設定
      myspecialvar: "myspecialvalue"
```

#### ・workflowで値を設定する

公式リファレンスには載っていないため，方法としては非推奨．```parameter```を渡したい```executor```を使いまわしたい時に使用する．

```yaml
version: 2.1

executors:
  python:
    # 引数の定義
    parameters:
      env:
        type: enum
        enum: [ "2.7", "3.5" ]
      myspecialvar:
        type: string
    docker:
      - image: circleci/python:<< parameters.tag >>
    environment:
      MYPRECIOUS: << parameters.myspecialvar >>
      
jobs:
  build:
    # 引数の定義
    parameters:
      # executorをデータ型として選択
      executor_param:
        type: executor
    executor: << parameters.executor_param >>

workflows:
   version: 2.1
   build-push:
     jobs:
       - build:
           # jobにてexecutor名を設定し，さらにexecutorに値を渡す
           executor_param:
             name: python
             # バージョン3.5を設定
             tag: "2.7"
             myspecialvar: "myspecialvalue"
       - build:
           executor_param:
             name: python
             # バージョン3.5を設定
             tag: "3.5"
             myspecialvar: "myspecialvalue"       
```

<br>

### pipeline parameters

#### ・値の出力方法

引数名を使用して，```pipeline.parameters```から値を出力する．

```
<< pipeline.parameters.xxxxx >>
```

#### ・job parametersを参照

定義できるデータ型は，job parameterと同じ．リポジトリ内でのみ参照できる．

```yaml
version: 2.1

parameters:
  # 引数を定義
  image-tag:
    type: string
    # デフォルト値
    default: "latest"
  workingdir:
    type: string
    default: "~/main"

jobs:
  build:
    docker:
      - image: circleci/node:<< pipeline.parameters.image-tag >>
        auth:
          username: mydockerhub-user
          password: $DOCKERHUB_PASSWORD
    environment:
      IMAGETAG: << pipeline.parameters.image-tag >>
    working_directory: << pipeline.parameters.workingdir >>
    steps:
      - run: echo "Image tag used was ${IMAGETAG}"
      - run: echo "$(pwd) == << pipeline.parameters.workingdir >>"
      
workflows:
  my-workflow:
    jobs:
      - build:
          # 引数名: 渡す値 
          image-tag: "1.0"
          workdir: "/tmp"
```

## 02-04. jobs

### jobsとは

複数の```job```を定義する．Workflowsを使わない場合は，少なくとも一つの```job```には```build```という名前を使用しなければならない．

<br>

### docker，machine

#### ・仮想環境の選択

jobを実行する仮想環境を選択できる．

#### ・dockerとは

![machine_executor](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/docker_executor.png)

コンテナ環境で```job```を行う．```job```にDockerイメージのビルドが含まれる場合，これは，包含するCircleCI環境の外で```job```を行う必要がある．コンテナ環境の場合，DockerfileのCOPYコマンドが機能しないので注意．

**＊実装例＊**


```yaml
version: 2.1

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

#### ・machineとは

![machine_executor](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/machine_executor.png)

**＊実装例＊**

```yaml
version: 2.1

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

<br>

### steps

#### ・stepsとは

処理をMap型で定義する．

#### ・when，unless

if文を定義する．```when```では条件がtrueの場合，また```unless```ではfalseの場合に実行する```step```を定義する．

**＊実装例＊**

```yaml
version: 2.1

jobs:
  custom_checkout:
    parameters:
      custom_checkout_parameters:
        type: bool
        # デフォルト値はfalse
        default: false
    machine: true
    steps:
      # 引数がtrueの場合
      - when:
          condition: << parameters.custom_checkout_parameters >>
          steps:
            - run: echo "独自のチェックアウト処理"
      # 引数がfalseの場合
      - unless:
          condition: << parameters.custom_checkout_parameters >>
          steps:
            - checkout
            
workflows:
  version: 2.1
  build-test-deploy:
    jobs:
      - custom_checkout:
          # 引数名: 渡す値
          custom_checkout_parameters: true
```


#### ・restore_cache，save_cache

![CircleCIキャッシュ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/CircleCIキャッシュ.png)

生成したファイルをキャッシュとして保存する．使い所として，例えば，ライブラリはcomposer.jsonの設定が変更されない限り，同じライブラリがインストールされる．しかし，CircleCIのWorkflowのたびに，ライブラリをインストールするのは非効率である．そこで，composer.jsonが変更されない限り，前回のWorkflow時に生成されたvendorディレクトリを繰り返し利用するようにする．また，一つのWorkflowの中でも，繰り返し利用できる．

**＊実装例＊**

```yaml
version: 2.1

jobs:
  build:
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

**＊実装例＊**

```yaml
version: 2.1

commands:
  restore_vendor:
    steps:
      # composer.jsonが変更されている場合は処理をスキップ．
      - restore_cache:
          key:
            - v1-dependecies-{{ checksum composer.json }}
  # 取得したcomposer.jsonを元に，差分のvendorをインストール．
  install_vendor:
     steps:
       - run: composer install
  save_vendor:
    steps:
      # 最新のvendorを保存．
      - save_cache:
          key: v1-dependecies-{{ checksum composer.json }}
          paths:
            - /vendor
```

#### ・persist_to_workspace，attach_workspace

![workflow_workspace_cache](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/workflow_workspace_cache.png)

CircleCIでは，jobごとに異なる仮想環境が構築されるため，他の```job```で使用された一時ファイルを再利用したい場合に，これを使う．

**＊実装例＊**

```yaml
version: 2.1

jobs:
  jobA:
    steps:
    # Workspaceにファイルをアップロード
      - persist_to_workspace:
          # jobAにて，Workspaceとするディレクトリのroot
          root: /tmp/workspace
          # Rootディレクトリを基準とした相対パス（"./"以外の場合は，ディレクトリの作成が必要）
          # パラメータは環境変数として出力できないので注意
          paths:
            - target/application.jar
            - build/*
  jobB:
    steps:
      # persist_to_workspaceで作成されたWorkspaceからファイルをダウンロード
      - attach_workspace:
        # jobAとは異なるディレクトリに，ファイルをダウンロードしてもよい
        at: /tmp/workspace
```

全てのディレクトリを保持するような場合がほとんどと思われるため，カレントディレクトリ以下（```.```）を指定するのがよい．

**＊実装例＊**

```yaml
version: 2.1

jobs:
  jobA:
    steps:
      - persist_to_workspace:
          root: .
          paths:
            - .
  jobB:
    steps:
      - attach_workspace:
        at: .
```

<br>

## 02-04. commands

### commandsとは

設定を部品化し，異なる```job```で```step```として繰り返し利用できる．

<br>

### 部品化と再利用

**＊実装例＊**

```yaml
version: 2.1

commands:
  sayhello:
    description: "Echo hello world"
    parameters:
      text:
        type: string
        default: "Hello World"
    steps:
      # parametersの値を渡す
      - run: echo << parameters.text >>
      
jobs:
  myjob:
    docker:
      - image: "circleci/node:9.6.1"
    steps:
      # command名
      - sayhello:
          # 引数名: 渡す値
          text: "Lev"
```

<br>

## 02-05. executors

### executorsとは

実行環境に関する設定を部品化し，異なる```job```で繰り返し利用できる．

<br>

### 部品化と再利用

**＊実装例＊**

```yaml
version: 2.1

executors:
  # ホストOS環境名
  my-executor:
    # ホストOS環境
    docker:
      - image: circleci/ruby:2.5.1-node-browsers
    working_directory: ~/example_project
    environment:
      XX: xx
      YY: yy

jobs:
  my-job:
    executor: my-executor
    steps:
      - run: echo "${XX}と${YY}です"
```

<br>

## 02-06. Workflow

### 特殊なsteps

#### ・pre-steps，post-steps

事前に```job```に定義する必要はない．```workspace```で，コールされる```job```の引数として設定することで，その```job```内の最初と最後に，```steps```を追加できる．

**＊実装例＊**

```yaml
version: 2.1

jobs:
  bar:
    machine: true
    steps:
      - checkout
      - run:
          command: echo "building"
      - run:
          command: echo "testing"
          
workflows:
  version: 2.1
  build:
    jobs:
      - bar:
          # Workspace前に行う処理
          pre-steps:
            - run:
                command: echo "install custom dependency"
          # Workspace後に行う処理
          post-steps:
            - run:
                command: echo "upload artifact to s3"
```

Orbsを使う場合は，オプションに引数を渡す前に定義する．

**＊実装例＊**

```yaml
workflows:
  version: 2.1
  build:
    jobs:
      - aws-xxx/build-push-yyy:
          # Workspace前に行う処理
          pre-steps:
            - run:
                command: echo "XXX"
          # Workspace後に行う処理
          post-steps:
            - run:
                command: echo "XXX"
          # Orbsのオプション
          name: xxx
          dockerfile: xxx
          tag: xxx
```

<br>

### branches

#### ・branchesとは

コミットされた時に```job```が発火するブランチ名，あるいは発火しないブランチ名，を設定する．正規表現で実装する必要がある．

| よくあるパターン  | 説明                                    |
| ----------------- | --------------------------------------- |
| ```/.*/```        | 全てのブランチを明示的に指定            |
| ```/feature.*/``` | 「feature」と名前のついたブランチを指定 |

**＊実装例＊**

``` yaml
workflows:
  version: 2.1
  build:
    jobs:
      - example:
          branches:
            only:
              - /.*/
```

```yaml
workflows:
  version: 2.1
  build:
    jobs:
      - example:
          branches:
            ignore:
              - /feature.*/
```

<br>

## 02-07. 環境変数

### CircleCIにおける環境変数とは

#### ・環境変数の種類と参照範囲

| 参照レベル | 方法                                        | 説明                                               |
| ---------- | ------------------------------------------- | -------------------------------------------------- |
| Bash       | ```export```，```source```，```$BASH_ENV``` | ```run```における```command```内のみで参照できる． |
| Container  | ```environment```                           | ```job```内の特定のコンテナのみで参照できる．      |
| Job        | ```environment```                           | ```job```内のみで参照できる．                      |
| Project    | Environment Variables機能                   | リポジトリ内のみ参照できる．                       |
| Global     | Contexts機能                                | 異なるリポジトリ間で参照できる．                   |

<br>

### 定義方法の違い

#### ・値の出力方法

オプションや```echo```の引数にて，```$```マークを使用して，値を出力する．

```yaml
# 出力
echo $XXXXX
```

文字列の中に値を出力する場合，```${}```を使用する．

```yaml
# 変数展開
echo "This is ${XXXXX}"
```

#### ・Bashレベル

一番参照範囲が小さく，```run```における```command```内のみで参照できる．```export```，```source```，```$BASH_ENV```，を使用する．

```yaml
version: 2.1 

jobs:
  build:
    docker:
      - image: smaant/lein-flyway:2.7.1-4.0.3
        auth:
          username: mydockerhub-user
          password: $DOCKERHUB_PASSWORD
    steps:
      - run:
          name: Update PATH and Define Environment Variable at Runtime
          command: |
            echo 'export PATH=/path/to/foo/bin:$PATH' >> $BASH_ENV
            echo 'export VERY_IMPORTANT=$(cat important_value)' >> $BASH_ENV
            source $BASH_ENV
```

#### ・Containerレベル

Bashレベルより参照範囲が大きく，```job```内のみで参照できる．```environment```を```image```と同じ階層で定義する．

```yaml
version: 2.1

jobs:
  build:
    docker:
      - image: postgres:9.4.1
        # imageと同じ階層で定義（）
        environment:
          POSTGRES_USER: root
```

#### ・Projectレベル

Containerレベルより参照範囲が大きく，プロジェクト内，すなわちリポジトリ内のみで参照できる．Environment Variables機能を使用する．


#### ・Grobalレベル

Projectレベルより参照範囲が大きく，異なるプロジェクト間，すなわちリポジトリ間で参照できる．Contexts機能を使用する．

<br>


## 02-08. CircleCIライブラリ

### orbs

#### ・orbsとは

CircleCIから提供される汎用的なパッケージの使用を読み込む．

**＊実装例＊**

```yaml
version: 2.1

orbs:
    hello: circleci/hello-build@0.0.5
    
workflows:
    "Hello Workflow":
        jobs:
          - hello/hello-build
```
#### ・jobs，commands，executors

| 構造      | 説明                                                         |
| --------- | ------------------------------------------------------------ |
| jobs      | workflowsにて，Orbsから```job```として使用できる．           |
| commands  | ```job```にて，``step```として使用できる．                   |
| executors | ```exexutor```にて，事前定義されたexecutorsとして使用できる． |

#### ・オプションへの引数の渡し方

AWS認証情報は，CircleCIのデフォルト名と同じ環境変数名で登録しておけば，オプションで渡さなくとも，自動で入力してくれる．

**＊実装例＊**

```yaml
version: 2.1

orbs:
  aws-ecr: circleci/aws-xxx@x.y.z

workflows:
  version: 2.1
  build_and_push_image:
    jobs:
      - aws-xxx/yyy-yyy-yyy:
          # デフォルト名であれば，記述しなくても自動的に入力してくれる．
          account-url: $AWS_ECR_ACCOUNT_URL_ENV_VAR_NAME
          aws-access-key-id: $ACCESS_KEY_ID_ENV_VAR_NAME
          aws-secret-access-key: $SECRET_ACCESS_KEY_ENV_VAR_NAME
          region: $AWS_REGION_ENV_VAR_NAME
```

<br>

### aws-ecr

#### ・jobs：build-and-push-image

CircleCIコンテナでDockerイメージをビルドし，ECRにデプロイできる．

**＊実装例＊**

```yaml
version: 2.1

orbs:
  aws-ecr: circleci/aws-ecr@x.y.z

workflows:
  version: 2.1
  build_and_push_image:
    jobs:
      - aws-ecr/build-and-push-image:
          account-url: $AWS_ECR_ACCOUNT_URL_ENV_VAR_NAME
          aws-access-key-id: $ACCESS_KEY_ID_ENV_VAR_NAME
          aws-secret-access-key: $SECRET_ACCESS_KEY_ENV_VAR_NAME
          region: $AWS_REGION_ENV_VAR_NAME
          # リポジトリがない時に作成するかどうか．
          create-repo: true
          no-output-timeout: 20m
          # projectを作業ディレクトリとした時の相対パス
          dockerfile: ./infra/docker/Dockerfile
          path: '.'
          profile-name: myProfileName
          repo: '{$APP_NAME}-repository'
          # CircleCIのハッシュ値によるバージョニング
          tag: $CIRCLE_SHA1
          # job内にて，attach_workspaceステップを実行．
          attach-workspace: true
          # attach_workspaceステップ実行時のrootディレクトリ
          workspace-root: <ディレクトリ名>
```

<br>

### aws-ecs

#### ・jobs：deploy-service-update

ECSのサービスのリビジョンを更新する．以下のaws-cliに対応している．

```bash
$ aws ecs update-service <複数のオプション>
```

**＊実装例＊**

```yaml
version: 2.1

orbs:
  aws-ecr: circleci/aws-ecr@x.y.z
  aws-ecs: circleci/aws-ecs@x.y.z
  
workflows:
  version: 2.1
  build-and-deploy:
    jobs:
      - aws-ecr/build-and-push-image:
      
      # ~~~ 省略 ~~~ #
      
      - aws-ecs/deploy-service-update:
          requires:
            - aws-ecr/build-and-push-image
          # タスク定義名を指定
          family: '${APP_NAME}-ecs-task-definition'
          # クラスター名を指定
          cluster-name: '${APP_NAME}-cluster'
          # サービス名を指定
          service-name: '${APP_NAME}-service'
          # CodeDeployにおけるデプロイの作成を設定
          deployment-controller: CODE_DEPLOY
          codedeploy-application-name: $APP_NAME}
          codedeploy-deployment-group-name: "${APP_NAME}-deployment-group"
          codedeploy-load-balanced-container-name: www-container
          codedeploy-load-balanced-container-port: 80
          # コンテナ名とイメージタグを上書き．イメージはCircleCIのハッシュ値でタグ付けしているので必須．
          container-image-name-updates: 'container=${APP_NAME}-container,tag=${CIRCLE_SHA1}'
```

#### ・jobs：run-task

サービスに内包されるタスクを指定して，設定したオプションで，現在起動中のタスクとは別のものを新しく起動する．以下のaws-cliを内部で実行している．

```bash
$ aws ecs run-task <複数のオプション>
```

**＊実装例＊**

例えば，マイグレーション用のタスクを起動し，データベースを更新する手法がある．

```yaml
version: 2.1

orbs:
  aws-ecs: circleci/aws-ecs@x.y.z

workflows:
  version: 2.1
  run-task:
    jobs:
      - aws-ecs/run-task:
          name: run-task-fargate
          cluster: "${APP_NAME}-ecs-cluster"
          # LATESTとするとその時点の最新バージョンを自動で割り振られてしまう．
          platform-version: 1.3.0
          assign-public-ip: ENABLED
          awsvpc: true
          launch-type: FARGATE
          # タスク定義名．最新リビジョン番号が自動補完される．
          task-definition: "${APP_NAME}-ecs-task-definition"
          subnet-ids: $AWS_SUBNET_IDS
          security-group-ids: $AWS_SECURITY_GROUPS
          # タスク起動時にマイグレーションコマンドを実行
          overrides: "{\\\"containerOverrides\\\":[{\\\"name\\\": \\\"app\\\",\\\"command\\\": [\\\"php\\\", \\\"artisan\\\", \\\"migrate\\\", \\\"--force\\\"]}]}"
```

<br>


### aws-code-deploy

#### ・jobs：deploy

S3にソースコードとappspecファイルをデプロイできる．また，CodeDeployを用いて，これをEC2にデプロイできる．

**＊実装例＊**

```yaml
version: 2.1

orbs:
  aws-code-deploy: circleci/aws-ecs@x.y.z

workflows:
  version: 2.1
  run-task:
    jobs:
      - aws-code-deploy/deploy:
          requires:
            - build-and-push-image-www
          name: deploy-source-code
          application-name: $APP_NAME}
          # appspecファイルを保存するバケット名
          bundle-bucket: "${APP_NAME}-bucket"
          # appspecファイルのあるフォルダ
          bundle-source: ./infra/aws_codedeploy
          # appspecファイルをzipフォルダで保存
          bundle-type: zip
          # zipフォルダ名
          bundle-key: xxx-bundle
          deployment-config: CodeDeployDefault.ECSAllAtOnce
          deployment-group: "${APP_NAME}-deployment-group"
          # ECSにアクセスできるCodeDeployサービスロール
          service-role-arn: $CODE_DEPLOY_ROLE_FOR_ECS
```

<br>

### terraform

#### ・commands：deploy_infrastructure

```yaml
version: 2.1

orbs:
  terraform: circleci/terraform@x.y.z
  
jobs:
  single-job-lifecycle:
    executor: terraform/default
    steps:
      - checkout
      - terraform/init:
          path: .
      - terraform/validate:
          path: .
      - terraform/fmt:
          path: .
      - terraform/plan:
          path: .
      - terraform/apply:
          path: .
      - terraform/destroy:
          path: .
    working_directory: ~/src
    
workflows:
  single-job-lifecycle:
    jobs:
      - single-job-lifecycle
```

#### ・jobs：deploy_infrastructure_job

```yaml
version: 2.1

orbs:
  terraform: 'circleci/terraform@dev:alpha'
  
workflows:
  deploy_infrastructure:
    jobs:
      - terraform/fmt:
          checkout: true
          context: terraform
      - terraform/validate:
          checkout: true
          context: terraform
          requires:
            - terraform/fmt
      - terraform/plan:
          checkout: true
          context: terraform
          persist-workspace: true
          requires:
            - terraform/validate
      - terraform/apply:
          attach-workspace: true
          context: terraform
          filters:
            branches:
              only: master
          requires:
            - terraform/plan
```

<br>

### slack

#### ・commands：status

ジョブの終了時に，成功または失敗に基づいて，ステータスを通知する．ジョブの最後のステップとして設定しなければならない．

```yaml
version: 2.1

orbs:
  slack: circleci/slack@x.y.z

jobs:
  build:
    docker:
      - image: <docker image>
    steps:
      - run: exit 0
      - slack/status:
          # 成功した場合
          success_message: ':tada: A $CIRCLE_job job has succeeded!'
          # 失敗した場合
          failure_message: ':red_circle: A $CIRCLE_job job has failed!'
          # 通知先のUSERIDをカンマ区切りで指定
          mentions: 'USERID1,USERID2'
          # SlackチャンネルのWebhookURL（CircleCI環境変数として登録していれば設定不要）
          webhook: webhook
```

<br>


## 03. Capistrano

### デプロイ処理の自動実行

#### ・仕組み

1. 自身のパソコンからクラウドデプロイサーバにリモート接続する．
2. クラウドデプロイサーバの自動デプロイツール（例：Capistrano）が，クラウドデプロイサーバからクラウドWebサーバにリモート接続する．
3. 自動デプロイツールが，クラウドWebサーバのGitを操作し，```pull```あるいは```clone```を実行する．その結果，GitHubからクラウドデプロイサーバに指定のブランチの状態が取り込まれる．

![デプロイ](https://raw.githubusercontent.com/Hiroki-IT/tech-notebook/master/images/デプロイ.png)
