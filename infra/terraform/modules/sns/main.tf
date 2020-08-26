#======
# ECS
#======
// Topic
resource "aws_sns_topic" "sns_topic_ecs" {
  name = "${var.app_name}-ecs-topic"
}

// Subscription
resource "aws_sns_topic_subscription" "sns_topic_subscription_ecs" {
  endpoint               = var.chatbot_endpoint // Chatbotエンドポイント
  endpoint_auto_confirms = true                 // サブスクリプション自動承認．httpsプロトコルを選択するために必須．
  protocol               = "https"
  topic_arn              = aws_sns_topic.sns_topic_ecs.arn // トピック
}

#=============
# CodeDeploy
#=============
// Topic
resource "aws_sns_topic" "sns_topic_codedeploy" {
  name = "${var.app_name}-codedeploy-topic"
}

// Subscription
resource "aws_sns_topic_subscription" "sns_topic_subscription_codedeploy" {
  endpoint               = var.chatbot_endpoint // Chatbotエンドポイント
  endpoint_auto_confirms = true                 // サブスクリプション自動承認．httpsプロトコルを選択するために必須．
  protocol               = "https"
  topic_arn              = aws_sns_topic.sns_topic_codedeploy.arn // トピック
}
