ARG BUILD_FROM=youdownwithjpd/addon-nvidia-base:latest
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Install server reqs
# Install Shane's webserver reqs w/ nvidia flavors
RUN \
#    pip install -U --pre --no-cache-dir --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v42 \
#        tensorflow-gpu && \
    pip3 install -U --pre --no-cache-dir \
         uvicorn \
         gunicorn \
         fastapi \
         redis \
         pillow \
         python-multipart
#         keras

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
