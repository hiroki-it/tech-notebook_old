# Terraform

## 01. よく使うコマンド集

#### ・```validate```：

設定ファイルの検証を行う．

```bash
$ terraform validate

Success! The configuration is valid.
```

#### ・```fmt```：

設定ファイルのインデントを揃える．処理を行ったファイルが表示される．

```bash
$ terraform fmt

main.tf
```

#### ・```import```：

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

#### ・```refresh```：

クラウドに対してリクエストを行い，現在のリソースの状態をtfstateファイルに反映する．

```bash
$ terraform refresh -var-file=config.tfvars
```

#### ・```plan```：

クラウドに対してリクエストを行い，現在のリソースの状態をtfstateファイルには反映せずに，設定ファイルの記述との差分を検証する．スクリプト実行時に，変数が定義されたファイルを実行すると，```variable```で宣言した変数に，値が格納される．

```bash
$ terraform plan -var-file=XXX.tfvars
```

差分がなければ，以下の通りになる．

```bash
No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```

ちなみに，```-refresh=true```オプションをつければ，```refresh```コマンドを同時に実行してくれる．

```bash
$ terraform plan -var-file=XXX.tfvars -refresh=true 
```

#### ・```apply```：

AWS上にクラウドインフラストラクチャを構築する．

```bash
$ terraform apply -var-file XXX.tfvars
```

成功すると，以下のメッセージが表示される．

```bash
Apply complete! Resources: X added, 0 changed, 0 destroyed.
```

#### ・```state list```：

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

### 01-02. Tips

#### ・ECSタスク稼働中に更新すると？

Terraformでタスク定義を更新すると，現在動いているECSで稼働しているタスクはそのままに，新しいリビジョン番号のタスク定義が作成される．コンソール画面の「新しいリビジョンの作成」と同じ挙動である．実際にタスクが増えていることは，サービスに紐づくタスク定義一覧から確認できる．次のデプロイ時に，このタスクが用いられる．

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



##  03. Rootモジュールにおける実装

### provider

AWSの他，GCPなどのプロバイダの認証を行う．

**＊実装例＊**

```tf
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
  version    = "~2.7" // プロバイダーのバージョン変更時は initを実行
}
```



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



### data resource

```data```によって，外部サービスから値を取得する．ルートモジュールに実装することも可能であるが，各モジュールに実装した方が分かりやすい．

#### ・Role

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



### output

モジュールで構築されたリソースがもつ特定の値を出力する．

#### ・ALB

**＊実装例＊**

ALBの場合

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



## 05. メタ引数

### メタ引数とは

全てのリソースで使用できるオプションのこと．

### ```depends_on```

指定したリソースの後に構築を行う．

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



### ```count```

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



### ```for_each```

### ```lifecycle```

#### ・```create_before_destroy```

```tf
resource "azurerm_resource_group" "example" {

  lifecycle {
    create_before_destroy = true
  }
}
```

#### ・```ignore_changes```

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



## 06. 外部ファイルとしての切り出し

### IAMポリシーJSON

```
// ここに実装例
```



### コンテナ定義JSON


```
// ここに実装例
```

