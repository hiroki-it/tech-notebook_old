#====================
# Output From Module
#====================
// ECS
output "ecs_task_execution_role_arn" {
  value = data.aws_iam_role.ecs_task_execution_role.arn
}

// CodeDeploy
output "codedeployment_role_for_ecs_arn" {
  value = data.aws_iam_role.codedeployment_role_for_ecs.arn
}