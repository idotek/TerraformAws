terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.41.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.2.0"
    }
    null = {
      source = "hashicorp/null"
      version = "3.2.2"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
}
