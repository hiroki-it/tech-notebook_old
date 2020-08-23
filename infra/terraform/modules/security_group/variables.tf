#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// VPC
variable "vpc_id" {}

// Security Group
variable "sg_alb_inbound_cidr_block_http" {}
variable "sg_alb_inbound_ipv6_cidr_block_http" {}
variable "sg_alb_inbound_cidr_block_https" {}
variable "sg_alb_inbound_ipv6_cidr_block_https" {}
variable "sg_ecs_inbound_cidr_block_ssh" {}
variable "sg_ecs_inbound_cidr_block_http" {}
variable "sg_outbound_cidr_block" {}

// Port
variable "port_http" {}
variable "port_https_main" {}
variable "port_custom_tcp_https" {}
variable "port_ssh" {}