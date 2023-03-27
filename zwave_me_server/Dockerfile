FROM ubuntu:focal

ENV branch=ubuntu
ENV distro=focal

WORKDIR /opt/z-way-server

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && \
    apt-get install -qqy --no-install-recommends \
    ca-certificates curl \
    wget procps gpg iproute2 openssh-client openssh-server sudo logrotate jq

RUN wget -q -O - https://storage.z-wave.me/Z-Way-Install |bash
RUN rm -f /opt/z-way-server/automation/storage/*

RUN useradd -rm -d /home/support -s /bin/bash -g root -G sudo -u 1000 support 
RUN  echo 'support:razberry' | chpasswd

RUN echo "ha" > /etc/z-way/box_type

RUN wget -O /opt/z-way-server/automation/classes/AutomationController.js https://raw.githubusercontent.com/Z-Wave-Me/home-automation/1c5ad7bb95453b5bb7749ad2d1e5907d6949ccc3/classes/AutomationController.js


COPY run.sh .
RUN chmod a+x run.sh

EXPOSE 8083
EXPOSE 8883

CMD /opt/z-way-server/run.sh
