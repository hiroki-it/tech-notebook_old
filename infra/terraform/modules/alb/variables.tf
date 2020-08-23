#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// VPC
variable "vpc_id" {}

// Subnet
variable "subnet_public_1a_id" {}
variable "subnet_public_1c_id" {}

// Security Group
variable "sg_alb_id" {}

// Port
variable "port_http" {}
variable "port_https" {}
variable "port_custom_tcp_https" {}

// certificate
variable "acm_certificate_arn" {}
variable "ssl_policy" {}
