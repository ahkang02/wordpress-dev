resource "aws_launch_template" "main" {
  name          = "wordpress-lt"
  image_id      = "ami-04b70fa74e45c3917" # Ubuntu 24.04 LTS (Canonical), check region! Assuming us-east-1 for now based on JSON output.
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false # Private instance behind ALB
    security_groups             = var.security_groups
  }

  iam_instance_profile {
    name = "LabInstanceProfile"
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2 php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip unzip awscli
              systemctl start apache2
              systemctl enable apache2
              
              # Download application code from S3
              aws s3 cp s3://chongzhihong-s3-bucket/wordpress.zip /tmp/wordpress.zip
              unzip -o /tmp/wordpress.zip -d /var/www/html/
              
              # Set permissions
              chown -R www-data:www-data /var/www/html/
              chmod -R 755 /var/www/html/
              
              # Ensure index.php triggers standard WP behavior if not present yet (optional safety)
              if [ ! -f /var/www/html/index.php ]; then
                echo "<?php phpinfo(); ?>" > /var/www/html/index.php
              fi
              EOF
  )

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
  name                   = "wordpress-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.main.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
