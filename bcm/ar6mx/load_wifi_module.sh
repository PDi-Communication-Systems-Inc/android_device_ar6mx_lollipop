#!/system/bin/sh
    # wireless
    insmod /system/lib/modules/compat.ko
    insmod /system/lib/modules/cfg80211.ko
    insmod /system/lib/modules/mac80211.ko
    # atheros
    insmod /system/lib/modules/ath.ko
    # ath9k
    insmod /system/lib/modules/ath9k_hw.ko
    insmod /system/lib/modules/ath9k_common.ko
    /system/bin/busybox sleep 2
    insmod /system/lib/modules/ath9k.ko

    # intel
    insmod /system/lib/modules/iwlwifi.ko
    /system/bin/busybox sleep 2
    insmod /system/lib/modules/iwlmvm.ko
    /system/bin/busybox sleep 2
    insmod /system/lib/modules/iwldvm.ko
    # btusb
    insmod /system/lib/modules/bluetooth.ko
    insmod /system/lib/modules/rfcomm.ko
    insmod /system/lib/modules/bnep.ko
    insmod /system/lib/modules/btusb.ko
    /system/bin/busybox sleep 1
    hciconfig hci0 up
