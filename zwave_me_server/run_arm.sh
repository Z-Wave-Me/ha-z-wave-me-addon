#!/bin/bash

#make storage folders
mkdir -p /data/z-way-server/automation/storage/
mkdir -p /data/z-way-server/config/zddx/
mkdir -p /data/z-way-server/automation/userModules/

#save data to /data/z-way-server
rm -rf /opt/z-way-server/automation/storage/ && 	ln -s /data/z-way-server/automation/storage/ /opt/z-way-server/automation/
rm -rf /opt/z-way-server/config/zddx/ && 			ln -s /data/z-way-server/config/zddx/ /opt/z-way-server/config/
rm -rf /opt/z-way-server/automation/userModules/ && ln -s /data/z-way-server/automation/userModules/ /opt/z-way-server/automation/

/etc/init.d/zbw_connect start
/etc/init.d/mongoose start
/etc/init.d/z-way-server start

tail --pid `cat /var/run/z-way-server.pid` -F /var/log/z-way-server.log | /opt/z-way-server/colorize-log.sh



