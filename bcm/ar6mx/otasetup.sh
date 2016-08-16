#!/system/bin/sh

if [[ -z /data/system/ota.conf ]]
   then
   echo "ota.conf does not exist, copying"
   cp /system/etc/ota.conf /data/system/ota.conf
else
   echo "ota.conf already exists"
fi
