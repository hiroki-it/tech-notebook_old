#=====
# S3
#=====
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.app_name}-bucket"
  acl    = "private"
  
  // バージョニング管理
  versioning {
    enabled = true
  }
}