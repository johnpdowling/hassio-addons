ARG BUILD_FROM=hassioaddons/ubuntu-base:4.0.0
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base
# hadolint ignore=DL3003
RUN \
    apt-get update 
RUN \
    apt-get install -y --no-install-recommends \
        sendmail
        
COPY rootfs /

CMD ["sendmail-mta"]
