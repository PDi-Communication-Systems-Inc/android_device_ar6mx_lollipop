#!/system/bin/sh

# A fairly rough way to separate off the bootargs
# this might need improvement in the future
# for now just interested in the board version

CMDLINE=`cat /proc/cmdline`
echo cmdline=$CMDLINE
for bootarg in $CMDLINE;
   do
      BOOTARG_VALUE=$bootarg
      echo BOOTARG value is $BOOTARG_VALUE
      (IFS='=';
       KEY='' 
       for kv in $BOOTARG_VALUE;
          do
             echo "$kv";
             if [ -z $KEY]; then
                KEY=pdiarm.cmdline.$kv
             else
                VALUE=$kv
                setprop $KEY $VALUE
                break
             fi
          done);   
   done
