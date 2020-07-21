#=============
# Input Value
#=============
// App Info
variable "app_name" {}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.app_name}-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
}