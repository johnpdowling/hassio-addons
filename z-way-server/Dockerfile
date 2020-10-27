ARG BUILD_FROM=youdownwithjpd/addon-raspbian-base:latest
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Build z-way

ENV TZ=America/Los_Angeles

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install additional packages that help to add Z-Wave.Me repository
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        dirmngr \
        apt-transport-https \
	gnupg
# Add Z-Wave.Me repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x7E148E3C
RUN    echo "deb https://repo.z-wave.me/z-way/raspbian stretch main" > /etc/apt/sources.list.d/z-wave-me.list
RUN    apt-get update
# upgrade and install everything zway needs itself in one go
RUN apt-get install --reinstall -y --no-install-recommends \
        z-way-full \
        z-way-server \
        zbw \
        webif
        
#        wget \
#        sharutils \
#        gawk \
#        libc-ares2 \
#        libavahi-compat-libdnssd-dev \
#       libarchive-dev \
#       libcurl3

#WORKDIR /opt
#RUN curl -O https://storage.z-wave.me/z-way-server/z-way-server-RaspberryPiXTools-v2.3.8.tgz && \
#    tar -zxvf z-way-server-RaspberryPiXTools-v2.3.8.tgz && \
#    rm z-way-server-RaspberryPiXTools-v2.3.8.tgz && \ 
#    mkdir -p /etc/z-way/ && \
#    echo "v2.3.8" > /etc/z-way/VERSION && echo "razberry" > /etc/z-way/box_type

#ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/z-way-server/libs
# follow "package config replace" path
RUN TMP_DIR=`mktemp -d` && \
		pushd $TMP_DIR && \
		apt-get download z-way-server && \
		dpkg-deb --fsys-tarfile ./z-way-server*.deb | sudo tar -C / -x ./opt/z-way-server/config/Defaults.xml ./opt/z-way-server/config.xml ./etc/z-way/box_type ./etc/logrotate.d/z-way-server ./etc/init.d/z-way-server && \
		apt-get download webif && \
		dpkg-deb --fsys-tarfile ./webif*.deb | sudo tar -C / -x ./etc/webif.conf ./etc/mongoose/mongoose.conf && \
		#  no config files in zbw package
		# apt-get download zbw
		# dpkg-deb --fsys-tarfile ./zbw*.deb | sudo tar -C / -x ...
		popd && \
		rm -R $TMP_DIR

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
