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



resource "tls_private_key" "key_pair_web" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "aws_key_pair" "TerraformKeyweb" {
  key_name   = "Terraform_Cle_Web"
  public_key = tls_private_key.key_pair_web.public_key_openssh

}

resource "local_sensitive_file" "TerraformPrivateKeyWeb" {
  content         = tls_private_key.key_pair_web.private_key_pem
  filename        = "Terrafom_Cle_Web.pem"
  file_permission = "600"
}
