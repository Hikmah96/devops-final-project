# ============================================================
# DEVOPS FINAL PROJECT - TERRAFORM INFRASTRUCTURE
# ============================================================

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# ============================================================
# AWS PROVIDER
# ============================================================

provider "aws" {
  region = "us-east-1"
}

# ============================================================
# VPC
# ============================================================

resource "aws_vpc" "devops_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name    = "DevOps-Final-VPC"
    Project = "DevOps-Final-Project"
  }
}

# ============================================================
# INTERNET GATEWAY
# ============================================================

resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.devops_vpc.id

  tags = {
    Name    = "DevOps-Final-Internet-Gateway"
    Project = "DevOps-Final-Project"
  }
}

# ============================================================
# PUBLIC SUBNET
# ============================================================

resource "aws_subnet" "devops_public_subnet" {
  vpc_id                  = aws_vpc.devops_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "DevOps-Final-Public-Subnet"
    Project = "DevOps-Final-Project"
  }
}

# ============================================================
# ROUTE TABLE
# ============================================================

resource "aws_route_table" "devops_route_table" {
  vpc_id = aws_vpc.devops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops_igw.id
  }

  tags = {
    Name    = "DevOps-Final-Public-Route-Table"
    Project = "DevOps-Final-Project"
  }
}

# ============================================================
# ROUTE TABLE ASSOCIATION
# ============================================================

resource "aws_route_table_association" "devops_route_association" {
  subnet_id      = aws_subnet.devops_public_subnet.id
  route_table_id = aws_route_table.devops_route_table.id
}

# ============================================================
# SECURITY GROUP
# ============================================================

resource "aws_security_group" "devops_security_group" {
  name        = "devops-final-security-group"
  description = "Security group for DevOps final project"
  vpc_id      = aws_vpc.devops_vpc.id

  ingress {
    description = "SSH for Ansible"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Portfolio application"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Java application"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "DevOps-Final-Security-Group"
    Project = "DevOps-Final-Project"
  }
}

# ============================================================
# EC2 KEY PAIR
# ============================================================

variable "instance_keypair" {
  description = "Existing AWS EC2 key pair used for SSH access"
  type        = string
  default     = "devops-final-key"
  sensitive   = true
}

# ============================================================
# EC2 SERVER
# ============================================================

resource "aws_instance" "devops_server" {
  ami           = "ami-06067086cf86c58e6"
  instance_type = "t3.micro"

  subnet_id = aws_subnet.devops_public_subnet.id

  key_name = var.instance_keypair

  vpc_security_group_ids = [
    aws_security_group.devops_security_group.id
  ]

  associate_public_ip_address = true

  tags = {
    Name    = "DevOps-Final-Server"
    Project = "DevOps-Final-Project"
  }
}

# ============================================================
# OUTPUTS
# ============================================================

output "vpc_id" {
  description = "ID of the DevOps final project VPC"
  value       = aws_vpc.devops_vpc.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.devops_public_subnet.id
}

output "server_public_ip" {
  description = "Public IP address of the DevOps server"
  value       = aws_instance.devops_server.public_ip
}

output "server_public_dns" {
  description = "Public DNS name of the DevOps server"
  value       = aws_instance.devops_server.public_dns
}
