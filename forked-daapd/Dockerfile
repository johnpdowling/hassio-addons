ARG BUILD_FROM=hassioaddons/base:8.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#adapted from sretalla's/kevineye's dockerfiles
# hadolint ignore=DL3003
RUN apk update \
 && apk add --no-cache \
        libcrypto1.1=1.1.1g-r0 \
        libssl1.1=1.1.1g-r0 \
 && apk add --no-cache --virtual deps1 \
        alsa-lib-dev \
        autoconf \
        automake \
        cmake \
        avahi-dev \
        bash \
        bsd-compat-headers \
        build-base \
        confuse-dev \
        curl \
        curl-dev \
        ffmpeg-dev \
        file \
        git \
        gnutls-dev \
        gperf \
        json-c-dev \
        libevent-dev \
        libgcrypt-dev \
        libplist-dev \
        libsodium-dev \
        libtool \
        libunistring-dev \
        openjdk7-jre-base \
        protobuf-c-dev \
        sqlite-dev \
        
 && apk add --no-cache --virtual=deps2 --repository http://nl.alpinelinux.org/alpine/edge/testing \
        libantlr3c-dev \
        mxml-dev \
        
 && apk add --no-cache \
        avahi \
        confuse \
        dbus \
        ffmpeg \
        json-c \
        libcurl \
        libevent \
        libgcrypt \
        libplist \
        libsodium \
        libunistring \
        libuv=1.29.1-r0 \
        libuv-dev=1.29.1-r0 \
        protobuf-c \
        sqlite \
        sqlite-libs \
        openssl \
        
 && apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
        libantlr3c \
        mxml \
 
 && curl -L -o /tmp/antlr-3.4-complete.jar http://www.antlr3.org/download/antlr-3.4-complete.jar && \
    echo '#!/bin/bash' > /usr/local/bin/antlr3 && \
    echo 'exec java -cp /tmp/antlr-3.4-complete.jar org.antlr.Tool "$@"' >> /usr/local/bin/antlr3 && \
    chmod 775 /usr/local/bin/antlr3 \

 && cd /tmp && \
    git clone --branch "v3.2.2" --depth=1 https://github.com/warmcat/libwebsockets.git && \
    cd /tmp/libwebsockets && \
    cmake ./ \
        -DCMAKE_BUILD_TYPE=MinSizeRel \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DLWS_IPV6=ON \
        -DLWS_STATIC_PIC=ON \
        -DLWS_UNIX_SOCK=OFF \
        -DLWS_WITH_LIBUV=ON \
        -DLWS_WITH_SHARED=ON \
        -DLWS_WITHOUT_TESTAPPS=ON && \
    make && \
    make install \

 && cd /tmp && \
    git clone https://github.com/ejurgensen/forked-daapd.git && \
    cd /tmp/forked-daapd && \
    autoreconf -fi && \
    ./configure \
      --enable-itunes \
      --with-libwebsockets && \
    make && \
    make install \

 && apk del --purge deps1 deps2 && \
    rm -rf /usr/local/bin/antlr3 /tmp/* \

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
    io.hass.name="Forked-daapd Server" \
    io.hass.description="The forked-daapd server program" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="The forked-daapd server program" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Forked-daapd Server" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/tree/master/forked-daapd/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/forked-daapd" \
    org.label-schema.vendor="JPD Hass.io Add-ons"
