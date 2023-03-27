#!/bin/bash

# If you are running Z-Way in docker without home assistant, specify the path to your interface here
device=/dev/ttyACM0

# Forcibly update the interface path in the user config configjson-XXXXXXXXXXXXXXXXXX at startup.
# Do not use this function if more than Z-Wave 1 interface is used
forceDevice=false

# By default remote access is on
remote_access=true
# And tech support access is not
remote_support_access=false

# Default config path
defCJ=/opt/z-way-server/automation/defaultConfigs/config.json

# If we find file options.json, we use the interface and options from this file
if [ -f "/data/options.json" ]; then
  # Get device path from Configuration tab of addon
  device=$(jq -r '.device | select(. != null)' /data/options.json)
  forceDevice=$(jq -r '.configjson_device_replace | select(. != null)' /data/options.json)
  remote_access=$(jq -r '.remote_access | select(. != null)' /data/options.json)
  remote_support_access=$(jq -r '.remote_support_access | select(. != null)' /data/options.json)
  zbw_password=$(jq -r '.zbw_password | select(. != null)' /data/options.json)
  local_ip=$(jq -r '.local_ip | select(. != null)' /data/options.json)
fi

# Change device path in /defailtConfig/config.json
sed -Ei "s|/dev/tty[A-Z]*[0-9]|$device|g" $defCJ

# Folders and files that we need to copy to the external /data directory
paths="/opt/z-way-server/automation/storage /opt/z-way-server/automation/userModules /opt/z-way-server/htdocs/smarthome/user/skin /opt/z-way-server/htdocs/smarthome/user/icons /etc/zbw"
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

# Use variable local_ip in ZBW (for find.z-wave.me) instead of the local IP as we can't get the IP outside the docker
echo "$local_ip" > /etc/zbw/local_ips
echo "8083" > /etc/zbw/local_port

# And force Z-Way to report the same domain instead of the IP
echo "\"$local_ip\"" > /opt/z-way-server/automation/localIP.json

# Check if remote access for support enable
if [ $remote_support_access ]; then
  touch /etc/zbw/flags/forward_ssh
else
  rm /etc/zbw/flags/forward_ssh
fi

# Change support user default password
if [ -n "$zbw_password" ]; then
  echo "support:$zbw_password" | chpasswd
fi

# If remote access enable start zbw_connect
if [ $remote_access ]; then
  rm /etc/zbw/flags/no_connection
else
  touch /etc/zbw/flags/no_connection
fi

# Starting Z-Way services
/etc/init.d/mongoose start
/etc/init.d/z-way-server start
/etc/init.d/zbw_connect start
service ssh start

# colored log output
tail --pid `cat /var/run/z-way-server.pid` -F /var/log/z-way-server.log | /opt/z-way-server/colorize-log.sh
