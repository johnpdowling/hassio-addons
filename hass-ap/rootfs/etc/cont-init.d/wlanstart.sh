#!/usr/bin/with-contenv bashio
# ==============================================================================
# JPD Hass.io Add-ons: HASS-AP
# Configures all the scripts
# ==============================================================================

# helper functions
ip2int()
{
    local a b c d
    { IFS=. read a b c d; } <<< $1
    echo $(((((((a << 8) | b) << 8) | c) << 8) | d))
}

int2ip()
{
    local ui32=$1; shift
    local ip=""
    local n
    for n in 1 2 3 4; do
        ip=$((ui32 & 0xff))${ip:+.}$ip
        ui32=$((ui32 >> 8))
    done
    echo $ip
}

netmask()
# Example: netmask 24 => 255.255.255.0
{
    local mask=$((0xffffffff << (32 - $1))); shift
    int2ip $mask
}


broadcast()
# Example: broadcast 192.0.2.0 24 => 192.0.2.255
{
    local addr=$(ip2int $1); shift
    local mask=$((0xffffffff << (32 - $1))); shift
    int2ip $((addr | ~mask))
}

network()
# Example: network 192.0.2.42 24 => 192.0.2.0
{
    local addr=$(ip2int $1); shift
    local mask=$((0xffffffff << (32 - $1))); shift
    int2ip $((addr & mask))
}

# privileged set in config.json, but check anyway
if [ ! -w "/sys" ] ; then
    bashio::log.error "[Error] Not running in privileged mode."
    exit 1
fi
CONFIG_PATH=/data/options.json
#MQTT_HOST="$(jq --raw-output '.mqtt_host' $CONFIG_PATH)"

# Default values
true ${OUTGOINGS:=eth0}
true ${INTERFACE:=wlan0}
#true ${SUBNET:=192.168.254.0}
SUBNET="$(jq --raw-output '.subnet' $CONFIG_PATH)"
#true ${AP_ADDR:=192.168.254.1}
AP_ADDR="$(jq --raw-output '.ap_address' $CONFIG_PATH)"
#true ${SSID:=dockerap}
SSID="$(jq --raw-output '.ssid' $CONFIG_PATH)"
#true ${CHANNEL:=11}
CHANNEL="$(jq --raw-output '.channel' $CONFIG_PATH)"
#true ${WPA_PASSPHRASE:=passw0rd}
WPA_PASSPHRASE="$(jq --raw-output '.wpa_passphrase' $CONFIG_PATH)"
true ${HW_MODE:=g}
#HW_MODE="$(jq --raw-output '.hw_mode' $CONFIG_PATH)"
true ${DRIVER:=nl80211}
#DRIVER="$(jq --raw-output '.driver' $CONFIG_PATH)"
true ${HT_CAPAB:=[HT40-][SHORT-GI-20][SHORT-GI-40]}
true ${MODE:=guest}

DHCP_MIN="$(jq --raw-output '.dhcp_min' $CONFIG_PATH)"
DHCP_MAX="$(jq --raw-output '.dhcp_max' $CONFIG_PATH)"

# Attach interface to container in guest mode
if [ "$MODE" == "guest"  ]; then
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
fi

if [ ! -f "/etc/hostapd.conf" ] ; then
    cat > "/etc/hostapd.conf" <<EOF
interface=${INTERFACE}
driver=${DRIVER}
ssid=${SSID}
hw_mode=${HW_MODE}
channel=${CHANNEL}
wpa=2
wpa_passphrase=${WPA_PASSPHRASE}
wpa_key_mgmt=WPA-PSK
# TKIP is no secure anymore
#wpa_pairwise=TKIP CCMP
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_ptk_rekey=600
ieee80211n=1
ht_capab=${HT_CAPAB}
wmm_enabled=1 
EOF

fi

# unblock wlan
rfkill unblock wlan

echo "Setting interface ${INTERFACE}"

# Setup interface and restart DHCP service 
ip link set ${INTERFACE} up
ip addr flush dev ${INTERFACE}
ip addr add ${AP_ADDR}/24 dev ${INTERFACE}

# NAT settings
echo "NAT settings ip_dynaddr, ip_forward"

for i in ip_dynaddr ip_forward ; do 
  if [ $(cat /proc/sys/net/ipv4/$i) ]; then
    echo $i already 1 
  else
    echo "1" > /proc/sys/net/ipv4/$i
  fi
done

cat /proc/sys/net/ipv4/ip_dynaddr 
cat /proc/sys/net/ipv4/ip_forward

if [ "${OUTGOINGS}" ] ; then
   ints="$(sed 's/,\+/ /g' <<<"${OUTGOINGS}")"
   for int in ${ints}
   do
      echo "Setting iptables for outgoing traffics on ${int}..."
      iptables -t nat -A POSTROUTING -o ${int} -j MASQUERADE
      iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
      iptables -A FORWARD -i ${INTERFACE} -o ${int} -j ACCEPT
      ip_mask=$(ip -o -f inet addr show | awk '/scope global eth0/ {print $4}')
      echo "IP_Mask for ${int} is ${ip_mask}"
      ip_=$(echo $ip_mask | cut -d'/' -f1)
      _mask=$(echo $ip_mask | cut -d'/' -f2)
      echo "which is ${ip_} and ${_mask}"
      network_prefix=$(network $ip_ $_mask) 
      echo "Prefix for ${int} is ${network_prefix}"
      int_subnet=$(echo $ip_mask | sed "s/$ip_/$network_prefix/g")
      echo "Subnet for ${int} is ${int_subnet}"
   done
else
   echo "Setting iptables for outgoing traffics on all interfaces..."
   iptables -t nat -A POSTROUTING -j MASQUERADE
   iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
   iptables -A FORWARD -i ${INTERFACE} -j ACCEPT
fi
echo "Configuring DHCP server .."

if [ ! -f "/config/hass-ap/dhcp-reservations.conf" ] ; then
  mkdir -p /config/hass-ap
  echo "" > /config/hass-ap/dhcp-reservations.conf
fi

cat > "/etc/dhcp/dhcpd.conf" <<EOF
option domain-name-servers 1.1.1.1, 1.0.0.1;
option subnet-mask 255.255.255.0;
option routers ${AP_ADDR};
subnet ${SUBNET} netmask 255.255.255.0 {
  range ${SUBNET::-1}${DHCP_MIN} ${SUBNET::-1}${DHCP_MAX};
}
include "/config/hass-ap/dhcp-reservations.conf";
EOF
