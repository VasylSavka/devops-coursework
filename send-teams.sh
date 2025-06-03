#!/bin/bash

MESSAGE=$1

if [ -z "$TEAMS_WEBHOOK" ]; then
  echo "❌ TEAMS_WEBHOOK is not set"
  exit 1
fi

curl -H "Content-Type: application/json" \
  -d "{\"text\": \"${MESSAGE}\"}" \
  "$TEAMS_WEBHOOK"
