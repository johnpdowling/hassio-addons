# Kegbot hass.io add-on
This add-on provides an installation of the [Kegbot](https://kegbot.org/) server and is based on their [docker project](https://github.com/Kegbot/kegbot-docker).

## Usage
Before beginning, set up a kegbot user on a MySQL/MariaDB system but do not create a database as that will be handled during setup. If you're using email, set up your server and/or gather your information.
1) Install add-on
2) In the config window, db information is required and email information (email_from, email_host, email_port, email_user, email_password, email_use_ssl, email_use_tls) is optional.
3) If you need to add extra kegbot or django settings, the settings file is located at %config%/kegbot/local_settings.py (right now there's a bug and DEBUG = False has to be hard-coded here)
4) Media is located in %config%/kegbot/media/
