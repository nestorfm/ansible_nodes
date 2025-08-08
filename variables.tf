variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "node_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 10
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
}

variable "ssh_user" {
  description = "SSH user for the AMI"
  type        = string
  default     = "ubuntu" # ubuntu for Ubuntu AMI, ec2-user for Amazon Linux
}

variable "public_key_path" {
  description = "Path to your public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to your private SSH key"
  type        = string
  default     = "~/.ssh/id_rsa"
}