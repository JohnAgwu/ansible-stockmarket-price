terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "stock_market_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "stock-market-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.stock_market_vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "stock-market-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.stock_market_vpc.id

  tags = {
    Name = "stock-market-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.stock_market_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "stock-market-public-rt"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Security group for NGINX servers"
  vpc_id      = aws_vpc.stock_market_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "java_sg" {
  name        = "java-sg"
  description = "Security group for Java application servers"
  vpc_id      = aws_vpc.stock_market_vpc.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.nginx_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible-sg"
  description = "Security group for Ansible control node"
  vpc_id      = aws_vpc.stock_market_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "nginx_amazon" {
  ami           = var.amazon_linux_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  tags = {
    Name = "nginx-amazon"
    Role = "nginx"
  }
}

resource "aws_instance" "nginx_ubuntu" {
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  tags = {
    Name = "nginx-ubuntu"
    Role = "nginx"
  }
}

resource "aws_instance" "java_amazon" {
  ami           = var.amazon_linux_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.java_sg.id]

  tags = {
    Name = "java-amazon"
    Role = "java"
  }
}

resource "aws_instance" "java_ubuntu" {
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.java_sg.id]

  tags = {
    Name = "java-ubuntu"
    Role = "java"
  }
}

resource "aws_instance" "ansible_control" {
  ami           = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  tags = {
    Name = "ansible-control"
    Role = "ansible"
  }
}