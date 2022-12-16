FROM ubuntu:focal

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV branch=ubuntu
ENV distro=focal

WORKDIR /opt/z-way-server

RUN apt-get update && \
    apt-get install -y wget procps gpg libcurl4 logrotate tzdata

# Add Z-Wave.Me repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 5b2f88a91611e683 && \
    echo "deb https://repo.z-wave.me/z-way/$branch $distro main" > /etc/apt/sources.list.d/z-wave-me.list

# Update packages list
RUN apt-get update && \
    apt-get install -y z-way-server zbw

COPY run_amd.sh .
RUN chmod a+x run_amd.sh



EXPOSE 8083

CMD /opt/z-way-server/run_amd.sh
