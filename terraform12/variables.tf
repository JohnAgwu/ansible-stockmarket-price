variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
}

variable "amazon_linux_ami" {
  description = "Amazon Linux 2 AMI ID"
  type        = string
}

variable "ubuntu_ami" {
  description = "Ubuntu 20.04 LTS AMI ID"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}