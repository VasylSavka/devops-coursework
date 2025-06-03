#!/bin/bash

MESSAGE=$1
WEBHOOK_URL=$2

curl -H "Content-Type: application/json" \
  -d "{\"text\": \"${MESSAGE}\"}" \
  "$WEBHOOK_URL"
