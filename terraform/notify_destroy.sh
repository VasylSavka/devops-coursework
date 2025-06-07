#!/bin/bash
MESSAGE="Terraform destroy: EC2 instance is being terminated."
WEBHOOK_URL="$1"

MESSAGE="$MESSAGE" WEBHOOK_URL="$WEBHOOK_URL" ./teams_notify.sh
