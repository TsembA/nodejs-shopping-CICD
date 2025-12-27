variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "instance_name" {
  type    = string
  default = "nodejs-shopping"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "docker_image" {
  type = string
}

variable "ghcr_user" {
  type      = string
  sensitive = true
}

variable "ghcr_token" {
  type      = string
  sensitive = true
}
