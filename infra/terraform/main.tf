variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "instance_app_name" {}
variable "instance_type" {}
variable "sg_outbound_cidr_block" {}
variable "r53_alb_dns_name" {}
variable "r53_alb_zone_id" {}
variable "r53_domain_name" {}
variable "r53_record_set_name" {}
variable "r53_record_type" {}
variable "region" {}
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}
variable "vpc_cidr_block" {}

# providerセクション：プロバイダの認証情報
# resourceセクション：Terraform内で管理するデータを以下の形式で記述．
#                  （"リソースタイプ" "リソース名"）

#============
# AWS認証情報
#============
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

#================
# Security Gruop
#================
module "module_security_group" {
  source = "modules/security_group"
  instance_app_name = var.instance_app_name
  sg_inbound_cidr_block = var.sg_outbound_cidr_block
  sg_outbound_cidr_block = var.sg_outbound_cidr_block
}

#=============
# Route53
#=============
module "module_route53" {
  source = "modules/route53"
  r53_alb_dns_name = var.r53_alb_dns_name
  r53_alb_zone_id = var.r53_alb_zone_id
  r53_domain_name = var.r53_domain_name
  r53_record_set_name = var.r53_record_set_name
  r53_record_type = var.r53_record_type
}

#=============
# VPC
#=============
module "module_vpc" {
  source = "modules/vpc"
  instance_app_name = var.instance_app_name
  region = var.region
  subnet_public_1a_cidr_block = var.subnet_public_1a_cidr_block
  subnet_public_1c_cidr_block = var.subnet_public_1c_cidr_block
  vpc_cidr_block = var.vpc_cidr_block
}

#=============
# EC2
#=============
module "module_ec2" {
  source = "modules/ec2"
  instance_app_name = var.instance_app_name
  instance_type = var.instance_type
}