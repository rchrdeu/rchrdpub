resource "aws_instance" "wizzcheck-app" {
  ami                         = "ami-0f3164307ee5d695a" # AMI linux ireland
  availability_zone           = "eu-west-1c"
  instance_type               = "t2.micro"
  private_ip                  = "10.5.1.10"
  key_name                    = var.key_name
  iam_instance_profile        = "S3ReadOnly"
  subnet_id                   = aws_subnet.wizzcheck-subnet.id
  vpc_security_group_ids      = [aws_security_group.wizzcheck-sg.id]
  associate_public_ip_address = true
  secondary_private_ips       = []
  user_data                   = file("init-app.sh")
  tags = {
    Name = "wizzcheck-app"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp3"
  }
}

output "wizzcheck-app-public-ip" {
  value = "https://${aws_instance.wizzcheck-app.public_ip}"
}


### elastic IP
resource "aws_eip" "wizzcheck-app-eip" {
  domain   = "vpc"
  instance = aws_instance.wizzcheck-app.id
}

### wizzcheck-db vm
resource "aws_instance" "wizzcheck-db" {
  ami                         = "ami-0f3164307ee5d695a" # AMI linux ireland
  availability_zone           = "eu-west-1c"            
  instance_type               = "t2.micro"
  private_ip                  = "10.5.1.11"
  key_name                    = var.key_name
  iam_instance_profile        = "S3ReadOnly"
  subnet_id                   = aws_subnet.wizzcheck-subnet.id
  vpc_security_group_ids      = [aws_security_group.wizzcheck-sg.id]
  associate_public_ip_address = true
  secondary_private_ips       = []

  user_data = file("init-db.sh")
  tags = {
    Name = "wizzcheck-db"
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 20
    volume_type           = "gp3"
  }
}

output "wizzcheck-db-public-ip" {
  value = "https://${aws_instance.wizzcheck-db.public_ip}"
}
