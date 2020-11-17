# Terraform

## 01. コマンド

### init

#### ・-backend

ローカルもしくはバックエンドにstateファイルを作成する．リモートの場合は，```-backend-config```オプションも必要．

```bash
$ terraform init -backend=false
```

#### ・-reconfigure

指定されたバックエンドのstateファイルがある場合，これを削除し，新しくstateファイルを作成する．

```bash
$ terraform init -reconfigure
```

#### ・-backend-config

初期化時に，バックエンドを明示的に指定し，これにstateファイルを作成する．

```bash
terraform init \
-backend=true \
-reconfigure \
-backend-config="bucket=<バケット名>" \
-backend-config="key=terraform.tfstate" \
-backend-config="region=ap-northeast-1" \
-backend-config="profile=<プロファイル名>" ./<ディレクトリ名>
```

#### ・-upgrade

モジュールとプラグインを更新する．

```bash
$ terraform init -upgrade
```

<br>

### validate

#### ・オプション無し

設定ファイルの検証を行う．

```bash
$ terraform validate

Success! The configuration is valid.
```

<br>

### fmt

#### ・-recursive

設定ファイルのインデントを揃える．処理を行ったファイルが表示される．

```bash
# -recursive: サブディレクトリを含む全ファイルをフォーマット
$ terraform fmt -recursive

main.tf
```

<br>

### import

#### ・-var-file <リソース>

terraformによる構築ではない方法で，すでにクラウド上にリソースが構築されている場合，これをterraformの管理下におく必要がある．リソースタイプとリソース名を指定し，stateファイルにリモートの状態を書き込む．現状，全てのリソースを一括して```import```する方法は無い．

```bash
$ terraform import -var-file=config.tfvars <リソースタイプ>.<リソース名> <AWS上リソース名>
```

モジュール化されている場合，指定の方法が異なる．

```bash
$ terraform import -var-file=config.tfvars module.<モジュール名>.<リソースタイプ>.<リソース名> <AWS上リソースID>
```

例えば，AWS上にすでにECRが存在しているとして，これをterraformの管理下におく．

```bash
$ terraform import -var-file=config.tfvars module.ecr_module.aws_ecr_repository.ecr_repository_www xxxxxxxxx
```

そして，ローカルのstateファイルとリモートの差分が無くなるまで，```import```を繰り返す．

````bash
$ terraform plan

No changes. Infrastructure is up-to-date.
````

#### ・importを行わなかった場合のエラー

もし```import```を行わないと，すでにクラウド上にリソースが存在しているためにリソースを構築できない，というエラーになる．

（エラー例1）

```bash
Error: InvalidParameterException: Creation of service was not idempotent.
```

（エラー例2）

```bash
Error: error creating ECR repository: RepositoryAlreadyExistsException: The repository with name 'tech-notebook_www' already exists in the registry with id 'XXXXXXXXXXXX'
```

<br>

### refresh

#### ・-var-file

クラウドに対してリクエストを行い，現在のリソースの状態をtfstateファイルに反映する．

```bash
$ terraform refresh -var-file=config.tfvars
```

<br>

### plan

#### ・-var-file

クラウドに対してリクエストを行い，現在のリソースの状態をtfstateファイルには反映せずに，設定ファイルの記述との差分を検証する．スクリプト実行時に，変数が定義されたファイルを実行すると，```variable```で宣言した変数に，値が格納される．

```bash
$ terraform plan -var-file=config.tfvars
```

差分がなければ，以下の通りになる．

```bash
No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```

#### ・-refresh

```-refresh=true```オプションをつければ，```refresh```コマンドを同時に実行してくれる．

```bash
$ terraform plan -var-file=config.tfvars -refresh=true 
```

<br>

### apply

#### ・-var-file

AWS上にクラウドインフラストラクチャを構築する．

```bash
$ terraform apply -var-file config.tfvars
```

成功すると，以下のメッセージが表示される．

```bash
Apply complete! Resources: X added, 0 changed, 0 destroyed.
```

<br>

### taint

#### ・-var-file <リソース>

stateファイルにおける指定されたリソースの```tainted```フラグを立てる．例えば，```apply```したが，途中でエラーが発生してしまい，リモートに中途半端はリソースが構築されてしまうことがある．ここで，```tainted```を立てておくと，リモートのリソースを削除したと想定した```plan```を実行できる．

```bash
$ terraform taint -var-file=config.tfvars module.<モジュール名>.<リソースタイプ>.<リソース名>
```

この後の```plan```コマンドのログからも，```-/+```で削除が行われる想定で，差分を比較していることがわかる．

```bash
$ terraform plan

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

-/+ <リソースタイプ>.<リソース名> (tainted) (new resource required)
      id: "1492336661259070634" => <computed> (forces new resource)


Plan: 1 to add, 0 to change, 1 to destroy.
```

<br>

### state list

#### ・オプション無し

ファイル内で定義しているリソースの一覧を表示する．

```bash
$ terraform state list
```

以下の通り，モジュールも含めて，リソースが表示される．

```bash
aws_instance.www-1a
aws_instance.www-1c
aws_key_pair.key_pair
module.alb_module.aws_alb.alb
module.ami_module.data.aws_ami.amazon_linux_2
module.route53_module.aws_route53_record.r53_record
module.route53_module.aws_route53_zone.r53_zone
module.security_group_module.aws_security_group.security_group_alb
module.security_group_module.aws_security_group.security_group_ecs
module.security_group_module.aws_security_group.security_group_instance
module.vpc_module.aws_internet_gateway.internet_gateway
module.vpc_module.aws_route_table.route_table_public
module.vpc_module.aws_route_table_association.route_table_association_public_1a
module.vpc_module.aws_route_table_association.route_table_association_public_1c
module.vpc_module.aws_subnet.subnet_public_1a
module.vpc_module.aws_subnet.subnet_public_1c
module.vpc_module.aws_vpc.vpc
```

<br>

## 02. 環境変数

実行ファイルに入力したい値を定義する．各サービスの間で実装方法が同じため，VPCのみ例を示す．

**＊実装例＊**

```tf
###############################
# VPC
###############################
vpc_cidr_block = "n.n.n.n/n" // IPv4アドレス範囲
```

<br>

### variable 

宣言することで，リソースに変数を与えることができるようになる．

**＊実装例＊**

```tf
###############################
# Input Value
###############################
// AWSCredentials
variable "credential" {
  type = map(string)
}
```

<br>

##  03. ルートモジュールにおける実装

### ディレクトリ構成

#### ・実行環境で区別する場合

```
terraform_project/
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── ec2
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── dev
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── prod
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
└── stg
    ├── main.tf
    ├── outputs.tf
    └── variables.tf
```

<br>

### terraform  settings

#### ・terraform settingsとは

terraformの実行時に，エントリポイントとして機能するファイル．

#### ・required_providers

AWSの他，GCPなどのプロバイダの認証を行う．一番最初に読みこまれるファイルのため，変数やモジュール化などが行えない．

**＊実装例＊**

```tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      
      // プロバイダーのバージョン変更時は initを実行
      version = "3.0" 
    }
  }
}
```

#### ・backend

```tfstate```ファイルを管理する場所を設定する．

```tf
terraform {
  // S3で管理するように設定
  backend "s3" {
    bucket = "<バケット名>"
    key    = "<バケット内のディレクトリ>"
    region = "ap-northeast-1"
  }
}
```

```tf
terraform {
  // ローカルPCで管理するように設定
  backend "local" {
    path = "<バケット内のディレクトリ>"
  }
}
```

<br>

### provider

#### ・providerとは

プロバイダにおけるアカウント認証を行う．

```tf
terraform {
  required_version = "0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0"
    }
  }
}

provider "aws" {
  # AWSアカウント情報の設定  
}
```

#### ・ハードコーディングによる認証

リージョンの他，アクセスキーとシークレットキーをハードコーディングで設定する．誤ってコミットしてしまう可能性があるため，ハードコーディングしないようにする．

**＊実装例＊**

```tf
terraform {
  required_version = "0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  access_key = "<アクセスキー>"
  secret_key = "<シークレットキー>"
}
```

#### ・Credentialsファイルによる認証

　AWSアカウント情報は，```~/.aws/credentials```ファイルに記載されている．

```
[default]
aws_access_key_id=<アクセスキー>
aws_secret_access_key=<シークレットキー>

[user1]
aws_access_key_id=<アクセスキー>
aws_secret_access_key=<シークレットキー>
```

Credentialsファイルを読み出し，プロファイル名を設定することにより，アカウント情報を参照できる．

**＊実装例＊**

```tf
terraform {
  required_version = "0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  
  // Linux，Unixの場合
  shared_credentials_file = "$HOME/.aws/<Credentialsファイル名>"
  
  // Windowsの場合
  // shared_credentials_file = "%USERPROFILE%\.aws\<Credentialsファイル名>"
  
  // defaultプロファイルを指定
  profile = default
}
```

#### ・環境変数による認証

Credentialsファイルではなく，```export```を使用して，必要な情報を設定しておくことも可能である．

```bash
$ export AWS_DEFAULT_REGION="ap-northeast-1"
$ export AWS_ACCESS_KEY_ID="<アクセスキー>"
$ export AWS_SECRET_ACCESS_KEY="<シークレットキー>"
```

環境変数を設定した上でteraformを実行すると，値が```provider```に自動的に出力される．CircleCIのような，一時的に環境変数が必要になるような状況では有効な方法である．

```tf
terraform {
  required_version = "0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0"
    }
  }
}

// リージョン，アクセスキー，シークレットアクセスキーは不要
provider "aws" {}
```

<br>

### multiple providers

#### ・multiple providersとは

複数の```provider```を実装し，エイリアスを使用して，これらを動的に切り替える方法．

**＊実装例＊**

```tf
terraform {
  required_version = "0.13.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.0"
    }
  }
}

provider "aws" {
  # デフォルト値とするリージョン
  region = "ap-northeast-1"
  access_key = "<アクセスキー>"
  secret_key = "<シークレットキー>"
}

provider "aws" {
  # 別リージョン
  alias = "ue1"
  region = "us-east-1"
  access_key = "<アクセスキー>"
  secret_key = "<シークレットキー>"
}
```

#### ・子モジュールでproviderを切り替える

子モジュールで```provider```を切り替えるには，ルートモジュールで```provider```の値を明示的に渡す必要がある．

```tf
module "route53" {
  source = "../modules/route53"

  providers = {
    aws = aws.ue1
  }
  
  // その他の設定値
}
```

さらに子モジュールで，```provider```の値を設定する必要がある．

```tf
###############################################
# Route53
###############################################
resource "aws_acm_certificate" "example" {
  # CloudFrontの仕様のため，us-east-1リージョンでSSL証明書を作成します．
  provider = aws

  domain_name               = var.route53_domain_example
  subject_alternative_names = ["*.${var.route53_domain_example}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.environment}-${var.service}-example-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}
```

<br>

### module

#### ・moduleとは

ルートモジュールで子モジュール読み込み，子モジュールに対して変数を渡す．

#### ・実装方法

**＊実装例＊**

```tf
###############################
# ALB
###############################
module "alb" {
  // モジュールのResourceを参照
  source = "../modules/alb"
  
  // モジュールに他のモジュールのアウトプット値を渡す．
  acm_certificate_api_arn = module.acm.acm_certificate_api_arn
}
```

<br>

## 04. 子モジュールにおける実装

### resource

#### ・resource

AWSのAPIに対してリクエストを送信し，クラウドインフラの構築を行う．

#### ・実装方法

**＊実装例＊**

```tf
###############################################
# ALB
###############################################
resource "aws_lb" "this" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  subnets            = var.subnet_public_ids
}
```

<br>

### data

#### ・dataとは

AWSのAPIに対してリクエストを送信し，クラウドインフラに関するデータを取得する．ルートモジュールに実装することも可能であるが，各モジュールに実装した方が分かりやすい．

#### ・実装方法

**＊実装例＊**

例として，タスク定義名を指定して，AWSから

```tf
###############################################
# ECS task definition
###############################################
data "aws_ecs_task_definition" this {
  task_definition = aws_ecs_task_definition.this.family
}
```

**＊実装例＊**

例として，AMIをフィルタリングした上で，AWSから特定のAMIの値を取得する．

```tf
###############################################
# AMI
###############################################
data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}
```

<br>

### output

#### ・outputとは

モジュールで構築されたリソースがもつ特定の値を出力する．

#### ・実装方法

**＊実装例＊**

例として，ALBの場合を示す．```resource```ブロックと```data```ブロックでアウトプットの方法が異なる．

```tf
###############################################
# ALB
###############################################
output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "elb_service_account_arn" {
  value = data.aws_elb_service_account.this.arn
}
```
<br>

## 05. メタ引数

### メタ引数とは

全てのリソースで使用できるオプションのこと．

<br>

### depends_on

#### ・depends_onとは

リソース間の依存関係を明示的に定義する．Terraformでは，基本的にリソース間の依存関係が暗黙的に定義されている．しかし，複数のリソースが関わると，リソースを適切な順番で構築できない場合があるため，そういったときに使用する．

#### ・ECS，ALB，ALB target group

例として，ECSを構築する場合，ECS，ALB，ALB target group，のリソースを適切な順番で構築できない可能性がある．そのため，ALBの構築後に，ALB target groupを構築するように定義する必要がある．

**＊実装例＊**

```tf
###############################################
# ALB target group
###############################################
resource "aws_lb_target_group" "this" {
  name                 = "${var.environment}-${var.service}-alb-tg"
  port                 = var.ecs_nginx_port_http
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = "60"
  target_type          = "ip"
  slow_start           = "60"

  health_check {
    interval            = 30
    path                = "/healthcheck"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }

  tags = {
    Environment = var.environment
  }

  depends_on = [aws_lb.this]
}
```

#### ・Internet Gateway，NAT Gateway

例として，NAT Gatewayを構築する場合，NAT Gateway，Internet Gateway，のリソースを適切な順番で構築できない可能性がある．そのため，Internet Gatewayの構築後に，NAT Gatewayを構築するように定義する必要がある．

```tf
resource "aws_nat_gateway" "this" {
  for_each = var.vpc_availability_zones

  subnet_id     = aws_subnet.public[*].id
  allocation_id = aws_eip.nat_gateway[*].id

  tags = {
    Name = format(
      "${var.environment}-${var.service}-%d-ngw",
      each.value
    )
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.this]
}

```

<br>

### count

#### ・countとは

**＊実装例＊**

```tf
resource "aws_instance" "server" {
  count = 4 # create four similar EC2 instances

  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}
```

<br>

### for_each

#### ・for_eachとは

```for_each```が持つ```key```または```value```の数だけ，リソースを繰り返し実行する．

**＊実装例＊**

例として，```for_each```ブロックが定義された```aws_iam_user```リソースが，```for_each```の持つ```value```の数だけ実行される．

```tf
locals {
  users = [
    "yamada",
    "tanaka",
    "suzuki"
  ]
}

resource "aws_iam_user" "users" {
  for_each = local.users
  name     = each.value
}
```

<br>

### lifecycle

#### ・lifecycleとは

#### ・create_before_destroy

```tf
resource "aws_acm_certificate" "example" {
  domain_name               = var.route53_domain_example
  subject_alternative_names = ["*.${var.route53_domain_example}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.environment}-${var.service}-example-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}
```

#### ・ignore_changes

リモート側のリソースの値が変更した場合に，これを無視し，```tfstate```ファイルに反映しないようにする．基本的に使用することはないが，リモート側のリソースが動的に変更される可能性があるリソースでは，設定が必要である．

**＊実装例＊**

例として，ECSでは，AutoScalingによってタスク数が増減し，またアプリケーションのデプロイでリビジョン番号が増加する．そのため，これらを無視する必要がある．

```tf
###############################################
# ECS Service
###############################################
resource "aws_ecs_service" "this" {
  name                               = "${var.environment}-${var.service}-ecs-service"
  cluster                            = aws_ecs_cluster.this.id
  launch_type                        = "Fargate"
  platform_version                   = "1.4.0"
  task_definition                    = "${aws_ecs_task_definition.this.family}:${max(aws_ecs_task_definition.this.revision, data.aws_ecs_task_definition.this.revision)}"
  desired_count                      = 2
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  health_check_grace_period_seconds  = 300

  network_configuration {
    security_groups  = [var.aws_security_group_ecs_id]
    subnets          = var.subnet_private_app_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_lb_target_group_arn
    container_name   = "${var.environment}-${var.service}-nginx"
    container_port   = var.ecs_nginx_port_http
  }

  lifecycle {
    ignore_changes = [
      # AutoScalingによるタスク数の増減を無視．
      desired_count,
      # アプリケーションのデプロイによるリビジョン番号の増加を無視．
      task_definition,
    ]
  }
}
```

**＊実装例＊**

使用例はすくないが，ちなみにリソース全体を無視する場合は```all```を設定する．

```tf
resource "aws_example" "example" {

  // 何らかの設定

  lifecycle {
    ignore_changes = all
  }
}
```

<br>

## 06. JSONの切り出しと読み出し

### templatefile関数

#### ・templatefile関数とは

第一引数でポリシーが定義されたjsonファイルを読み出し，第二引数でファイルに変数を渡す．ファイルの拡張子はjson

**＊実装例＊**

例として，S3の場合を示す．

```tf
###############################################
# S3 bucket policy
###############################################
resource "aws_s3_bucket_policy" "alb" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = templatefile(
    "${path.module}/policies/alb_bucket_policy.json",
    {
      aws_elb_service_account_arn = var.aws_elb_service_account_arn
      aws_s3_bucket_alb_logs_arn  = aws_s3_bucket.alb_logs.arn
    }
  )
}
```

バケットポリシーを定義するJSONファイルでは，```${}```で変数を出力する．

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_elb_service_account_arn}/*"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket_alb_logs_arn}/*"
    }
  ]
}
```

<br>

### ポリシーのアタッチ

#### ・管理ポリシー

AWSから提供される管理ポリシーは，jsonファイルで定義する必要はない．ポリシーのARNを指定した上で，```aws_iam_role_policy_attachment```でロールにアタッチできる．

**＊実装例＊**

例として，ecs-task-executionロールへのECSTaskExecutionRole管理ポリシーのアタッチを示す．

```
###############################################
# IAM Role For ECS Task
###############################################

# ロールに管理ポリシーをアタッチします．
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
```

#### ・インラインポリシー

jsonファイルで定義したインポリシーは，```aws_iam_role_policy```でロールにアタッチできる．

**＊実装例＊**

例として，ECS Taskにおける，ecs-task-executionロールへのSsmAccessインラインポリシーのアタッチを示す．

```tf
###############################################
# IAM Role For ECS Task
###############################################

# ロールにインラインポリシーをアタッチします．
resource "aws_iam_role_policy" "ecs_task_execution" {
  role = aws_iam_role.ecs_task_execution
  policy = templatefile(
    "${path.module}/policies/ssm_access_inline_policy.json",
    {}
  )
}
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": "*"
    }
  ]
}
```

#### ・信頼ポリシー

コンソール画面でロールを作成する場合は意識することはないが，特定のリソースにロールをアタッチするためには，ロールに信頼ポリシーを組み込む必要がある．信頼ポリシーでは，信頼されるエンティティにリソース名が定義されている．jsonファイルで定義した信頼ポリシーは，```aws_iam_role```でロールにアタッチできる．

**＊実装例＊**

例として，ECS Taskにおける，ecs-task-executionロールへの信頼ポリシーのアタッチを示す．

```
###############################################
# IAM Role For ECS Task
###############################################

# ロールに信頼ポリシーをアタッチします．
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.environment}-${var.service}-ecs-task-execution-role"
  assume_role_policy = templatefile(
    "${path.module}/policies/ecs_task_execution_role_trust_policy.json",
    {}
  )
}
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

**＊実装例＊**

例として，Lambda@Edgeにおける，lambda-execute-roleロールへの信頼ポリシーのアタッチを示す．

```tf
###############################################
# IAM Role For Lambda@Edge
###############################################

# ロールに信頼ポリシーをアタッチします．
resource "aws_iam_role" "lambda_execute" {
  name = "${var.environment}-${var.service}-lambda-execute-role"
  assume_role_policy = templatefile(
    "${path.module}/policies/lambda_execute_role_trust_policy.json",
    {}
  )
}
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "edgelambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

#### ・バケットポリシー

S3アタッチされる，自身へのアクセスを制御するためにインラインポリシーのこと．詳しくは，AWSのノートを参照せよ．定義したバケットポリシーは，```aws_s3_bucket_policy```でロールにアタッチできる．

**＊実装例＊**

```tf
###############################################
# S3 bucket policy
###############################################

# S3にバケットポリシーをアタッチします．
resource "aws_s3_bucket_policy" "alb" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = templatefile(
    "${path.module}/policies/alb_bucket_policy.json",
    {}
  )
}
```

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::582318560864:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::<バケット名>/*"
    }
  ]
}
```

<br>

### containerDefinitionsの設定

#### ・containerDefinitionsとは

タスク定義のうち，コンテナを定義する部分のこと．

**＊実装例＊**

```json
{
  "ipcMode": null,
  "executionRoleArn": "<ecsTaskExecutionRoleのARN>"
  "containerDefinitions": [
    
  ]

   ~ ~ ~ その他の設定 ~ ~ ~

}
```

#### ・設定方法

**＊実装例＊**

例として，SSMのパラメータストアの値を参照できるように，```secrets```を設定している．

```tf
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.service}-${var.environment}-ecs-task"
  memory                   = "2048"
  cpu                      = "1024"
  network_mode             = "awsvpc"
  task_role_arn            = var.iam_role_ecs_task_execution_arn
  execution_role_arn       = var.iam_role_ecs_task_execution_arn
  requires_compatibilities = "FARGATE"
  
  # コンテナ定義を読み出します．
  container_definitions = templatefile(
    "${path.module}/container_defeinitions.json",
    {}
  )
}
```


```json
[
  {
    "name": "app",
    "image": "<ECRリポジトリのURL>",
    "essential": true,
    "portMappings": [
      {
        "containerPort": "80",
        "hostPort": "80",
        "protocol": "tcp"
      }
    ],
    "secrets": [
      {
        "name": "<アプリケーションの環境変数名>",
        "valueFrom": "<SSMのパラメータ名>"
      },
      {
        "name": "DB_HOST",
        "valueFrom": "/ecs/DB_HOST"
      },
      {
        "name": "DB_DATABASE",
        "valueFrom": "/ecs/DB_DATABASE"
      },
      {
        "name": "DB_PASSWORD",
        "valueFrom": "/ecs/DB_PASSWORD"
      },
      {
        "name": "DB_USERNAME",
        "valueFrom": "/ecs/DB_USERNAME"
      },
      {
        "name": "REDIS_HOST",
        "valueFrom": "/ecs/REDIS_HOST"
      },
      {
        "name": "REDIS_PASSWORD",
        "valueFrom": "/ecs/REDIS_PASSWORD"
      },
      {
        "name": "REDIS_PORT",
        "valueFrom": "/ecs/REDIS_PORT"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "<ロググループ名>",
        "awslogs-region": "<リージョン>",
        "awslogs-stream-prefix": "<ログストリーム名のプレフィクス>"
      }
    }
  }
]
```

<br>

## 07. 命名規則

### 変数の命名

#### ・単数形と複数形の命名分け

複数の値をもつlist型の変数であれば複数形で命名する．一方で，string型など値が一つしかなければ単数形とする．

**＊実装例＊**

例として，VPCの場合を示す．

```tf
###############################################
# VPC variables
###############################################
vpc_availability_zones             = { a = "a", c = "c" }
vpc_cidr                           = "n.n.n.n/23"
vpc_subnet_private_datastore_cidrs = { a = "n.n.n.n/27", c = "n.n.n.n/27" }
vpc_subnet_private_app_cidrs       = { a = "n.n.n.n/25", c = "n.n.n.n/25" }
vpc_subnet_public_cidrs            = { a = "n.n.n.n/27", c = "n.n.n.n/27" }
```

<br>

### リソースとデータリソースの命名

#### ・リソース名で種類を表現

リソース名において，リソースタイプを繰り返さないようにする．もし種類がある場合，リソース名でその種類を表現する．

**＊実装例＊**

例として，VPCの場合を示す．

```tf
###############################################
# VPC route table
###############################################

# 良い例
resource "aws_route_table" "public" {

}

resource "aws_route_table" "private" {

}
```

```tf
###############################################
# VPC route table
###############################################

# 悪い例
resource "aws_route_table" "route_table_public" {

}

resource "aws_route_table" "route_table_private" {

}
```

#### ・this

一つのリソースタイプに，一つのリソースしか種類が存在しない場合，```this```で命名する．

**＊実装例＊**

```tf
resource "aws_internet_gateway" "this" {

}
```

#### ・設定の順序，行間

最初に```count```や```for_each```を設定し改行する．その後，各設定を行間を空けずに記述する．```tags```，```depends_on```，```lifecycle```，の順で配置する．ただし実際，これらの全ての設定が必要なリソースはない．

**＊実装例＊**

```tf
###############################################
# EXAMPLE
###############################################
resource "aws_example" "this" {
  // 最初にfor_each
  for_each = var.vpc_availability_zones

  // 各設定
  subnet_id = aws_subnet.public[*].id

  tags = {
    Name = format(
      "${var.environment}-${var.service}-%d-example",
      each.value
    )
    Environment = var.environment
  }
  
  depends_on = []

  lifecycle {
    create_before_destroy = true
  }
}
```

<br>

### アウトプット値の命名

#### ・基本ルール

アウトプット値の名前は，```<リソース名>_<リソースタイプ>_<attribute名>```で命名する．

**＊実装例＊**

例として，IAM Roleの場合

```tf
###############################################
# Output IAM Role
###############################################
output "ecs_task_execution_iam_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}

output "lambda_execute_iam_role_arn" {
  value = aws_iam_role.lambda_execute.arn
}

output "rds_enhanced_monitoring_iam_role_arn" {
  value = aws_iam_role.rds_enhanced_monitoring.arn
}
```

#### ・list型アウトプット値は複数形

ループで構築したリソースは，list型でアウトプットする必要がある．この時，アウトプットの変数名は複数形にする．

**＊実装例＊**

例として，VPCの場合

```tf
###############################################
# Output VPC
###############################################
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_app_subnetids" {
  value = aws_subnet.private_app[*].id
}

output "private_datastore_subnet_ids" {
  value = aws_subnet.private_datastore[*].id
}
```

#### ・thisは省略

リソース名が```this```である場合，アウトプット値名ではこれを省略してもよい．

**＊実装例＊**

例として，ALBの場合

```tf
###############################################
# Output ALB
###############################################
output "alb_zone_id" {
  value = aws_lb.this.zone_id
}

output "alb_dns_name" {
  value = aws_lb.this.dns_name
}
```

#### ・冗長なattribute名は省略

**＊実装例＊**

例として，ECRの場合

```tf
###############################################
# Output ECR
###############################################
output "laravel_ecr_repository_url" {
  value = aws_ecr_repository.laravel.repository_url
}

output "nginx_ecr_repository_url" {
  value = aws_ecr_repository.nginx.repository_url
}
```

<br>

## 08. その他

### ECS

#### ・タスク定義の更新

Terraformでタスク定義を更新すると，現在動いているECSで稼働しているタスクはそのままに，新しいリビジョン番号のタスク定義が作成される．コンソール画面の「新しいリビジョンの作成」と同じ挙動である．実際にタスクが増えていることは，サービスに紐づくタスク定義一覧から確認できる．次のデプロイ時に，このタスクが用いられる．

