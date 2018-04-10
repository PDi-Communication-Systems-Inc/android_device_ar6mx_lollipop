#!/system/bin/sh
TAG=AUDIO_PREF_SETUP

if [[ -z /data/system/audio_pass_through_pref]]
   then
   log -p i "$TAG" "audio_pass_through_pref does not exist, copying"
   echo -e "audio_pass_through_pref does not exist, copying\n"
   cp /system/etc/audio_pass_through_pref /data/system/audio_pass_through_pref
   chmod 0664 /data/system/audio_pass_through_pref
else
   log -p i "$TAG" "audio_pass_through_pref already exists"
   echo -e "audio_pass_through_pref  already exists\n"
fi
