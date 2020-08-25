// SNS Topic
resource "aws_sns_topic" "sns_topic" {
  name = "${var.app_name}-sns-topic"
}

// Subscription
resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  endpoint               = var.chatbot_endpoint // Chatbotエンドポイント
  endpoint_auto_confirms = true                 // サブスクリプション自動承認．httpsプロトコルを選択するために必須．
  protocol               = "https"
  topic_arn              = aws_sns_topic.sns_topic.arn // トピック
}
