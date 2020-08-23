#====================
# Output From Module
#====================
// ALB
output "sg_alb_id" {
  value = aws_security_group.sg_alb.id
}

// ECS
output "sg_ecs_id" {
  value = aws_security_group.sg_ecs.id
}