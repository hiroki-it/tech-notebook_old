#====================
# Output From Module
#====================
// Route53
output "acm_certificate_arn" {
  value = aws_acm_certificate.acm_certificate.arn
}