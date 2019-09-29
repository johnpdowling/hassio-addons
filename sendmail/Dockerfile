ARG BUILD_FROM=hassioaddons/ubuntu-base:3.2.0
FROM ${BUILD_FROM}

# Install base system
RUN \
    apt-get update 
RUN \
    apt-get install -y --no-install-recommends \
        sendmail
        
COPY rootfs /

CMD ["sendmail-mta"]
