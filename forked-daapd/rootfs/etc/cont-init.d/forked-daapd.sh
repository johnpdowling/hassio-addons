#!/usr/bin/with-contenv bashio
# ==============================================================================
# JPD Hass.io Add-ons: forked-daapd server
# Configures the forked-daapd Server
# ==============================================================================

if ! bashio::fs.directory_exists '/config/forked-daapd/cache'; then
    bashio::log.debug 'Creating cache folder...'
    mkdir -p /config/forked-daapd/cache
fi

if ! bashio::fs.file_exists '/config/forked-daapd/forked-daapd.conf'; then
    bashio::log.debug 'Copying default conf file...'
    cp /usr/local/etc/forked-daapd.conf /config/forked-daapd/forked-daapd.conf
fi

if ! bashio::fs.directory_exists '/config/forked-daapd/music'; then
    bashio::log.debug 'Creating music folder...'
    mkdir -p /config/forked-daapd/music
    bashio::log.debug 'Creating HA fifo file...'
    mkfifo -m 666 /config/forked-daapd/music/HomeAssistantAnnounce
fi

bashio::log.info 'Kicking off avahi-daemon...'
avahi-daemon --daemonize --no-chroot
