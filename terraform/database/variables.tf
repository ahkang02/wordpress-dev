variable "subnets" { type = list(string) }
variable "security_groups" { type = list(string) }
variable "instance_class" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
