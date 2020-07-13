#====================
# Output From Module
#====================
// VPC
output "vpc_id" {
  value = aws_vpc.vpc.id
}

// Subnet
output "subnet_public_1a_id" {
  value = aws_subnet.subnet_public_1a.id
}
output "subnet_public_1c_id" {
  value = aws_subnet.subnet_public_1c.id
}