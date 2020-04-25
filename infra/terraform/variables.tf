# NOTE: 使用したい変数を定義.

#============
# AWSアカウント
#============
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}

#=============
# EC2
#=============
variable "instance_type" {}

#================
# Securirty Group
#================

#=============
# Route 53
#=============

#=============
# VPC
#=============




#=============
# Subnet
#=============
variable "cidr_block" {}
variable "public_1a_cidr_block" {}
variable "public_1c_cidr_block" {}
variable "public-subnet-1a-id" {}
variable "public-subnet-1c-id" {}

#=============
# Route Table
#=============

#==============================
# Subnet と Route Table の紐付け
#==============================
