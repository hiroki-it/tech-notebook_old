#=============
# Input Value
#=============
// App Info
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

// Port
variable "port_http" {}

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

  // デプロイメント
  deployment_controller {
    type = "CODE_DEPLOY" // Blue/Greenデプロイメント
  }

  // ロードバランシング
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "www-container"
    container_port   = var.port_http
  }

  // ネットワークアクセス
  network_configuration {
    subnets         = [var.subnet_public_1a_id, var.subnet_public_1c_id]
    security_groups = [var.security_group_ecs_id]
  }
}

#======================
# ECS Task Definition
#======================
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "${var.app_name}-ecs-task-definition" // ファミリーにリビジョン番号がついてタスク定義名
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = var.ecs_task_execution_role_arn
  cpu                      = var.ecs_task_size_cpu // タスクサイズ．タスク当たり，定義されたコンテナが指定個数入ることを想定
  memory                   = var.ecs_task_size_memory
  container_definitions    = file("container_definition.json") // 引数パスはルートモジュール基準
}

#====================
# ECS Task Schedule
#====================
// スケジュールルール
resource "aws_cloudwatch_event_rule" "cloudwatch_event_rule_ecs" {
  name                = "builder-event-rule"
  description         = "Make Html"
  schedule_expression = "cron(0 20 * * ? *)"
}

// ターゲットのスケジュール
resource "aws_cloudwatch_event_target" "cloudwatch_event_target_ecs" {
  target_id = "${var.app_name}-builder"
  rule      = aws_cloudwatch_event_rule.cloudwatch_event_rule_ecs.name
  arn       = aws_ecs_cluster.ecs_cluster.arn
  role_arn  = var.ecs_task_execution_role_arn

  // ロードバランシング
  ecs_target {
    launch_type         = "FARGATE"
    platform_version    = "latest"
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.ecs_task_definition.arn

    // ネットワークアクセス
    network_configuration {
      subnets         = [var.subnet_public_1a_id, var.subnet_public_1c_id]
      security_groups = [var.security_group_ecs_id]
    }
  }
}