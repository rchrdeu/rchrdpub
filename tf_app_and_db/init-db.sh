#!/bin/bash

sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker pull mysql
sudo docker run -e MYSQL_ROOT_PASSWORD=1234 -e MYSQL_DATABASE=wizzcheck -e MYSQL_USER=wizzcheck -e MYSQL_PASSWORD=1234 -d --name wizzcheckdb mysql
