#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/bcm/ar6mx/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
# AR6MX default target for EXT4
BUILD_TARGET_FS = ext4

# AR6MX default target device(change to emmc for emmc boot)
ifeq ($(MAKE_SD_CARD),T)
$(warning Setting target device to sd)
   BUILD_TARGET_DEVICE = sd
else
$(warning Setting target device to emmc)
   BUILD_TARGET_DEVICE = emmc
endif

include device/fsl/imx6/imx6_target_fs.mk

ifeq ($(BUILD_TARGET_DEVICE),sd)
ADDITIONAL_BUILD_PROPERTIES += \
                        ro.boot.storage_type=sd
TARGET_RECOVERY_FSTAB = device/bcm/ar6mx/fstab.bcm.sd
PRODUCT_COPY_FILES +=	\
	device/bcm/ar6mx/fstab.bcm.sd:root/fstab.freescale
else
ADDITIONAL_BUILD_PROPERTIES += \
                        ro.boot.storage_type=emmc
TARGET_RECOVERY_FSTAB = device/bcm/ar6mx/fstab.bcm.emmc
PRODUCT_COPY_FILES +=	\
	device/bcm/ar6mx/fstab.bcm.emmc:root/fstab.freescale
endif # BUILD_TARGET_DEVICE


TARGET_BOOTLOADER_BOARD_NAME := AR6MX

# This enables the wpa wireless driver
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION := VER_2_1_DEVEL_WCS

# Enabling iwlwifi
BOARD_USING_INTEL_IWL := true
INTEL_IWL_MODULE_SUB_FOLDER := cht

COMBO_CHIP_VENDOR := intel
COMBO_CHIP := lnp

# SoftAp FW reload definitions.
# we don't really need this, it's to avoid error when the framework
# will trigger the fwReloadSoftap function, what will lead to an error
# enabling the SoftAp.
# so we set up this for letting the function execute gracefully.
WIFI_DRIVER_FW_PATH_STA := "/system/vendor/firmware/iwlwifi-softap-dummy.ucode"
WIFI_DRIVER_FW_PATH_AP  := "/system/vendor/firmware/iwlwifi-softap-dummy.ucode"
WIFI_DRIVER_FW_PATH_P2P := "/system/vendor/firmware/iwlwifi-softap-dummy.ucode"
WIFI_DRIVER_FW_PATH_PARAM := "/dev/null"

# config_wifi_background_scan_support=true:
#for intel vendor
BOARD_WLAN_DEVICE := intel
BOARD_HOSTAPD_PRIVATE_LIB                := private_lib_driver_cmd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd
WPA_SUPPLICANT_VERSION                   := VER_0_8_X
HOSTAPD_VERSION                          := VER_0_8_X
WIFI_DRIVER_MODULE_PATH                  ?= auto

DEVICE_PACKAGE_OVERLAYS += device/bcm/common/wlan/overlay-pno

DEVICE_PACKAGE_OVERLAYS += device/bcm/common/wlan/overlay-tcp-buffers


USE_ATHR_GPS_HARDWARE := false
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := false
SENSOR_MMA8451 := false

# for recovery service
TARGET_SELECT_KEY := 28

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true
# uncomment below lins if use NAND
#TARGET_USERIMAGES_USE_UBIFS = true


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
UBI_ROOT_INI := device/fsl/sabresd_6dq/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init vmalloc=400M androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := false
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/bcm/ar6mx/bluetooth

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := true

# camera hal v2
IMX_CAMERA_HAL_V2 := true

#define consumer IR HAL support
IMX6_CONSUMER_IR_HAL := true

# Filesystem and partitioning
BOARD_RECOVERY_PARTITION_SIZE           := 104900000
BOARD_CACHEIMAGE_PARTITION_SIZE         := 805306368
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE       := ext4

ifeq ($(EMMC_SIZE),PRODUCTION)
   BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 1425829120
   BOARD_USERDATAIMAGE_PARTITION_SIZE := 3600000000
$(warning Production build -- Setting system size to $(BOARD_SYSTEMIMAGE_PARTITION_SIZE) and data size to $(BOARD_USERDATAIMAGE_PARTITION_SIZE))
else ifeq ($(EMMC_SIZE),TESTING)
   BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 958860800
   BOARD_USERDATAIMAGE_PARTITION_SIZE := 456000000
$(warning Testing build -- Setting system size to $(BOARD_SYSTEMIMAGE_PARTITION_SIZE) and data size to $(BOARD_USERDATAIMAGE_PARTITION_SIZE))
else
   BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 958860800
   BOARD_USERDATAIMAGE_PARTITION_SIZE := 256000000
$(warning EMMC_SIZE not defined, using TESTING -- Setting system size to $(BOARD_SYSTEMIMAGE_PARTITION_SIZE) and data size to $(BOARD_USERDATAIMAGE_PARTITION_SIZE))
endif

BOARD_FLASH_BLOCK_SIZE := 4096

# Customized boot image args to include device tree
# use = since PRODUCT_OUT has not been yet, will be later on
ifeq ($(CORE_TYPE),Q)
   BOARD_MKBOOTIMG_ARGS = --second $(PRODUCT_OUT)/imx6q-ar6mx.dtb
else ifeq ($(CORE_TYPE),S)
   BOARD_MKBOOTIMG_ARGS = --second $(PRODUCT_OUT)/imx6dl-ar6mx.dtb
endif

# Boot animation optimizations
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true

# which configuration should be used for the quad, dual, and solo boards
# Upgraded to u-boot 2015.4 which uses the SPL to detect 1GB or 2GB RAM so the config changes to quad only --JTS 11/8/2018
#TARGET_BOOTLOADER_CONFIG := 6q:ar6mxqandroid_config 6dl:ar6mxdlandroid_config 6solo:ar6mxsandroid_config
TARGET_BOOTLOADER_CONFIG := 6q:ar6mxandroid_defconfig

# which device tree binary blob should be used with the quad and dual boards
TARGET_BOARD_DTS_CONFIG := 6q:imx6q-ar6mx.dtb 6dl:imx6dl-ar6mx.dtb

# which file is the kernel configuration file for the BCM board
TARGET_KERNEL_DEFCONF := imx_v7_android_defconfig

BOARD_SEPOLICY_DIRS := \
       device/bcm/ar6mx/sepolicy \
       device/fsl/imx6/sepolicy

BOARD_SEPOLICY_UNION := \
       domain.te \
       system_app.te \
       system_server.te \
       untrusted_app.te \
       sensors.te \
       init_shell.te \
       bluetooth.te \
       hci_attach.te \
       kernel.te \
       mediaserver.te \
       file_contexts \
       genfs_contexts \
       fs_use  \
       rild.te \
       hostapd.te \
       init.te \
       netd.te \
       bootanim.te \
       dnsmasq.te \
       recovery.te \
       device.te \
       wpa.te \
       zygote.te \
       pdi_ts_script.te \
       pdi_cmdline_script.te \
       pdi_ota_script.te \
       initgpios.te \
       eGTouchD.te \
       platform_app.te \
       drmserver.te \
       healthd.te \
       radio.te \
       surfaceflinger.te \
       pdi_copy_device_policies.te \
       keystore.te

# Recovery Options
TARGET_NO_RECOVERY                      := false
ifeq ($(AIO_CONFIGURATION),T)
$(warning Using Recovery Pixel Format BGRA_8888)
TARGET_RECOVERY_PIXEL_FORMAT            := "BGRA_8888"
else
$(warning Using Recovery Pixel Format RGBX_8888)
TARGET_RECOVERY_PIXEL_FORMAT            := "RGBX_8888"
endif

# OTA Addition to update bootloader
TARGET_RECOVERY_UPDATER_LIBS            := librecovery_updater_ar6mx
