FROM ubuntu:focal

ENV branch=ubuntu
ENV distro=focal

WORKDIR /opt/z-way-server

RUN apt-get update && \
    apt-get install -qqy --no-install-recommends \
    ca-certificates curl \
    wget procps gpg iproute2 openssh-client logrotate

RUN wget -q -O - https://storage.z-wave.me/Z-Way-Install |bash
RUN rm -f /opt/z-way-server/automation/storage/*


RUN echo "ha" > /etc/z-way/box_type

COPY run.sh .
RUN chmod a+x run.sh



EXPOSE 8083

CMD /opt/z-way-server/run.sh
