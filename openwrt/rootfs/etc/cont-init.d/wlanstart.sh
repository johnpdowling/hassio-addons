#!/usr/bin/with-contenv bashio
# ==============================================================================
# JPD Hass.io Add-ons: OpenWRT
# Configures wlan0 in guest mode so we can use it in services
# ==============================================================================

# privileged set in config.json, but check anyway
if [ ! -w "/sys" ] ; then
    bashio::log.error "[Error] Not running in privileged mode."
    exit 1
fi
#CONFIG_PATH=/data/options.json
#MQTT_HOST="$(jq --raw-output '.mqtt_host' $CONFIG_PATH)"

# Default values
true ${INTERFACE:=wlan0}

# Attach interface to container in guest mode
bashio::log.info "Fetching interface data for container"

CONTAINER_ID=$(cat /proc/self/cgroup | grep -o  -e "/docker/.*" | head -n 1| sed "s/\/docker\/\(.*\)/\\1/")
CONTAINER_PID=$(docker inspect -f '{{.State.Pid}}' ${CONTAINER_ID})
CONTAINER_IMAGE=$(docker inspect -f '{{.Config.Image}}' ${CONTAINER_ID})

bashio::log.info "Attaching interface to container"
docker run -t --privileged --net=host --pid=host --rm --entrypoint /bin/sh ${CONTAINER_IMAGE} -c "
    PHY=\$(echo phy\$(iw dev ${INTERFACE} info | grep wiphy | tr ' ' '\n' | tail -n 1))
    iw phy \$PHY set netns ${CONTAINER_PID}
"
bashio::log.info "Setting up interface"
ip link set ${INTERFACE} name wlan0

INTERFACE=wlan0

# unblock wlan
rfkill unblock wlan

# Setup interface and bring it up 
ip link set ${INTERFACE} up
ip addr flush dev ${INTERFACE}
