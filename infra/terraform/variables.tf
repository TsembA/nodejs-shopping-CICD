############################
# Global
############################
variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-west-1"
}
############################
# SSH
############################
variable "ssh_key_name" {
  description = "AWS EC2 key pair name"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to local SSH public key"
  type        = string
}
############################
# EC2
############################
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
############################
# Application
############################
variable "image" {
  description = "Docker image for NodeJS application (used by Ansible)"
  type        = string
}
