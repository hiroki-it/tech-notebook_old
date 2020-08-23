#=============
# AWS認証情報
#=============
provider "aws" {
  access_key = var.credential.aws_access_key
  secret_key = var.credential.aws_secret_key
  region     = var.credential.region
  version    = "~> 2.7" // プロバイダーのバージョンの変更時は，initを実行
}

#========
# Roles
#========
module "service_role_module" {
  // モジュールのResourceを参照
  source = "../modules/service_role"

  app_name = var.app_name.camel
}

#======
# VPC
#======
module "vpc_module" {

  // モジュールのResourceを参照
  source = "../modules/vpc"

  app_name                    = var.app_name.kebab
  credential_region           = var.credential.region
  igw_cidr_block              = var.igw_cidr_block
  nacl_inbound_cidr_block     = var.nacl.inbound_cidr_block
  nacl_outbound_cidr_block    = var.nacl.outbound_cidr_block
  subnet_public_1a_cidr_block = var.subnet.public_1a_cidr_block
  subnet_public_1c_cidr_block = var.subnet.public_1c_cidr_block
  vpc_cidr_block              = var.vpc_cidr_block

}

#=================
# Security Gruop
#=================
module "security_group_module" {

  // モジュールのResourceを参照
  source = "../modules/security_group"

  // 他のモジュールの出力値を渡す
  vpc_id = module.vpc_module.vpc_id

  app_name                             = var.app_name.kebab
  port_http                            = var.port.http
  port_https_main                      = var.port.https
  port_custom_tcp_https                = var.port.custom_tcp_https
  port_ssh                             = var.port.ssh
  sg_alb_inbound_cidr_block_http       = var.sg.alb_inbound_cidr_block_http
  sg_alb_inbound_ipv6_cidr_block_http  = var.sg.alb_inbound_ipv6_cidr_block_http
  sg_alb_inbound_cidr_block_https      = var.sg.alb_inbound_cidr_block_https
  sg_alb_inbound_ipv6_cidr_block_https = var.sg.alb_inbound_ipv6_cidr_block_https
  sg_ecs_inbound_cidr_block_ssh        = var.sg.ecs_inbound_cidr_block_ssh
  sg_ecs_inbound_cidr_block_http       = var.sg.ecs_inbound_cidr_block_http
  sg_outbound_cidr_block               = var.sg.outbound_cidr_block
}

#======
# ALB
#======
module "alb_module" {

  // モジュールのResourceを参照
  source = "../modules/alb"

  // 他のモジュールの出力値を渡す
  acm_certificate_arn = module.acm_certificate_module.acm_certificate_arn
  subnet_public_1a_id = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id = module.vpc_module.subnet_public_1c_id
  sg_alb_id           = module.security_group_module.sg_alb_id
  vpc_id              = module.vpc_module.vpc_id

  app_name              = var.app_name.kebab
  port_http             = var.port.http
  port_https            = var.port.https
  port_custom_tcp_https = var.port.custom_tcp_https
  ssl_policy            = var.ssl_policy
}

#==========
# Route53
#==========
module "route53_module" {

  // モジュールのResourceを参照.
  source = "../modules/route53"

  // 他のモジュールの出力値を渡す.
  alb_zone_id  = module.alb_module.alb_zone_id
  alb_dns_name = module.alb_module.alb_dns_name
  vpc_id       = module.vpc_module.vpc_id

  credential_region = var.credential.region
  domain_name       = var.domain.name
  domain_sub_name   = var.domain.sub_name

}

#======
# ECR
#======
module "ecr_module" {

  // モジュールのResourceを参照
  source = "../modules/ecr"

  app_name = var.app_name.kebab
}

#======
# ECS
#======
module "ecs_module" {

  // モジュールのResourceを参照
  source = "../modules/ecs"

  // 他のモジュールの出力値を渡す
  alb_target_group_blue_arn   = module.alb_module.alb_target_group_blue_arn
  ecs_task_execution_role_arn = module.service_role_module.ecs_task_execution_role_arn
  subnet_public_1a_id         = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id         = module.vpc_module.subnet_public_1c_id
  sg_ecs_id                   = module.security_group_module.sg_ecs_id

  app_name  = var.app_name.kebab
  port_http = var.port.http

}

#=============
# CodeDeploy
#=============
module "codedeploy_module" {
  // モジュールのResourceを参照
  source = "../modules/codedeploy"

  // 他のモジュールの出力値を渡す
  alb_listener_blue_arn           = module.alb_module.alb_listener_blue_arn
  alb_listener_green_arn          = module.alb_module.alb_listener_green_arn
  alb_target_group_blue_name      = module.alb_module.alb_target_group_blue_name
  alb_target_group_green_name     = module.alb_module.alb_target_group_green_name
  codedeployment_role_for_ecs_arn = module.service_role_module.codedeployment_role_for_ecs_arn
  ecs_cluster_name                = module.ecs_module.ecs_cluster_name
  ecs_service_name                = module.ecs_module.ecs_service_name

  app_name = var.app_name.camel
}

#=====
# S3
#=====
module "s3_module" {
  source = "../modules/s3"

  app_name = var.app_name.kebab
}

#==================
# CloudWatch Logs
#==================
module "cloudwatch_logs_module" {
  source = "../modules/cloudwatch_logs"
}

#================
# Certificate
#================
module "acm_certificate_module" {
  // モジュールのResourceを参照
  source = "../modules/acm_certificate"

  // 他のモジュールの出力値を渡す
  route53_zone_id = module.route53_module.route53_zone_id

  app_name        = var.app_name.kebab
  domain_name     = var.domain.name
  domain_sub_name = var.domain.sub_name
}

#=============
# Public Key
#=============
resource "aws_key_pair" "key_pair" {
  key_name   = var.public_key.name
  public_key = file(var.public_key.path)
}