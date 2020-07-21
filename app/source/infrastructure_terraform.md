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
$ terraform import -var-file=config.tfvars module.{モジュール名}.{リソース}.{リソース名} {AWS上リソース名}
```

例えば，AWS上にすでにECRが存在しているとして，これをterraformの管理下におく．

```bash
$ terraform import -var-file=config.tfvars module.ecr_module.aws_ecr_repository.ecr_repository_www tech-notebook-www
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



## 02. 値定義ファイル

実行ファイルに入力したい値を定義する．

**【実装例】**

```tf
#============
# AWS認証情報
#============
aws_access_key = "XXX"
aws_secret_key = "XXX"
region         = "XXX"

#=============
# VPC
#=============
vpc_cidr_block = "n.n.n.n/n" // Pアドレスの範囲

#=============
# Subnet
#=============
subnet_public_1a_cidr_block = "n.n.n.n/n" // IPv4アドレスの範囲
subnet_public_1c_cidr_block = "n.n.n.n/n" // IPv4アドレスの範囲

#================
# Security Group
#================
sg_inbound_cidr_block  = ["n.n.n.n/n"]  // IPv4アドレスの全ての範囲
sg_outbound_cidr_block = ["n.n.n.n/n"] // IPv4アドレスの全ての範囲

#=================
# Internet Gateway
#=================
igw_cidr_block = "n.n.n.n/n" // IPv4アドレスの全ての範囲

#============
# Route53
#============
r53_domain_name     = "example.jp"     // ドメイン名
r53_record_set_name = "example.jp" // レコードセット名
r53_record_type     = "A"                  // レコードタイプ

#==============
# EC2 Instance
#==============
app_name = "example-app"  // アプリケーション名

#==============
# Key Pair
#==============
key_name        = "aws_key.pub"
public_key_path = "~/.ssh/aws/aws_key.pub"
```



## 02-02. rootモジュールファイル

### 設定ファイルの参考ドキュメント

https://www.terraform.io/docs/providers/aws/



### 変数の定義

変数定義ファイルから，ファイル内の変数に値を格納する．

**【実装例】**

```tf
#=============
# Input Value
#=============
// AWS認証情報
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

// VPC
variable "vpc_cidr_block" {}

// Subnet
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}

// Security Group
variable "sg_inbound_cidr_block" {}
variable "sg_outbound_cidr_block" {}

// Internet Gateway
variable "igw_cidr_block" {}

// Route53
variable "r53_domain_name" {}
variable "r53_record_set_name" {}
variable "r53_record_type" {}

// ECS，EC2 Instance
variable "app_name" {}

// Key Pair
variable "key_name" {}
variable "public_key_path" {}
```

### AWSの認証

**【実装例】**

```tf
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}
```

### モジュールの読み込み

モジュールを読み込み，変数を渡す．各モジュールの記述例を以下に示す．

#### ・VPCの場合

**【実装例】**

```tf
#=============
# VPC
#=============
module "vpc_module" {

  // モジュールのResourceを参照.
  source = "../modules/vpc"

  region                      = var.region
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_public_1a_cidr_block = var.subnet_public_1a_cidr_block
  subnet_public_1c_cidr_block = var.subnet_public_1c_cidr_block
  igw_cidr_block              = var.igw_cidr_block
  app_name           = var.app_name
}
```

#### ・Securitygroupの場合

**【実装例】**

```tf
#================
# Security Gruop
#================
module "security_group_module" {

  // モジュールのResourceを参照.
  source = "../modules/security_group"

  // 他のモジュールの出力値を渡す.
  vpc_id = module.vpc_module.vpc_id

  sg_inbound_cidr_block  = var.sg_inbound_cidr_block
  sg_outbound_cidr_block = var.sg_outbound_cidr_block
  app_name      = var.app_name
}
```

#### ・Route53の場合

**【実装例】**

```tf
#=============
# Route53
#=============
module "route53_module" {

  // モジュールのResourceを参照.
  source = "../modules/route53"

  // 他のモジュールの出力値を渡す.
  r53_alb_dns_name = module.alb_module.alb_dns_name
  r53_alb_zone_id  = module.alb_module.alb_zone_id

  r53_domain_name     = var.r53_domain_name
  r53_record_set_name = var.r53_record_set_name
  r53_record_type     = var.r53_record_type
}
```


#### ・ALBの場合

**【実装例】**


```tf
#=============
# ALB
#=============
module "alb_module" {

  // モジュールのResourceを参照.
  source = "../modules/alb"

  // 他のモジュールの出力値を渡す.
  vpc_id                = module.vpc_module.vpc_id
  subnet_public_1a_id   = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id   = module.vpc_module.subnet_public_1c_id
  security_group_alb_id = module.security_group_module.security_group_alb_id

  app_name = var.app_name
}
```

#### ・AMIの場合

**【実装例】**

```tf
#==============
# AMI
#==============
module "ami_module" {
  source = "../modules/ami"
}
```

#### ・ECRの場合

**【実装例】**

```tf
#==============
# ECR
#==============
module "ecr_module" {

  source = "../modules/ecr"

  app_name = var.app_name
}
```

#### ・ECSの場合

**【実装例】**

```tf
#======
# ECS
#======
module "ecs_module" {

  // モジュールのResourceを参照.
  source = "../modules/ecs"

  // 他のモジュールの出力値を渡す.
  ecs_task_execution_role_arn = module.roles_module.ecs_task_execution_role_arn
  alb_target_group_arn        = module.alb_module.alb_target_group_arn
  subnet_public_1a_id         = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id         = module.vpc_module.subnet_public_1c_id
  security_group_ecs_id       = module.security_group_module.security_group_ecs_id

  app_name             = var.app_name
  ecs_task_size_cpu    = var.ecs_task_size_cpu
  ecs_task_size_memory = var.ecs_task_size_memory
}
```

### リソース構築

#### ・EC2の場合

**【実装例】**

```tf
#==============
# EC2 Instance
#==============
resource "aws_instance" "www-1a" {
  ami                     = module.ami_module.ami_amazon_linux_2_id
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [module.security_group_module.security_group_instance_id]
  subnet_id               = module.vpc_module.subnet_public_1a_id
  disable_api_termination = true
  monitoring              = true
  tags = {
    Name          = "${var.instance_app_name}-www-1a"
    Subnet-status = "public"
  }
}

resource "aws_instance" "www-1c" {
  ami                     = module.ami_module.ami_amazon_linux_2_id
  instance_type           = "t2.micro"
  vpc_security_group_ids  = [module.security_group_module.security_group_instance_id]
  subnet_id               = module.vpc_module.subnet_public_1c_id
  disable_api_termination = true
  monitoring              = true
  tags = {
    Name          = "${var.instance_app_name}-www-1c"
    Subnet-status = "public"
  }
}
```

#### ・公開鍵の場合

**【実装例】**

```tf
#==============
# Public Key
#==============
resource "aws_key_pair" "key_pair" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}
```



## 02-03. モジュールファイル

### rootモジュールファイルからの変数入力

```variable```によって，rootモジュールファイルから変数を入力できる．

**【実装例】**

```tf
#=============
# Input Value
#=============
// App Name
variable "app_name" {}
```



### リソース構築

```resource```によって，クラウド上に構築するリソースを定義できる．各リソースの記述例を以下に示す．

#### ・VPCの場合

**【実装例】**

```tf
#=============
# VPC
#=============
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.instance_app_name}-vpc"
  }
}
```

#### ・Subnetの場合

**【実装例】**

```tf
#=============
# Subnet
#=============
resource "aws_subnet" "subnet_public_1a" {
  vpc_id            = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block        = var.subnet_public_1a_cidr_block
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.instance_app_name}-public-subnet-1a"
  }
}
resource "aws_subnet" "subnet_public_1c" {
  vpc_id            = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block        = var.subnet_public_1c_cidr_block
  availability_zone = "${var.region}c"
  tags = {
    Name = "${var.instance_app_name}-public-subnet-1c"
  }
}
```
#### ・Internet Gatewayの場合

**【実装例】**

```tf
#=================
# Internet Gateway
#=================
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  tags = {
    Name = "${var.instance_app_name}-internet-gateway"
  }
}
```

#### ・Route Tableの場合

**【実装例】**

```tf
#=============
# Route Table
#=============
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  route {
    cidr_block = var.igw_cidr_block
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.instance_app_name}-public-route-table"
  }
}
```
```tf
#==============================
# Subnet と Route Table の紐付け
#==============================
resource "aws_route_table_association" "route_table_association_public_1a" {
  subnet_id      = aws_subnet.subnet_public_1a.id        // アタッチするSubnetのID
  route_table_id = aws_route_table.route_table_public.id // アタッチするRoute TableのID
}

resource "aws_route_table_association" "route_table_association_public_1c" {
  subnet_id      = aws_subnet.subnet_public_1c.id
  route_table_id = aws_route_table.route_table_public.id
}
```

#### ・Route53の場合

```tf
#==========
# Route53
#==========
resource "aws_route53_zone" "r53_zone" {
  name = var.r53_domain_name
}

resource "aws_route53_record" "r53_record" {
  zone_id = aws_route53_zone.r53_zone.id
  name    = var.r53_record_set_name
  type    = var.r53_record_type
  alias {
    name                   = var.r53_alb_dns_name
    zone_id                = var.r53_alb_zone_id
    evaluate_target_health = false
  }
}
```

#### ・ALBの場合

```tf
#======
# ALB
#======
resource "aws_alb" "alb" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.security_group_alb_id]
  subnets            = [var.subnet_public_1a_id, var.subnet_public_1c_id]
}

#===============
# Target Group
#===============
resource "aws_alb_target_group" "alb_target_group" {
  name        = "${var.app_name}-alb-target-group"
  port        = 80 // ALBからのルーティング時の解放ポート
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
  }
}

#===========
# Listener
#===========
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80 // ALBの受信時の解放ポート
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}
```

#### ・ECRの場合

```
#======
# ECR
#======
resource "aws_ecr_repository" "ecr_repository_builder" {
  name                 = "${var.app_name}-builder"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository" "ecr_repository_www" {
  name                 = "${var.app_name}-www"
  image_tag_mutability = "IMMUTABLE"
}
```

#### ・ECSの場合

```tf
#=============
# ECS Cluster
#=============
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.app_name}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#======================
# ECS Task Definition
#======================
resource "aws_ecs_task_definition" "ecs_task_definition" {

  // ファミリーにリビジョン番号がついてタスク定義名．
  family                   = "${var.app_name}-ecs-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role_arn
  // タスクサイズ．タスク当たり，定義されたコンテナが指定個数入ることを想定．
  cpu                      = var.ecs_task_size_cpu
  memory                   = var.ecs_task_size_memory
  // 引数パスはルートモジュール基準．
  container_definitions    = file("container_definition.json")
}

#==============
# ECS Service
#==============
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = "1"
  platform_version = "LATEST"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "www"
    container_port   = 80
  }
  
  network_configuration {
    subnets = [var.subnet_public_1a_id, var.subnet_public_1c_id]
    security_groups = [var.security_group_ecs_id]
  }
}
```



### モジュールから値出力ファイル

モジュールで構築されたリソースがもつ特定の値を出力する．

#### ・VPCの場合

**【実装例】**

例えば，VPCやSubnetのIDは，他のリソースに紐づけるために，値を出力する必要がある．

```tf
// VPC
output "vpc_id" {
  value = aws_vpc.vpc.id
}
```

#### ・Subnetの場合

**【実装例】**

```tf
// Subnet
output "subnet_public_1a_id" {
  value = aws_subnet.subnet_public_1a.id
}
output "subnet_public_1c_id" {
  value = aws_subnet.subnet_public_1c.id
}
```



#### ・ALBの場合

```tf
// ALB
output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}
output "alb_zone_id" {
  value = aws_alb.alb.zone_id
}
output "alb_target_group_arn" {
  value = aws_alb_target_group.alb_target_group.arn
}
```



### 外部サービスからの値の取得

```data```によって，外部サービスから値を取得する．

#### ・AMIの場合

**【実装例】**

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



## 02-04. 外部ファイルとしての切り出し

### IAMポリシーのJSONファイル

