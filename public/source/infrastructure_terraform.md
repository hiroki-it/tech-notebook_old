# Terraform

## 01. コマンド

### init

#### ・-backend=false

ローカルにstateファイルを作成する．

```bash
$ terraform init -backend=false
```

```bash
# ディレクトリを指定することも可能
$ terraform init -backend=false <ルートモジュールのディレクトリへの相対パス>
```

#### ・-backend=true, -backend-config

リモートにstateファイルを作成する．代わりに，```terraform settings```ブロック内の```backend```で指定しても良い．

```bash
$ terraform init \
    -backend=true \
    -reconfigure \
    -backend-config="bucket=<バケット名>" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=ap-northeast-1" \
    -backend-config="profile=<プロファイル名>" \
    <ルートモジュールのディレクトリへの相対パス>
```

#### ・-reconfigure

指定されたバックエンドのstateファイルがある場合，これを削除し，新しくstateファイルを作成する．

```bash
$ terraform init -reconfigure
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

```bash
# ディレクトリを指定することも可能
$ terraform validate <ルートモジュールのディレクトリへの相対パス>
```

<br>

### fmt

#### ・-check

インデントを揃えるべき箇所が存在するかどうかを判定する．もし存在する場合「```1```」，存在しない場合は「```0```」を返却する．

```bash
$ terraform fmt -check
```

#### ・-recursive

設定ファイルのインデントを揃える．処理を行ったファイルが表示される．

```bash
# -recursive: サブディレクトリを含む全ファイルをフォーマット
$ terraform fmt -recursive

main.tf
```

<br>

### import

#### ・-var-file

terraformによる構築ではない方法で，すでにクラウド上にリソースが構築されている場合，これをterraformの管理下におく必要がある．リソースタイプとリソース名を指定し，stateファイルにリモートの状態を書き込む．現状，全てのリソースを一括して```import```する方法は無い．リソースIDは，リソースによって異なるため，リファレンスの「Import」または「Attributes Referenceの```id```」を確認すること（例えば，ACMにとってのIDはARNだが，S3バケットにとってのIDはバケット名である）．

```bash
$ terraform import \
    -var-file=config.tfvars \
    <リソースタイプ>.<リソース名> <AWS上リソースID>
```

モジュールを使用している場合，指定の方法が異なる．

```bash
$ terraform import \
    -var-file=config.tfvars \
    module.<モジュール名>.<リソースタイプ>.<リソース名> <AWS上リソースID>
```

例えば，AWS上にすでにECRが存在しているとして，これをterraformの管理下におく．

```bash
$ terraform import \
    -var-file=config.tfvars \
    module.ecr.aws_ecr_repository.www xxxxxxxxx
```

そして，ローカルのstateファイルとリモートの差分が無くなるまで，```import```を繰り返す．

````bash
$ terraform plan -var-file=config.tfvars

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

#### ・シンボルの見方

構築（```+```），更新（```~```），削除（```-```）で表現される．

```
+ create
~ update in-place
- destroy
```

#### ・-var-file

クラウドに対してリクエストを行い，現在のリソースの状態をtfstateファイルには反映せずに，設定ファイルの記述との差分を検証する．スクリプト実行時に，変数が定義されたファイルを実行すると，```variable```で宣言した変数に，値が格納される．

```bash
$ terraform plan -var-file=config.tfvars
```

```bash
# ディレクトリを指定することも可能
# 第一引数で変数ファイルの相対パス，第二引数でをルートモジュールの相対パス
$ terraform plan \
    -var-file=<ルートモジュールのディレクトリへの相対パス>/config.tfvars \
    <ルートモジュールのディレクトリへの相対パス>
```

差分がなければ，以下の通りになる．

```bash
No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```

#### ・-target

特定のリソースに対して，```plan```コマンドを実行する．

```bash
$ terraform plan \
    -var-file=config.tfvars \
    -target=<リソースタイプ>.<リソース名>
```

モジュールを使用している場合，指定の方法が異なる．

```bash
$ terraform plan \
    -var-file=config.tfvars \
    -target=module.<モジュール名>.<リソースタイプ>.<リソース名>
```

#### ・-refresh

このオプションをつければ，```refresh```コマンドを同時に実行してくれる．ただ，デフォルトで```true```なので，不要である．

```bash
$ terraform plan \
    -var-file=config.tfvars \
    -refresh=true
```

https://github.com/hashicorp/terraform/issues/17311

#### ・-parallelism

並列処理数を設定できる．デフォルト値は```10```である．

```bash
$ terraform plan \
    -var-file=config.tfvars \
    -parallelism=30
```

#### ・-out

実行プランファイルを生成する．```apply```コマンドのために使用できる．

```bash
$ terraform plan \
    -var-file=config.tfvars \
    -out=<実行プランファイル名>.tfplan
```

<br>

### apply

#### ・-var-file

AWS上にクラウドインフラストラクチャを構築する．

```bash
$ terraform apply -var-file config.tfvars
```

```bash
# ディレクトリを指定することも可能
# 第一引数で変数ファイルの相対パス，第二引数でをルートモジュールの相対パス
$ terraform apply \
    -var-file=<ルートモジュールのディレクトリへの相対パス>/config.tfvars \
    <ルートモジュールのディレクトリへの相対パス>
```

成功すると，以下のメッセージが表示される．

```bash
Apply complete! Resources: X added, 0 changed, 0 destroyed.
```

#### ・-target

特定のリソースに対して，```apply```コマンドを実行する．

```bash
$ terraform apply \
    -var-file=config.tfvars \
    -target=<リソースタイプ>.<リソース名>
```

モジュールを使用している場合，指定の方法が異なる．

```bash
$ terraform apply \
    -var-file=config.tfvars \
    -target=module.<モジュール名>.<リソースタイプ>.<リソース名>
```

#### ・-parallelism

並列処理数を設定できる．デフォルト値は```10```である．

```bash
$ terraform apply \
    -var-file=config.tfvars \
    -parallelism=30
```

#### ・実行プランファイル

事前に，```plan```コマンドによって生成された実行プランファイルを元に，```apply```コマンドを実行する．実行プランを渡す場合は，変数をオプションに設定する必要はない．

```bash
$ terraform apply <実行プランファイル名>.tfplan
```

<br>

### taint

#### ・-var-file <リソース>

stateファイルにおける指定されたリソースの```tainted```フラグを立てる．例えば，```apply```したが，途中でエラーが発生してしまい，リモートに中途半端はリソースが構築されてしまうことがある．ここで，```tainted```を立てておくと，リモートのリソースを削除したと想定した```plan```を実行できる．

```bash
$ terraform taint \
    -var-file=config.tfvars \
    module.<モジュール名>.<リソースタイプ>.<リソース名>
```

この後の```plan```コマンドのログからも，```-/+```で削除が行われる想定で，差分を比較していることがわかる．

```bash
$ terraform plan -var-file=config.tfvars

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

##  02. ルートモジュールにおける実装

### ディレクトリ構成

#### ・実行環境で区別する場合

```
terraform_project/
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── ami
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── dev
│   ├── config.tfvars
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── variables.tf
├── prod
│   ├── config.tfvars
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   └── variables.tf
└── stg
    ├── config.tfvars
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    └── variables.tf
```

<br>

### tfstateファイル

#### ・tfstateファイルとは

リモートのインフラの状態が定義されたjsonファイルのこと．初回時，```apply```コマンドを実行し，成功もしくは失敗したタイミングで生成される．

<br>

### terraform  settings

#### ・terraform settingsとは

terraformの実行時に，エントリポイントとして機能するファイル．

#### ・required_providers

AWSやGCPなど，使用するプロバイダを定義する．プロバイダによって，異なるリソースタイプが提供される．一番最初に読みこまれるファイルのため，変数やモジュール化などが行えない．

**＊実装例＊**

```tf
terraform {

  required_providers {
    # awsプロバイダを定義
    aws = {
      # グローバルソースアドレスを指定
      source  = "hashicorp/aws"
      
      // プロバイダーのバージョン変更時は initを実行
      version = "3.0" 
    }
  }
}
```

#### ・backend

stateファイルを管理する場所を設定する．S3などのリモートで管理する場合，アカウント情報を設定する必要がある．代わりに，```init```コマンド実行時に指定しても良い．デフォルト値は```local```である．

**＊実装例＊**

```tf
terraform {

  // ローカルPCで管理するように設定
  backend "local" {
    path = "${path.module}/terraform.tfstate"
  }
}
```

```tf
terraform {

  // S3で管理するように設定
  backend "s3" {
    bucket                  = "<バケット名>"
    key                     = "<バケット内のディレクトリ>"
    region                  = "ap-northeast-1"
    profile                 = "example"
    shared_credentials_file = "$HOME/.aws/<Credentialsファイル名>"
  }
}
```

バケットは，どのユーザも削除できないように，ポリシーを設定しておくとよい．

**＊実装例＊**

```json
{
  "Statement": [
    {
      "Sid": "DenyDeleteBucket",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:DeleteBucket",
      "Resource": "arn:aws:s3:::<tfstateのバケット名>"
    }
  ]
}
```

<br>

### provider

#### ・providerとは

プロバイダにおけるアカウント認証を行う．```terraform settings```で定義したプロバイダ名を指定する必要がある．

**＊実装例＊**

```tf
terraform {
  required_version = "0.13.5"

  required_providers {
    # awsプロバイダを定義
    aws = {
      # 何らかの設定
    }
  }
  
  backend "s3" {
    # 何らかの設定
  }
}

# awsプロバイダを指定
provider "aws" {
  # アカウント認証の設定
}
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
}

provider "aws" {
  # 別リージョン
  alias  = "ue1"
  region = "us-east-1"
}
```

#### ・子モジュールでproviderを切り替える

子モジュールで```provider```を切り替えるには，ルートモジュールで```provider```の値を明示的に渡す必要がある．

**＊実装例＊**

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

**＊実装例＊**

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

### アカウント情報の設定方法

#### ・ハードコーディングによる設定

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
  
  backend "s3" {
    bucket     = "<バケット名>"
    key        = "<バケット内のディレクトリ>"
    region     = "ap-northeast-1"
    access_key = "<アクセスキー>"
    secret_key = "<シークレットキー>"
  }
}

provider "aws" {
  region     = "ap-northeast-1"
  access_key = "<アクセスキー>"
  secret_key = "<シークレットキー>"
}
```

#### ・credentialsファイルによる設定

　AWSアカウント情報は，```~/.aws/credentials```ファイルに記載されている．

```
[default]
aws_access_key_id=<アクセスキー>
aws_secret_access_key=<シークレットキー>

[user1]
aws_access_key_id=<アクセスキー>
aws_secret_access_key=<シークレットキー>
```

credentialsファイルを読み出し，プロファイル名を設定することにより，アカウント情報を参照できる．

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
  
  // credentialsファイルから，アクセスキー，シークレットアクセスキーを読み込む
  backend "s3" {
    bucket                  = "<バケット名>"
    key                     = "<バケット内のディレクトリ>"
    region                  = "ap-northeast-1"
    profile                 = "example"
    shared_credentials_file = "$HOME/.aws/<Credentialsファイル名>"
  }
}

// credentialsファイルから，アクセスキー，シークレットアクセスキーを読み込む
provider "aws" {
  region                  = "ap-northeast-1"
  profile                 = "example"
  shared_credentials_file = "$HOME/.aws/<Credentialsファイル名>"
}
```

#### ・環境変数による設定

Credentialsファイルではなく，```export```を使用して，必要な情報を設定しておくことも可能である．参照できる環境変数名は決まっている．

```bash
# regionの代わり
$ export AWS_DEFAULT_REGION="ap-northeast-1"

# access_keyの代わり
$ export AWS_ACCESS_KEY_ID="<アクセスキー>"

# secret_keyの代わり
$ export AWS_SECRET_ACCESS_KEY="<シークレットキー>"

# profileの代わり
$ export AWS_PROFILE="<プロファイル名>"

#tokenの代わり（AmazonSTSを使用する場合）
$ export AWS_SESSION_TOKEN="<トークン>"
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
  
  // リージョン，アクセスキー，シークレットアクセスキーは不要
  backend "s3" {
    bucket  = "<バケット名>"
    key     = "<バケット内のディレクトリ>"
  }
}

// リージョン，アクセスキー，シークレットアクセスキーは不要
provider "aws" {}
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

## 03. 変数

### tfvarsファイル

#### ・tfvarsファイルの用途

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

#### ・variableとは

リソースで使用する変数を定義する．

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

## 04. 子モジュールにおける実装

### resource

#### ・resourceとは

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
#### ・map型でアウトプット

```tf
###############################################
# Output VPC
###############################################
output "public_subnet_ids" {
  value = {
    a = aws_subnet.public[var.vpc_availability_zones.a].id,
    c = aws_subnet.public[var.vpc_availability_zones.c].id
  }
}

output "private_app_subnet_ids" {
  value = {
    a = aws_subnet.private_app[var.vpc_availability_zones.a].id,
    c = aws_subnet.private_app[var.vpc_availability_zones.c].id
  }
}

output "private_datastore_subnet_ids" {
  value = {
    a = aws_subnet.private_datastore[var.vpc_availability_zones.a].id,
    c = aws_subnet.private_datastore[var.vpc_availability_zones.c].id
  }
}
```

```tf
example = values(private_app_subnet_ids)
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
  count = 4
  
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

```for_each```が持つ```key```または```value```の数だけ，リソースを繰り返し実行する．繰り返し処理を行う時に，countとは違い，要素名を指定して出力することができる．

**＊実装例＊**

例として，```for_each```ブロックが定義された```aws_subnet```リソースが，```for_each```の持つ```value```の数だけ実行される．

```tf
locals {
  vpc_availability_zones = {
    a = "a",
    c = "c"
  }
}

###############################################
# Public subnet
###############################################
resource "aws_subnet" "public" {
  for_each = var.vpc_availability_zones

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.vpc_subnet_public_cidrs[each.key]
  availability_zone       = "${var.region}${each.value}"
  map_public_ip_on_launch = true

  tags = {
    Name = format(
      "${var.environment}-${var.service}-pub-%s-subnet",
      each.value
    )
    Environment = var.environment
  }
}
```

<br>

### lifecycle

#### ・lifecycleとは

リソースの構築，更新，そして削除のプロセスをカスタマイズできる．

#### ・create_before_destroy

リソースを新しく構築した後に削除するように，変更できる．通常時，Terraformの処理順序として，リソースの削除後に構築が行われる．しかし，他のリソースと依存関係が存在する場合，先に削除が行われることによって，他のリソースに影響が出てしまう．これに対処するために，先に新しいリソースを構築し，紐づけし直してから，削除する必要がある．

```tf
###############################################
# For example domain
###############################################
resource "aws_acm_certificate" "example" {
  domain_name               = var.route53_domain_example
  subject_alternative_names = ["*.${var.route53_domain_example}"]
  validation_method         = "DNS"

  tags = {
    Name = "${var.environment}-${var.service}-example-cert"
  }

  # 新しい証明書を構築した後に削除する．
  lifecycle {
    create_before_destroy = true
  }
}
```

#### ・ignore_changes

リモートのみで起こったリソースの構築・更新・削除を無視し，```tfstate```ファイルに反映しないようにする．基本的に使用することはないが，リモート側のリソースが動的に変更される可能性があるリソースでは，設定が必要である．

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

第一引数でポリシーが定義されたファイルを読み出し，第二引数でファイルに変数を渡す．ファイルの拡張子はtplとするのがよい．

**＊実装例＊**

例として，S3の場合を示す．

```tf
###############################################
# S3 bucket policy
###############################################
resource "aws_s3_bucket_policy" "alb" {
  bucket = aws_s3_bucket.alb_logs.id
  policy = templatefile(
    "${path.module}/policies/alb_bucket_policy.tpl",
    {
      aws_elb_service_account_arn = var.aws_elb_service_account_arn
      aws_s3_bucket_alb_logs_arn  = aws_s3_bucket.alb_logs.arn
    }
  )
}
```

バケットポリシーを定義するtplファイルでは，string型で出力する場合は```"${}"```で，int型で出力する場合は```${}```で出力する．拡張子をjsonにしてしまうと，int型の出力をjsonの構文エラーとして扱われてしまう．

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
    "${path.module}/policies/ssm_access_inline_policy.tpl",
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
    "${path.module}/policies/ecs_task_execution_role_trust_policy.tpl",
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
    "${path.module}/policies/lambda_execute_role_trust_policy.tpl",
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
    "${path.module}/policies/alb_bucket_policy.tpl",
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

#### ・ライフサイクルポリシー

ECRにアタッチされる，イメージの有効期間を定義するポリシー．コンソール画面から入力できるため，基本的にポリシーの実装は不要であるが，TerraformなどのIaCツールでは必要になる．

```json
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images untagged",
      "selection": {
        "tagStatus": "untagged",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 10 images any",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
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

例として，SSMのパラメータストアの値を参照できるように，```secrets```を設定している．int型を変数として渡せるように，拡張子をjsonではなくtplとするのが良い．

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
    "${path.module}/container_defeinitions.tpl",
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
        "containerPort": 80,
        "hostPort": 80,
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

countでループで構築したリソースは，list型でアウトプットすることができる．この時，アウトプットの変数名は複数形にする．ちなみに，for_eachで構築したリソースはアスタリスクでインデックス名を指定できないので，注意．

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

## 08. その他の仕様

### ECS

#### ・タスク定義の更新

Terraformでタスク定義を更新すると，現在動いているECSで稼働しているタスクはそのままに，新しいリビジョン番号のタスク定義が作成される．コンソール画面の「新しいリビジョンの作成」と同じ挙動である．実際にタスクが増えていることは，サービスに紐づくタスク定義一覧から確認できる．次のデプロイ時に，このタスクが用いられる．

<br>

### RDS

#### ・インスタンスを配置するAZ

事前にインスタンスにAZを表す識別子を入れたとしても，Terraformはインスタンスを配置するAZを選べない．そのため，AZと識別子の関係が逆になってしまうことがある．その場合は，デプロイ後に手動で名前を変更すればよい．この変更は，Terraformが差分として認識しないので問題ない．

```tf
###############################################
# RDS Cluster Instance
###############################################
resource "aws_rds_cluster_instance" "this" {
  for_each = var.vpc_availability_zones

  engine                       = "aurora-mysql"
  engine_version               = "5.7.mysql_aurora.2.09.1"
  # Terraformはインスタンスを配置するAZを選択できない
  identifier                   = "${var.environment}-${var.service}-rds-instance-${each.key}"
  cluster_identifier           = aws_rds_cluster.rds_cluster.id
  instance_class               = var.rds_instance_class
  db_subnet_group_name         = aws_db_subnet_group.this.id
  db_parameter_group_name      = aws_db_parameter_group.this.id
  preferred_backup_window      = "19:00-19:30"
  monitoring_interval          = 60
  monitoring_role_arn          = var.rds_iam_role_arn
  auto_minor_version_upgrade   = false
  preferred_maintenance_window = "sun:17:00-sun:17:30"
  apply_immediately            = true
}
```





<br>

### tfnotify

#### ・コマンド

tfnotifyの設定ファイルで，以下のコマンドが実行されるようにする．環境別にtfnotifyを配置しておくとよい．

```bash
$ terraform plan | tfnotify --config ./${ENV}/tfnotify.yml plan
```

#### ・設定ファイル

```yaml
# https://github.com/mercari/tfnotify
# https://github.com/mercari/tfnotify/releases/tag/v0.7.0
---
ci: circleci

notifier:
  github:
    token: <環境変数に登録したGitHubToken>
    repository:
      owner: "<ユーザ名もしくは組織名>"
      name: "<リポジトリ名>"

terraform:
  plan:
    template: |
      {{ .Title }} for staging <sup>[CI link]( {{ .Link }} )</sup>
      {{ .Message }}
      {{if .Result}}
      <pre><code> {{ .Result }}
      </pre></code>
      {{end}}
      <details><summary>Details (Click me)</summary>

      <pre><code> {{ .Body }}
      </pre></code></details>
  apply:
    template: |
      {{ .Title }}
      {{ .Message }}
      {{if .Result}}
      <pre><code>{{ .Result }}
      </pre></code>
      {{end}}
      <details><summary>Details (Click me)</summary>

      <pre><code>{{ .Body }}
      </pre></code></details>
```

