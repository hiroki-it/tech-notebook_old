#======
# ECS
#======
// ロググループ
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_ecs" {
  name              = "/${var.app_name_kebab}/ecs/container-definition.production"
  // 保持期間
  retention_in_days = 7
}

// メトリクスフィルター
resource "aws_cloudwatch_log_metric_filter" "cloudwatch_log_metric_filter" {
  name           = "WARNING-ERROR"
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group_ecs.name

  // フィルターパターンで，OR条件には疑問符を使用
  pattern = "?WARNING ?ERROR ?CRITICAL ?EMERGENCY ?ALERT"

  // メトリクスの詳細
  metric_transformation {
    // メトリクス名前空間
    namespace = var.app_name_camel
    // メトリクス名
    name      = "${var.app_name_camel}WarningErrorMetric"
    // メトリクス値
    value     = 1
  }
}

// メトリクスアラーム
resource "aws_cloudwatch_metric_alarm" "cloudwatch_metric_alarm" {

  alarm_name        = "${var.app_name_kebab}-ecs-alarm"
  alarm_description = "Alarm from ECS"
  namespace         = var.app_name_camel
  metric_name       = "${var.app_name_camel}WarningErrorMetric"
  // 統計
  statistic         = "Sum"
  // 期間
  period            = 300

  // 条件
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0

  // 通知トリガー
  actions_enabled = true
  // 送信先 
  alarm_actions   = [var.sns_topic_arn]
}