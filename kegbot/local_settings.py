# kegbot-docker local settings.

# Inspired by: https://github.com/blalor/docker-kegbot-server
# Safe to edit by hand. See http://kegbot.org/docs/server/ for more info.

import os

DEBUG = bool(os.environ.get("KEGBOT_DEBUG", ""))
TEMPLATE_DEBUG = DEBUG

KEGBOT_ROOT = os.environ.get("KEGBOT_ROOT", "/kegbot-data")

LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "file": {
            "level": "DEBUG",
            "class": "logging.FileHandler",
            "filename": os.path.join(KEGBOT_ROOT, "kegbot.log"),
        },
    },
    "loggers": {
        "root": {
            "handlers": ["file"],
            "level": "DEBUG",
            "propagate": True,
        },
    },
}

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'filters': {
        'require_debug_true': {
            '()': 'django.utils.log.RequireDebugTrue',
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'filters': ['require_debug_true'],
            'class': 'logging.StreamHandler',
            'formatter': 'verbose',
        },
        'null': {
            'class': 'django.utils.log.NullHandler',
        },
        'redis': {
            'level': 'INFO',
            'class': 'django.utils.log.NullHandler',
        },
    },
    'formatters': {
        'verbose': {
            'format': '%(asctime)s %(levelname)-8s (%(name)s) %(message)s'
        },
        'simple': {
            'format': '%(levelname)s %(message)s'
        },
    },
    'loggers': {
        'raven': {
            'level': 'DEBUG',
            'handlers': ['console'],
            'propagate': False,
        },
        'pykeg': {
            'level': 'INFO',
            'handlers': ['console', 'redis'],
            'propagate': False,
        },
        '': {
            'level': 'INFO',
            'handlers': ['console'],
            'formatter': 'verbose',
        },
    },
}

### database settings

_dbhost = os.environ["KEGBOT_DB_HOST"]
_dbport = os.environ.get("KEGBOT_DB_PORT", 3306)
_dbname = os.environ.get("KEGBOT_DB_NAME", "kegbot")
_dbuser = os.environ.get("KEGBOT_DB_USER", "root")
_dbpass = os.environ.get("KEGBOT_DB_PASS", None)

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "OPTIONS": {
            "init_command": "SET default_storage_engine=INNODB"
        },

        "NAME":     _dbname,
        "HOST":     _dbhost,
        "PORT":     _dbport,
        "USER":     _dbuser,
        "PASSWORD": _dbpass,
    }
}

del _dbname, _dbhost, _dbport, _dbuser, _dbpass

_redishost = os.environ["KEGBOT_REDIS_HOST"]
_redisport = os.environ.get("KEGBOT_REDIS_PORT", 6379)

#### redis settings

BROKER_URL = "redis://{}:{}/0".format(_redishost, _redisport)
CELERY_RESULT_BACKEND = BROKER_URL
CACHES = {
    'default': {
        'BACKEND': 'redis_cache.cache.RedisCache',
        'LOCATION': '{}:{}:1'.format(_redishost, _redisport),
        'OPTIONS': {
            'CLIENT_CLASS': 'redis_cache.client.DefaultClient',
        }
    }
}

del _redishost, _redisport

MEDIA_ROOT  = os.path.join(KEGBOT_ROOT, "media")
STATIC_ROOT = os.path.join(KEGBOT_ROOT, "static")
MEDIA_URL  = "/media/"
STATIC_URL = "/static/"

SECRET_KEY = os.environ.get("KEGBOT_SECRET_KEY", "change-me")  # TODO: warning.

if "KEGBOT_EMAIL_HOST" in os.environ:
    # Tell Kegbot use the SMTP e-mail backend.
    EMAIL_BACKEND = "django.core.mail.backends.smtp.EmailBackend"

    # "From" address for e-mails.
    EMAIL_FROM_ADDRESS = os.environ["KEGBOT_EMAIL_FROM"]

    EMAIL_HOST = os.environ["KEGBOT_EMAIL_HOST"]
    EMAIL_PORT = int(os.environ.get("KEGBOT_EMAIL_PORT", 25))

    # Credentials for SMTP server.
    if "KEGBOT_EMAIL_USER" in os.environ:
        EMAIL_HOST_USER     = os.environ["KEGBOT_EMAIL_USER"]
        EMAIL_HOST_PASSWORD = os.environ["KEGBOT_EMAIL_PASSWORD"]

    EMAIL_USE_SSL       = bool(os.environ.get("KEGBOT_EMAIL_USE_SSL", ""))
    EMAIL_USE_TLS       = bool(os.environ.get("KEGBOT_EMAIL_USE_TLS", ""))
