LOCAL_PATH := $(call my-dir)

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif
include device/fsl-proprietary/media-profile/media-profile.mk
include device/fsl-proprietary/sensor/fsl-sensor.mk
#Add compat driver support
ifndef PRIVATE_WPA_SUPPLICANT_CONF
  WIFI_DRIVER_SOCKET_IFACE := wlan0
  -include external/wpa_supplicant_8/wpa_supplicant/wpa_supplicant_conf.mk
endif
