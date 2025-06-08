#!/bin/bash

ACTION="$1"
WEBHOOK="$2"

if [ "$ACTION" == "" ]; then
  echo "❌ No action provided to destroy_logic.sh"
  exit 1
fi

if [ "$ACTION" == "destroy" ]; then
  bash ./notify_destroy.sh "$WEBHOOK" "🗑️ Terraform destroy: EC2 instance is being terminated."
else
  bash ./notify_destroy.sh "$WEBHOOK" "🛠️ Terraform apply is replacing EC2 instance..."
fi
