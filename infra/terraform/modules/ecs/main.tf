#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// Subnet
variable "subnet_public_1a_id" {}
variable "subnet_public_1c_id" {}

// Security Group
variable "security_group_ecs_id" {}

// ALB
variable "alb_target_group_arn" {}

// ECS
variable "ecs_task_size_cpu" {}
variable "ecs_task_size_memory" {}
variable "ecs_task_execution_role_arn" {}

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
  name             = "${var.app_name}-ecs-service"
  cluster          = aws_ecs_cluster.ecs_cluster.id
  task_definition  = aws_ecs_task_definition.ecs_task_definition.arn
  launch_type      = "FARGATE"
  desired_count    = "1"
  platform_version = "LATEST"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "www"
    container_port   = 80
  }

  network_configuration {
    subnets         = [var.subnet_public_1a_id, var.subnet_public_1c_id]
    security_groups = [var.security_group_ecs_id]
  }
}