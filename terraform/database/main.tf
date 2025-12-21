resource "aws_db_subnet_group" "main" {
  name       = "wordpress-subnet-group"
  subnet_ids = var.subnets

  tags = {
    Name = "wordpress-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier        = "wordpress-rds"
  engine            = "mysql"
  engine_version    = "8.0.43"
  instance_class    = var.instance_class
  allocated_storage = 20
  db_name           = var.db_name
  username          = var.db_username
  password          = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_groups
  
  skip_final_snapshot = true
  multi_az            = false
  publicly_accessible = false
}
