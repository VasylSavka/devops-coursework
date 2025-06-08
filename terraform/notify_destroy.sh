#!/bin/bash

WEBHOOK_URL=$1
MESSAGE=$2

if [ -z "$WEBHOOK_URL" ] || [ -z "$MESSAGE" ]; then
  echo "❌ Usage: ./notify_destroy.sh <webhook_url> <message>"
  exit 1
fi

curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$(cat <<EOF
{
  "text": "$MESSAGE"
}
EOF
)"
