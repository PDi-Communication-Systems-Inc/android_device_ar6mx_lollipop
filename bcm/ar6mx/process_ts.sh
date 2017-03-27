#!/system/bin/sh

# Test for Atmel or EETI touchscreen
BIN=/system/bin
COUNT=`$BIN/lsusb | $BIN/grep -i atmel | $BIN/busybox wc -l`
DONE=false
TAG=PROCESS_TOUCHSCREEN

# Atmel touchscreen handling
if [ $COUNT -ge "1" ];
  then
      # try to reset Atmel MXT1664S1 up to five times
      log -p i "$TAG" "$COUNT Atmel Touchscreen discovered"
      echo -e "$COUNT Atmel Touchscreen discovered\n"
      setprop pdiarm.touchscreen Atmel
 
      # Figure out where the Atmel touchscreen is on the usb bus
      PATH=`$BIN/lsusb | $BIN/grep -i Atmel | $BIN/busybox cut -d " " -f 1`
      # Simulating reconnect to CN5 port 
      "$BIN"/usbreset "$PATH"
      # Send USB packet to Atmel chip to reset itself
      "$BIN"/mxt-app -v 4 --reset

      RESULT=$?	
      let COUNTER=0
      if [ $RESULT -gt "0" ];
         then
         while [ $COUNTER -lt 5 ]; do
            log -p e "$TAG" "Reset failed with result code $RESULT ... Retrying mxt-app reset, try $COUNTER"
            echo -e "Reset failed with result code $RESULT ... Retrying mxt-app reset, try $COUNTER\n"
            # Figure out where the Atmel touchscreen is on the usb bus
            PATH=`$BIN/lsusb | $BIN/grep -i Atmel | $BIN/busybox cut -d " " -f 1`

            # Simulating reconnect to CN5 port 
            "$BIN"/usbreset "$PATH"
            # Send USB packet to Atmel chip to reset itself
            "$BIN"/mxt-app -v 4 --reset 

            # Check to see if we need to repeat process
            RESULT=$?
            if [ $RESULT -eq "0" ];  
               then
               # stop any additional attempts and display info on Atmel chip
               let COUNTER=100
               "$BIN"/mxt-app -i
            else
               # try again
               let COUNTER=COUNTER+1
            fi  
         done
      else
            log -p i "$TAG" "Atmel initalized okay with result code $RESULT"
	    echo -e "Atmel initalized okay with result code $RESULT\n"
      fi  
      # For Atmel touchscreens we need to disable the egalax touchscreen 
      PROCESS=`$BIN/ps | $BIN/grep eGTouchD | $BIN/busybox tr -s " " | $BIN/busybox cut -d " " -f 2`
      if [ $PROCESS -gt "0" ];
         then
             log -p i "$TAG" "killing process $PROCESS"
             echo -e "killing process $PROCESS\n"
             kill $PROCESS 
      else
          log -p e "$TAG" "No process to call the kill command on"
          echo -e "No process to call the kill command on\n"
      fi

      DONE=true
fi

# EETI touchscreen handling
COUNT=`$BIN/lsusb | $BIN/grep -i egalax | $BIN/busybox wc -l`
if [ $COUNT -ge "1" ];
   then
       log -p i "$TAG" "$COUNT eGalax Touchscreen discovered, resetting usb controller"
       echo -e "$COUNT eGalax Touchscreen discovered, resetting usb controller\n"
       # Reset entire controller touchscreen is connected to
       # vid=0x58f Alcor Micro controller, pid=6254 -- generic USB Hub
       (sleep 10; usbreset 058f:6254) &

       log -p i "$TAG" "Resetting touchscreen device"
       echo -e "Resetting touchscreen device\n"
       DEVICEID=`lsusb | busybox grep eGalax | busybox cut -d':' -f3 | busybox cut -c1-4`
       # Reset device itself 0x0eef=eGalax, 0xa04d/0xc000 (EXC3147-3430) 
       # USB Touchscreen Controller
       if [ $DEVICEID == "a04d" ];
          then
             (sleep 15; usbreset 0eef:$DEVICEID) &
       elif [ $DEVICEID == "0xc000" ] 
           then
              log -p i "$TAG" "$DEVICEID does not like to reset after bus, not doing reset"
       else
              log -p i "$TAG" "Unknown EGalax touchscreen $DEVICEID not doing reset"
       fi
       setprop pdiarm.touchscreen eGalax-$DEVICEID
>>>>>>> f7cfb0e... New EGalax Touchscreen does not like to reset after bus, locks up
       DONE=true
fi

# Indicate completion of touchscreen processing
if [ $DONE == "true" ];
   then
      PROP="$("$BIN"/getprop pdiarm.touchscreen)"
      log -p i "$TAG" "Done with touchscreen processing $PROP"
      echo -e "Done with touchscreen processing $PROP\n"
      exit 0
fi

# if nothing found assume i2c touchscreen
I2CDETECTCMD=`i2cdetect -y 1 0x4a 0x4a | busybox cut -d : -f2 | busybox tail +6 | busybox tr -d '[[:space:]]'`
log -p i "$TAG" "Result of i2c detection is $I2CDETECTCMD"
echo -e "Result of i2c detection is $I2CDETECTCMD\n"
if [ $I2CDETECTCMD == "4a" ];
   then
      # load i2c touchscreen 
      RESULT=`insmod /system/lib/modules/atmel_mxt_ts.ko`
      if [ $RESULT -ne "0" ];
      then
         log -p e "$TAG" "Driver failed to load properly, trying to remove"
         echo -e "Driver failed to load properly, trying to remove\n"
         rmmod atmel_mxt_ts.ko
      fi

      # remove eGalax USB Touch Daemon process 
      PROCESS=`$BIN/ps | $BIN/grep eGTouchD | $BIN/busybox tr -s " " | $BIN/busybox cut -d " " -f 2`
      log -p i "$TAG" "killing process $PROCESS"
      echo -e "killing process $PROCESS\n"
      kill $PROCESS

      # indicate the i2c touchscreen has been setup via properties
      NAME=`cat /sys/bus/i2c/devices/1-004a/name`
      log -p i "$TAG" "found touchscreen $NAME"
      echo -e "found touchscreen $NAME\n"
      setprop pdiarm.touchscreen $NAME
      PROP=`$BIN"/getprop pdiarm.touchscreen`
      echo -e "Done with touchscreen processing $PROP\n"
elif [ $I2CDETECTCMD == "UU" ] 
     then
         # indicate the i2c touchscreen has been setup via properties
         NAME=`cat /sys/bus/i2c/devices/1-004a/name`
         log -p i "$TAG" "found touchscreen $NAME"
         echo -e "found touchscreen $NAME \n"
         setprop pdiarm.touchscreen $NAME
         PROP=`$BIN/getprop pdiarm.touchscreen`
         log -p i "$TAG" "Done with touchscreen processing $PROP"
         echo -e "Done with touchscreen processing $PROP\n"

         DONE=true
	 exit 126
else
   log -p w "i2c touchscreen not present"
   echo -e "i2c touchscreen not present\n"
   DONE=true 
   exit 131
fi

# Indicate completion of touchscreen processing
if [ $DONE == "true" ];
   then
      PROP="$("$BIN"/getprop pdiarm.touchscreen)"
      log -p i "Done with touchscreen processing $PROP"
      echo -e "Done with touchscreen processing $PROP\n"
      exit 0
fi
