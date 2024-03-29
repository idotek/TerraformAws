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