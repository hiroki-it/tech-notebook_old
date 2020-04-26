variable "instance_type" {}
variable "instance_app_name" {}

#=============
# EC2
#=============
resource "aws_instance" "www-1a" {
  ami = ""
  instance_type = var.instance_type
  tags = {
    Name = "${var.instance_app_name}-www-1a"
    Subnet-status = "public"
  }
}