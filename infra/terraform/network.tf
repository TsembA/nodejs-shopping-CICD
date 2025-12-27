############################
# DATA SOURCES
############################

data "aws_availability_zones" "available" {
  state = "available"
}

############################
# LOCALS
############################

locals {
  # Explicitly choose us-west-1b, but only if it exists in this account
  az_us_west_1b = one([
    for az in data.aws_availability_zones.available.names : az
    if az == "us-west-1b"
  ])
}

############################
# VPC
############################

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = "nodejs-shopping-vpc"
    Project = "nodejs-shopping"
    Managed = "terraform"
  }
}

############################
# PUBLIC SUBNET
############################

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = local.az_us_west_1b

  tags = {
    Name    = "nodejs-shopping-public-subnet"
    Project = "nodejs-shopping"
    Managed = "terraform"
  }
}

############################
# INTERNET GATEWAY
############################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "nodejs-shopping-igw"
    Project = "nodejs-shopping"
    Managed = "terraform"
  }
}

############################
# ROUTING
############################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "nodejs-shopping-public-rt"
    Project = "nodejs-shopping"
    Managed = "terraform"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
