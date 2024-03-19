terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.41.0"
    }
  }
}

provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
    token = var.token
}


resource "aws_vpc" "TF-VPC" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "TF-VPC"
  }
}

resource "aws_subnet" "AZ-A" {
    vpc_id = aws_vpc.TF-VPC.id
    cidr_block = "10.10.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "AZ-A"
    }
}

resource "aws_subnet" "AZ-B" {
    vpc_id = aws_vpc.TF-VPC.id
    cidr_block = "10.10.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "AZ-B"
    }
}

resource "aws_subnet" "AZ-C" {
    vpc_id = aws_vpc.TF-VPC.id
    cidr_block = "10.10.3.0/24"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
    tags = {
        Name = "AZ-C"
    }
}

resource "aws_subnet" "AZ-Admin" {
    vpc_id = aws_vpc.TF-VPC.id
    cidr_block = "10.10.0.0/24"
    availability_zone = "us-east-1d"
    map_public_ip_on_launch = true
    tags = {
        Name = "AZ-Admin"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.TF-VPC.id

  tags = {
    Name = "TF-GW"
  }
}

resource "aws_route_table" "TF-Route" {
  vpc_id = aws_vpc.TF-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  
  route {
    cidr_block = "10.10.0.0/16"
    gateway_id = "local"
  }

}