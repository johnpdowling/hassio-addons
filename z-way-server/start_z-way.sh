#!/bin/sh

#set to use host dbus in HA config file
avahi-daemon --daemonize --no-chroot

#create folders if necessary, copy defaults if necessary(empty) , remove defaults and soft link to config
mkdir -p /config/z-way-server/config
[ -z /config/z-way-server/config ] && cp -r /opt/z-way-server/config /config/z-way-server/config
rm -rf /opt/z-way-server/config && ln -s /config/z-way-server/config /opt/z-way-server/config

mkdir -p /config/z-way-server/storage
[ -z /config/z-way-server/storage ] && cp -r /opt/z-way-server/automation/storage /config/z-way-server/storage
rm -rf /opt/z-way-server/automation/storage && ln -s /config/z-way-server/storage /opt/z-way-server/automation/storage

mkdir -p /config/z-way-server/userModules
[ -z /config/z-way-server/userModules ] && cp -r /opt/z-way-server/automation/userModules /config/z-way-server/userModules
rm -rf /opt/z-way-server/automation/userModules && ln -s /config/z-way-server/userModules /opt/z-way-server/automation/userModules

mkdir -p /config/z-way-server/ZDDX
[ -z /config/z-way-server/ZDDX ] && cp -r /opt/z-way-server/ZDDX /config/z-way-server/ZDDX
rm -rf /opt/z-way-server/ZDDX && ln -s /config/z-way-server/ZDDX /opt/z-way-server/ZDDX

#kick off the server
echo "/opt/:"
ls -l /opt/
echo "/opt/z-way-server/:"
ls -l /opt/z-way-server/

/opt/z-way-server/z-way-server
