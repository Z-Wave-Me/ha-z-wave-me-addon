#!/bin/bash
/etc/init.d/z-way-server start
tail --pid `cat /var/run/z-way-server.pid` -F /var/log/z-way-server.log