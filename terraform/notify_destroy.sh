#!/bin/bash

MESSAGE="Terraform destroy: EC2 instance is being terminated."
WEBHOOK_URL="$1"

export MESSAGE
export WEBHOOK_URL

./teams_notify.sh
exit 0
