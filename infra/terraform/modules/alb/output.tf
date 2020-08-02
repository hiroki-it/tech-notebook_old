#====================
# Output From Module
#====================
// ALB
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

// ALB Target Group
output "alb_target_group_green_name" {
  value = aws_lb_target_group.alb_target_group_green.name
}
output "alb_target_group_blue_name" {
  value = aws_lb_target_group.alb_target_group_blue.name
}
output "alb_target_group_blue_arn" {
  value = aws_lb_target_group.alb_target_group_blue.arn
}

// Listener
output "alb_listener_blue_arn" {
  value = aws_lb_listener.lb_listener_blue.arn
}
output "alb_listener_green_arn" {
  value = aws_lb_listener.lb_listener_green.arn
}