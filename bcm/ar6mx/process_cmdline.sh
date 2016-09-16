#!/system/bin/sh

# A fairly rough way to separate off the bootargs
# this might need improvement in the future
# for now just interested in the board version

CMDLINE=`cat /proc/cmdline`
echo -e "cmdline=$CMDLINE\n"
for bootarg in $CMDLINE;
   do
      BOOTARG_VALUE=$bootarg
      echo -e "BOOTARG value is $BOOTARG_VALUE\n"
      (IFS='=';
       KEY='' 
       for kv in $BOOTARG_VALUE;
          do
             echo -e "key is $kv\n";
             if [ -z $KEY]; then
                KEY=pdiarm.cmdline.$kv
             else
                VALUE=$kv
                echo -e "setting property $KEY=$VALUE\n"
                setprop $KEY $VALUE
                break
             fi
          done);   
   done
