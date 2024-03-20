#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker pull wordpress
sudo docker run --name wizzcheckwp -d wordpress -e WORDPRESS_DB_HOST=wizzcheckdb -e WORDPRESS_DB_USER=wizzcheck