resource "aws_instance" "AC-Admin" {
  instance_type          = "t2.micro"
  ami                    = "ami-080e1f13689e07408"
  subnet_id              = aws_subnet.AZ-Admin.id
  vpc_security_group_ids = [aws_security_group.AdminNSG.id]
  key_name               = "Terraform_Cle_Admin"
  tags = {
    Name = "AC-Admin"
  }
}

resource "aws_instance" "AC-A" {
  instance_type          = "t2.micro"
  ami                    = "ami-080e1f13689e07408"
  subnet_id              = aws_subnet.AZ-A.id
  vpc_security_group_ids = [aws_security_group.WebNSG.id]
  key_name               = "Terraform_Cle_Admin"
  tags = {
    Name = "AC-A"
  }
}

resource "aws_instance" "AC-B" {
  instance_type          = "t2.micro"
  ami                    = "ami-080e1f13689e07408"
  subnet_id              = aws_subnet.AZ-B.id
  vpc_security_group_ids = [aws_security_group.WebNSG.id]
  key_name               = "Terraform_Cle_Admin"
  tags = {
    Name = "AC-B"
  }
}

resource "aws_instance" "AC-C" {
  instance_type          = "t2.micro"
  ami                    = "ami-080e1f13689e07408"
  subnet_id              = aws_subnet.AZ-C.id
  vpc_security_group_ids = [aws_security_group.WebNSG.id]
  key_name               = "Terraform_Cle_Admin"
  tags = {
    Name = "AC-C"
  }
}
