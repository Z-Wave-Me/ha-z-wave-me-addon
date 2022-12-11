#!/bin/bash
/etc/init.d/zbw_connect start
/etc/init.d/mongoose start
/etc/init.d/z-way-server start

tail -F /var/log/z-way-server.log