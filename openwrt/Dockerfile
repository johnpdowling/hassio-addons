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

#RUN mkdir /var/lock

# Install system
RUN apk update && \
    apk add --no-cache \
    docker \
    iw \
    rsync

RUN if [ "${BUILD_ARCH}" = "i386" ]; then curl -o /tmp/openwrt.tar.gz http://downloads.openwrt.org/releases/19.07.1/targets/x86/generic/openwrt-19.07.1-x86-generic-generic-rootfs.tar.gz; fi
RUN if [ "${BUILD_ARCH}" = "amd64" ]; then curl -o /tmp/openwrt.tar.gz http://downloads.openwrt.org/releases/19.07.1/targets/x86/64/openwrt-19.07.1-x86-64-generic-rootfs.tar.gz; fi
RUN if [ "${BUILD_ARCH}" = "arm7" ]; then curl -o /tmp/openwrt.tar.gz http://downloads.openwrt.org/releases/19.07.1/targets/armvirt/32/openwrt-19.07.1-armvirt-32-default-rootfs.tar.gz; fi
RUN if [ "${BUILD_ARCH}" = "aarch64" ]; then curl -o /tmp/openwrt.tar.gz http://downloads.openwrt.org/releases/19.07.1/targets/armvirt/64/openwrt-19.07.1-armvirt-64-default-rootfs.tar.gz; fi
RUN mkdir /tmp/openwrt && tar -zxvf /tmp/openwrt.tar.gz -C /tmp/openwrt && \
    rm /tmp/openwrt/etc/hosts && \
    rm /tmp/openwrt/etc/resolv.conf && \
    rm -rf /tmp/openwrt/var && \
    rm -rf /tmp/openwrt/init
# && \

#    rm -rf /tmp/openwrt/etc/init.d
#    rm -rf /tmp/openwrt/etc
    
#RUN cp -rn /tmp/openwrt/* /

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
