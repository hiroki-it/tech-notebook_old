#=============
# Input Value
#=============
// AWS認証情報
variable "credential" {}

// App Name
variable "app_name" {}

// Domain
variable "domain" {}

// VPC
variable "vpc_cidr_block" {}

// Internet Gateway
variable "igw_cidr_block" {}

// Network ACL
variable "nacl" {}

// Subnet
variable "subnet" {}

// Security Group
variable "security_group" {}

// ECS
variable "ecs" {}

// Port
variable "port" {}

// Key Pair
variable "public_key" {}

// certificate
variable "ssl_policy" {}
