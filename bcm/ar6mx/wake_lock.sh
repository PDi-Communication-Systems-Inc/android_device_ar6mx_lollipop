#!/system/bin/sh

# Never let the kernel sleep
echo pdi_never_sleep > /sys/power/wake_lock
