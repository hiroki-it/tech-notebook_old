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
  desired_count    = 1
  platform_version = "1.3.0" // LATESTとすると自動で変換されてしまうため，直接指定する．

  // デプロイメント
  deployment_controller {
    type = "CODE_DEPLOY" // CodeDeploy制御によるBlue/Greenデプロイ
  }

  // ヘルスチェック猶予期間
  health_check_grace_period_seconds = 5

  // ロードバランシング
  load_balancer {
    target_group_arn = var.alb_target_group_blue_arn
    container_name   = "www-container"
    container_port   = var.port_http
  }

  // ネットワークアクセス
  network_configuration {
    subnets          = [var.subnet_public_1a_id, var.subnet_public_1c_id]
    security_groups  = [var.sg_ecs_id]
    assign_public_ip = true
  }

  // 動的な差分を無視
  // NOTE: apply時にコメントアウトする
  lifecycle {
    ignore_changes = [
      // タスク数の増減
      desired_count,
      // リビジョン番号
      task_definition,
      // ALBの切り替え
      load_balancer,
    ]
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

  // タスクサイズでは，タスク当たり，定義されたコンテナが最大2つ入るように設定
  cpu    = 512
  memory = 1024

  // コンテナ定義
  container_definitions = file("container_definition.json") // 引数パスはルートモジュール基準
}