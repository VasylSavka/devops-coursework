#!/bin/bash

yum update -y
yum install -y docker

systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

sleep 15

docker run -d --restart always -p 3000:3000 vindigora/devops-node-app:latest
