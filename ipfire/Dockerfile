ARG BUILD_FROM
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# install build reqs
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
    linux-headers-generic \
  && apt-get install -y \
    build-essential \
    git-core \
    g++ \
    realpath \
    patch \
    byacc \
    make \
    python-urlgrabber \
    autoconf \
    automake \
    nano \
    wget \
    pv \
    dialog \
    bzip2

RUN git clone git://git.ipfire.org/ipfire-2.x.git && \
    cd ipfire-2.x && \
    git checkout -b next -t origin/next && \
    ./make.sh downloadsrc && \
    ./make.sh gettoolchain && \
    ./make.sh build

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="IPFire addon for ${BUILD_ARCH}" \
    io.hass.description="JPD Hass.io Add-ons: ${BUILD_ARCH} IPFire image" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="JPD Hass.io Add-ons: ${BUILD_ARCH} IPFire" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Addon IPFire for ${BUILD_ARCH}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/ipfire/blob/master/README.md" \
    org.label-schema.vcs-ref=${REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/ipfire" \
    org.label-schema.vendor="John Dowling"
##############################################
