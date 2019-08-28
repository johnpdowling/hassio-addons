#!/bin/sh

#adapted from kevineye
rm -rf /var/run
mkdir -p /var/run/dbus
dbus-uuidgen --ensure
sleep 1
dbus-daemon --system

avahi-daemon --daemonize --no-chroot

mkdir -p /config/cache
[[ ! -f /config/forked-daapd.conf ]] && cp /usr/local/etc/forked-daapd.conf /config/forked-daapd.conf

exec forked-daapd -f -c /config/forked-daapd.conf -P /var/run/forked-daapd.pid
