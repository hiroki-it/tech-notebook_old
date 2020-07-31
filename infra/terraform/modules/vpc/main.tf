#=============
# Input Value
#=============
// AWS認証情報
variable "region" {}

// App Info
variable "app_name" {}

// VPC
variable "vpc_cidr_block" {}

// Subnet
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}

// Internet Gateway
variable "igw_cidr_block" {}

#======
# VPC
#======
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.app_name}-vpc"
  }
}

#=========
# Subnet
#=========
resource "aws_subnet" "subnet_public_1a" {
  vpc_id            = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block        = var.subnet_public_1a_cidr_block
  availability_zone = "${var.region}a"
  tags = {
    Name = "${var.app_name}-public-subnet-1a"
  }
}

resource "aws_subnet" "subnet_public_1c" {
  vpc_id            = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block        = var.subnet_public_1c_cidr_block
  availability_zone = "${var.region}c"
  tags = {
    Name = "${var.app_name}-public-subnet-1c"
  }
}

#===================
# Internet Gateway
#===================
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  tags = {
    Name = "${var.app_name}-internet-gateway"
  }
}

#==============
# Route Table
#==============
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  route {
    cidr_block = var.igw_cidr_block
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.app_name}-public-route-table"
  }
}

#================================
# Subnet と Route Table の紐付け
#================================
resource "aws_route_table_association" "route_table_association_public_1a" {
  subnet_id      = aws_subnet.subnet_public_1a.id        // アタッチするSubnetのID
  route_table_id = aws_route_table.route_table_public.id // アタッチするRoute TableのID
}

resource "aws_route_table_association" "route_table_association_public_1c" {
  subnet_id      = aws_subnet.subnet_public_1c.id
  route_table_id = aws_route_table.route_table_public.id
}