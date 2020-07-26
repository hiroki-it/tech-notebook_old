#======
# ECS
#======
resource "aws_cloudwatch_log_group" "cloudwatch_log_group_ecs_" {
  name              = "/aws/ecs/containerinsights/tech-notebook-ecs-cluster/performance"
  retention_in_days = 1
}