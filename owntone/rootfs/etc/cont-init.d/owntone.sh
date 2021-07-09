#!/usr/bin/with-contenv bashio

#Start it up

if ! bashio::fs.directory_exists '/config/owntone/cache'; then
    bashio::log.debug 'Creating cache folder...'
    mkdir -p /config/owntone/cache
fi

if ! bashio::fs.file_exists '/config/owntone/owntone.conf'; then
    bashio::log.debug 'Copying default conf file...'
    cp /usr/local/etc/owntone.conf /config/owntone/owntone.conf
fi

if ! bashio::fs.directory_exists '/config/owntone/music'; then
bashio::log.debug 'Creating music folder...'
    mkdir -p /config/owntone/music
    bashio::log.debug 'Creating HA fifo file...'
    mkfifo -m 666 /config/owntone/music/HomeAssistantAnnounce
fi

