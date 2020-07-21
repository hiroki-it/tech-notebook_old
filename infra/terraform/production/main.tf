#=============
# Input Value
#=============
// AWS認証情報
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

// App Info
variable "app_name" {}
variable "app_domain_name" {}
variable "app_sub_domain_name" {}

// VPC
variable "vpc_cidr_block" {}

// Subnet
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}

// Security Group
variable "security_group_inbound_cidr_block" {}
variable "security_group_outbound_cidr_block" {}

// Internet Gateway
variable "igw_cidr_block" {}

// ECS
variable "ecs_task_size_cpu" {}
variable "ecs_task_size_memory" {}

// Port
variable "port_http_blue" {}
variable "port_http_green" {}
variable "port_https_blue" {}
variable "port_https_green" {}
variable "port_ssh" {}

// Key Pair
variable "key_name" {}
variable "public_key_path" {}

// certificate
variable "ssl_policy" {}

#=============
# AWS認証情報
#=============
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
  version    = "~> 2.7" // プロバイダーのバージョンの変更時は，initを実行
}

#========
# Roles
#========
module "roles_module" {
  // モジュールのResourceを参照
  source = "../modules/service_role"
}

#======
# VPC
#======
module "vpc_module" {

  // モジュールのResourceを参照
  source = "../modules/vpc"

  region                      = var.region
  vpc_cidr_block              = var.vpc_cidr_block
  subnet_public_1a_cidr_block = var.subnet_public_1a_cidr_block
  subnet_public_1c_cidr_block = var.subnet_public_1c_cidr_block
  igw_cidr_block              = var.igw_cidr_block
  app_name                    = var.app_name
}

#=================
# Security Gruop
#=================
module "security_group_module" {

  // モジュールのResourceを参照
  source = "../modules/security_group"

  // 他のモジュールの出力値を渡す
  vpc_id = module.vpc_module.vpc_id

  security_group_inbound_cidr_block  = var.security_group_inbound_cidr_block
  security_group_outbound_cidr_block = var.security_group_outbound_cidr_block
  app_name                           = var.app_name
  port_http_blue                     = var.port_http_blue
  port_http_green                    = var.port_http_green
  port_https                         = var.port_https_blue
  port_ssh                           = var.port_ssh
}

#======
# ALB
#======
module "alb_module" {

  // モジュールのResourceを参照
  source = "../modules/alb"

  // 他のモジュールの出力値を渡す
  vpc_id                = module.vpc_module.vpc_id
  subnet_public_1a_id   = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id   = module.vpc_module.subnet_public_1c_id
  security_group_alb_id = module.security_group_module.security_group_alb_id
  acm_certificate_arn   = module.acm_certificate_module.acm_certificate_arn

  app_name         = var.app_name
  port_http_blue   = var.port_http_blue
  port_http_green  = var.port_http_green
  port_https_blue  = var.port_https_blue
  port_https_green = var.port_https_green
  ssl_policy       = var.ssl_policy
}

#==========
# Route53
#==========
module "route53_module" {

  // モジュールのResourceを参照.
  source = "../modules/route53"

  // 他のモジュールの出力値を渡す.
  alb_dns_name = module.alb_module.alb_dns_name
  vpc_id       = module.vpc_module.vpc_id

  app_domain_name     = var.app_domain_name
  app_sub_domain_name = var.app_sub_domain_name
  region              = var.region
}

#======
# ECR
#======
module "ecr_module" {

  // モジュールのResourceを参照
  source = "../modules/ecr"

  app_name = var.app_name
}

#======
# ECS
#======
module "ecs_module" {

  // モジュールのResourceを参照
  source = "../modules/ecs"

  // 他のモジュールの出力値を渡す
  ecs_task_execution_role_arn = module.roles_module.ecs_task_execution_role_arn
  alb_target_group_arn        = module.alb_module.alb_target_group_blue_arn
  subnet_public_1a_id         = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id         = module.vpc_module.subnet_public_1c_id
  security_group_ecs_id       = module.security_group_module.security_group_ecs_id

  app_name             = var.app_name
  ecs_task_size_cpu    = var.ecs_task_size_cpu
  ecs_task_size_memory = var.ecs_task_size_memory
  port_http            = var.port_http_blue
}

#=============
# CodeDeploy
#=============
module "codedeploy_module" {
  // モジュールのResourceを参照
  source = "../modules/codedeploy"

  // 他のモジュールの出力値を渡す
  alb_listener_blue_arn           = module.alb_module.alb_listener_blue_arn
  alb_target_group_blue_name      = module.alb_module.alb_target_group_blue_name
  alb_target_group_green_name     = module.alb_module.alb_target_group_green_name
  codedeployment_role_for_ecs_arn = module.roles_module.codedeployment_role_for_ecs_arn
  ecs_cluster_name                = module.ecs_module.ecs_cluster_name
  ecs_service_name                = module.ecs_module.ecs_service_name

  app_name = var.app_name
}

#=====
# S3
#=====
module "s3_module" {
  source = "../modules/s3"

  app_name = var.app_name
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

  app_name            = var.app_name
  app_domain_name     = var.app_domain_name
  app_sub_domain_name = var.app_sub_domain_name
}

#=============
# Public Key
#=============
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}