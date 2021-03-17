#!/system/bin/sh

TAG=INSTALL_APK

if [ ! -e /data/system.notfirstrun ]; then    
    # wait for the first boot sequence to finish, 205 sec
    sleep 205
    log -p i -t "$TAG" "Installing dolfin APK."
    echo -e "Installing dolfin APK.  \n"
  
    /system/bin/sh /system/bin/pm install /system/preinstall/dolfin_apk

    touch /data/system.notfirstrun    

    # Indicate completion 
    log -p i -t "$TAG" "Done installing dolfin APK."
    echo -e "Done installing dolfin APK.  \n"
fi

exit 0
