#=================
# Input To Module
#=================

// AWS認証情報
variable "region" {}

// VPC
variable "vpc_id" {}

// Security Group
variable "security_group_alb_id" {}

// Subnet
variable "public_subnet_1a_id" {}
variable "public_subnet_1c_id" {}

// EC2 Instance
variable "instance_app_name" {}

#==========================
# Application Load Balancer
#==========================
resource "aws_alb" "alb" {
  name = "${var.instance_app_name}-alb"
  security_groups = [var.security_group_alb_id]
  subnets = [var.public_subnet_1a_id, var.public_subnet_1c_id]
  internal = false
  enable_deletion_protection = false
}