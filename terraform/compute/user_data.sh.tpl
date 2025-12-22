#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
set -ex

echo "=== Starting user data script at $(date) ==="

# Wait for instance to be fully ready
sleep 10

# Install packages (Amazon Linux 2023 uses dnf)
echo "Installing packages..."
dnf update -y
dnf install -y httpd php php-mysqlnd php-fpm php-cli php-gd php-json php-zip php-mbstring php-xml php-curl unzip mariadb105

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

# Create wp-config.php
echo "Creating wp-config.php..."
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# Inject database credentials using sed
sed -i "s/database_name_here/${db_name}/" /var/www/html/wp-config.php
sed -i "s/username_here/${db_user}/" /var/www/html/wp-config.php
sed -i "s/password_here/${db_password}/" /var/www/html/wp-config.php
sed -i "s/localhost/${db_host}/" /var/www/html/wp-config.php

# Set permissions
echo "Setting permissions..."
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

# --- Apache Configuration ---
echo "Configuring Apache..."

# 1. Enable mod_rewrite (usually enabled, but ensuring it)
if [ -f /etc/httpd/conf.modules.d/00-base.conf ]; then
  sed -i 's/^#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/httpd/conf.modules.d/00-base.conf
fi

# 2. Configure AllowOverride All and DirectoryIndex
echo "Updating httpd.conf..."

# Helper to insert DirectoryIndex if missing (simplistic approach, or just rely on default having it)
# Better: Create a config file for WordPress
cat <<CONF > /etc/httpd/conf.d/wordpress.conf
<Directory "/var/www/html">
    AllowOverride All
    Require all granted
</Directory>

<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>
CONF

# Also update main config if user strictly requested editing httpd.conf directly (optional if conf.d works)
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf

# Restart Apache to apply changes
systemctl restart httpd

echo "=== User data script completed at $(date) ==="
