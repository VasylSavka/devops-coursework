#!/bin/bash

ACTION="$1"
WEBHOOK="$2"

if [ "$ACTION" == "destroy" ]; then
  bash ./notify_destroy.sh "$WEBHOOK" "🗑️ Terraform destroy: EC2 instance is being terminated."
else
  bash ./notify_destroy.sh "$WEBHOOK" "🛠️ Terraform apply is replacing EC2 instance..."
fi
