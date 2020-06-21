#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// ALB
variable "alb_target_group_arn" {}

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
  family = "${var.app_name}-ecs-task-definition"
  // containerDefinitionsセクションのJSONデータを記述
  // 引数パスはルートモジュール基準
  container_definitions = file("task_definition.json")
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

#==============
# ECS Service
#==============
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.app_name}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "www"
    container_port   = 80
  }
}