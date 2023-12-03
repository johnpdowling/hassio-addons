ARG BUILD_FROM
FROM $BUILD_FROM

ENV WG_PORT=53255

VOLUME /etc/localtime:/etc/localtime:ro

# Install requirements for add-on
RUN \
  apk add --no-cache \
    python3 py3-pip
RUN \
  pip install \
    requests_aws4auth boto3 flask warrant 

# Copy data for add-on
COPY run.sh /
COPY waterguru_flask.py /
RUN chmod a+x /run.sh
RUN chmod a+x /waterguru_flask.py

CMD [ "/run.sh" ]
