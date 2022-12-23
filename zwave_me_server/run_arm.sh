#!/bin/bash

# get device path from Configuration tab of addon
d=$(grep -Eo '\/dev\/tty[A-z]*[0-9]' /data/options.json)

ln -s $d /dev/zwave

# change device path in /defailtConfig/config.json
sed -Ei "s|/dev/tty[A-Z]*[0-9]|/dev/zwave|g" /opt/z-way-server/automation/defaultConfigs/config.json

# copy files the first boot and link paths to /data on each boot
for path in /opt/z-way-server/automation/storage/ /opt/z-way-server/config/zddx/ /opt/z-way-server/automation/userModules/ /etc/init.d/ /etc/z-way/ /etc/zbw/; do
  if [ -f $path -a ! -f /data/$path ]; then
    cp -R $path /data/$path
  fi
  rm -rf $path && ln -s /data/$path $path
done

# start
/etc/init.d/zbw start
/etc/init.d/mongoose start
/etc/init.d/z-way-server start

# colored log
tail --pid `cat /var/run/z-way-server.pid` -F /var/log/z-way-server.log | /opt/z-way-server/colorize-log.sh
