#!/bin/bash
/etc/init.d/z-way-server start
while [ -e /proc/`cat /var/run/z-way-server.pid` ]; do sleep 1; done