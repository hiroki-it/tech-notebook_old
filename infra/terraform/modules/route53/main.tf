#=============
# Input Value
#=============
// App Info
variable "app_domain_name" {}
variable "app_sub_domain_name" {}
variable "region" {}

// VPC
variable "vpc_id" {}

// ALB
variable "alb_dns_name" {}

#==========
# Route53
#==========
// ホストゾーン
data "aws_route53_zone" "route53_zone" {
  name = var.app_domain_name
}
// レコードセット
resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.route53_zone.id
  name    = "${var.app_sub_domain_name}.${var.app_domain_name}"
  type    = "CNAME"
  ttl     = 300

  // ルーティング先のDNS名
  records = [var.alb_dns_name]
}