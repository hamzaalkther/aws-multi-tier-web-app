#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "This is an app server in AWS Region US-EAST-1" > /var/www/html/index.html
