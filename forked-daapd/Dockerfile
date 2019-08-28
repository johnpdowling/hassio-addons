ARG BUILD_FROM=hassioaddons/base:3.1.0
FROM ${BUILD_FROM}

#adapted from sretalla's dockerfile

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
        sqlite-dev \
 && apk add --no-cache --virtual=deps2 --repository http://nl.alpinelinux.org/alpine/edge/testing \
        libantlr3c-dev \
        mxml-dev

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
        mxml

RUN  curl -L -o /tmp/antlr-3.4-complete.jar http://www.antlr3.org/download/antlr-3.4-complete.jar \
 && echo '#!/bin/bash' > /usr/local/bin/antlr3 \
 && echo 'exec java -cp /tmp/antlr-3.4-complete.jar org.antlr.Tool "$@"' >> /usr/local/bin/antlr3 \
 && chmod 775 /usr/local/bin/antlr3

RUN cd /tmp \
 && git clone https://github.com/warmcat/libwebsockets.git \
 && cd /tmp/libwebsockets \
 && cmake ./ \
 && make install

RUN  cd /tmp \
 && git clone https://github.com/ejurgensen/forked-daapd.git \
 && cd /tmp/forked-daapd \
 && autoreconf -i
 
RUN ./configure \
      --enable-itunes \
      --enable-mpd \
      --enable-lastfm \
      --enable-chromecast

RUN make \
 && make install

RUN  apk del --purge deps1 deps2 \
 && rm -rf /usr/local/bin/antlr3 /tmp/*
 
RUN  cd /usr/local/etc \
 && sed -i -e 's/\(uid.*=.*\)/uid = "root"/g' forked-daapd.conf \
 && sed -i s#"ipv6 = yes"#"ipv6 = no"#g forked-daapd.conf \
 && sed -i s#/srv/music#/music#g forked-daapd.conf \
 && sed -i s#/usr/local/var/cache/forked-daapd/songs3.db#/config/cache/songs3.db#g forked-daapd.conf \
 && sed -i s#/usr/local/var/cache/forked-daapd/cache.db#/config/cache/cache.db#g forked-daapd.conf \
 && sed -i s#/usr/local/var/log/forked-daapd.log#/dev/stdout#g forked-daapd.conf \
 && sed -i "/db_path\ =/ s/# *//" forked-daapd.conf \
 && sed -i "/cache_path\ =/ s/# *//" forked-daapd.conf

#VOLUME /config /music

ADD daapd.sh /daapd

CMD /daapd
