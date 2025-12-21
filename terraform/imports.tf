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

import {
  to = module.network.aws_nat_gateway.main
  id = "nat-198f1bfd2b41a54aa"
}

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

import {
  to = module.s3.aws_s3_bucket.main
  id = "chongzhihong-s3-bucket"
}

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

import {
  to = module.database.aws_db_instance.main
  id = "wordpress-rds"
}

import {
  to = module.compute.aws_autoscaling_group.main
  id = "wordpress-asg"
}
