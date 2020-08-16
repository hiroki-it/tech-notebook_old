#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// VPC
variable "vpc_id" {}

// Security Group
variable "security_group_alb_inbound_cidr_block_http" {}
variable "security_group_alb_inbound_cidr_block_https" {}
variable "security_group_ecs_inbound_cidr_block_http" {}
variable "security_group_ecs_inbound_cidr_block_ssh" {}
variable "security_group_outbound_cidr_block" {}

// Port
variable "port_http" {}
variable "port_https_main" {}
variable "port_custom_tcp_https" {}
variable "port_ssh" {}