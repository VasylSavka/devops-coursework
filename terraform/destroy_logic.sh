#!/bin/bash

action="$1"
webhook="$2"

if [ "$action" = "destroy" ]; then
  bash ./notify_destroy.sh "$webhook" "🗑️ Terraform destroy: EC2 instance is being terminated."
else
  bash ./notify_destroy.sh "$webhook" "🛠️ Terraform apply is replacing EC2 instance..."
fi
