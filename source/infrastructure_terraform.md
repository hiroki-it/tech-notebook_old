# Terraform

## 01. コマンド

#### ・```plan```：

スクリプト実行時に，変数が定義されたファイルを実行すると，```variable```で宣言した変数に，値が格納される．

```bash
terraform plan -var-file="XXX.tfvars"
```

#### ・```apply```：

AWS上にクラウドインフラストラクチャを構築する．

```bash
terraform apply -var-file="XXX.tfvars"
```

成功すると，以下のメッセージが表示される．

```bash
Apply complete! Resources: X added, 0 changed, 0 destroyed.
```



## 02. インフラ構築に必要なファイル

### 変数定義ファイル

実行ファイルに入力したい値を定義する．

```yml
#============
# AWS認証情報
#============
aws_access_key = "XXX"
aws_secret_key = "XXX"
region = "XXX"

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
sg_inbound_cidr_block = ["n.n.n.n/n"]  // IPv4アドレスの全ての範囲
sg_outbound_cidr_block = ["n.n.n.n/n"] // IPv4アドレスの全ての範囲

#=================
# Internet Gateway
#=================
igw_cidr_block = "n.n.n.n/n" // IPv4アドレスの全ての範囲

#============
# Route53
#============
r53_domain_name = "example.jp"     // ドメイン名
r53_record_set_name = "example.jp" // レコードセット名
r53_record_type = "A"                  // レコードタイプ

#==============
# EC2 Instance
#==============
instance_app_name = "example-app"  // アプリケーション名

#==============
# Key Pair
#==============
key_name = "aws_key.pub"
public_key_path = "~/.ssh/aws/aws_key.pub"
```



### rootモジュールファイル

#### ・変数定義ファイルからの変数格納

変数定義ファイルから，ファイル内の変数に値を格納する．

```yml
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

// EC2 Instance
variable "instance_app_name" {}

// Key Pair
variable "key_name" {}
variable "public_key_path" {}
```

#### ・AWSの認証

```yml
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}
```

#### ・モジュールの読み込み

モジュールに変数を入力する．

```yml
#=============
# VPC
#=============
module "vpc_module" {
  
  // モジュールのResourceを参照.
  source = "../modules/vpc"
  
  // モジュールに値を注入.
  region                      = var.region
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_public_1a_cidr_block = var.subnet_public_1a_cidr_block
  subnet_public_1c_cidr_block = var.subnet_public_1c_cidr_block
  igw_cidr_block              = var.igw_cidr_block 
  instance_app_name           = var.instance_app_name
}

#================
# Security Gruop
#================
module "security_group_module" {
  
  // モジュールのResourceを参照.
  source = "../modules/security_group"

  // モジュールに値を注入.
  vpc_id                 = module.vpc_module.vpc_id
  sg_inbound_cidr_block  = var.sg_inbound_cidr_block
  sg_outbound_cidr_block = var.sg_outbound_cidr_block
  instance_app_name      = var.instance_app_name
}

#=============
# ALB
#=============
module "alb_module" {
  
  // モジュールのResourceを参照.
  source = "../modules/alb"

  // モジュールに値を注入.
  region                = var.region
  vpc_id                = module.vpc_module.vpc_id
  subnet_public_1a_id   = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id   = module.vpc_module.subnet_public_1c_id
  security_group_alb_id = module.security_group_module.security_group_alb_id
  instance_app_name     = var.instance_app_name
}

#=============
# Route53
#=============
module "route53_module" {

  // モジュールのResourceを参照.
  source = "../modules/route53"

  // モジュールに値を注入.
  r53_alb_dns_name    = module.alb_module.alb_dns_name
  r53_alb_zone_id     = module.alb_module.alb_zone_id
  r53_domain_name     = var.r53_domain_name
  r53_record_set_name = var.r53_record_set_name
  r53_record_type     = var.r53_record_type
}

#==============
# AMI
#==============
module "ami_module" {
  source = "../modules/ami"
}
```

#### ・リソース構築

```yml
#==============
# EC2 Instance
#==============
resource "aws_instance" "www-1a" {
  ami = module.ami_module.ami_amazon_linux_2_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.security_group_module.security_group_instance_id]
  subnet_id = module.vpc_module.subnet_public_1a_id
  disable_api_termination = true
  monitoring = true
  tags = {
    Name = "${var.instance_app_name}-www-1a"
    Subnet-status = "public"
  }
}

resource "aws_instance" "www-1c" {
  ami = module.ami_module.ami_amazon_linux_2_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.security_group_module.security_group_instance_id]
  subnet_id = module.vpc_module.subnet_public_1c_id
  disable_api_termination = true
  monitoring = true
  tags = {
    Name = "${var.instance_app_name}-www-1c"
    Subnet-status = "public"
  }
}
```

#### ・公開鍵の登録

```yml
#==============
# Public Key
#==============
resource "aws_key_pair" "key_pair" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}
```



### モジュールファイル

#### ・rootモジュールファイルからの変数入力

```yml
// AWS認証情報
variable "region" {}

// VPC
variable "vpc_cidr_block" {}

// Subnet
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}

// Internet Gateway
variable "igw_cidr_block" {}

// EC2 Instance
variable "instance_app_name" {}
```

#### ・リソース構築

```yml
#=============
# VPC
#=============
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.instance_app_name}-vpc"
  }
}

#=============
# Subnet
#=============
resource "aws_subnet" "subnet_public_1a" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block = var.subnet_public_1a_cidr_block
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.instance_app_name}-public-subnet-1a"
  }
}

resource "aws_subnet" "subnet_public_1c" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block = var.subnet_public_1c_cidr_block
  availability_zone = "${var.region}c"
  tags = {
    Name = "${var.instance_app_name}-public-subnet-1c"
  }
}

#=================
# Internet Gateway
#=================
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  tags = {
    Name = "${var.instance_app_name}-internet-gateway"
  }
}

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

#==============================
# Subnet と Route Table の紐付け
#==============================
resource "aws_route_table_association" "route_table_association_public_1a" {
  subnet_id = aws_subnet.subnet_public_1a.id // アタッチするSubnetのID
  route_table_id = aws_route_table.route_table_public.id // アタッチするRoute TableのID
}

resource "aws_route_table_association" "route_table_association_public_1c" {
  subnet_id = aws_subnet.subnet_public_1c.id
  route_table_id = aws_route_table.route_table_public.id
}
```



### モジュールから値出力ファイル

モジュールで構築されたリソースがもつ特定の値を出力する．

```yml
// VPC
output "vpc_id" {
  value = aws_vpc.vpc.id
}

// Subnet
output "subnet_public_1a_id" {
  value = aws_subnet.subnet_public_1a.id
}
output "subnet_public_1c_id" {
  value = aws_subnet.subnet_public_1c.id
}
```

