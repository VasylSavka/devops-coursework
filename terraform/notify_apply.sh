#!/bin/bash
MESSAGE="Terraform apply: EC2 instance has been created successfully. Public IP: $1:3000"
WEBHOOK_URL="$2"

MESSAGE="$MESSAGE" WEBHOOK_URL="$WEBHOOK_URL" ./teams_notify.sh
