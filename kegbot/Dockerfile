#ARG BUILD_FROM=hassioaddons/base:3.1.0
#FROM ${BUILD_FROM}
FROM python:2.7-alpine

RUN apk update \ 
#    apk add --no-cache python2 python-dev py-pip python-pip py-virtualenv build-base build-dependencies
    apk add --no-cache --virtual \
        libcrypto1.1 \
        libssl1.1 \
        musl-utils \
        musl \
        bash \
        curl \
        tzdata
RUN apk add --no-cache --virtual jq musl-dev build-base build-dependencies linux-headers linux-kernel-headers
RUN apk add --no-cache py-pillow

#redis, nginx
RUN apk add --no-cache --virtual redis-server nginx
ADD kegbot.conf /etc/nginx/conf.d/default.conf
ADD nginx.conf /etc/nginx/nginx.conf

#kb
RUN mkdir /app
#WORKDIR /app
#ENV PATH="/app/bin:${PATH}"

ENV KEGBOT_VERSION=master
RUN apk add --no-cache --virtual curl tar \
     && curl -k -L https://github.com/Kegbot/kegbot-server/archive/${KEGBOT_VERSION}.tar.gz -o /tmp/kegbot.tar.gz \
     && tar -xf /tmp/kegbot.tar.gz -C /tmp/ \
     && ls -la /tmp/ \
     && cp -r /tmp/kegbot-server-${KEGBOT_VERSION}/* /app/ \
     && cp -r /tmp/kegbot-server-${KEGBOT_VERSION}/bin/* /bin/
     
RUN apk add --no-cache --virtual gcc musl-dev \
     && apk add --no-cache zlib-dev libjpeg-turbo libjpeg-turbo-dev libjpeg openjpeg \
     && apk add --no-cache mysql-client \
     && apk add --no-cache mariadb-dev
RUN ls -la ./ 
#RUN python /app/setup.py install 
#RUN apk del musl-dev gcc 
RUN rm -rf /tmp/kegbot*

RUN mkdir -p /etc/kegbot
COPY local_settings.py /etc/kegbot/

ADD     run.sh /run.sh
RUN     chmod 700 /run.sh

ENTRYPOINT ["/bin/sh"]
CMD     ["/run.sh"]
