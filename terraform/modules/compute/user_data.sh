#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
docker run -d -p 80:3000 your-dockerhub/sample-app:latest
