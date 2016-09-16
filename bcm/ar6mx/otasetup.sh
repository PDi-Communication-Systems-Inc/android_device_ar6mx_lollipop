#!/system/bin/sh

if [[ -z /data/system/ota.conf ]]
   then
   echo -e "ota.conf does not exist, copying\n"
   cp /system/etc/ota.conf /data/system/ota.conf
else
   echo -e "ota.conf already exists\n"
fi
