#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// Subnet
variable "subnet_public_1a_id" {}
variable "subnet_public_1c_id" {}

// Security Group
variable "security_group_ecs_id" {}

// ALB
variable "alb_target_group_green_arn" {}

// ECS
variable "ecs_task_size_cpu" {}
variable "ecs_task_size_memory" {}
variable "ecs_task_execution_role_arn" {}

// Port
variable "port_http" {}
