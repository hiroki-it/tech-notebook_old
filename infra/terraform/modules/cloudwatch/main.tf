#======
# ECS
#======
// ロググループ
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_ecs" {
  name              = "/${var.app_name}/ecs/container-definition.production"
  // 保持期間
  retention_in_days = 7
}

// メトリクスフィルター
resource "aws_cloudwatch_log_metric_filter" "cloudwatch_log_metric_filter" {
  name           = "WARNING-ERROR"
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group_ecs.name

  // フィルターパターンで，OR条件には疑問符を使用
  pattern        = "?WARNING ?ERROR ?CRITICAL ?EMERGENCY ?ALERT"

  // メトリクスの詳細
  metric_transformation {
    // メトリクス名前空間
    namespace = "WarningError"
    // メトリクス名
    name      = "${var.app_name}LogMetric"
    // メトリクス値
    value     = 1
  }
}