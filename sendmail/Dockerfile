ARG BUILD_FROM=hassioaddons/ubuntu-base:4.0.0
FROM ${BUILD_FROM}

# Install base system
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        sendmail
        
COPY rootfs /

CMD ["sendmail-mta"]
