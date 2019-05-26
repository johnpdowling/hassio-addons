# Docker file to create an image for a hass.io add-on that contains enough software to bother your Flashforge Finder and publish its info.
# This hass.io addon is based on 01F0's project here: https://github.com/01F0/flashforge-finder-api

ARG BUILD_FROM
FROM $BUILD_FROM

MAINTAINER John Dowling

LABEL Description="This image is used to start a Flask API server that will act as a conduit to your Flashforge Finder"

# Copy data
COPY *.sh /

#install environment
RUN apk add --no-cache build-deps alpine-sdk cmake git \
            python python-dev py-pip build-base
RUN pip install Flask
RUN mkdir /fff-api && cd /fff-api && \
    git clone https://github.com/01F0/flashforge-finder-api.git
    
CMD cd / && /run.sh
