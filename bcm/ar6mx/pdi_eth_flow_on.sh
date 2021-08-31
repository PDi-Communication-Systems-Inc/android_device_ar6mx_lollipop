#!/system/bin/sh
# Force flow control to be on.  Flow control is required to
# achieve greater than 3mbps when receiving UDP streams. It
# must be forced on because Cisco switches don't properly
# auto-negotiate it on.
 
TAG=FLOWCONTROL

# Wait for ethernet driver to load, 200 sec on first boot (less time after 
# first boot).
# Detect first boot by looking for the system.notfirstrun file created by the
# pdi_install_apk script.

if [ ! -e /data/system.notfirstrun ]; then    
    sleep 200
else
    sleep 25
fi

log -p i -t "$TAG" "Forcing ethernet flow control on. "
echo -e "Forcing ethernet flow control on.  \n"
  
/system/bin/ethtool -A eth0 rx on tx on

exit 0
