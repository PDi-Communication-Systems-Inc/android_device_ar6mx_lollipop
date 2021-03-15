#!/system/bin/sh

# A fairly rough way to separate off the bootargs
# this might need improvement in the future
# for now just interested in the board version

# exec >(busybox tee -i /cache/process_cmdline.txt)
# exec 2>&1

CMDLINE=`cat /proc/cmdline`
TAG=PROCESS_CMDLINE
log -p i -t "$TAG" "cmdline=$CMDLINE"
echo -e "cmdline=$CMDLINE  \n"
for bootarg in $CMDLINE;
   do
      BOOTARG_VALUE=$bootarg
      log -p i -t "$TAG" "BOOTARG VALUE is $BOOTARG_VALUE"
      echo -e "BOOTARG value is $BOOTARG_VALUE  \n"
      (IFS='=';
       KEY='' 
       for kv in $BOOTARG_VALUE;
          do
	     log -p i -t "$TAG" "key is $kv"
             echo -e "key is $kv  \n";
             if [ -z $KEY]; then
                KEY=pdiarm.cmdline.$kv
             else
                VALUE=$kv
		log -p i -t "$TAG" "setting property $KEY=$VALUE"
                echo -e "setting property $KEY=$VALUE  \n"
                setprop $KEY $VALUE
                break
             fi
          done);   
   done
