ARG BUILD_FROM=hassioaddons/base:3.1.0
FROM ${BUILD_FROM}

RUN apk update \ 
    apk add bash python python-dev py-pip
    
#redis, nginx
RUN apk add redis-server
            nginx
ADD kegbot.conf /etc/nginx/conf.d/default.conf
ADD nginx.conf /etc/nginx/nginx.conf

RUN mkdir /app
WORKDIR /app

#kb
ENV KEGBOT_VERSION=master
RUN  apk add curl \
     && curl -k -L https://github.com/Kegbot/kegbot-server/archive/${KEGBOT_VERSION}.tar.gz -o /tmp/kegbot.tar.gz \
     && tar -xf /tmp/kegbot.tar.gz -C /tmp/ \
     && ls -la /tmp/ \
     && cp -r /tmp/kegbot-server-${KEGBOT_VERSION}/* /app/ \
     && apk add gcc musl-dev \
     && apk add zlib-dev libjpeg-turbo libjpeg-turbo-dev libjpeg openjpeg \
     && apk add mysql-client \
     && apk add mariadb-dev \
     && ls -la ./ \
     && python ./setup.py install \
     && apk del musl-dev gcc \
     && rm -rf /tmp/kegbot*

RUN mkdir -p /etc/kegbot
COPY local_settings.py /etc/kegbot/

ADD     run.sh /run.sh
RUN     chmod 700 /run.sh

ENTRYPOINT ["/bin/sh"]
CMD     ["/run.sh"]