ARG BUILD_FROM=youdownwithjpd/addon-raspbian-base:latest
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build z-way

ENV TZ=America/Los_Angeles

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# upgrade and install all the libs zway needs ourself in one go
RUN apt-get update 
RUN apt-get install -y --no-install-recommends \
        wget \
        sharutils \
        gawk \
        libc-ares2 \
        libavahi-compat-libdnssd-dev \
        libarchive-dev \
        libcurl3

WORKDIR /opt
RUN curl -O https://storage.z-wave.me/z-way-server/z-way-server-RaspberryPiXTools-v2.3.8.tgz && \
    tar -zxvf z-way-server-RaspberryPiXTools-v2.3.8.tgz && \
    rm z-way-server-RaspberryPiXTools-v2.3.8.tgz && \ 
    mkdir -p /etc/z-way/ && \
    echo "v2.3.8" > /etc/z-way/VERSION && echo "razberry" > /etc/z-way/box_type

ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/z-way-server/libs

# Copy root filesystem
COPY rootfs /

WORKDIR /opt/z-way-server

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
##############################################
