#!/bin/bash
/etc/init.d/zbw_connect start
/etc/init.d/mongoose start
/etc/init.d/z-way-server start

tail --pid `cat /var/run/z-way-server.pid` -n +1 -F /var/log/z-way-server.log | /opt/z-way-server/colorize-log.sh -q