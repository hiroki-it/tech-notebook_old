#=============
# Input Value
#=============
// App Info
variable "app_name" {}

#======
# ECR
#======
resource "aws_ecr_repository" "ecr_repository_www" {
  name                 = "${var.app_name}-www"
  image_tag_mutability = "IMMUTABLE"
}