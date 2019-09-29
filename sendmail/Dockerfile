ARG BUILD_FROM=hassioaddons/ubuntu-base:4.0.0
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base system
RUN \
    apt-get update 
RUN \
    apt-get install -y --no-install-recommends \
        sendmail
        
COPY rootfs /

CMD ["sendmail-mta"]
