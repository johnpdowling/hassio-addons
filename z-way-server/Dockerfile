#START AS BUILDING BASE ADDON - NOTE ARMHF/DEBIAN
FROM armhf/debian:stretch-slim

#COPY qemu-arm-static /usr/bin

# Environment variables
ENV \
    DEBIAN_FRONTEND="noninteractive" \
    HOME="/root" \
    LANG="C.UTF-8" \
    PS1="$(whoami)@$(hostname):$(pwd)$ " \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    TERM="xterm-256color"

# Copy root filesystem
COPY rootfs /

ARG BUILD_ARCH=armhf

# Set shell
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base system
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        jq \
        tzdata

RUN \
    curl -o /bin/yq https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_arm
    
RUN S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
    \
    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-${S6_ARCH}.tar.gz" \
        | tar zxvf - -C / \
    \
    && mkdir -p /etc/fix-attrs.d \
    && mkdir -p /etc/services.d \
    \
    && curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/v0.4.1.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
        /tmp/bashio.tar.gz \
        --strip 1 -C /tmp/bashio \
    \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    \
    && rm -fr \
        /tmp/* \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

# Entrypoint & CMD
ENTRYPOINT [ "/init" ]

# Build arugments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Addon Raspi base for ${BUILD_ARCH}" \
    io.hass.description="JPD Hass.io Add-ons: ${BUILD_ARCH} z-way-server image" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="JPD Hass.io Add-ons: ${BUILD_ARCH} Z-Way Server" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Addon Z-Way-Server for ${BUILD_ARCH}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/z-way-server/blob/master/README.md" \
    org.label-schema.vcs-ref=${REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/z-way-server" \
    org.label-schema.vendor="John Dowling"


# NOW BUILD ZWAY AS NORMAL

ENV TZ=America/Los_Angeles

COPY *.sh /

RUN chmod +x /*.sh

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# upgrade and install all the libs zway needs ourself in one go
RUN apt-get install -y --no-install-recommends --force-yes \
            wget sharutils gawk libc-ares2 libavahi-compat-libdnssd-dev libarchive-dev libcurl3

WORKDIR /opt
RUN curl -O https://storage.z-wave.me/z-way-server/z-way-server-RaspberryPiXTools-v2.3.8.tgz && \
    tar -zxvf z-way-server-RaspberryPiXTools-v2.3.8.tgz && \
    rm z-way-server-RaspberryPiXTools-v2.3.8.tgz
    
RUN mkdir -p /etc/z-way/ && echo "v2.3.8" > /etc/z-way/VERSION && echo "razberry" > /etc/z-way/box_type

#COPY config.xml /opt/z-way-server/

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/z-way-server/libs

#RUN rm /usr/bin/qemu-arm-static

WORKDIR /opt/z-way-server

CMD /start_z-way.sh

HEALTHCHECK CMD curl --fail http://localhost:8083/ || exit 1
