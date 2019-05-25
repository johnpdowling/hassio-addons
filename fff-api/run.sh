#!/bin/bash
set -e

# configs
WAIT_TIME=10

# Run fff-api
while true; do
    answer="$(cd /fff-api && FLASK_APP=webapi.py flask run --host=0.0.0.0 --port=5000)" || true
    
    echo "$(date): $answer"
    
    now="$(date +%s)"
    
    sleep "$WAIT_TIME"
done
