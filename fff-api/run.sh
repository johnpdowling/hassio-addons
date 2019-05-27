#!/bin/bash
set -e
CONFIG_PATH=/data/options.json

# configs
LOCAL_ONLY=$(jq --raw-output '.local_only' $CONFIG_PATH)
WAIT_TIME=10

HOST=""
if [ !$LOCAL_ONLY ]
then
HOST="--host=0.0.0.0"
fi

# Run fff-api
while true; do
    answer="$(cd /fff-api/api && FLASK_APP=webapi.py flask run $HOST --port=5000)" || true
    
    echo "$(date): $answer"
    
    now="$(date +%s)"
    
    sleep "$WAIT_TIME"
done
