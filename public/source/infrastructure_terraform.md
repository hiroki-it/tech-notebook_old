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

#### ・-var-file

terraformによる構築ではない方法で，すでにクラウド上にリソースが構築されている場合，これをterraformの管理下におく必要がある．

```bash
$ terraform import -var-file=config.tfvars {リソース}.{リソース名} {AWS上リソース名}
```

モジュール化されている場合，指定の方法が異なる．

```bash
$ terraform import -var-file=config.tfvars module.{モジュール名}.{リソース}.{リソース名} {AWS上リソースID}
```

例えば，AWS上にすでにECRが存在しているとして，これをterraformの管理下におく．

```bash
$ terraform import -var-file=config.tfvars module.ecr_module.aws_ecr_repository.ecr_repository_www xxxxxxxxx
```

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
#======
# VPC
#======
vpc_cidr_block = "n.n.n.n/n" // IPv4アドレス範囲
```

<br>

### variable 

宣言することで，リソースに変数を与えることができるようになる．

**＊実装例＊**

```tf
#=============
# Input Value
#=============
// AWS認証情報
variable "credential" {
  type = map(string)
}
```

<br>

##  03. Rootモジュールにおける実装

### terraform

#### ・required_providers

AWSの他，GCPなどのプロバイダの認証を行う．

**＊実装例＊**

```tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      
      // プロバイダーのバージョン変更時は initを実行
      version = "~> 3.0" 
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

使用するプロバイダで認証を行う．

**＊実装例＊**

リージョンの他，アクセスキーとシークレットキーを設定する．

```tf
provider "aws" {
  region = "ap-northeast-1"
  access_key = "<アクセスキー>"
  secret_key = "<シークレットキー>"
}
```

アクセスキーとシークレットキーの代わりに，プロファイルを設定しても良い．

```
provider "aws" {
  region = "ap-northeast-1"
  
  // Linux，Unixの場合
  shared_credentials_file = "$HOME/.aws/<機密情報ファイル名>"
  
  // Windowsの場合
  // shared_credentials_file = "%USERPROFILE%\.aws\<機密情報ファイル名>"
  
  // defaultプロファイル
  profile = default
}
```

機密情報ファイルと各プロファイルは以下の様になっている．

```
[default]
aws_access_key_id=<アクセスキー>
aws_secret_access_key=<シークレットキー>

[user1]
aws_access_key_id=<アクセスキー>
aws_secret_access_key=<シークレットキー>
```

#### ・一時的な環境変数を利用した認証

事前に，```export```を使用して，必要な情報を設定しておく．

```bash
$ export AWS_DEFAULT_REGION="ap-northeast-1"
$ export AWS_ACCESS_KEY_ID="<アクセスキー>"
$ export AWS_SECRET_ACCESS_KEY="<シークレットキー>"
```

サーバ（ローカルPC）を再起動するまでの間だけ，設定値が```aws{}```に自動的に出力される．CircleCIのような，一時的に環境変数が必要になるような状況で，有効な方法．

```tf
// 何も設定しなくてよい．
provider "aws" {}
```

<br>

### module

モジュールを読み込み，変数を渡す．

**＊実装例＊**

ALBの場合

```tf
#======
# ALB
#======
module "alb_module" {

  // モジュールのResourceを参照
  source = "../modules/alb"

  // 他のモジュールの出力値を渡す
  acm_certificate_arn = module.acm_certificate_module.acm_certificate_arn
  subnet_public_1a_id = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id = module.vpc_module.subnet_public_1c_id
  sg_alb_id           = module.security_group_module.sg_alb_id
  vpc_id              = module.vpc_module.vpc_id

  app_name              = var.app_name.kebab
  port_http             = var.port.http
  port_https            = var.port.https
  port_custom_tcp_https = var.port.custom_tcp_https
  ssl_policy            = var.ssl_policy
}
```

<br>

## 04. 各モジュールにおける実装

### resource

aws-cliを用いて，クラウドインフラストラクチャの構築を行う．

**＊実装例＊**

ALBの場合

```tf
#======
# ALB
#======
resource "aws_lb" "alb" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  subnets            = [var.subnet_public_1a_id, var.subnet_public_1c_id]
}
```

<br>

### data resource

```data```によって，外部サービスから値を取得する．ルートモジュールに実装することも可能であるが，各モジュールに実装した方が分かりやすい．

#### ・Role

**＊実装例＊**

```tf
#======
# ECS
#======
data "aws_iam_role" "ecs_task_execution_role" {
  name = "xxxxxECSTaskExecutionRole"
}
```

#### ・AMI

**＊実装例＊**

例えば，　AMIをフィルタリングした上で，AWSから特定のAMIの値を取得する．

```tf
#==============
# AMI
#==============
data "aws_ami" "amazon_linux_2" {
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

モジュールで構築されたリソースがもつ特定の値を出力する．

#### ・ALB

**＊実装例＊**

ALBの場合

**＊実装例＊**

```tf
#====================
# Output From Module
#====================
// ALB
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

// ALB Target Group
output "alb_target_group_green_name" {
  value = aws_lb_target_group.alb_target_group_green.name
}
output "alb_target_group_blue_name" {
  value = aws_lb_target_group.alb_target_group_blue.name
}
output "alb_target_group_blue_arn" {
  value = aws_lb_target_group.alb_target_group_blue.arn
}

// Listener
output "alb_listener_blue_arn" {
  value = aws_lb_listener.lb_listener_blue.arn
}
output "alb_listener_green_arn" {
  value = aws_lb_listener.lb_listener_green.arn
}
```

<br>

## 05. メタ引数

### メタ引数とは

全てのリソースで使用できるオプションのこと．

### depends_on

#### ・depends_on

指定したリソースの後に構築を行う．

**＊実装例＊**

```tf
resource "aws_iam_role_policy" "example" {
  name   = "example"
  role   = aws_iam_role.example.name
  policy = jsonencode({
    "Statement" = [{
      "Action" = "s3:*",
      "Effect" = "Allow",
    }],
  })
}

resource "aws_instance" "example" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.example

  depends_on = [
    aws_iam_role_policy.example,
  ]
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

```for_each```ブロックが定義された```aws_iam_user```リソースが，```for_each```の持つ```value```の数だけ生成される．

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

```tf
// ここに実装例
```

#### ・create_before_destroy

```tf
resource "azurerm_resource_group" "example" {

  lifecycle {
    create_before_destroy = true
  }
}
```

#### ・ignore_changes

リソース内で変更を無視するオプションを設定する．

```tf
resource "aws_instance" "example" {

  tags = {
    Name = "xxx"
  }

  lifecycle {
    ignore_changes = [
      tags["xxx"],
    ]
  }
}
```

リソース全体を無視する場合，配列などは使用せず，```all```とする．

```tf
resource "aws_instance" "example" {

  tags = {
    Name = "xxx"
  }

  lifecycle {
    ignore_changes = all
}
```

<br>

## 06. JSONの実装

### IAMポリシー

```
// ここに実装例
```



### コンテナ定義


```
// ここに実装例
```

<br>

## 07. ベストプラクティス

### ディレクトリ構成

#### ・モジュールを使用する場合

```
terraform_project/
├── dev
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
├── modules
│   ├── ec2
│   │ ├── ec2.tf
│   │ └── main.tf
│   └── vpc
│   ├── main.tf
│   └── vpc.tf
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

### 変数の命名規則

#### ・単数形と複数形の命名分け

複数の値をもつlist型の変数であれば複数形で命名する．一方で，string型など値が一つしかなければ単数形とする．

```tf
vpc_availability_zones             = ["a", "c"]
vpc_cidr                           = "n.n.n.n/23"
vpc_subnet_private_datastore_cidrs = ["n.n.n.n/27", "n.n.n.n/27"]
vpc_subnet_private_app_cidrs       = ["n.n.n.n/25", "n.n.n.n/25"]
vpc_subnet_public_cidrs            = ["n.n.n.n/27", "n.n.n.n/27"]
```

<br>

### リソースとデータリソースの命名規則

#### ・リソースタイプを繰り返さない

リソース名において，リソースタイプを繰り返さないようにする．

**＊実装例＊**

```tf
// 良い例
resource "aws_route_table" "public" {}
```
```tf
// 悪い例
//// リソースでリソースタイプを繰り返さないようにする
resource "aws_route_table" "public_route_table" {}
resource "aws_route_table" "public_aws_route_table" {}
```

#### ・this

一つのリソースタイプに，一つのリソースしか種類が存在していない場合，```this```で命名する．

**＊実装例＊**

```tf
resource "aws_internet_gateway" "this" {}
```

一方で，種類がある場合，リソースタイプを繰り返さないようにしつつ，種類名で命名する．

```tf
// パブリックサブネットのルートテーブル
resource "aws_route_table" "public" {}

// プライベートサブネットのルートテーブル
resource "aws_route_table" "private" {}
```

#### ・記述順序，行間の空け方

最初に```count```を設定し改行する．その後，各設定を行間を空けずに記述する．最後に，```depends_on```と```lifecycle```をそれぞれ行間を空けて配置する．

**＊実装例＊**

```tf
resource "aws_nat_gateway" "this" {
  count         = "1"

  allocation_id = "..."
  subnet_id     = "..."

  tags = {
    Name = "..."
  }

  depends_on = ["aws_internet_gateway.this"]

  lifecycle {
    create_before_destroy = true
  }
}
```

<br>

### アウトプットの命名規則

#### ・返却値がわかりやすいように

返却値が分かりやすいように命名する．この時，リソース名に```public```，```private```を名前に入れる．

**＊実装例＊**

```tf
output "public_subnet_id" {
  // パブリックSubnetのIDを返す 
}

output "private_subnet_id" {
  // プライベートSubnetのIDを返す 
}
```

#### ・this

```this```は省略してもよい．

**＊実装例＊**

```tf
output "this_nat_gateway_id" {
  // thisというNATGatewayのIDを返す 
}

output "nat_gateway_id" {
  // thisというNATGatewayのIDを返す 
}
```

<br>

### IAM

#### ・認証情報の管理方法

例え，```.gitignore```ファイルで機密情報を管理していたとしても，誤ってコミットしてしまう可能性があるため，以下の様に，ハードコーディングしないようにする．

**＊実装例＊**

```tf
provider "aws" {
  region     = "<リージョン>"
  access_key = "<アクセスキー>"
  secret_key = "<シークレットキー>"
}
```

推奨の方法として，AWSにアクセスするための認証情報は，ローカルディレクトリで管理するようにするように，これを読み込むようにする．

**＊実装例＊**

```tf
provider "aws" {
 region = "<リージョン>"
 shared_credentials_file = "<認証情報ファイルのパス>"
 profile = "customprofile"
}
```

```
[default]
aws_access_key_id = <アクセスキー>
aws_secret_access_key = <シークレットキー>
```

<br>

### ECS

#### ・タスク定義の更新

Terraformでタスク定義を更新すると，現在動いているECSで稼働しているタスクはそのままに，新しいリビジョン番号のタスク定義が作成される．コンソール画面の「新しいリビジョンの作成」と同じ挙動である．実際にタスクが増えていることは，サービスに紐づくタスク定義一覧から確認できる．次のデプロイ時に，このタスクが用いられる．
