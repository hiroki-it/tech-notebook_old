#==========
# Route53
#==========
// ホストゾーンの取得
data "aws_route53_zone" "route53_zone" {
  name = var.domain_name
}
// レコードセット
resource "aws_route53_record" "route53_record" {
  zone_id = data.aws_route53_zone.route53_zone.id
  name    = "${var.domain_sub_name}.${data.aws_route53_zone.route53_zone.name}" // サブドメインを含むFQDN
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
  fqdn              = "${var.domain_sub_name}.${data.aws_route53_zone.route53_zone.name}"
  resource_path     = "/"
  request_interval  = 30
  failure_threshold = 3
  type              = "HTTPS"
  port              = 443

  tags = {
    Name = "${var.domain_sub_name}-route53-health-check"
  }
}