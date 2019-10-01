#!/usr/bin/with-contenv bashio
# ==============================================================================
# JPD Hass.io Add-ons: Z-Way Server
# Configures the Z-Way Server
# ==============================================================================

bashio::log.debug 'Creating config folder (if necessary)...'
mkdir -p /config/z-way-server/config
bashio::log.debug 'Creating storage folder (if necessary)...'
mkdir -p /config/z-way-server/storage
bashio::log.debug 'Creating user modules folder (if necessary)...'
mkdir -p /config/z-way-server/userModules
bashio::log.debug 'Creating zddx folder (if necessary)...'
mkdir -p /config/z-way-server/ZDDX

bashio::log.debug 'Copying default config files (if necessary)...'
[ -z /config/z-way-server/config ] && cp -r /opt/z-way-server/config /config/z-way-server/config
bashio::log.debug 'Linking config files...'
rm -rf /opt/z-way-server/config && ln -s /config/z-way-server/config /opt/z-way-server/config

bashio::log.debug 'Copying default storage files (if necessary)...'
[ -z /config/z-way-server/storage ] && cp -r /opt/z-way-server/automation/storage /config/z-way-server/storage
bashio::log.debug 'Linking storage files...'
rm -rf /opt/z-way-server/automation/storage && ln -s /config/z-way-server/storage /opt/z-way-server/automation/storage

bashio::log.debug 'Copying default user modules files (if necessary)...'
[ -z /config/z-way-server/userModules ] && cp -r /opt/z-way-server/automation/userModules /config/z-way-server/userModules
bashio::log.debug 'Linking user modules files...'
rm -rf /opt/z-way-server/automation/userModules && ln -s /config/z-way-server/userModules /opt/z-way-server/automation/userModules

bashio::log.debug 'Copying default zddx files (if necessary)...'
[ -z /config/z-way-server/ZDDX ] && cp -r /opt/z-way-server/ZDDX /config/z-way-server/ZDDX
bashio::log.debug 'Linking zddx files...'
rm -rf /opt/z-way-server/ZDDX && ln -s /config/z-way-server/ZDDX /opt/z-way-server/ZDDX
