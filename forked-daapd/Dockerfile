ARG BUILD_FROM=hassioaddons/base:5.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

#adapted from sretalla's/kevineye's dockerfiles
# hadolint ignore=DL3003
RUN apk update

RUN \
    apk add --no-cache --virtual .build-dependencies \
        bsd-compat-headers=0.7.2-r0 \
        build-base=0.5-r1 \
        cmake=3.15.5-r0 \
        docker=19.03.5-r1 \
        json-c-dev=0.13.1-r1 \
        libffi-dev=3.2.1-r6 \
        libuv-dev=1.34.0-r0 \
        openssl-dev=1.1.1g-r0 \
        python3-dev=3.8.2-r0 \
        zlib-dev=1.2.11-r3 

RUN apk add --no-cache \
        ack=3.2.0-r0 \
        alsa-plugins-pulse=1.2.1-r0 \
        alsa-utils=1.2.1-r0 \
        awake=1.0-r4 \
        bash-completion=2.9-r0 \
        bind-tools=9.14.12-r0 \
        bluez=5.52-r1 \
        colordiff=1.0.18-r1 \
        device-mapper-libs=2.02.186-r0 \
        docker-bash-completion=19.03.5-r1 \
        docker-zsh-completion=19.03.5-r1 \
        git=2.24.3-r0 \
        htop=2.2.0-r0 \
        json-c=0.13.1-r1 \
        libltdl=2.4.6-r7 \
        libuv=1.34.0-r0 \
        libxml2-utils=2.9.10-r3 \
        mariadb-client=10.4.13-r0 \
        mosh=1.3.2-r13 \
        mosquitto-clients=1.6.8-r0 \
        nano-syntax=4.6-r0 \
        nano=4.6-r0 \
        ncurses=6.1_p20200118-r4 \
        net-tools=1.60_git20140218-r2 \
        networkmanager=1.20.8-r0 \
        nmap=7.80-r1 \
        openssh=8.1_p1-r0 \
        openssl=1.1.1g-r0 \
        pwgen=2.08-r0 \
        pulseaudio-utils=13.0-r2 \
        python3=3.8.2-r0 \
        rsync=3.1.3-r2 \
        sqlite=3.30.1-r2 \
        sudo=1.8.31-r0 \
        tmux=3.0a-r1 \
        vim=8.2.0-r0 \
        wget=1.20.3-r0 \
        zip=3.0-r7 \
        zsh-autosuggestions=0.6.3-r0 \
        zsh-syntax-highlighting=0.6.0-r0 \
        zsh=5.7.1-r0

RUN apk --no-cache add --virtual=deps1 \
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
        sqlite-dev
 RUN apk add --no-cache --virtual=deps2 --repository http://nl.alpinelinux.org/alpine/edge/testing \
        libantlr3c-dev \
        mxml-dev \
        
RUN apk add --no-cache \
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
        protobuf-c \
        sqlite \
        sqlite-libs \
        openssl \        
 && apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/testing \
        libantlr3c \
        mxml \
 
RUN curl -L -o /tmp/antlr-3.4-complete.jar http://www.antlr3.org/download/antlr-3.4-complete.jar && \
    echo '#!/bin/bash' > /usr/local/bin/antlr3 && \
    echo 'exec java -cp /tmp/antlr-3.4-complete.jar org.antlr.Tool "$@"' >> /usr/local/bin/antlr3 && \
    chmod 775 /usr/local/bin/antlr3 \
 \
 && cd /tmp && \
    git clone https://github.com/warmcat/libwebsockets.git && \
    cd /tmp/libwebsockets && \
    cmake ./ && \
    make install \
 \
 && cd /tmp && \
    git clone https://github.com/ejurgensen/forked-daapd.git && \
    cd /tmp/forked-daapd && \
    autoreconf -fi && \
    ./configure \
      --enable-itunes \
      --with-libwebsockets && \
    make && \
    make install \
 \
 && apk del --purge deps1 deps2 && \
    rm -rf /usr/local/bin/antlr3 /tmp/*

RUN cd /usr/local/etc \
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
