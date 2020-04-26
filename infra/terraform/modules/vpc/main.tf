variable "region" {}
variable "instance_app_name" {}
variable "vpc_cidr_block" {}
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}

#=================
# Internet Gateway
#=================
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  tags = {
    Name = "${var.instance_app_name}-internet-gateway"
  }
}

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
resource "aws_subnet" "public-subnet-1a" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block = var.subnet_public_1a_cidr_block
  availability_zone = var.region
  tags = {
    Name = "${var.instance_app_name}-public-subnet-1a"
  }
}

resource "aws_subnet" "public-subnet-1c" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block = var.subnet_public_1c_cidr_block
  availability_zone = var.region
  tags = {
    Name = "${var.instance_app_name}-public-subnet-1c"
  }
}

#=============
# Route Table
#=============
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  tags = {
    Name = "${var.instance_app_name}-public-route-table"
  }
}

#==============================
# Subnet と Route Table の紐付け
#==============================
resource "aws_route_table_association" "public-rta-1a" {
  subnet_id = aws_subnet.public-subnet-1a.id // アタッチするSubnetのID
  route_table_id = aws_route_table.public-rt.id // アタッチするRoute TableのID
}

resource "aws_route_table_association" "public-rta-1c" {
  subnet_id = aws_subnet.public-subnet-1c.id
  route_table_id = aws_route_table.public-rt.id
}