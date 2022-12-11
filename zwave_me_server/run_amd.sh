#!/bin/bash
/etc/init.d/z-way-server start
tail -F /var/log/z-way-server.log