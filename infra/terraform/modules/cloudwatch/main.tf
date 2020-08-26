#======
# ECS
#======
// ロググループ
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_ecs" {
  name              = "/${var.app_name_kebab}/ecs/container-definition.production"
  retention_in_days = 7 // 保持期間
}

// メトリクスフィルター
resource "aws_cloudwatch_log_metric_filter" "cloudwatch_log_metric_filter" {
  name           = "WARNING-ERROR"
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group_ecs.name
  pattern        = "?WARNING ?ERROR ?CRITICAL ?EMERGENCY ?ALERT" // フィルターパターンで，OR条件には疑問符を使用

  // メトリクスの詳細
  metric_transformation {

    namespace = var.app_name_camel                        // メトリクス名前空間
    name      = "${var.app_name_camel}WarningErrorMetric" // メトリクス名
    value     = 1                                         // メトリクス値
  }
}

// メトリクスアラーム
resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm" {

  alarm_name          = "${var.app_name_kebab}-ecs-alarm"
  alarm_description   = "Alarm from ECS"
  namespace           = var.app_name_camel
  metric_name         = "${var.app_name_camel}WarningErrorMetric"
  statistic           = "Sum"                  // 統計
  period              = 300                    // 期間
  comparison_operator = "GreaterThanThreshold" // 条件
  evaluation_periods  = 1
  threshold           = 0
  actions_enabled     = true                    // 通知トリガー
  alarm_actions       = [var.sns_topic_ecs_arn] // 送信先 
}