ARG BUILD_FROM=hassioaddons/debian-base
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#from owntone-server instructions
# hadolint ignore=DL3003
RUN apt-get update &&
    apt-get install \
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
 && sed -i -e 's/\(uid.*=.*\)/uid = "root"/g' forked-daapd.conf \
 && sed -i s#"ipv6 = yes"#"ipv6 = no"#g forked-daapd.conf \
 && sed -i s#/srv/music#/config/forked-daapd/music#g forked-daapd.conf \
 && sed -i s#/usr/local/var/cache/forked-daapd/songs3.db#/config/forked-daapd/cache/songs3.db#g forked-daapd.conf \
 && sed -i s#/usr/local/var/cache/forked-daapd/cache.db#/config/forked-daapd/cache/cache.db#g forked-daapd.conf \
 && sed -i s#/usr/local/var/log/forked-daapd.log#/dev/stdout#g forked-daapd.conf \
 && sed -i "/websocket_port\ =/ s/# *//" forked-daapd.conf \
 && sed -i "/trusted_networks\ =/ s/# *//" forked-daapd.conf \
 && sed -i "/pipe_autostart\ =/ s/# *//" forked-daapd.conf \
 && sed -i "/db_path\ =/ s/# *//" forked-daapd.conf \
 && sed -i "/cache_path\ =/ s/# *//" forked-daapd.conf

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
    io.hass.name="Owntone Server" \
    io.hass.description="The owntone server program" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="The owntone server program" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Owntone Server" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/tree/master/owntone/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/owntone" \
    org.label-schema.vendor="JPD Hass.io Add-ons"
