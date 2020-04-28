#====================
# Output From Module
#====================
output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}
output "alb_zone_id" {
  value = aws_alb.alb.zone_id
}