# Add-on archived and won't be further developed here. Please use OwnTone.

# forked-daapd hass.io add-on
This add-on provides an installation of the [forked-daapd](https://github.com/ejurgensen/forked-daapd) server and is based on the [docker project](https://github.com/sretalla/docker-forked-daapd) by [/u/sretalla](https://github.com/sretalla) and [/u/kevineye](https://github.com/kevineye).

## Usage
1) Install add-on and start it
2) For your setup, you may need to further edit forked-daapd.conf to suit your needs. All files are located in %config%/forked-daapd/ and are created after first start

## Notes
1) The forked-daapd compiled here was only given the configure flag --enable-itunes. Chromecast, Spotify, etc. are disabled in this add-on. I wanted an instance to work with my [custom component](https://github.com/johnpdowling/custom_components/tree/master/forked-daapd) and AirPlay devices
2) The named pipe %config%/forked-daapd/music/HomeAssistantAnnounce is created to facilitate announcements via the component
