#======
# ECS
#======
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_ecs_" {
  name              = "/ecs/tech-notebook/www-container/awslogs-group"
  retention_in_days = 1
}