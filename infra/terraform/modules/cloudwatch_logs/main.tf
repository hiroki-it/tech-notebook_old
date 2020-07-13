#======
# ECS
#======
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_ecs_scheduled_tasks" {
  name              = "/aws/ecs/ecs-scheduled-tasks/builder-rule"
  retention_in_days = 1
}