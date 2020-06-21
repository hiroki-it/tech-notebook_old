#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// VPC
variable "vpc_id" {}

// Subnet
variable "subnet_public_1a_id" {}
variable "subnet_public_1c_id" {}

// Security Group
variable "security_group_alb_id" {}

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