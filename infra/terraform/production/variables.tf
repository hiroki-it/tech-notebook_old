#=============
# Input Value
#=============
// AWS認証情報
variable "credential" {
  type = map(string)
}

// App Name
variable "app_name" {
  type = map(string)
}

// Domain
variable "domain" {
  type = map(string)
}

// Key Pair
variable "public_key" {
  type = map(string)
}

// VPC
variable "vpc_cidr_block" {
}

// Internet Gateway
variable "igw_cidr_block" {
}

// Network ACL
variable "nacl" {
  type = map(string)
}

// Subnet
variable "subnet" {
  type = map(string)
}

// Security Group
variable "sg" {
  type = map(string)
}

// Port
variable "port" {
  type = map(number)
}

// certificate
variable "ssl_policy" {
}
