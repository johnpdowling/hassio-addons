ARG BUILD_FROM=youdownwithjpd/addon-nvidia-base:latest
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Initialize constants used to control image spatial dimensions and data type
ENV REDIS_HOST=localhost
ENV REDIS_PORT=6379
ENV IMAGE_QUEUE=image_queue
ENV IMAGE_WIDTH=224
ENV IMAGE_HEIGHT=224
ENV IMAGE_CHANS=3
ENV IMAGE_DTYPE=float32
ENV BATCH_SIZE=32
# Time in ms between each poll by model server against Redis
ENV SERVER_SLEEP=0.25  
# Time in ms between each poll by web server against Redis
ENV CLIENT_SLEEP=0.25  
# Num tries by web server to retrieve results from Redis before giving up
ENV CLIENT_MAX_TRIES=100
# TensorFlow vars
ENV TF_FORCE_GPU_ALLOW_GROWTH=true

# Install server, nvidia tensorflow-gpu reqs
RUN \
    apt-get update && \
    apt-get install -y --fix-missing --no-install-recommends \
        redis \
        libhdf5-serial-dev \
        hdf5-tools \
        libhdf5-dev \
        zlib1g-dev \
        zip \
        git \
        libjpeg8-dev && \
# Install Shane's webserver reqs w/ nvidia flavors
    pip3 install --pre --no-cache-dir --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 \
         tensorflow-gpu && \
    pip3 install --pre --no-cache-dir \
         uvicorn \
         gunicorn \
         fastapi \
         redis \
         pillow \
         python-multipart \
         email-validator && \
# Install keras
    apt-get install -y --fix-missing --no-install-recommends \
        python3-keras && \
    rm -fr \
        /var/{cache,log}/* \
        /var/lib/apt/lists/*

# Copy root filesystem
COPY rootfs /

# Build arugments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Keras REST Server" \
    io.hass.description="RESTful server for Keras engine" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="John Dowling <john.patrick.dowling@gmail.com>" \
    org.label-schema.description="JPD Hass.io Add-ons: ${BUILD_ARCH} Keras REST Server" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Addon Keras REST Server for ${BUILD_ARCH}" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://addons.community" \
    org.label-schema.usage="https://github.com/johnpdowling/hassio-addons/keras-rest/blob/master/README.md" \
    org.label-schema.vcs-ref=${REF} \
    org.label-schema.vcs-url="https://github.com/johnpdowling/hassio-addons/keras-rest" \
    org.label-schema.vendor="John Dowling"
##############################################
