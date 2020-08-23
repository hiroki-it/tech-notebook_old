#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// Subnet
variable "subnet_public_1a_id" {}
variable "subnet_public_1c_id" {}

// Security Group
variable "sg_ecs_id" {}

// ALB
variable "alb_target_group_blue_arn" {}

// ECS
variable "ecs_task_execution_role_arn" {}

// Port
variable "port_http" {}
