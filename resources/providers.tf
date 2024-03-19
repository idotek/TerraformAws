terraform {
  required_providers {
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
