variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "wordpress"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnet_cidrs" {
  description = "Private Subnet CIDRs"
  type        = list(string)
  default     = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS Instance Class"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_name" {
  description = "Database Name"
  type        = string
  default     = "wordpress"
}

variable "db_username" {
  description = "Database Master Username"
  type        = string
  default     = "admin"
}

# In a real scenario, this should be passed as a sensitive var or fetched from Secrets Manager during apply if creating fresh.
# valid password for testing if needed, but we rely on existing secret or new random one.
variable "db_password" {
  description = "Database Master Password"
  type        = string
  sensitive   = true
  default     = "ChangeMe123!"
}
