#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
docker pull 123456789012.dkr.ecr.us-east-1.amazonaws.com/saas-app:latest
docker run -d -p 80:3000 123456789012.dkr.ecr.us-east-1.amazonaws.com/saas-app:latest
