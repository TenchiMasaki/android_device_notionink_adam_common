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
PRODUCT_LOCALES += mdpi

# Dalvik
# DONT_INSTALL_DEX_FILES := true
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dexopt-data-only=1
#    dalvik.vm.heaptargetutilization=0.25 \
#    dalvik.vm.jit.codecachesize=0 \


# Adam/Harmony Configs
PRODUCT_COPY_FILES := \
    $(LOCAL_KERNEL):kernel \
    device/notionink/adam_common/files/init.harmony.rc:root/init.harmony.rc \
    device/notionink/adam_common/files/init.harmony.usb.rc:root/init.harmony.usb.rc \
    device/notionink/adam_common/files/ueventd.harmony.rc:root/ueventd.harmony.rc \
    device/notionink/adam_common/files/fstab.harmony:root/fstab.harmony \
    device/notionink/adam_common/files/bcmdhd.cal:system/etc/wifi/bcmdhd.cal \
    device/notionink/adam_common/files/nvram.txt:system/etc/wifi/nvram.txt \
    device/notionink/adam_common/files/adam_preboot.sh:system/etc/adam_preboot.sh \
    device/notionink/adam_common/files/02do:system/etc/adam_postboot.sh \
#    device/notionink/adam_common/files/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
#    device/notionink/adam_common/files/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf


# Modules
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/modules/scsi_wait_scan.ko:system/lib/modules/scsi_wait_scan.ko \
   #device/notionink/adam_common/modules/tun.ko:system/lib/modules/tun.ko

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

# Graphics
PRODUCT_COPY_FILES += \
    device/notionink/adam_common/files/media_profiles.xml:system/etc/media_profiles.xml

# Codecs
PRODUCT_COPY_FILES += \
     device/notionink/adam_common/files/media_codecs.xml:system/etc/media_codecs.xml

# Mixer paths
PRODUCT_COPY_FILES += \
     device/notionink/adam_common/files/mixer_paths.xml:system/etc/mixer_paths.xml

# Audio policy configuration
PRODUCT_COPY_FILES += \
     device/notionink/adam_common/files/audio_policy.conf:system/etc/audio_policy.conf

# APNs list
PRODUCT_COPY_FILES += \
   device/notionink/adam_common/files/apns-conf.xml:system/etc/apns-conf.xml

      
PRODUCT_PROPERTY_OVERRIDES += \
    ro.wifi.country=US \
    wifi.interface=wlan0 \
    ro.sf.lcd_density=120 \
    wifi.supplicant_scan_interval=15 \
    debug.hwui.render_dirty_regions=false \
    ro.zygote.disable_gl_preload=true \
    ro.bq.gpu_to_cpu_unsupported=true \
    hwui.use_gpu_pixel_buffers=false \
#    ro.boot.selinux=disabled \
#    ro.build.selinux=0

# Live Wallpapers
PRODUCT_PACKAGES += \
	HoloSpiralWallpaper \
        LiveWallpapersPicker \
        VisualizationWallpapers

#Audio
PRODUCT_PACKAGES += \
        audio.a2dp.default \
	audio.primary.harmony \
	audio.usb.default \
        libaudioutils \
        tinymix \
        tinyplay \
        tinyrec \

# Harmony Hardware
PRODUCT_PACKAGES += \
	sensors.harmony \
	lights.harmony \
	gps.harmony \
	camera.tegra \
#	hwcomposer.tegra

PRODUCT_PACKAGES += \
	librs_jni \
	bttest \
	libbt-vendor
        
# These are the hardware-specific feature permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
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
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml 


PRODUCT_PROPERTY_OVERRIDES += \
	ro.opengles.version=131072 \
	ro.opengles.surface.rgb565=true

#Set default.prop properties for root + mtp
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.sys.usb.config=mtp

ADDITIONAL_DEFAULT_PROPERTIES += \
	ro.secure=0 \
	ro.adb.secure=0

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_PACKAGES += \
	com.android.future.usb.accessory \
	libnetcmdiface 

# Filesystem management tools and others
PRODUCT_PACKAGES += \
	setup_fs \
        make_ext4fs \
        l2ping \
        hcitool \
        bttest 

$(call inherit-product, device/common/gps/gps_us_supl.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

WIFI_BAND := 802_11_BG
WPA_SUPPLICANT_VERSION := VER_0_8_X
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/device-bcm.mk)
# Firmware
#PRODUCT_COPY_FILES += \
#	hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/fw_bcm4329.bin:system/vendor/firmware/fw_bcmhd.bin \
#   hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/fw_bcm4329_apsta.bin:system/vendor/firmware/fw_bcmdhd_apsta.bin

#	device/notionink/adam_common/files/vendor/firmware/fw_bcmdhd.bin:system/vendor/firmware/fw_bcmdhd.bin \
#        device/notionink/adam_common/files/vendor/firmware/fw_bcmdhd_p2p.bin:system/vendor/firmware/fw_bcmdhd_p2p.bin \
#        device/notionink/adam_common/files/vendor/firmware/fw_bcmdhd_apsta.bin:system/vendor/firmware/fw_bcmdhd_apsta.bin

$(call inherit-product, frameworks/native/build/tablet-dalvik-heap.mk)
$(call inherit-product, vendor/notionink/adam/device-vendor.mk)
