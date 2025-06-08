#!/bin/bash

MESSAGE=$1
WEBHOOK_URL=$2

TIME=$(date "+%Y-%m-%d %H:%M:%S")
USER=${BUILD_USER_ID:-"N/A"}
JOB_NAME=${JOB_NAME:-"N/A"}
BUILD_NUMBER=${BUILD_NUMBER:-"N/A"}
GIT_COMMIT_MSG=$(git log -1 --pretty=%s || echo "N/A")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD || echo "main")

cat <<EOF > payload.json
{
  "@type": "MessageCard",
  "@context": "http://schema.org/extensions",
  "summary": "$MESSAGE",
  "themeColor": "0076D7",
  "title": "$MESSAGE",
  "sections": [{
    "facts": [
      { "name": "🕒 Time", "value": "$TIME" },
      { "name": "👤 User", "value": "$USER" },
      { "name": "🏷️ Job", "value": "$JOB_NAME" },
      { "name": "🔢 Build", "value": "#$BUILD_NUMBER" },
      { "name": "💬 Commit", "value": "$GIT_COMMIT_MSG" },
      { "name": "🌿 Branch", "value": "$GIT_BRANCH" }
    ],
    "markdown": true
  }]
}
EOF

curl -H "Content-Type: application/json" -d @payload.json "$WEBHOOK_URL"
