terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

variable "key_name" {
  description = "The name of the EC2 Key Pair to allow SSH access to the instances"
  default     = "rchrdlink"
}

### VPC 
resource "aws_vpc" "wizzcheck-vpc" {
  cidr_block = "10.5.0.0/20"
  tags = {
    Name = "wizzcheck"
  }
}

output "vpc_id" {
  value = aws_vpc.wizzcheck-vpc.id
}

### Subnet
resource "aws_subnet" "wizzcheck-subnet" {
  vpc_id                  = aws_vpc.wizzcheck-vpc.id
  cidr_block              = "10.5.1.0/24"
  availability_zone       = "eu-west-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "wizzcheck"
  }
}

output "subnet_id" {
  value = aws_subnet.wizzcheck-subnet.id
}

### Internet Gateway
resource "aws_internet_gateway" "wizzcheck-ig" {
  vpc_id = aws_vpc.wizzcheck-vpc.id
}

### Route Table
resource "aws_route_table" "wizzcheck-rt" {
  vpc_id = aws_vpc.wizzcheck-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wizzcheck-ig.id
  }
}

### Route table association
resource "aws_route_table_association" "wizzcheck-rta" {
  subnet_id      = aws_subnet.wizzcheck-subnet.id
  route_table_id = aws_route_table.wizzcheck-rt.id
}