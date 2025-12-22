variable "instance_type" { type = string }
variable "security_groups" { type = list(string) }
variable "subnets" { type = list(string) }
variable "target_group_arn" { type = string }
variable "db_host" { type = string }
variable "db_name" { type = string }
variable "db_user" { type = string }
variable "db_password" { type = string }
