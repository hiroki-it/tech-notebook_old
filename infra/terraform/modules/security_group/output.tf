#====================
# Output From Module
#====================
// ALB
output "security_group_alb_id" {
  value = aws_security_group.security_group_alb.id
}

// ECS
output "security_group_ecs_id" {
  value = aws_security_group.security_group_ecs.id
}