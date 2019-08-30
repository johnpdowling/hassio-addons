# forked-daapd hass.io add-on
This add-on provides an installation of the [forked-daapd](https://github.com/ejurgensen/forked-daapd) server and is based on the [docker project](https://github.com/sretalla/docker-forked-daapd) by @sretalla and @kevineye.

## Usage
Before beginning, set up a kegbot user on a MySQL/MariaDB system but do not create a database as that will be handled during setup. If you're using email, set up your server and/or gather your information.
1) Install add-on and start it
2) For your setup, you may need to further edit forked-daapd.conf to suit your needs. All files are located in %config% and are created after first start

## Notes
1) The forked-daapd compiled here was only given the configure flag --enable-itunes. Chromecast, Spotify, etc. are disabled in this add-on. I wanted an instance to work with my [custom component](https://github.com/johnpdowling/custom_components/tree/master/forked-daapd) and AirPlay devices
2) The named pipe %config%/forked-daapd/music/HomeAssistantAnnounce is created to facilitate announcements via the component
