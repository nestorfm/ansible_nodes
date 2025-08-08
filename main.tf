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

# Get your current IP for SSH access
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default subnet
data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "${var.aws_region}a"
  default_for_az    = true
}

# Security Group with explicit VPC
resource "aws_security_group" "rundeck_nodes" {
  name        = "rundeck-nodes-sg"
  description = "Security group for Rundeck managed nodes"
  vpc_id      = data.aws_vpc.default.id
  
  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "rundeck-nodes-sg"
  }
}

# Key Pair
resource "aws_key_pair" "rundeck_key" {
  key_name   = "rundeck-nodes-key"
  public_key = file(var.public_key_path)
}

# EC2 Instances with explicit subnet
resource "aws_instance" "rundeck_nodes" {
  count                       = var.node_count
  ami                        = var.ami_id
  instance_type              = var.instance_type
  key_name                   = aws_key_pair.rundeck_key.key_name
  vpc_security_group_ids     = [aws_security_group.rundeck_nodes.id]
  subnet_id                  = data.aws_subnet.default.id
  associate_public_ip_address = true
  
  # Wait for instance to be ready
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    # Ensure SSH service is running
    systemctl enable sshd
    systemctl start sshd
  EOF
  
  tags = {
    Name        = "rundeck-node-${count.index + 1}"
    Environment = "rundeck-test"
    NodeGroup   = "rundeck-managed"
  }
}