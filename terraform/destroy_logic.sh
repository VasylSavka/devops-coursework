#!/bin/bash

ACTION="$1"
WEBHOOK="$2"

if [ -z "$ACTION" ] || [ -z "$WEBHOOK" ]; then
  echo "❌ Usage: ./destroy_logic.sh <action> <webhook_url>"
  exit 1
fi

if [ "$ACTION" = "destroy" ]; then
  bash ./notify_destroy.sh "$WEBHOOK" "🗑️ Terraform destroy: EC2 instance is being terminated."
else
  bash ./notify_destroy.sh "$WEBHOOK" "🛠️ Terraform apply is replacing EC2 instance..."
fi
