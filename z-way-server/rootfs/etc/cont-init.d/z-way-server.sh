#!/usr/bin/with-contenv bashio
# ==============================================================================
# JPD Hass.io Add-ons: Z-Way Server
# Configures the Z-Way Server
# ==============================================================================

if ! bashio::fs.directory_exists '/config/forked-daapd/cache'; then
    bashio::log.debug 'Creating cache folder...'
    mkdir -p /config/forked-daapd/cache
fi

if ! bashio::fs.file_exists '/config/forked-daapd/forked-daapd.conf'; then
    bashio::log.debug 'Copying default conf file...'
    cp /usr/local/etc/forked-daapd.conf /config/forked-daapd/forked-daapd.conf
fi
