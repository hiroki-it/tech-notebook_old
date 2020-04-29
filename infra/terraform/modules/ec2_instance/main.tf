#=============
# Input Value
#=============
// EC2 Instance
variable "instance_number" {}
variable "instance_app_name" {}

// Key Pair
variable "key_name" {}
variable "public_key_path" {}

#==============
# EC2 Instance
#==============
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

resource "aws_instance" "www-1a" {
  ami = data.aws_ami.amazon_linux_2.image_id
  instance_type = "t2.micro"
  tags = {
    Name = "${var.instance_app_name}-www-1a"
    Subnet-status = "public"
  }
}

resource "aws_instance" "www-1c" {
  ami = data.aws_ami.amazon_linux_2.image_id
  instance_type = "t2.micro"
  tags = {
    Name = "${var.instance_app_name}-www-1c"
    Subnet-status = "public"
  }
}

#==============
# Key Pair
#==============
resource "aws_key_pair" "aws-key-pair" {
  key_name = var.key_name
  public_key = file(var.public_key_path)
}