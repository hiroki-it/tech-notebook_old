#====================
# Output From Module
#====================
// ECS
output "sns_topic_ecs_arn" {
value = aws_sns_topic.sns_topic_ecs.arn
}

// CodeDeploy
output "sns_topic_codedeploy_arn" {
  value = aws_sns_topic.sns_topic_codedeploy.arn
}