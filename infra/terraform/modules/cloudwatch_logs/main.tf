#======
# ECS
#======
data "aws_cloudwatch_log_group" "cloudwatch_log_group_ecs_" {
  name  = "/aws/ecs/containerinsights/tech-notebook-ecs-cluster/performance"
}