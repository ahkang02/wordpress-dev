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

  user_data = base64encode(<<-EOF
#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -ex

echo "=== Starting user data script at $(date) ==="

# Wait for instance to be fully ready
sleep 10

# Install packages (Amazon Linux 2023 uses dnf)
echo "Installing packages..."
dnf update -y
dnf install -y httpd php php-mysqlnd php-gd php-mbstring php-xml php-curl php-zip unzip

# Start and enable Apache (httpd on Amazon Linux)
echo "Starting Apache..."
systemctl start httpd
systemctl enable httpd

# Download application code from S3 with retry
echo "Downloading WordPress from S3..."
for i in {1..5}; do
  aws s3 cp s3://chongzhihong-s3-bucket/wordpress.zip /tmp/wordpress.zip && break
  echo "S3 download attempt $i failed, retrying in 10s..."
  sleep 10
done

# Check if download succeeded
if [ ! -f /tmp/wordpress.zip ]; then
  echo "ERROR: Failed to download wordpress.zip from S3"
  exit 1
fi

# Extract code
echo "Extracting WordPress..."
unzip -o /tmp/wordpress.zip -d /var/www/html/

# Set permissions
echo "Setting permissions..."
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

# Enable .htaccess (mod_rewrite for WordPress permalinks)
echo "Configuring Apache for WordPress..."
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf

# Restart Apache to apply changes
systemctl restart httpd

echo "=== User data script completed at $(date) ==="
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
