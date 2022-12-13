#!/usr/bin/with-contenv bashio
/etc/init.d/z-way-server start
tail --pid `cat /var/run/z-way-server.pid` -n +1 -F /var/log/z-way-server.log