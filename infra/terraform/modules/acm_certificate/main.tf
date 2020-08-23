#============
# 証明書発行
#============
resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.domain_name          // ネイキッドドメイン
  subject_alternative_names = ["*.${var.domain_name}"] // サブドメイン群
  validation_method         = "DNS"

  tags = {
    Name = var.domain_name
  }

  // 証明書の再生成のタイミング
  lifecycle {
    create_before_destroy = true
  }
}

// 証明書のDNS検証
resource "aws_route53_record" "route53_record_verification" {
  zone_id = var.route53_zone_id
  name    = aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_type
  records = [aws_acm_certificate.acm_certificate.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

// 証明書検証の待機
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [aws_route53_record.route53_record_verification.fqdn]
}
