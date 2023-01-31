#!/bin/bash

# If you are running Z-Way in docker without home assistant, specify the path to your interface here
device=/dev/ttyACM0

# Forcibly update the interface path in the user config configjson-XXXXXXXXXXXXXXXXXX at startup.
# Do not use this function if more than Z-Wave 1 interface is used
forceDevice=false

# Default config path
defCJ=/opt/z-way-server/automation/defaultConfigs/config.json

# If we find file options.json, we use the interface and options from this file
if [ -f "/data/options.json" ]; then
  # Get device path from Configuration tab of addon
  device=$(grep -Eo '/dev/tty[A-Z]*[0-9]' /data/options.json)
  forceDevice=$(grep "configjson_device_replace" /data/options.json | cut -d ":" -f 2)
fi

# Change device path in /defailtConfig/config.json
sed -Ei "s|/dev/tty[A-Z]*[0-9]|$device|g" $defCJ

# Folders and files that we need to copy to the external /data directory
paths="/opt/z-way-server/automation/storage /opt/z-way-server/automation/userModules /etc/zbw /etc/init.d/zbw_connect /opt/z-way-server/automation/.syscommands"
for path in $paths; do
  # Сheck the presence of the /data/ folder and the original server directories.
  if [ -e $path -a ! -e /data/$path ]; then
    # Make folders from the path variable with the exception of the last folder in the path
    mkdir -p /data/`dirname $path`
    # Moving files and folders from the standard directory to the /data folder
    mv $path /data/$path
  else
    rm -rf $path
  fi
# Creating symlinks to the objects that we moved
  ln -sf /data$path $path
done

# User configjson file path
userCJ=$(ls /opt/z-way-server/automation/storage/configjson-*)

# If we can't find configjson file in /data dirrectory we think this is first start and generate new remote ID
if [ ! -f /data$userCJ ]; then 
  wget 'http://find.z-wave.me/zbw_new_user?box_type=razberry' -O /tmp/zbw_connect_setup.run 
  bash /tmp/zbw_connect_setup.run -y
fi

# If force device selection checked and /storage/configjson-* exists, replace the path in it too
if [ -f /opt/z-way-server/automation/storage/configjson-* ] && [ $forceDevice ]; then
  sed -Ei "s|/dev/tty[A-Z]*[0-9]|$device|g" $userCJ
fi

# Change default config directory to configs/config for compatility with Docker, HA and Hub
if [ -e /opt/z-way-server/config -a ! -e /data/opt/z-way-server/configs/config ]; then
  # Change config path in defaultConfigs/config.json from config to configs/config
  sed -i 's|"config": "config"|"config": "configs/config"|g' $defCJ
  # Make configs folder in external /data folder
  mkdir -p /data/opt/z-way-server/configs/
  # Move config folder from default docker image to external folder
  mv /opt/z-way-server/config/ /data/opt/z-way-server/configs/
else
  # Jut remove config folder from docker image dirrectory
  rm -rf /opt/z-way-server/config/
fi
# Make simlinks
ln -sf /data/opt/z-way-server/configs/ /opt/z-way-server/


IFACE_BLACKLIST_MASK='^lo$|^veth|^docker|^hassio'
# Get network interfaces
IFACES=`ls -1 /sys/class/net | grep -Ev "$IFACE_BLACKLIST_MASK"`

for i in $IFACES; do
  LOCAL_IP=`ip a show dev $i | sed -nre 's/^\s+inet ([0-9.]+).+$/\1/; T n; p; :n'`
  LOCAL_IPS="$LOCAL_IPS $LOCAL_IP"
done

  # i think filtering out only 127.0.0.1 address is sufficient
ZBW_INTERNAL_IP=""
for i in $LOCAL_IPS; do
  if [[ $ZBW_INTERNAL_IP ]]; then
    ZBW_INTERNAL_IP="$ZBW_INTERNAL_IP,$i";
  else
    ZBW_INTERNAL_IP="$i";
  fi
done
echo $LOCAL_IPS > /etc/zbw/local_ip

# Starting services
/etc/init.d/dbus start
#/etc/init.d/avahi-daemon start
/etc/init.d/mongoose start
/etc/init.d/z-way-server start
/etc/init.d/zbw_connect start

# colored log output
tail --pid `cat /var/run/z-way-server.pid` -F /var/log/z-way-server.log | /opt/z-way-server/colorize-log.sh
