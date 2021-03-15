#!/system/bin/sh
TAG=OTA_SETUP

if [[ -z /data/system/ota.conf ]]
   then
   log -p i -t "$TAG" "ota.conf does not exist, copying"
   echo -e "ota.conf does not exist, copying  \n"
   cp /system/etc/ota.conf /data/system/ota.conf
else
   log -p i -t "$TAG" "ota.conf already exists"
   echo -e "ota.conf already exists  \n"
fi
