ARG BUILD_FROM=hassioaddons/base:3.1.0
FROM ${BUILD_FROM}
#FROM armhf/debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk update && \
    apk add --no-cache wget sharutils tzdata gawk c-ares c-ares-dev \
                       avahi-compat-libdns_sd avahi-tools avahi-dev \
                       libarchive-dev curl libcurl

WORKDIR /opt
RUN curl -O https://storage.z-wave.me/z-way-server/z-way-server-Debian-v3.0.0.tgz && \
    tar -zxvf z-way-server-Debian-v3.0.0.tgz && \
    rm z-way-server-Debian-v3.0.0.tgz
    
#remove folders we're linking to on disk
RUN rm -rf /opt/z-way-server/config && \
    rm -rf /opt/z-way-server/automation/storage && \
    rm -rf /opt/z-way-server/automation/userModules && \
    rm -rf /opt/z-way-server/ZDDX

#create config folders if they don't exist
RUN mkdir -p /config/z-way-server/config && \
    mkdir -p /config/z-way-server/automation/storage && \
    mkdir -p /config/z-way-server/automation/userModules && \
    mkdir -p /config/z-way-server/ZDDX

#linky linky
RUN ln -s /config/z-way-server/config /opt/z-way-server/config && \
    ln -s /config/z-way-server/automation/storage /opt/z-way-server/automation/storage && \
    ln -s /config/z-way-server/automation/userModules /opt/z-way-server/automation/userModules && \
    ln -s /config/z-way-server/ZDDX /opt/z-way-server/ZDDX

RUN mkdir -p /etc/z-way/ && echo "v3.0.0" > /etc/z-way/VERSION && echo "razberry" > /etc/z-way/box_type

#COPY config.xml /opt/z-way-server/

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/z-way-server/libs

#RUN rm /usr/bin/qemu-arm-static

WORKDIR /opt/z-way-server

CMD ["/opt/z-way-server/z-way-server"]

HEALTHCHECK CMD curl --fail http://localhost:8083/ || exit 1
