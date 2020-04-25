# providerセクション：プロバイダの認証情報
# resourceセクション：Terraform内で管理するデータを以下の形式で記述．
#                  （"リソースタイプ" "リソース名"）

#=============
# AWS
#=============
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

#=============
# EC2
#=============
resource "aws_instance" "sphinx-www-1a" {
  ami = ""
  instance_type = var.instance_type
}

#================
# Securirty Group
#================
resource "aws_security_group" "sphinx-security-group" {

}

#=============
# Route 53
#=============
resource "aws_route53" "sphinx-route53" {
  
}

#=============
# VPC
#=============
resource "aws_vpc" "sphinx-vpc" {
  cidr_block = var.cidr_block
}

#=============
# Subnet
#=============
resource "aws_subnet" "sphinx-public-subnet-1a" {
  vpc_id = aws_vpc.sphinx-vpc.id
  cidr_block = var.public_1a_cidr_block
  availability_zone = var.region
}

resource "aws_subnet" "sphinx-public-subnet-1c" {
  vpc_id = aws_vpc.sphinx-vpc.id
  cidr_block = var.public_1c_cidr_block
  availability_zone = var.region
}

#=============
# Route Table
#=============
resource "aws_route_table" "sphinx-public-route-table" {
  vpc_id = aws_vpc.sphinx-vpc.id
  route {}
}

#==============================
# Subnet と Route Table の紐付け
#==============================
resource "aws_route_table_association" "sphinx-publicroute-table-association" {
  subnet_id = aws_subnet.sphinx-public-subnet-1a
  route_table_id = aws_route_table.sphinx-public-route-table.id
}

resource "aws_route_table_association" "sphinx-publicroute-table-association" {
  subnet_id = aws_subnet.sphinx-public-subnet-1c
  route_table_id = aws_route_table.sphinx-public-route-table.id
}
