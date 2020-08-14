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
variable "alb_zone_id" {}
variable "alb_dns_name" {}

#==========
# Route53
#==========
// ホストゾーンの取得
data "aws_route53_zone" "route53_zone" {
  name = var.app_domain_name
}
// レコードセット
resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.route53_zone.id
  name    = "${var.app_sub_domain_name}.${data.aws_route53_zone.route53_zone.name}" // サブドメインを含むFQDN
  type    = "A"

  // エイリアス
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

// ヘルスチェック
resource "aws_route53_health_check" "route53_health_check" {
  fqdn              = "${var.app_sub_domain_name}.${data.aws_route53_zone.route53_zone.name}"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 10
  type              = "HTTPS"
  port              = 443

  tags = {
    Name = "${var.app_sub_domain_name}-route53-health-check"
  }
}