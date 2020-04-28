#=================
# Input To Module
#=================
// EC2 Instance
variable "instance_number" {}
variable "instance_type" {}
variable "instance_app_name" {}

// Key Pair
variable "key_name" {}
variable "public_key" {}

#==============
# EC2 Instance
#==============
resource "aws_instance" "www-1a" {
  count = var.instance_number
  ami = ""
  instance_type = var.instance_type
  tags = {
    Name = "${var.instance_app_name}-www-1a"
    Subnet-status = "public"
  }
}

#==============
# Key Pair
#==============
resource "aws_key_pair" "aws-key-pair" {
  key_name = var.key_name
  public_key = var.public_key
}