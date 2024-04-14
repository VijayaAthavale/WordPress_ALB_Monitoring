#! /bin/bash

# ---------------------------------------------------------
# WordPress Setup Script
# ---------------------------------------------------------
# Purpose:
# This script automates the setup of a WordPress environment on a Linux server.
# It is designed to be run on a fresh instance to install and configure the necessary
# components for a WordPress site, including the Apache web server, MariaDB database,
# PHP, and WordPress itself.
#
# Usage:
# This script is intended for system administrators or developers setting up WordPress
# on a cloud instance or dedicated server. It simplifies the initial setup process, ensuring
# a standard, secure, and optimized environment for running WordPress.
#
# Components Installed:
# - Apache web server for serving WordPress pages
# - MariaDB, a community-developed fork of MySQL, for database storage
# - PHP and PHP MySQL extension to execute WordPress PHP scripts and interact with the database
# - WordPress, the latest version, as the content management system
#
# Additional Configurations:
# - Sets the MariaDB root password for security
# - Configures the WordPress wp-config.php with the provided database details
# - Adjusts file and directory permissions for security and accessibility
#
# Prerequisites:
# - A Linux server with yum package manager (CentOS, Amazon Linux, etc.)
# - Network access to yum repositories to install packages
# - Sudo privileges for the executing user to install software and change configurations
#
# Note:
# Before running, ensure you replace the placeholder values for DBName, DBUser,
# DBPassword, and DBRootPassword with your actual database configuration.
# ---------------------------------------------------------


# Update all packages on the system to their latest versions
sudo yum update -y

# Install Apache web server
sudo yum install -y httpd

# Install MariaDB (version 10.5), PHP, and PHP's MySQL extension, along with unzip utility
sudo yum install -y php php-mysqlnd unzip

### INSTALLING MYSQL CLIENT ###"
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
#sudo yum install -y mysql-community-client
sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
sudo dnf install mysql-community-server -y

sudo rm -rf /var/lib/rpm/.rpm.lock

### INSTALLING MYSQL SERVER ###"
#sudo yum install -y mysql-community-server
sudo yum install -y mysql

### START AND ENABLE MYSQLD SERVICE ###"
#sudo service mysqld start
#sudo systemctl enable mysqld
sudo systemctl start mysqld
sudo systemctl restart mysqld



# TMP_PASSWORD=$(sudo cat /var/log/mysqld.log  | grep 'temporary password' | awk '{print $11}')

# mysql --connect-expired-password  -u root -h 127.0.0.1 -p$TMP_PASSWORD <<< "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_SERVER_PASSWORD'"

# sudo service mysqld restart

# Set variables for the database configuration
DBName=${rds_dbname}
DBUser=${rds_user}
DBPassword=${rds_password}
RDS_Endpoint=${rds_endpoint}



# Start the Apache server and enable it to start automatically on system boot
sudo systemctl start httpd
sudo systemctl enable httpd

# Start the MariaDB service and enable it to start automatically on system boot
#sudo systemctl start mariadb
#sudo systemctl enable mariadb

# Secure the mysql server by setting the root password
#mysqladmin -u root password $DBRootPassword


# Download the latest version of WordPress and place it in the web root directory
wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
tar -zxvf latest.tar.gz # Extract the WordPress archive
cp -rvf wordpress/* . # Copy WordPress files to the current directory
rm -R wordpress # Remove the now empty WordPress directory
rm latest.tar.gz # Clean up by deleting the downloaded archive

# Rename the sample WordPress configuration file and update it with the database details
cp ./wp-config-sample.php ./wp-config.php
sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php
sed -i "s/'username_here'/'$DBUser'/g" wp-config.php
sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sed -i "s/'localhost'/'$RDS_Endpoint'/g" wp-config.php

# Change the ownership and permissions to secure the WordPress files and directories
usermod -a -G apache ec2-user # Add the ec2-user to the apache group
chown -R ec2-user:apache /var/www # Change owner to ec2-user and group to apache
chmod 2775 /var/www # Set the directory permissions
find /var/www -type d -exec chmod 2775 {} \; # Find directories and set permissions
find /var/www -type f -exec chmod 0664 {} \; # Find files and set permissions
