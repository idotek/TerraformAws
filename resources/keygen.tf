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