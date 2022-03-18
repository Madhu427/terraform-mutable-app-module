resource "null_resource" "app_deploy" {
  triggers = {
    instance_ids = join(",", aws_spot_instance_request.ec2-spot.*.spot_instance_id)
  }
  count = length(aws_spot_instance_request.ec2-spot)
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = local.SSH_USERNAME
      password = local.SSH_PASSWORD
      host     = aws_spot_instance_request.ec2-spot.*.private_ip[count.index]
    }

    inline = [
      "ansible-pull -i  localhost, -U https://github.com/Madhu427/ansible.git roboshop.yml -e COMPONENT=${var.COMPONENT} -e ENV=${var.ENV} -e APP_VERSION=${var.APP_VERSION} -e NEXUS_USERNAME=${local.NEXUS_USERNAME} -e NEXUS_PASSOWRD=${local.NEXUS_PASSWORD}"
    ]
  }
}


locals {
  NEXUS_USERNAME = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["NEXUS_USERNAME"])
  NEXUS_PASSWORD = nonsensitive(jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["NEXUS_PASSWORD"])
  SSH_USERNAME   = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_USERNAME"]
  SSH_PASSWORD   = jsondecode(data.aws_secretsmanager_secret_version.secrets.secret_string)["SSH_PASSWORD"]
}