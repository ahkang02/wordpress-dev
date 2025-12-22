# VPC and Networking
import {
  to = module.network.aws_vpc.main
  id = "vpc-0a489413feaf29711"
}

import {
  to = module.network.aws_internet_gateway.main
  id = "igw-0b47d5643e4dd54a4"
}

import {
  to = module.network.aws_subnet.public[0]
  id = "subnet-0f338ba277ca3e58b"
}

import {
  to = module.network.aws_subnet.public[1]
  id = "subnet-02ec891fe4f48659e"
}

import {
  to = module.network.aws_subnet.private[0]
  id = "subnet-0e3bb916520b90671"
}

import {
  to = module.network.aws_subnet.private[1]
  id = "subnet-0c8de53430bc22f9b"
}

# Route Tables - using existing public RT that already has associations
import {
  to = module.network.aws_route_table.public
  id = "rtb-0531c97f8fe463728"
}

# Route Table Associations (public subnets)
import {
  to = module.network.aws_route_table_association.public[0]
  id = "subnet-0f338ba277ca3e58b/rtb-0531c97f8fe463728"
}

import {
  to = module.network.aws_route_table_association.public[1]
  id = "subnet-02ec891fe4f48659e/rtb-0531c97f8fe463728"
}

# NAT Gateway and EIP - REMOVED (deleted, will be recreated)
# The old NAT gateway (nat-198f1bfd2b41a54aa) and EIP (eipalloc-012802b54b1f66d2f) are deleted
# Terraform will create new ones

# ALB
import {
  to = module.alb.aws_lb.main
  id = "arn:aws:elasticloadbalancing:us-east-1:203051159063:loadbalancer/app/wordpress-alb/cb413c9365238c57"
}

import {
  to = module.alb.aws_lb_target_group.main
  id = "arn:aws:elasticloadbalancing:us-east-1:203051159063:targetgroup/wordpress-tg/8c9fcde5cf8d545a"
}

import {
  to = module.alb.aws_lb_listener.http
  id = "arn:aws:elasticloadbalancing:us-east-1:203051159063:listener/app/wordpress-alb/cb413c9365238c57/23493a9c94483c76"
}

# S3
import {
  to = module.s3.aws_s3_bucket.main
  id = "chongzhihong-s3-bucket"
}

# Security Groups
import {
  to = module.security.aws_security_group.alb
  id = "sg-0ff96281c0c59ec97"
}

import {
  to = module.security.aws_security_group.ec2
  id = "sg-027b43cc57b2f5ee5"
}

import {
  to = module.security.aws_security_group.rds
  id = "sg-0f6400da16068b428"
}

# Database
import {
  to = module.database.aws_db_instance.main
  id = "wordpress-rds"
}

import {
  to = module.database.aws_db_subnet_group.main
  id = "wordpress-subnet-group"
}

# Compute
import {
  to = module.compute.aws_autoscaling_group.main
  id = "wordpress-asg"
}

import {
  to = module.compute.aws_launch_template.main
  id = "lt-03707aa2b66e4e31f"
}

import {
  to = module.compute.aws_autoscaling_policy.cpu
  id = "wordpress-asg/Target Tracking Policy"
}
# Private Route Table (use rtb-03858c06d84861695 which is now correctly associated)
import {
  to = module.network.aws_route_table.private
  id = "rtb-03858c06d84861695"
}

# Private Route Table Associations - match current associations
import {
  to = module.network.aws_route_table_association.private[0]
  id = "subnet-0e3bb916520b90671/rtb-03858c06d84861695"
}

import {
  to = module.network.aws_route_table_association.private[1]
  id = "subnet-0c8de53430bc22f9b/rtb-03858c06d84861695"
}

