variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "instance_name" {
  description = "Lightsail instance name"
  type        = string
  default     = "nodejs-shopping"
}

variable "blueprint_id" {
  description = "OS image"
  type        = string
  default     = "ubuntu_22_04"
}

variable "bundle_id" {
  description = "Lightsail plan"
  type        = string
  default     = "nano_2_0"
}
variable "docker_image" {
  description = "Docker image to deploy"
  type        = string
}