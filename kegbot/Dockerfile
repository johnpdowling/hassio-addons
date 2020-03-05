ARG BUILD_FROM=hassioaddons/python-base:latest
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

ENV PATH="/app/bin:${PATH}"
ENV PYTHONPATH="/app:/app/bin:${PYTHONPATH}"
ENV PYTHON3PATH="/app:/app/bin:${PYTHON3PATH}"
# other sets
ENV KEGBOT_REDIS_HOST=localhost
ENV KEGBOT_REDIS_PORT=6379
ENV KEGBOT_SETTINGS_DIR=/config/kegbot/
ENV KEGBOT_MEDIA_ROOT=/config/kegbot/media/
#    export KEGBOT_DATA_DIR=/config/kegbot/kegbot-data/
ENV KEGBOT_VERSION=master
ENV LANG C.UTF-8

RUN apk update && \
    apk add --no-cache build-base python3-dev py3-setuptools py3-virtualenv py3-mysqlclient py3-future \
                       nginx redis curl gcc musl-dev mysql-client \
                       zlib-dev libjpeg-turbo libjpeg-turbo-dev libjpeg openjpeg \
                       libcrypto1.1>1.1.1d-r2 libssl1.1>1.1.1d-r2 \
                       mariadb-dev

COPY requirements.txt /tmp/
RUN pip3 install -U -r /tmp/requirements.txt

COPY rootfs /
RUN echo "# shellcheck source=lib/kegbot.sh" >> /usr/lib/bashio/bashio.sh && \
    echo "source \"\${__BASHIO_LIB_DIR}/kegbot.sh\"" >> /usr/lib/bashio/bashio.sh
    
ADD kegbot.conf /etc/nginx/conf.d/default.conf
ADD nginx.conf /etc/nginx/nginx.conf

#kb

RUN curl -k -L https://github.com/Kegbot/kegbot-server/archive/${KEGBOT_VERSION}.tar.gz -o /tmp/kegbot.tar.gz \
     && tar -xf /tmp/kegbot.tar.gz -C /tmp/ \
     && ls -la /tmp/ \
     && mkdir /app \
     && cp -r /tmp/kegbot-server-${KEGBOT_VERSION}/* /app/ \
     && ls -la ./ \
     && cp -r /app/bin/* /bin/

WORKDIR /app
RUN ln -s /usr/bin/python3 /usr/bin/python && python /app/setup.py install 
#RUN apk del musl-dev gcc 
RUN rm -rf /tmp/kegbot*

RUN mkdir -p /kegbot-data/
COPY local_settings.py /kegbot-data/

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Kegbot Server" \
    io.hass.description="The kegbot server program" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="The kegbot server program" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Kegbot Server" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/tree/master/kegbot/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/kegbot" \
    org.label-schema.vendor="JPD Hass.io Add-ons"
