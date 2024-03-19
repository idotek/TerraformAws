resource "aws_vpc" "TF-VPC" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "TF-VPC"
  }
}