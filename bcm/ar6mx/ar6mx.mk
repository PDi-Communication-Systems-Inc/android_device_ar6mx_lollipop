# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx6/imx6.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

# Overrides -- These values are not to be changed
PRODUCT_NAME := ar6mx
PRODUCT_DEVICE := ar6mx
PRODUCT_MANUFACTURER := PDi Communication Systems, Inc.
PRODUCT_BRAND := PDi-Tab
PRODUCT_MODEL := PD403-008

PRODUCT_PROPERTY_OVERRIDES += \
			hw.nobattery=true \
			sys.device.type=tablet

PRODUCT_COPY_FILES += \
        device/bcm/ar6mx/init.rc:root/init.freescale.rc \
        device/bcm/ar6mx/gpsreset.sh:system/etc/gpsreset.sh \
        device/bcm/ar6mx/audio_policy.conf:system/etc/audio_policy.conf \
        device/bcm/ar6mx/audio_effects.conf:system/vendor/etc/audio_effects.conf \
        device/bcm/ar6mx/load_wifi_module.sh:system/etc/load_wifi_module.sh \
        device/bcm/ar6mx/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf \
	device/bcm/ar6mx/device_policies.xml:system/etc/device_policies.xml \
	device/bcm/ar6mx/copy_device_policies.sh:system/etc/copy_device_policies.sh

PRODUCT_COPY_FILES +=	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx6d.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx6q.bin

# setup dm-verity configs.
ifneq ($(BUILD_TARGET_DEVICE),sd)
  PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/mmcblk3p5
$(warning Setting system verity partition to mmcblk3p5)
$(call inherit-product, build/target/product/verity.mk)
else 
 PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/mmcblk2p5
$(warning Setting system verity parition to mmblk2p5)
$(call inherit-product, build/target/product/verity.mk)
endif

#endif

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/bcm/ar6mx/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi xhdpi

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.hardware.faketouch.xml:system/etc/permissions/android.hardware.faketouch.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
	frameworks/native/data/etc/android.hardware.consumerir.xml:system/etc/permissions/android.hardware.consumerir.xml \
	frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
	device/bcm/ar6mx/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/bcm/ar6mx/ota.conf:system/etc/ota.conf \
	device/bcm/ar6mx/ota.conf:data/system/ota.conf

#PDi additions
PRODUCT_COPY_FILES += \
 	device/bcm/ar6mx/process_ts.sh:system/etc/process_ts.sh \
        device/bcm/ar6mx/process_cmdline.sh:system/etc/process_cmdline.sh \
	device/bcm/ar6mx/otasetup.sh:system/etc/otasetup.sh \
        device/bcm/EETI/eGalaxTouch_VirtualDevice.idc:system/usr/idc/eGalaxTouch_VirtualDevice.idc \
        device/bcm/EETI/eGTouchA.ini:data/eGTouchA.ini \
        device/bcm/EETI/eGTouchD:system/bin/eGTouchD \
	kernel_imx/drivers/input/touchscreen/atmel_mxt_ts.ko:/system/lib/modules/atmel_mxt_ts.ko \
	device/bcm/ar6mx/common/input/Atmel_maXTouch_Touchscreen.idc:system/usr/idc/Atmel_maXTouch_Touchscreen.idc \
	device/bcm/ar6mx/common/input/touchscreen.xcfg:/system/etc/touchscreen.xcfg \
	vendor/pdi/data/bootanimation.zip:system/media/bootanimation.zip

# PDi Core Packages
PRODUCT_PACKAGES += AudioRoute							\
		    AdobeReader 						\
		    org.jtb.alogcat_43						\
		    ReplicaIsland						\
		    org.wikipedia						\
		    net.micode.fileexplorer 					\
		    com.mobilepearls.sokoban					\
		    com.example.puzzlegame					\
		    org.moire.opensudoku.game					\
		    com.mobilepearls.memory					\
		    maxtouch							\
		    libmaxtouch-jni						\
		    libusbdroid							\
		    mxt-app							\
		    usbreset							\
                    libusb1.0							\
                    i2c-tools							\
		    i2cdetect							\
		    i2cget							\
		    i2cset							\
		    i2cdump							\
		    HoloSpiralWallpaper						\
		    Galaxy4							\
		    MagicSmokeWallpapers					\
		    VisualizationWallpapers					\
		    NoiseField							\
		    PhaseBeam							\
		    WebViewDream						\
		    org.androidappdev.wifiwidget				\
		    org.tomdroid						\
		    todoTxtTouch						\
		    jackpal.androidterm 					\
		    libjackpal-termexec2					\
		    libjackpal-androidterm5					\
		    alogcat							\
		    com.uberspot.a2048						\
		    org.petero.droidfish-1.61-69 				\
		    fbreader							\
		    frozenbubble						\
		    libmodplug-1.0						\
		    ghostcommander						\
		    k9								\
		    hn-android							\
		    com.kmagic.solitaire_450					\
		    VLC								\
		    raidl							\
		    iperf                                                       \
                    com.pdiarm.newuserconfirmation				\
		    PicoTts							\
		    PicoLangInstaller

# TVRC Branch Specific Packages
PRODUCT_PACKAGES += omicron-V1_2_4                                         

# for Compat driver
PRODUCT_COPY_FILES += \
	device/bcm/ar6mx/p2p_supplicant.conf:system/etc/wifi/p2p_supplicant.conf

# Add sample data files
PRODUCT_COPY_FILES += \
                  vendor/pdi/data/littlewomenormeg00alcoiala.epub:system/media/text/littlewomenormeg00alcoiala.epub

# include firmware binaries for Wifi adapters
#$(call inherit-product-if-exists, vendor/linux-firmware/iwlwifi.mk)
$(call inherit-product,$(LOCAL_PATH)/firmware.mk)

PRODUCT_PROPERTY_OVERRIDES += \
        wifi.interface=wlan0


# Including SuperUser in TVRC builds
SUPERUSER_PACKAGE := com.bcm.superuser
SUPERUSER_PACKAGE_PREFIX := .cyanogenmod.superuser
SUPERUSER_EMBEDDED := true

PRODUCT_PACKAGES += devregs   \
		    inputRead \
		    su

PRODUCT_COPY_FILES += device/bcm/init.superuser.rc:root/init.superuser.rc	\
		      device/bcm/ar6mx/devregs_imx6x.dat:/system/etc/devregs_imx6x.dat

# Wireless packages
PRODUCT_PACKAGES += IWLWIFI 			\
	            iwlwifi.ko			\
		    hcitool			\
		    hciconfig			\
		    rctest			\
		    l2ping			\
		    l2test			\
		    btmgmt

# Video for Linux Packages
PRODUCT_PACKAGES += v4l2-ctl			\
		    v4l2-dbg                    \
		    v4l2-compliance             \
		    libv4l2                     \
		    libv4l_convert              \
                    hostapd                     \
                    hostapd_cli                 \
                    wpa_supplicant              \
                    wpa_cli

# Additional native troubleshooting tools
PRODUCT_PACKAGES += librank			\
		    procmem                     \
		    procrank                    \
		    showmap                     \
		    latencytop			\
		    strace

# Add PDi internal closed source packages
PRODUCT_PACKAGES += com.pdiarm.managemyaccount
			
ifneq ($(AIO_CONFIGURATION),T)
$(warning Including PDi TV App)
# PRODUCT_PACKAGES += pdiarm.com.camerapreview
endif

PRODUCT_DEFAULT_DEV_CERTIFICATE := \
				vendor/pdi/security/ar6mx/releasekey
#copy iwlwifi wpa config files
PRODUCT_COPY_FILES += \
        device/bcm/common/wlan/wpa_supplicant-common.conf:system/etc/wifi/wpa_supplicant.conf \
        device/bcm/common/wlan/iwlwifi/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf
