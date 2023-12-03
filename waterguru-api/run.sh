#!/usr/bin/with-contenv bashio
set -e

bashio::log.info "Creating WG configuration..."

# Create main config
WG_USER=$(bashio::config 'email')
WG_PASS=$(bashio::config 'password')

sed -i "s/WG_USER/${WG_USER}/" /waterguru_flask.py
sed -i "s/WG_PASS/${WG_PASS}/" /waterguru_flask.py
sed -i "s/WG_PORT/${WG_PORT}/" /waterguru_flask.py

bashio::log.info "Starting WG API server..."
python3 /waterguru_flask.py
