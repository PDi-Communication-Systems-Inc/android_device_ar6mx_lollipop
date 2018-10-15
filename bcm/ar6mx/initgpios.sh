
cd /sys/class/gpio
echo 36 > export
cd gpio36
echo high > direction

cd /sys/class/gpio
echo 37 > export
cd gpio37
echo in > direction
chmod 777 /sys/class/gpio/gpio37/value
chmod 777 /sys/class/gpio/gpio37/direction
chown root system /sys/class/gpio/gpio37/value
chown root system /sys/class/gpio/gpio37/direction

cd /sys/class/gpio
echo 39 > export
cd gpio39
echo out > direction
chmod 777 /sys/class/gpio/gpio39/value
chmod 777 /sys/class/gpio/gpio39/direction
chown root system /sys/class/gpio/gpio39/value
chown root system /sys/class/gpio/gpio39/direction

cd /sys/class/gpio
echo 200 > export
cd gpio200
echo in > direction
chmod 777 /sys/class/gpio/gpio200/value
chmod 777 /sys/class/gpio/gpio200/direction
chown root system /sys/class/gpio/gpio200/value
chown root system /sys/class/gpio/gpio200/direction


/system/bin/internalSpeakers
