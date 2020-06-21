#=============
# Input Value
#=============
// App Name
variable "app_name" {}

#======
# ECR
#======
resource "aws_ecr_repository" "ecr_repository_builder" {
  name                 = "${var.app_name}-builder-respository"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "ecr_repository_www" {
  name                 = "${var.app_name}-www-respository"
  image_tag_mutability = "MUTABLE"
}