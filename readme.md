terraform apply -var-file="secrets.tfvars"
terraform destroy -var-file="secrets.tfvars"



access_key = "XX"
secret_key = "XX"
token      = "XX"



le playbook ansible fonctionne a la main mais le provider est bug


J'aurais pu utiliser le provider remote-exec plutot que de faire du Ansible, mais je voulais rester dans la logique (Terraform = infra, ansible = system.)