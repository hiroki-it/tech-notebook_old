#======
# VPC
#======
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.app_name}-vpc"
  }
}

#==============
# Network ACL
#==============
resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol   = -1 // 全てのポート番号
    rule_no    = 100
    action     = "allow"
    cidr_block = var.nacl_inbound_cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1 // 全てのポート番号
    rule_no    = 100
    action     = "allow"
    cidr_block = var.nacl_outbound_cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.app_name}-network-acl"
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
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc.id // アタッチするVPCのID
  route {
    cidr_block = var.igw_cidr_block
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "${var.app_name}-public-route-table"
  }
}

#=========
# Subnet
#=========
resource "aws_subnet" "subnet_public_1a" {
  vpc_id            = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block        = var.subnet_public_1a_cidr_block
  availability_zone = "${var.credential_region}a"
  tags = {
    Name = "${var.app_name}-public-subnet-1a"
  }
}

resource "aws_subnet" "subnet_public_1c" {
  vpc_id            = aws_vpc.vpc.id // アタッチするVPCのID
  cidr_block        = var.subnet_public_1c_cidr_block
  availability_zone = "${var.credential_region}c"
  tags = {
    Name = "${var.app_name}-public-subnet-1c"
  }
}

#================================
# Route Table と Subnet の紐付け
#================================
resource "aws_route_table_association" "rta_public_1a" {
  subnet_id      = aws_subnet.subnet_public_1a.id        // アタッチするSubnetのID
  route_table_id = aws_route_table.rt_public.id // アタッチするRoute TableのID
}

resource "aws_route_table_association" "rta_public_1c" {
  subnet_id      = aws_subnet.subnet_public_1c.id
  route_table_id = aws_route_table.rt_public.id
}