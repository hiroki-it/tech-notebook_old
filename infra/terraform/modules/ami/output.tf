#====================
# Output From Module
#====================
output "ami_amazon_linux_2_id" {
  value = data.aws_ami.amazon_linux_2.id
}