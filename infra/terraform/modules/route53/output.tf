#====================
# Output From Module
#====================
output "route53_record_fqdn" {
  value = aws_route53_record.route53_record.fqdn
}
output "route53_zone_id" {
  value = data.aws_route53_zone.route53_zone.id
}