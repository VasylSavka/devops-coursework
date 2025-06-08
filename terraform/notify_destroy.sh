#!/bin/bash

WEBHOOK_URL=$1
MESSAGE=$2

cat <<EOF > payload.json
{
  "text": "${MESSAGE}"
}
EOF

curl -H "Content-Type: application/json" -d @payload.json $WEBHOOK_URL
