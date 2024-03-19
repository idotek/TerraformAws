terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.41.0"
    }
   tls = {
      source = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
}


resource "aws_vpc" "TF-VPC" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "TF-VPC"
  }
}

resource "aws_subnet" "AZ-A" {
  vpc_id                  = aws_vpc.TF-VPC.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "AZ-A"
  }
}

resource "aws_subnet" "AZ-B" {
  vpc_id                  = aws_vpc.TF-VPC.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "AZ-B"
  }
}

resource "aws_subnet" "AZ-C" {
  vpc_id                  = aws_vpc.TF-VPC.id
  cidr_block              = "10.10.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "AZ-C"
  }
}

resource "aws_subnet" "AZ-Admin" {
  vpc_id                  = aws_vpc.TF-VPC.id
  cidr_block              = "10.10.0.0/24"
  availability_zone       = "us-east-1d"
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
  tags = {
    Name = "TF-Routing"
  }
}

resource "aws_main_route_table_association" "RouteAndVPC" {
  vpc_id         = aws_vpc.TF-VPC.id
  route_table_id = aws_route_table.TF-Route.id
}

resource "aws_security_group" "LbNSG" {
  name = "Lb NSG"
  description = "Lb NSG"
  vpc_id = aws_vpc.TF-VPC.id
  ingress {
    description = "All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}


resource "aws_security_group" "AdminNSG" {
  name = "Admin NSG"
  description = "Admin NSG"
  vpc_id = aws_vpc.TF-VPC.id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_security_group" "WebNSG" {
  name        = "Web NSG"
  description = "Web NSG"
  vpc_id      = aws_vpc.TF-VPC.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/24"]
  }

  ingress {
    description = "Web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "icmp"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}


resource "tls_private_key" "key_pair_admin" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "aws_key_pair" "TerraformKeyAdmin" {
  key_name   = "Terraform_Cle_Admin"
  public_key = tls_private_key.key_pair_admin.public_key_openssh

}

resource "local_sensitive_file" "TerraformPrivateKeyAdmin" {
  content         = tls_private_key.key_pair_admin.private_key_pem
  filename        = "Terraform_Cle_Admin.pem"
  file_permission = "600"
}

resource "aws_instance" "AC-Admin" {
  instance_type          = "t2.micro"
  ami                    = "ami-080e1f13689e07408"
  subnet_id              = aws_subnet.AZ-Admin.id
  vpc_security_group_ids = [aws_security_group.AdminNSG.id]
  key_name = "Terraform_Cle_Admin"
  tags = {
    Name = "AC-Admin"
  }
}

resource "aws_instance" "AC-A" {
  instance_type          = "t2.micro"
  ami                    = "ami-080e1f13689e07408"
  subnet_id              = aws_subnet.AZ-A.id
  vpc_security_group_ids = [aws_security_group.WebNSG.id]
  key_name = "Terraform_Cle_Admin"
  tags = {
    Name = "AC-A"
  }
}

resource "aws_instance" "AC-B" {
  instance_type          = "t2.micro"
  ami                    = "ami-080e1f13689e07408"
  subnet_id              = aws_subnet.AZ-B.id
  vpc_security_group_ids = [aws_security_group.WebNSG.id]
  key_name = "Terraform_Cle_Admin"
  tags = {
    Name = "AC-B"
  }
}

resource "aws_instance" "AC-C" {
  instance_type          = "t2.micro"
  ami                    = "ami-080e1f13689e07408"
  subnet_id              = aws_subnet.AZ-C.id
  vpc_security_group_ids = [aws_security_group.WebNSG.id]
  key_name = "Terraform_Cle_Admin"
  tags = {
    Name = "AC-C"
  }
}

resource "aws_elb" "TF-LB" {
  name    = "TF-LB"
  subnets = [aws_subnet.AZ-A.id, aws_subnet.AZ-B.id, aws_subnet.AZ-C.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.AC-A.id, aws_instance.AC-B.id, aws_instance.AC-C.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "TF-LB"
  }
}



