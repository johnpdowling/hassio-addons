#!/usr/bin/env bash
# ==============================================================================
# JPD Hass.io Add-ons: Kegbot Server
# Set up kegbot environment
# ==============================================================================
set -e
CONFIG_PATH=/data/options.json

die() {
  bashio::log.info "Error: $@"
  exit 1
}

setup_env() {
  #pull required options
  export KEGBOT_DB_NAME=$(jq --raw-output '.db_name' $CONFIG_PATH)
  export KEGBOT_DB_HOST=$(jq --raw-output '.db_host' $CONFIG_PATH)
  export KEGBOT_DB_PORT=$(jq --raw-output '.db_port' $CONFIG_PATH)
  export KEGBOT_DB_USER=$(jq --raw-output '.db_user' $CONFIG_PATH)
  export KEGBOT_DB_PASS=$(jq --raw-output '.db_pass' $CONFIG_PATH)
  export KEGBOT_DEBUG=$(jq --raw-output '.debug' $CONFIG_PATH)
  #pull optional options
  export KEGBOT_EMAIL_FROM=$(jq --raw-output '.email_from' $CONFIG_PATH)
  export KEGBOT_EMAIL_HOST=$(jq --raw-output '.email_host' $CONFIG_PATH) 
  export KEGBOT_EMAIL_PORT=$(jq --raw-output '.email_port' $CONFIG_PATH)
  export KEGBOT_EMAIL_USER=$(jq --raw-output '.email_user' $CONFIG_PATH)
  export KEGBOT_EMAIL_PASSWORD=$(jq --raw-output '.email_password' $CONFIG_PATH)
  export KEGBOT_EMAIL_USE_SSL=$(jq --raw-output '.email_use_ssl' $CONFIG_PATH)
  export KEGBOT_EMAIL_USE_TLS=$(jq --raw-output '.email_use_tls' $CONFIG_PATH)
  
  # Set defaults to required if missing
  if [ -z "${KEGBOT_DB_NAME}" ]; then
    export KEGBOT_DB_NAME="kegbot"
  fi
  if [ -z "${KEGBOT_DB_USER}" ]; then
    export KEGBOT_DB_USER="root"
  fi
  if [ -z "${KEGBOT_DB_PASS}" ]; then
    export KEGBOT_DB_PASS=""
  fi
  if [ -z "${KEGBOT_DB_PORT}" ]; then
    export KEGBOT_DB_PORT=3306
  fi

  # Remove optionals if missing
  if [[ -z "${KEGBOT_EMAIL_FROM}" || "${KEGBOT_EMAIL_FROM}" == "null" ]]; then
    export -n KEGBOT_EMAIL_FROM
  fi
  if [[ -z "${KEGBOT_EMAIL_HOST}" || "${KEGBOT_EMAIL_HOST}" == "null" ]]; then
    export -n KEGBOT_EMAIL_HOST
  fi
  if [[ ! -z "${KEGBOT_EMAIL_PORT}" && "${KEGBOT_EMAIL_PORT}" == "null" ]]; then
    export -n KEGBOT_EMAIL_PORT
  fi
  if [[ ! -z "${KEGBOT_EMAIL_USER}" && "${KEGBOT_EMAIL_USER}" == "null" ]]; then
    export -n KEGBOT_EMAIL_USER
  fi
  if [[ ! -z "${KEGBOT_EMAIL_PASSWORD}" && "${KEGBOT_EMAIL_PASSWORD}" == "null" ]]; then
    export -n KEGBOT_EMAIL_PASSWORD
  fi
  if [[ ! -z "${KEGBOT_EMAIL_USE_SSL}" && "${KEGBOT_EMAIL_USE_SSL}" == "null" ]]; then
    export -n KEGBOT_EMAIL_USE_SSL
  fi
  if [[ ! -z "${KEGBOT_EMAIL_USE_TLS}" && "${KEGBOT_EMAIL_USE_TLS}" == "null" ]]; then
    export -n KEGBOT_EMAIL_USE_TLS
  fi

export KEGBOT_DATABASE_URL="${KEGBOT_DB_USER}:${KEGBOT_DB_PASS}@${KEGBOT_DB_HOST}:${KEGBOT_DB_PORT}/${KEGBOT_DB_NAME}"

  # other sets
  if [ -z "${KEGBOT_REDIS_PORT}" ]; then
    export KEGBOT_REDIS_HOST=localhost
    export KEGBOT_REDIS_PORT=6379
  fi

  if [ -z "${KEGBOT_SETTINGS_DIR}" ]; then
    export KEGBOT_SETTINGS_DIR=/config/kegbot/
  fi
  
  if [ -z "${KEGBOT_MEDIA_ROOT}" ]; then
    export KEGBOT_MEDIA_ROOT=/config/kegbot/media/
  fi
  
#  if [ -z "${KEGBOT_DATA_DIR}" ]; then
#    export KEGBOT_DATA_DIR=/config/kegbot/kegbot-data/
#  fi

  # Verify mandatory variables.
  if [ -z "${KEGBOT_DB_HOST}" ]; then
    die "Must set KEGBOT_DB_HOST or MYSQL_PORT_3306_TCP_{ADDR,PORT}"
  fi
  if [ -z "${KEGBOT_REDIS_HOST}" ]; then
    die "Must set KEGBOT_REDIS_HOST or REDIS_PORT_6379_TCP_{ADDR,PORT}"
  fi

  export C_FORCE_ROOT=True   ## needed by celery

#  env
}

#bashio::log.info "Setting up environment..."
setup_env
