FROM balenalib/rpi-raspbian

WORKDIR /opt/z-way-server

RUN apt-get update && \
    apt-get install -qqy --no-install-recommends \
    ca-certificates curl \
    wget procps gpg iproute2 openssh-client logrotate

RUN wget -q -O - https://storage.z-wave.me/RaspbianInstall |bash
COPY start.sh .
RUN chmod a+x start.sh

EXPOSE 8083

CMD /opt/z-way-server/start.sh
