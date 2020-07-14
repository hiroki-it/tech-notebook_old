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
resource "aws_route53_zone" "route53_zone" {
  name = var.app_domain_name

  vpc {
    vpc_id     = var.vpc_id
    vpc_region = var.region
  }
}
// レコードセット
resource "aws_route53_record" "route53_record" {
  zone_id = aws_route53_zone.route53_zone.id
  name    = "${var.app_sub_domain_name}.${var.app_domain_name}"
  type    = "CNAME"
  ttl     = 300

  // ルーティング先のDNS名
  records = [var.alb_dns_name]
}