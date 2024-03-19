resource "local_file" "inventory" {
    filename = "external/ansible/hosts"
    content = <<EOF
[adminserver]
${aws_instance.AC-Admin.public_ip}
EOF
}

resource "local_file" "var_file" {
    filename = "external/ansible/var.yaml"
    content = <<EOF
---

web1: ${aws_instance.AC-A.private_ip}
web2: ${aws_instance.AC-B.private_ip}
web3: ${aws_instance.AC-C.private_ip}
EOF
}

resource "null_resource" "AnsiblelaybookExec" {
  provisioner "local-exec" {
  command = "ansible-playbook -i external/ansible/hosts external/ansible/playbook.yml"
  }
}

