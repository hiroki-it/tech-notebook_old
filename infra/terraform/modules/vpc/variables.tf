#=============
# Input Value
#=============
// AWS認証情報
variable "credential_region" {}

// App Name
variable "app_name" {}

// VPC
variable "vpc_cidr_block" {}

// Internet Gateway
variable "igw_cidr_block" {}

// Network ACL
variable "nacl_inbound_cidr_block" {}
variable "nacl_outbound_cidr_block" {}

// Subnet
variable "subnet_public_1a_cidr_block" {}
variable "subnet_public_1c_cidr_block" {}
