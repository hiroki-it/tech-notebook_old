#=============
# Input Value
#=============
// AWS認証情報
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

// App Name
variable "app_name" {}

// VPC
variable "vpc_cidr_block" {}

// Subnet
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}

// Security Group
variable "sg_inbound_cidr_block" {}
variable "sg_outbound_cidr_block" {}

// Internet Gateway
variable "igw_cidr_block" {}

// Route53
variable "r53_domain_name" {}
variable "r53_record_set_name" {}
variable "r53_record_type" {}

// ECS
variable "ecs_task_size_cpu" {}
variable "ecs_task_size_memory" {}

// Key Pair
variable "key_name" {}
variable "public_key_path" {}

#============
# AWS認証情報
#============
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

#========
# Roles
#========
module "roles_module" {
  // モジュールのResourceを参照.
  source = "../modules/roles"
}

#======
# VPC
#======
module "vpc_module" {

  // モジュールのResourceを参照.
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

  // モジュールのResourceを参照.
  source = "../modules/security_group"

  // 他のモジュールの出力値を渡す.
  vpc_id = module.vpc_module.vpc_id

  sg_inbound_cidr_block  = var.sg_inbound_cidr_block
  sg_outbound_cidr_block = var.sg_outbound_cidr_block
  app_name               = var.app_name
}

#======
# ALB
#======
module "alb_module" {

  // モジュールのResourceを参照.
  source = "../modules/alb"

  // 他のモジュールの出力値を渡す.
  vpc_id                = module.vpc_module.vpc_id
  subnet_public_1a_id   = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id   = module.vpc_module.subnet_public_1c_id
  security_group_alb_id = module.security_group_module.security_group_alb_id

  app_name = var.app_name
}

#==========
# Route53
#==========
module "route53_module" {

  // モジュールのResourceを参照.
  source = "../modules/route53"

  // 他のモジュールの出力値を渡す.
  r53_alb_dns_name = module.alb_module.alb_dns_name
  r53_alb_zone_id  = module.alb_module.alb_zone_id

  r53_domain_name     = var.r53_domain_name
  r53_record_set_name = var.r53_record_set_name
  r53_record_type     = var.r53_record_type
}

#======
# ECR
#======
module "ecr_module" {

  // モジュールのResourceを参照.
  source = "../modules/ecr"

  app_name = var.app_name
}

#======
# ECS
#======
module "ecs_module" {

  // モジュールのResourceを参照.
  source = "../modules/ecs"

  // 他のモジュールの出力値を渡す.
  ecs_task_execution_role_arn = module.roles_module.ecs_task_execution_role_arn
  alb_target_group_arn        = module.alb_module.alb_target_group_arn
  subnet_public_1a_id         = module.vpc_module.subnet_public_1a_id
  subnet_public_1c_id         = module.vpc_module.subnet_public_1c_id
  security_group_ecs_id       = module.security_group_module.security_group_ecs_id

  app_name             = var.app_name
  ecs_task_size_cpu    = var.ecs_task_size_cpu
  ecs_task_size_memory = var.ecs_task_size_memory
}

#==================
# CloudWatch Logs
#==================
module "cloudwatch_logs" {
  source = "../modules/cloud_watch_logs"
}

#=============
# Public Key
#=============
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}