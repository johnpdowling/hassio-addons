ARG BUILD_FROM=hassioaddons/base:3.1.0
FROM ${BUILD_FROM}

RUN apk update \ 
    apk add --no-cache --virtual bash python python-dev py-pip python-pip
    
#redis, nginx
RUN apk add --no-cache --virtual redis-server nginx
ADD kegbot.conf /etc/nginx/conf.d/default.conf
ADD nginx.conf /etc/nginx/nginx.conf

RUN mkdir /app
WORKDIR /app

#kb
ENV KEGBOT_VERSION=master
RUN apk add --no-cache --virtual curl \
     && curl -k -L https://github.com/Kegbot/kegbot-server/archive/${KEGBOT_VERSION}.tar.gz -o /tmp/kegbot.tar.gz \
     && tar -xf /tmp/kegbot.tar.gz -C /tmp/ \
     && ls -la /tmp/ \
     && cp -r /tmp/kegbot-server-${KEGBOT_VERSION}/* /app/
RUN apk add --no-cache --virtual gcc musl-dev \
     && apk add zlib-dev libjpeg-turbo libjpeg-turbo-dev libjpeg openjpeg \
     && apk add mysql-client \
     && apk add mariadb-dev
RUN ls -la ./ 
RUN python /app/setup.py install 
RUN apk del musl-dev gcc 
RUN rm -rf /tmp/kegbot*

RUN mkdir -p /etc/kegbot
COPY local_settings.py /etc/kegbot/

ADD     run.sh /run.sh
RUN     chmod 700 /run.sh

ENTRYPOINT ["/bin/sh"]
CMD     ["/run.sh"]
