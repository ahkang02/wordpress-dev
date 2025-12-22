resource "aws_launch_template" "main" {
  name                   = "wordpress-lt"
  image_id               = "ami-0c101f26f147fa7fd" # Amazon Linux 2023 AMI (us-east-1)
  instance_type          = var.instance_type
  update_default_version = true # Creates new version on changes

  network_interfaces {
    associate_public_ip_address = false # Private instance behind ALB
    security_groups             = var.security_groups
  }

  iam_instance_profile {
    name = "LabInstanceProfile"
  }

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", {
    db_host     = var.db_host
    db_name     = var.db_name
    db_user     = var.db_user
    db_password = var.db_password
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "wordpress-instance"
    }
  }
}

resource "aws_autoscaling_group" "main" {
  name                = "wordpress-asg"
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.subnets
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}

resource "aws_autoscaling_policy" "cpu" {
  name                   = "Target Tracking Policy"
  autoscaling_group_name = aws_autoscaling_group.main.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
