#!/usr/bin/with-contenv bashio
# ==============================================================================
# JPD Hass.io Add-ons: Keras REST Server
# Runs the Keras model saver
# ==============================================================================
set -e
CONFIG_PATH=/data/options.json

#pull required option(s)
export MODEL_NAME=$(jq --raw-output '.model_name' $CONFIG_PATH)
if [ -z "${MODEL_NAME}" ]; then
    export MODEL_NAME="imagenet"
fi
bashio::log.debug "Setting up Keras model..."
python3 /app/modelsaver/main.py
