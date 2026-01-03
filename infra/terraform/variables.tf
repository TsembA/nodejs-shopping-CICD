############################
# Global
############################
variable "aws_region" {
  description = "AWS region to deploy resources into"
  type        = string
  default     = "us-west-1"
}

############################
# Application
############################
variable "image" {
  description = "Docker image for NodeJS application (GHCR)"
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
