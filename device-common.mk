#
# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file includes all definitions that apply to ALL tuna devices, and
# are also specific to tuna devices
#
# Everything in this directory will become public

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/notionink/adam_common/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

DEVICE_PACKAGE_OVERLAYS := device/notionink/adam_common/overlay

# uses mdpi artwork where available
PRODUCT_AAPT_CONFIG := normal mdpi hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := mdpi
PRODUCT_LOCALES += en mdpi

# Enable optional sensor types
PRODUCT_PROPERTY_OVERRIDES += \
    ro.qti.sensors.smd=false \
    ro.qti.sensors.game_rv=true \
    ro.qti.sensors.georv=true \
    ro.qti.sensors.smgr_mag_cal_en=true \
    ro.qti.sensors.step_detector=false \
    ro.qti.sensors.step_counter=false \
    ro.qti.sensors.tap=false \
    ro.qti.sensors.facing=false \
    ro.qti.sensors.tilt=false \
    ro.qti.sensors.amd=false \
    ro.qti.sensors.rmd=false \
    ro.qti.sensors.vmd=false \
    ro.qti.sensors.pedometer=false \
    ro.qti.sensors.pam=false \
    ro.qti.sdk.sensors.gestures=false

# Dalvik
# DONT_INSTALL_DEX_FILES := true
#PRODUCT_PROPERTY_OVERRIDES += \
#    dalvik.vm.dexopt-flags=m=y,v=n,o=a
#m=y

# Decrease VM Heap Size
#PRODUCT_PROPERTY_OVERRIDES += \
#    dalvik.vm.heapgrowthlimit=128m \
#    dalvik.vm.heapsize=256m \
#    dalvik.vm.dexopt-data-only=1 \
#    dalvik.vm.heaptargetutilization=0.25 \
#    dalvik.vm.jit.codecachesize=0 \

# Adam/Harmony Configs
PRODUCT_COPY_FILES := \
    $(LOCAL_KERNEL):kernel \
    device/notionink/adam_common/files/fstab.harmony:root/fstab.harmony \
    device/notionink/adam_common/files/init.harmony.rc:root/init.harmony.rc \
    device/notionink/adam_common/files/init.harmony.usb.rc:root/init.harmony.usb.rc \
    device/notionink/adam_common/files/ueventd.harmony.rc:root/ueventd.harmony.rc \
    device/notionink/adam_common/files/bcmdhd.cal:system/etc/wifi/bcmdhd.cal \
    device/notionink/adam_common/files/nvram.txt:system/etc/wifi/nvram.txt \
    device/notionink/adam_common/files/adam_preboot.sh:system/etc/adam_preboot.sh \
    device/notionink/adam_common/files/init.usb.rc:root/init.usb.rc \
#    device/notionink/adam_common/recovery/init.recovery.harmony.rc:root/init.recovery.harmony.rc
#    device/notionink/adam_common/files/init.rc:root/init.rc \
#    device/notionink/adam_common/files/init.cm.rc:root/init.cm.rc \
#    device/notionink/adam_common/files/init.superuser.rc:root/init.superuser.rc \
#    device/notionink/adam_common/files/adam_postboot.sh:system/etc/adam_postboot.sh \
#    device/notionink/adam_common/files/init.zygote32.rc:root/init.zygote32.rc \
#    device/notionink/adam_common/files/init.trace.rc:root/init.trace.rc \
#    device/notionink/adam_common/files/ueventd.rc:root/ueventd.rc \
#    device/notionink/adam_common/files/file_contexts:root/file_contexts \
#    device/notionink/adam_common/files/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
#    device/notionink/adam_common/files/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf


# Modules
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/modules/scsi_wait_scan.ko:system/lib/modules/scsi_wait_scan.ko \
    device/notionink/adam_common/modules/tun.ko:system/lib/modules/tun.ko

# Bluetooth
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/files/bcm4329.hcd:system/etc/firmware/bcm4329.hcd

# Bluetooth config files
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/files/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf
#    system/bluetooth/data/main.nonsmartphone.conf:system/etc/bluetooth/main.conf \


# Touchscreen
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/files/at168_touch.idc:system/usr/idc/at168_touch.idc

# GPIO Keys
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/files/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl

# GPIO Keys
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/files/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl

# Graphics
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/files/media_profiles.xml:system/etc/media_profiles.xml

# Codecs
PRODUCT_COPY_FILES += \
     device/notionink/adam_common/files/media_codecs.xml:system/etc/media_codecs.xml \
     frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
     frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
     device/notionink/adam_common/files/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml

# Mixer paths
PRODUCT_COPY_FILES += \
     device/notionink/adam_common/files/mixer_paths.xml:system/etc/mixer_paths.xml

# Audio policy configuration
PRODUCT_COPY_FILES += \
     device/notionink/adam_common/files/audio_policy.conf:system/etc/audio_policy.conf

# APNs list
#PRODUCT_COPY_FILES += \
#   device/notionink/adam_common/files/apns-conf.xml:system/etc/apns-conf.xml

# Boot animation
PRODUCT_COPY_FILES += \
    vendor/liquid/prebuilt/common/bootanimation/480.zip:system/media/bootanimation.zip

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    ro.sf.lcd_density=120

# Hdmi CEC: works as a playback device (4).
PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=0

# Live Wallpapers
PRODUCT_PACKAGES += \
	HoloSpiralWallpaper \
	LiveWallpapers \
        LiveWallpapersPicker \
        VisualizationWallpapers \

#Audio
PRODUCT_PACKAGES += \
        audio.a2dp.default \
	audio.primary.harmony \
	audio.usb.default \
        audio.r_submix.default \
        libaudio-resampler \
        libaudioutils \
        tinymix \
        tinyplay \
        tinyrec \
        libaudioamp \
        FM2 \
        FMRecord

# Harmony Hardware
PRODUCT_PACKAGES += \
	sensors.harmony \
	lights.harmony \
	gps.harmony \
	camera.tegra \
	hwcomposer.tegra \
	power.tegra

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1

# These are the OpenMAX IL modules
PRODUCT_PACKAGES += \
    libSEC_OMX_Core \
    libOMX.SEC.AVC.Decoder \
    libOMX.SEC.M4V.Decoder \
    libOMX.SEC.M4V.Encoder \
    libOMX.SEC.AVC.Encoder

# Usb accessory
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

# OMX
PRODUCT_PACKAGES += \
	libc2dcolorconvert \
	libdivxdrmdecrypt \
	libOmxCore \
	libOmxVdec \
	libOmxVenc \
	libOmxAacEnc \
	libOmxAmrEnc \
	libOmxEvrcEnc \
	libOmxQcelp13Enc \
	libstagefrighthw \
	libdashplayer \
#	qcmediaplayer

#PRODUCT_BOOT_JARS += \
#	qcmediaplayer

# WebKit
PRODUCT_PACKAGES += \
	libwebcore

# Webkit (classic webview provider)
PRODUCT_PROPERTY_OVERRIDES += \
	persist.webview.provider=classic

# IPv6 tethering
PRODUCT_PACKAGES += \
	ebtables \
	ethertypes

PRODUCT_PACKAGES += \
	librs_jni \
	libemoji \
	bttest \
	libbt-vendor \
	webview \
	WebViewDream \
	PhotoTable \
	libwebkit \
	libmmcamera_interface2 \
	libmmcamera_interface
    
# Sensor daemon
PRODUCT_PACKAGES += \
       g5sensord

# These are the hardware-specific feature permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

#PRODUCT_PROPERTY_OVERRIDES += \
#    ro.boot.selinux=disabled \
#    ro.build.selinux=0

# start adb early
ADDITIONAL_DEFAULT_PROPERTIES += \
	persist.sys.usb.config=mtp \
	ro.secure=0 \
	ro.adb.secure=0 \
	persist.fuse_sdcard=true \
	ro.serial=0123456789ABCDEF \
	ro.product.manufacturer=NotionInk \
	ro.product.model=Notion_Ink_ADAM

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_PACKAGES += \
	libnetcmdiface

# Wifi
PRODUCT_PACKAGES += \
	libwpa_client \
	hostapd \
	hostapd_default.conf \
	dhcpcd.conf \
	wpa_supplicant \
	wpa_supplicant.conf
	
PRODUCT_PACKAGES += \
	wpa_supplicant_overlay.conf \
	p2p_supplicant_overlay.conf

# Filesystem management tools and others
PRODUCT_PACKAGES += \
	e2fsck \
	setup_fs \
        make_ext4fs \
        l2ping \
        hcitool \
        bttest
        
# GPS
PRODUCT_PACKAGES += \
	libloc_adapter \
	libloc_eng \
	libloc_api_v02 \
	libloc_ds_api \
	libloc_core \
	libizat_core \
	libgeofence \
	libgps.utils \
	gps.conf

$(call inherit-product, device/common/gps/gps_us_supl.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

WIFI_BAND := 802_11_BG
WPA_SUPPLICANT_VERSION := VER_0_8_X
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/device-bcm.mk)
# Firmware
#PRODUCT_COPY_FILES += \
#	hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/fw_bcm4329.bin:system/vendor/firmware/fw_bcmdhd.bin \
#   hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/fw_bcm4329_apsta.bin:system/vendor/firmware/fw_bcmdhd_apsta.bin

#	device/notionink/adam_common/files/vendor/firmware/fw_bcmdhd.bin:system/vendor/firmware/fw_bcmdhd.bin \
#        device/notionink/adam_common/files/vendor/firmware/fw_bcmdhd_p2p.bin:system/vendor/firmware/fw_bcmdhd_p2p.bin \
#        device/notionink/adam_common/files/vendor/firmware/fw_bcmdhd_apsta.bin:system/vendor/firmware/fw_bcmdhd_apsta.bin

$(call inherit-product, frameworks/native/build/tablet-dalvik-heap.mk)
$(call inherit-product, vendor/notionink/adam/device-vendor.mk)
