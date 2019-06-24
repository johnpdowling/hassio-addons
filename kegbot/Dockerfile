ARG BUILD_FROM=hassioaddons/base:3.1.0
FROM ${BUILD_FROM}
#FROM python:2.7-stretch

RUN apk update && \
    apk add --no-cache build-base python2 python-dev py-pip py-setuptools py-virtualenv py-mysqldb

#nginx
RUN apk add --no-cache nginx redis
ADD kegbot.conf /etc/nginx/conf.d/default.conf
ADD nginx.conf /etc/nginx/nginx.conf

#kb
COPY setup.py /     
RUN mkdir /app
#WORKDIR /app
ENV PATH="/app/bin:${PATH}"
ENV PYTHONPATH="/app:${PYTHONPATH}"

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
     && cp -r /app/bin/* /bin/

RUN pip install -U gunicorn
RUN pip install -U celery
RUN pip install -U redis
RUN pip install -U kegbot

WORKDIR /app
RUN python /app/setup.py install 
#RUN apk del musl-dev gcc 
RUN rm -rf /tmp/kegbot*

RUN mkdir -p /config/kegbot
COPY local_settings.py /config/kegbot/

ADD     run.sh /run.sh
RUN     chmod 700 /run.sh

ENTRYPOINT ["/bin/sh"]
CMD     ["/run.sh"]
