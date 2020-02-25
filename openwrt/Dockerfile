ARG BUILD_FROM
FROM $BUILD_FROM

ARG BUILD_ARCH

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

# Set shell
SHELL ["/bin/ash", "-o", "pipefail", "-c"]

RUN mkdir /var/lock

# Install HA system
RUN \
    opkg update \
    && opkg install \
        ca-bundle \
        curl
#        jq 
#        tzdata

RUN if [ "${BUILD_ARCH}" = "i386" ]; then curl -o /bin/yq https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_386; fi
RUN if [ "${BUILD_ARCH}" = "amd64" ]; then curl -o /bin/yq https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_amd64; fi
RUN if [ "${BUILD_ARCH}" = "arm7" ]; then curl -o /bin/yq https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_arm; fi
RUN if [ "${BUILD_ARCH}" = "aarch64" ]; then curl -o /bin/yq https://github.com/mikefarah/yq/releases/download/2.4.0/yq_linux_arm64; fi

#RUN S6_ARCH="${BUILD_ARCH}" \
#    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; fi \
#    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
#    \
#    && curl -L -s "https://github.com/just-containers/s6-overlay/releases/download/v1.22.1.0/s6-overlay-${S6_ARCH}.tar.gz" \
#        | tar zxvf - -C / \
#    \
#    && mkdir -p /etc/fix-attrs.d \
#    && mkdir -p /etc/services.d \
#    \
#    && curl -J -L -o /tmp/bashio.tar.gz \
#        "https://github.com/hassio-addons/bashio/archive/v0.4.1.tar.gz" \
#    && mkdir /tmp/bashio \
#    && tar zxvf \
#        /tmp/bashio.tar.gz \
#        --strip 1 -C /tmp/bashio \
#    \
#    && mv /tmp/bashio/lib /usr/lib/bashio \
#    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
#    \
#    && rm -fr \
#        /tmp/* \
#        /var/{cache,log}/* \
#        /var/lib/apt/lists/*

# Build arugments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Addon OpenWRT for ${BUILD_ARCH}" \
    io.hass.description="JPD Hass.io Add-ons: ${BUILD_ARCH} OpenWRT image" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="base" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="JPD Hass.io Add-ons: ${BUILD_ARCH} OpenWRT image" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Addon OpenWRT for ${BUILD_ARCH}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/tree/master/openwrt/README.md" \
    org.label-schema.vcs-ref=${REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/openwrt" \
    org.label-schema.vendor="John Dowling"
