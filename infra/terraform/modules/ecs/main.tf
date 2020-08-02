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
variable "alb_target_group_blue_arn" {}

// ECS
variable "ecs_task_size_cpu" {}
variable "ecs_task_size_memory" {}
variable "ecs_task_execution_role_arn" {}

// Port
variable "port_http_default" {}

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
  task_definition  = "${aws_ecs_task_definition.ecs_task_definition.family}:${max("${aws_ecs_task_definition.ecs_task_definition.revision}", "${data.aws_ecs_task_definition.ecs_task_definition.revision}")}"
  launch_type      = "FARGATE"
  desired_count    = "1"
  platform_version = "1.3.0" // LATESTとすると自動で変換されてしまうため，直接指定する．

  // デプロイメント
  deployment_controller {
    type = "CODE_DEPLOY" // CodeDeploy制御によるBlue/Greenデプロイ
  }

  // ロードバランシング
  load_balancer {
    target_group_arn = var.alb_target_group_blue_arn
    container_name   = "www-container"
    container_port   = var.port_http_default
  }

  // ネットワークアクセス
  network_configuration {
    subnets          = [var.subnet_public_1a_id, var.subnet_public_1c_id]
    security_groups  = [var.security_group_ecs_id]
    assign_public_ip = true
  }
}

#======================
# ECS Task Definition
#======================
data "aws_ecs_task_definition" ecs_task_definition {
  task_definition = "${var.app_name}-ecs-task-definition"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = data.aws_ecs_task_definition.ecs_task_definition.family // ファミリーにリビジョン番号がついてタスク定義名
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  cpu                      = var.ecs_task_size_cpu // タスクサイズ．タスク当たり，定義されたコンテナが指定個数入ることを想定
  memory                   = var.ecs_task_size_memory
  container_definitions    = file("container_definition.json") // 引数パスはルートモジュール基準
}