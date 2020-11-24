ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

COPY rootfs /

RUN apk update && \
    apk add --no-cache \
    bash \
    hostapd \
    iptables \
    dhcp \
    docker \
    iproute2 \
    iw
    
RUN echo "" > /var/lib/dhcp/dhcpd.leases

RUN modprobe ip_tables && \
    echo 'ip_tables' >> /etc/modules

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Home Assistant Access Point" \
    io.hass.description="This image is used to create a wireless access point." \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="Home Assistant Access Point instance" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Home Assistant Access Point" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/tree/master/hass-ap/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/hass-ap" \
    org.label-schema.vendor="JPD Hass.io Add-ons"
