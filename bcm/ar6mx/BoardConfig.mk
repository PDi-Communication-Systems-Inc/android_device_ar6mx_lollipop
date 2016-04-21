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

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

#for intel vendor
BOARD_WLAN_DEVICE := intel
BOARD_HOSTAPD_PRIVATE_LIB                := private_lib_driver_cmd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd
WPA_SUPPLICANT_VERSION                   := VER_0_8_X
HOSTAPD_VERSION                          := VER_0_8_X
WIFI_DRIVER_MODULE_PATH                  ?= auto

BOARD_MODEM_VENDOR := AMAZON

USE_ATHR_GPS_HARDWARE := true
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true

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

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init video=mxcfb0:dev=ldb,bpp=32 video=mxcfb1:off video=mxcfb2:off video=mxcfb3:off vmalloc=400M androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale cma=384M

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := false
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/bcm/ar6mx/bluetooth

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# camera hal v2
IMX_CAMERA_HAL_V2 := true

#define consumer IR HAL support
IMX6_CONSUMER_IR_HAL := true

# Filesystem and partitioning
BOARD_RECOVERY_PARTITION_SIZE           := 104900000
BOARD_CACHEIMAGE_PARTITION_SIZE         := 256000000
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE       := ext4

ifeq ($(EMMC_SIZE),STANDARD)
   BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 1258291200
   BOARD_USERDATAIMAGE_PARTITION_SIZE := 3900000000
else
   BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 786432000
   BOARD_USERDATAIMAGE_PARTITION_SIZE := 256000000
endif

BOARD_FLASH_BLOCK_SIZE := 4096

# Boot animation optimizations
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true

# Perform JIT-ready optimizations of jar/apks at compile time
# Should reduce first-run boot but will increase compile times
WITH_DEXPREOPT=true

TARGET_BOOTLOADER_CONFIG := 6q:ar6mxqandroid_config 6dl:ar6mxdlandroid_config 6solo:ar6mxsandroid_config
TARGET_BOARD_DTS_CONFIG := 6q:imx6q-ar6mx.dtb 6dl:imx6dl-ar6mx.dtb

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
       eGTouchD.te

# Other Recovery Options
TARGET_NO_RECOVERY                      := false
TARGET_RECOVERY_PIXEL_FORMAT            := "BGRA_8888"
# TODO: Allow OTA to update bootloader
#TARGET_RECOVERY_UPDATER_LIBS            := librecovery_updater_ar6mx
