#!/bin/bash

#get device path from Configuration tab of addon
d=$(grep -Eo '\/dev\/tty[A-z]*[0-9]' /data/options.json)

# change device path in /defailtConfig/config.json
sed -Ei "s|/dev/tty[A-Z]*[0-9]|$d|g" /opt/z-way-server/automation/defaultConfigs/config.json

# if /storage/configjson-* exists, replace the path in it too
if [ -f /opt/z-way-server/automation/storage/configjson-* ]; then
  cj=$(ls /opt/z-way-server/automation/storage/configjson-*)
  sed -Ei "s|/dev/tty[A-Z]*[0-9]|$d|g" $cj
fi

echo -n "Selected device in configjson: "  ; grep -Eo '\/dev\/tty[A-z]*[0-9]' $cj
echo -n "Selected device in config.json: " ; grep -Eo '\/dev\/tty[A-z]*[0-9]' /opt/z-way-server/automation/defaultConfigs/config.json
echo -n "Selected device in options.json: "; grep -Eo '\/dev\/tty[A-z]*[0-9]' /data/options.json

#make storage folders
mkdir -p /data/opt/z-way-server/automation/storage/
mkdir -p /data/opt/z-way-server/config/zddx/
mkdir -p /data/opt/z-way-server/automation/userModules/
mkdir -p /data/etc/init.d/
mkdir -p /data/etc/zbw/
mkdir -p /data/etc/z-way/

#save data to /data/z-way-server
rm -rf /opt/z-way-server/automation/storage/		&&	ln -sf /data/opt/z-way-server/automation/storage/ /opt/z-way-server/automation/
rm -rf /opt/z-way-server/config/zddx/			&&	ln -sf /data/opt/z-way-server/config/zddx/ /opt/z-way-server/config/
rm -rf /opt/z-way-server/automation/userModules/	&&	ln -sf /data/opt/z-way-server/automation/userModules/ /opt/z-way-server/automation/

if [ ! -f /data/etc/init.d/z-way-server ] || [ ! -f /data/etc/init.d/zbw_connect ]; then
echo "First start detected"
cp /etc/init.d/z-way-server	/data/etc/init.d/z-way-server
cp /etc/init.d/zbw_connect	/data/etc/init.d/zbw_connect
cp -R /etc/zbw/			/data/etc/
cp -R /etc/z-way		/data/etc/
fi

rm -f /etc/init.d/z-way-server				&&	ln -sfT /data/etc/init.d/z-way-server /etc/init.d/z-way-server
rm -f /etc/init.d/zbw_connect				&&	ln -sfT /data/etc/init.d/zbw_connect /etc/init.d/zbw_connect
rm -rf /etc/zbw/					&&	ln -sf /data/etc/zbw/ /etc/
rm -rf /etc/z-way/					&&	ln -sf /data/etc/z-way/ /etc/


/etc/init.d/mongoose start
/etc/init.d/z-way-server start

tail --pid `cat /var/run/z-way-server.pid` -F /var/log/z-way-server.log | /opt/z-way-server/colorize-log.sh



