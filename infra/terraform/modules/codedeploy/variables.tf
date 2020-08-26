#=============
# Input Value
#=============
// App Name
variable "app_name" {}

// ALB
variable "alb_target_group_blue_name" {}
variable "alb_target_group_green_name" {}
variable "alb_listener_blue_arn" {}
variable "alb_listener_green_arn" {}

// ECS
variable "ecs_cluster_name" {}
variable "ecs_service_name" {}

// CodeDeploy
variable "codedeployment_role_for_ecs_arn" {}

// SNS
variable "sns_topic_codedeploy_arn" {}
