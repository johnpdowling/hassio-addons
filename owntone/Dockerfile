ARG BUILD_FROM=hassioaddons/debian-base:latest
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apk update

#from owntone-server instructions
# hadolint ignore=DL3003
RUN apt-get update &&
    apt-get install -y --fix-missing --no-install-recommends \
        build-essential git autotools-dev autoconf automake libtool gettext gawk \
        gperf antlr3 libantlr3c-dev libconfuse-dev libunistring-dev libsqlite3-dev \
        libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavutil-dev \
        libasound2-dev libmxml-dev libgcrypt20-dev libavahi-client-dev zlib1g-dev \
        libevent-dev libplist-dev libsodium-dev libjson-c-dev libwebsockets-dev \
        libcurl4-openssl-dev libprotobuf-c-dev
RUN git clone https://github.com/owntone/owntone-server.git && \
    cd owntone-server && \
    autoreconf -i && \
    ./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-libwebsockets && \
    make && \
    make install        

# && cd /tmp && \
#    git clone https://github.com/ejurgensen/forked-daapd.git && \
#    cd /tmp/forked-daapd && \
#    autoreconf -fi && \
#    ./configure \
#      --enable-itunes \
#      --with-libwebsockets && \
#    make && \
#    make install \

# && apk del --purge deps1 deps2 && \
#    rm -rf /usr/local/bin/antlr3 /tmp/* \

 && cd /usr/local/etc \
 && sed -i -e 's/\(uid.*=.*\)/uid = "root"/g' owntone.conf \
 && sed -i s#"ipv6 = yes"#"ipv6 = no"#g owntone.conf \
 && sed -i s#/srv/music#/config/owntone/music#g owntone.conf \
 && sed -i s#/usr/local/var/cache/owntone/songs3.db#/config/owntone/cache/songs3.db#g owntone.conf \
 && sed -i s#/usr/local/var/cache/owntone/cache.db#/config/owntone/cache/cache.db#g owntone.conf \
 && sed -i s#/usr/local/var/log/owntone.log#/dev/stdout#g owntone.conf \
 && sed -i "/websocket_port\ =/ s/# *//" owntone.conf \
 && sed -i "/trusted_networks\ =/ s/# *//" owntone.conf \
 && sed -i "/pipe_autostart\ =/ s/# *//" owntone.conf \
 && sed -i "/db_path\ =/ s/# *//" owntone.conf \
 && sed -i "/cache_path\ =/ s/# *//" owntone.conf

VOLUME /etc/localtime /etc/localtime:ro

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="OwnTone Server" \
    io.hass.description="The OwnTone server program" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="The OwnTone server program" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="OwnTone Server" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/tree/master/owntone/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/owntone" \
    org.label-schema.vendor="JPD Hass.io Add-ons"
