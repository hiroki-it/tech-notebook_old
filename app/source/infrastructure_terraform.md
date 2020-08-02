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



## 02. 環境変数

実行ファイルに入力したい値を定義する．各サービスの間で実装方法が同じため，VPCのみ例を示す．

**【実装例】**

```tf
#======
# VPC
#======
vpc_cidr_block = "n.n.n.n/n" // IPv4アドレス範囲
```



## 03. Rootモジュール

### Rootモジュールにおけるvariable 

変数定義ファイルから，ファイル内の変数に値を格納する．各サービスの間で実装方法が同じため，VPCのみ例を示す．

**【実装例】**

```tf
// VPC
variable "vpc_cidr_block" {}
```



### provider

AWSの他，GCPなどのプロバイダの認証を行う．

**【実装例】**

```tf
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}
```



### module

モジュールを読み込み，変数を渡す．各モジュールの記述例を以下に示す．各サービスの間で実装方法が同じため，VPCのみ例を示す．




#### ・VPC

**【実装例】**

```tf
#======
# VPC
#======
module "vpc_module" {

  // モジュールのResourceを参照
  source = "../modules/vpc"

  region                      = var.region
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_public_1a_cidr_block = var.subnet_public_1a_cidr_block
  subnet_public_1c_cidr_block = var.subnet_public_1c_cidr_block
  igw_cidr_block              = var.igw_cidr_block
  app_name                    = var.app_name
}
```



## 04. 各モジュール｜resource

### 各モジュールにおけるvariable

```variable```によって，rootモジュールファイルから変数を入力できる．

**【実装例】**

```tf
#=============
# Input Value
#=============
// App Name
variable "app_name" {}
```



### コンピューティング

```resource```によって，クラウド上に構築するリソースを定義できる．各リソースの記述例を以下に示す．なお，各モジュールファイルにおける変数入力の実装は省略している．

#### ・EC2

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
#### ・公開鍵

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



### コンテナ｜ECS x Fargate

#### ・ECS

Blue/Greenデプロイメントを行う場合の例を示す．

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

#==============
# ECS Service
#==============
resource "aws_ecs_service" "ecs_service" {
  name             = "${var.app_name}-ecs-service"
  cluster          = aws_ecs_cluster.ecs_cluster.id
  task_definition  = "${aws_ecs_task_definition.ecs_task_definition.family}:${max("${aws_ecs_task_definition.ecs_task_definition.revision}", "${data.aws_ecs_task_definition.ecs_task_definition.revision}")}"
  launch_type      = "FARGATE"
  desired_count    = "1"
  platform_version = "1.3.0" // LATESTとすると自動で変換されてしまうため，直接指定する．

  // デプロイメント
  deployment_controller {
    type = "CODE_DEPLOY" // CodeDeploy制御によるBlue/Greenデプロイ
  }

  // ロードバランシング
  load_balancer {
    target_group_arn = var.alb_target_group_blue_arn
    container_name   = "www-container"
    container_port   = var.port_http_default
  }

  // ネットワークアクセス
  network_configuration {
    subnets          = [var.subnet_public_1a_id, var.subnet_public_1c_id]
    security_groups  = [var.security_group_ecs_id]
    assign_public_ip = true
  }
}

#======================
# ECS Task Definition
#======================
data "aws_ecs_task_definition" ecs_task_definition {
  task_definition = "${var.app_name}-ecs-task-definition"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = data.aws_ecs_task_definition.ecs_task_definition.family // ファミリーにリビジョン番号がついてタスク定義名
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  cpu                      = var.ecs_task_size_cpu // タスクサイズ．タスク当たり，定義されたコンテナが指定個数入ることを想定
  memory                   = var.ecs_task_size_memory
  container_definitions    = file("container_definition.json") // 引数パスはルートモジュール基準
}
```


#### ・ECR

```
#======
# ECR
#======
resource "aws_ecr_repository" "ecr_repository_www" {
  name                 = "${var.app_name}-www"
  image_tag_mutability = "IMMUTABLE"
}
```



### ストレージ

#### ・S3

```
#=====
# S3
#=====
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.app_name}-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
}
```



### ネットワーキング，コンテンツデリバリー

#### ・ALB

```tf
#======
# ALB
#======
resource "aws_lb" "alb" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.security_group_alb_id]
  subnets            = [var.subnet_public_1a_id, var.subnet_public_1c_id]
}

#===============
# Target Group
#===============
// Blue
resource "aws_lb_target_group" "alb_target_group_blue" {
  name        = "${var.app_name}-target-group-blue"
  port        = var.port_http_default // ALBからのルーティング時解放ポート
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  // ヘルスチェック
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
    matcher             = 200
    port                = var.port_http_default
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.alb]
}

// Green
resource "aws_lb_target_group" "alb_target_group_green" {
  name        = "${var.app_name}-target-group-green"
  port        = var.port_http_custom // ALBからのルーティング時解放ポート
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  // ヘルスチェック
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
    matcher             = 200
    port                = var.port_http_custom
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.alb]
}

#===========
# Listener
#===========
resource "aws_lb_listener" "lb_listener_blue" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port_https // ALBの受信時の解放ポート
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn

  // アクション
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_blue.arn
  }
}

resource "aws_lb_listener" "lb_listener_green" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port_http_custom // ALBの受信時の解放ポート
  protocol          = "HTTP"

  // アクション
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_green.arn
  }
}
```

#### ・Route53

ホストゾーンはコンソールから入力し，Terraformの変更対象外とした方が運用上都合が良いため，dataリソースを用いている．

```tf
#==========
# Route53
#==========
// ホストゾーンの取得
data "aws_route53_zone" "route53_zone" {
  name = var.app_domain_name
}

// レコードセット
resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.route53_zone.id
  name    = "${var.app_sub_domain_name}.${data.aws_route53_zone.route53_zone.name}" // サブドメインを含むFQDN
  type    = "CNAME"
  ttl     = 60
  records = [var.alb_dns_name] // ルーティング先のDNS名
}
```

#### ・VPC

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

#### ・Subnet

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

#### ・Route Table

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

#### ・Internet Gateway

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



### 開発者用ツール

#### ・CodeDeploy

Blue/Greenデプロイメントを行う場合の例を示す．

```
#=================
# CodeDeploy App
#=================
resource "aws_codedeploy_app" "codedeploy_app" {
  name             = var.app_name
  compute_platform = "ECS"
}

#===================
# CodeDeploy Group
#===================
resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name               = var.app_name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${var.app_name}-deployment-group"
  service_role_arn       = var.codedeployment_role_for_ecs_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  // デプロイタイプ
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  // デプロイ設定
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  // 環境設定
  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  // Load Balancer（Additional configure in ECS）
  load_balancer_info {
    target_group_pair_info {
      
      // 本稼働リスナーARN
      prod_traffic_route {
        listener_arns = [var.alb_listener_blue_arn]
      }
      // ターゲットグループ１（Blue）
      target_group {
        name = var.alb_target_group_blue_name
      }
      
      // テストリスナーARN
      test_traffic_route {
        listener_arns = [var.alb_listener_green_arn]
      }
      // ターゲットグループ２（Green）
      target_group {
        name = var.alb_target_group_green_name
      }
    }
  }
}
```



## 04-02. 各モジュール｜その他

### output

モジュールで構築されたリソースがもつ特定の値を出力する．各サービスの間で実装方法が同じため，VPCのみ例を示す．

#### ・VPC

**【実装例】**

例えば，VPCやSubnetのIDは，他のリソースに紐づけるために，値を出力する必要がある．

```tf
// VPC
output "vpc_id" {
  value = aws_vpc.vpc.id
}
```



### data resource

```data```によって，外部サービスから値を取得する．

#### ・Role

```
#======
# ECS
#======
data "aws_iam_role" "ecs_task_execution_role" {
  name = "xxxxxECSTaskExecutionRole"
}
```

#### ・AMI

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



## 05. 外部ファイルとしての切り出し

### IAMポリシーJSON

```
// ここに実装例
```



### コンテナ定義JSON


```
// ここに実装例
```

