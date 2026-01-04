############################
# Global
############################
variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-west-1"
}

############################
# EC2
############################
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Existing EC2 Key Pair name for SSH access"
  type        = string
}

############################
# Application
############################
variable "image" {
  description = "Docker image for NodeJS application (used by Ansible)"
  type        = string
}
