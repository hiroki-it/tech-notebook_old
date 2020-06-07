#=============
# Input Value
#=============
// VPC
variable "vpc_id" {}

// Subnet
variable "subnet_public_1a_id" {}
variable "subnet_public_1c_id" {}

// Security Group
variable "security_group_alb_id" {}

// EC2 Instance
variable "instance_app_name" {}

#==========================
# Application Load Balancer
#==========================
resource "aws_alb" "alb" {
  name               = "${var.instance_app_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.security_group_alb_id]
  subnets            = [var.subnet_public_1a_id, var.subnet_public_1c_id]
}

resource "aws_alb_target_group" "alb_target_group" {
  name        = "${var.instance_app_name}-alb-target"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}