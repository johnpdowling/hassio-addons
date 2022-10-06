#!/command/with-contenv bashio
# ==============================================================================
# JPD Hass.io Add-ons: owntone server
# Runs the owntone Server
# ==============================================================================
# shellcheck disable=SC1091

# Start with init
if ! bashio::fs.directory_exists '/config/owntone/cache'; then
   bashio::log.info 'Creating cache folder...'
   mkdir -p /config/owntone/cache
fi

if ! bashio::fs.file_exists '/config/owntone/owntone.conf'; then
   bashio::log.info 'Copying default conf file...'
   cp /usr/local/etc/owntone.conf /config/owntone/owntone.conf
fi

if ! bashio::fs.directory_exists '/config/owntone/music'; then
   bashio::log.info 'Creating music folder...'
   mkdir -p /config/owntone/music
   bashio::log.info 'Creating HA fifo file...'
   mkfifo -m 666 /config/owntone/music/HomeAssistantAnnounce
fi

# Run owntone
bashio::log.info 'Starting the OwnTone Server...'
owntone -f -c /config/owntone/owntone.conf -P /var/run/owntone.pid
