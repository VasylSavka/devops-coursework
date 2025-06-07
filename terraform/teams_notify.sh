#!/bin/bash

if [ -z "$MESSAGE" ] || [ -z "$WEBHOOK_URL" ]; then
  echo "❌ Usage: MESSAGE='<message>' WEBHOOK_URL='<url>' ./teams_notify.sh"
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

exit 0 
