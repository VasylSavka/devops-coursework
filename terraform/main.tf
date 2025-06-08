provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "devops_app" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "devops-key"

  tags = {
    Name = "DevOpsAppInstance"
  }

  user_data = file("userdata.sh")
}

resource "null_resource" "teams_notify_apply" {
  triggers = {
    instance_ip = aws_instance.devops_app.public_ip
    always_run  = timestamp()
  }

  provisioner "local-exec" {
    command = "bash ./notify_apply.sh ${self.triggers.instance_ip} ${var.teams_webhook_url}"
  }
}

resource "null_resource" "teams_notify_destroy" {
  triggers = {
    always_run  = timestamp()
    webhook_url = var.teams_webhook_url
    action_flag = var.action  # <== Ренеймінг допомагає уникнути name collision
  }

  provisioner "local-exec" {
    when = destroy
    command = <<EOT
      ACTION_FLAG="${self.triggers.action_flag}"
      if [ "$${ACTION_FLAG}" = "destroy" ]; then
        bash ./notify_destroy.sh "${self.triggers.webhook_url}" "🗑️ Terraform destroy: EC2 instance is being terminated."
      else
        bash ./notify_destroy.sh "${self.triggers.webhook_url}" "🛠️ Terraform apply is replacing EC2 instance..."
      fi
    EOT
  }
}

