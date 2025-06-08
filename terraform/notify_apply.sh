#!/bin/bash

INSTANCE_IP=$1
WEBHOOK_URL=$2

if [ -z "$INSTANCE_IP" ] || [ -z "$WEBHOOK_URL" ]; then
  echo "❌ Usage: ./notify_apply.sh <instance_ip> <webhook_url>"
  exit 1
fi

MESSAGE="Terraform apply: EC2 instance has been created successfully. Public IP: ${INSTANCE_IP}:3000"

MESSAGE="$MESSAGE" WEBHOOK_URL="$WEBHOOK_URL" ./teams_notify.sh
