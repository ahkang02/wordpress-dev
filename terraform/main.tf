module "network" {
  source = "./network"
  
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "./security"
  
  vpc_id = module.network.vpc_id
}

module "alb" {
  source = "./alb"
  
  vpc_id          = module.network.vpc_id
  subnets         = module.network.public_subnet_ids
  security_groups = [module.security.alb_sg_id]
}

module "compute" {
  source = "./compute"
  
  instance_type     = var.instance_type
  subnets           = module.network.private_subnet_ids
  security_groups   = [module.security.ec2_sg_id]
  target_group_arn  = module.alb.target_group_arn
}

module "database" {
  source = "./database"
  
  subnets         = module.network.private_subnet_ids
  security_groups = [module.security.rds_sg_id]
  instance_class  = var.db_instance_class
  db_name         = var.db_name
  db_username     = var.db_username
  db_password     = var.db_password
}

module "s3" {
  source = "./s3"
}
