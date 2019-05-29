#ARG BUILD_FROM=hassioaddons/base:3.1.0
#FROM ${BUILD_FROM}
FROM python:2.7-stretch

RUN apt-get update
#    apk add --no-cache python2 python-dev py-pip python-pip py-virtualenv build-base build-dependencies
RUN apt-get install -y libssl-dev && \
    apt-get install -y musl && \
    apt-get install -y musl-dev && \
    apt-get install -y libc-dev && \
    apt-get install -y bash && \
    apt-get install -y curl && \
    apt-get install -y tzdata && \
    apt-get install -y jq && \
    apt-get install -y python-dev
#RUN apk add --no-cache py-pillow py-mysqldb

#redis, nginx
RUN apt-get install -y redis-server nginx
ADD kegbot.conf /etc/nginx/conf.d/default.conf
ADD nginx.conf /etc/nginx/nginx.conf

#kb
COPY setup.py /     
RUN mkdir /app
#WORKDIR /app
ENV PATH="/app/bin:${PATH}"
ENV PYTHONPATH="/app:${PYTHONPATH}"

ENV KEGBOT_VERSION=master
RUN apt-get install -y curl tar \
     && curl -k -L https://github.com/Kegbot/kegbot-server/archive/${KEGBOT_VERSION}.tar.gz -o /tmp/kegbot.tar.gz \
     && tar -xf /tmp/kegbot.tar.gz -C /tmp/ \
     && ls -la /tmp/ \
     && cp -r /tmp/kegbot-server-${KEGBOT_VERSION}/* /app/ \
     && cp -r /app/bin/* /bin/

RUN apt-get install -y gcc g++ zlib1g-dev && \
    apt-get install -y libturbojpeg0 libturbojpeg0-dev libjpeg-dev libopenjp2-7-dev
#RUN apt-get install -y libopenjpeg-dev libopenjp2-7-dev openjpeg-tools
RUN apt-get install -y mysql-client libmariadbclient-dev libmariadbd-dev

RUN ls -la ./ 
#RUN python /setup.py install 
#RUN apk del musl-dev gcc 
RUN rm -rf /tmp/kegbot*

RUN mkdir -p /etc/kegbot
COPY local_settings.py /etc/kegbot/

ADD     run.sh /run.sh
RUN     chmod 700 /run.sh

ENTRYPOINT ["/bin/sh"]
CMD     ["/run.sh"]
