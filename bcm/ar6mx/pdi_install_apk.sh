#!/system/bin/sh

TAG=INSTALL_APK

if [ ! -e /data/system.notfirstrun ]; then    
    # wait for the first boot sequence to finish, 205 sec
    sleep 205
    log -p i -t "$TAG" "Installing APK."
    echo -e "Installing APK.  \n"
  
    # Use "pm install" to install any APK's that would not work as a system app
    # This was done for dolfin.apk and I had to remove the .apk extension before including
    #  the APK file in the build.
    #/system/bin/sh /system/bin/pm install /system/preinstall/dolfin_apk

    touch /data/system.notfirstrun    

    # Indicate completion 
    log -p i -t "$TAG" "Done installing APK."
    echo -e "Done installing APK.  \n"
fi

exit 0
