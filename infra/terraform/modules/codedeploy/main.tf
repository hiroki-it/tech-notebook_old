#=================
# CodeDeploy App
#=================
resource "aws_codedeploy_app" "codedeploy_app" {
  name             = var.app_name
  compute_platform = "ECS"
}

#===================
# CodeDeploy Group
#===================
resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${aws_codedeploy_app.codedeploy_app.name}-deployment-group"
  service_role_arn       = var.codedeployment_role_for_ecs_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  // デプロイタイプ
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  // デプロイ設定
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  // 環境設定
  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  // Load Balancer（Additional configure in ECS）
  load_balancer_info {
    target_group_pair_info {

      // 本稼働リスナーARN
      prod_traffic_route {
        listener_arns = [var.alb_listener_blue_arn]
      }

      // テストリスナーARN（新本稼働リスナーARN）
      test_traffic_route {
        listener_arns = [var.alb_listener_green_arn]
      }

      // ターゲットグループ１（Blue）
      target_group {
        name = var.alb_target_group_blue_name
      }

      // ターゲットグループ２（Green）
      target_group {
        name = var.alb_target_group_green_name
      }
    }
  }

  // トリガー
  trigger_configuration {
    trigger_name       = "${aws_codedeploy_app.codedeploy_app.name}-codedeploy-failure"
    trigger_events     = ["DeploymentFailure"]
    trigger_target_arn = var.sns_topic_codedeploy_arn // CodeDeployトピック
  }
}