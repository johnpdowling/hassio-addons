#!/bin/bash -ex
set -e
CONFIG_PATH=/data/options.json
# Run script for kegbot appserver.

die() {
  echo "Error: $@"
  exit 1
}

do_mysql() {
  mysql -B -u "${KEGBOT_DB_USER}" --password="${KEGBOT_DB_PASS}" -h "${KEGBOT_DB_HOST}" -P ${KEGBOT_DB_PORT} "${@}"
  return $?
}

### Main routines

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
  
  # Set defaults to required
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

  # Set defaults to optionals
  if [ -z "${KEGBOT_EMAIL_FROM}" ]; then
    export KEGBOT_EMAIL_FROM=""
  fi
  if [ -z "${KEGBOT_EMAIL_HOST}" ]; then
    export KEGBOT_EMAIL_HOST=""
  fi
  if [ -z "${KEGBOT_EMAIL_PORT}" ]; then
    export KEGBOT_EMAIL_PORT=25
  fi
  if [ -z "${KEGBOT_EMAIL_USER}" ]; then
    export KEGBOT_EMAIL_USER=""
  fi
  if [ -z "${KEGBOT_EMAIL_PASSWORD}" ]; then
    export KEGBOT_EMAIL_PASSWORD=""
  fi
  if [ -z "${KEGBOT_EMAIL_USE_SSL}" ]; then
    export KEGBOT_EMAIL_USE_SSL=False
  fi
  if [ -z "${KEGBOT_EMAIL_USE_TLS}" ]; then
    export KEGBOT_EMAIL_USE_TLS=False
  fi

  if [ -z "${KEGBOT_REDIS_PORT}" ]; then
    export KEGBOT_REDIS_HOST=localhost
    export KEGBOT_REDIS_PORT=6379
  fi

  if [ -z "${KEGBOT_SETTINGS_DIR}" ]; then
    export KEGBOT_SETTINGS_DIR=/config/kegbot/
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

  env
}

wait_for_mysql() {
  nc -z $KEGBOT_DB_HOST $KEGBOT_DB_PORT || sleep 30
  if ! do_mysql "${KEGBOT_DB_NAME}" -e "show tables"; then
    do_mysql -e "create database ${KEGBOT_DB_NAME};"
    kegbot migrate --noinput -v 0
    do_mysql "${KEGBOT_DB_NAME}" -e "show tables"
  fi
}

kick_off_nginx() {
  nginx -g 'daemon on;'
}

kick_off_redis() {
  redis-server --daemonize yes
}

wait_for_redis() {
  redis-cli -h "${KEGBOT_REDIS_HOST}" -p ${KEGBOT_REDIS_PORT} ping
}

# Perform first-launch setup.
maybe_setup_kegbot() {
  if [ ! -d "${KEGBOT_SETTINGS_DIR}" ]; then
    mkdir -p ${KEGBOT_SETTINGS_DIR}/media
    mv /kegbot-data/local_settings.py ${KEGBOT_SETTINGS_DIR}
  fi
  
  kegbot collectstatic --noinput -v 0
  #do_mysql -e "create database ${KEGBOT_DB_NAME};" || die "Could not create database."
  true
}

run_daemons() {
  kegbot run_all --logs_dir=/kegbot-data --gunicorn_options="-w 3 -b 127.0.0.1:8000"
}

setup() {
  python /app/setup.py install
}

run_all() {
  setup_env
  kick_off_nginx
  kick_off_redis

  wait_for_mysql
  wait_for_redis

  maybe_setup_kegbot
  ls -ld /kegbot-data
  ls -l /kegbot-data
  echo `date` >> /kegbot-data/runlog
  run_daemons
}

run_all
