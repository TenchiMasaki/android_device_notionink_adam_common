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

# This variable is set first, so it can be overridden
# by BoardConfigVendor.mk

BOARD_ADAM := true

TARGET_ARCH_LOWMEM := true

# Skip droiddoc build to save build time
BOARD_SKIP_ANDROID_DOC_BUILD := true

# Devices asserts
TARGET_OTA_ASSERT_DEVICE := adam,adam_3g,adam_recovery
# Don't include backuptools
WITH_GMS := true

# Use the non-open-source parts, if they're present
-include vendor/notionink/adam/BoardConfigVendor.mk

# partitions
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 0x01000000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 0x26be3680
BOARD_USERDATAIMAGE_PARTITION_SIZE := 0x105c0000

# platform
TARGET_ARCH := arm
TARGET_NO_RADIOIMAGE := true
TARGET_BOARD_PLATFORM := tegra
TARGET_TEGRA_VERSION := t20
TARGET_BOOTLOADER_BOARD_NAME := harmony
TARGET_NO_BOOTLOADER := true
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a
TARGET_ARCH_VARIANT_CPU := cortex-a9
TARGET_ARCH_VARIANT_FPU := vfpv3-d16
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := tegra2
ARCH_ARM_HAVE_NEON := false
TARGET_HAVE_TEGRA_ERRATA_657451 := true
ARCH_ARM_USE_NON_NEON_MEMCPY := true
#TARGET_BOARD_INFO_FILE := device/notionink/adam_common/board-info.txt

# Compiler Optimization - This is a @codefireX specific flag to use -O3 everywhere.
ARCH_ARM_HIGH_OPTIMIZATION := true
# ANDROID, LINUX-ARM AND TLS REGISTER EMULATION
ARCH_ARM_HAVE_TLS_REGISTER := true
# Avoid the generation of ldrcc instructions
NEED_WORKAROUND_CORTEX_A9_745320 := true
#define to use all of the Linaro Cortex-A9 optimized string funcs,
#instead of subset known to work on all machines
USE_ALL_OPTIMIZED_STRING_FUNCS := true
# customize the malloced address to be 16-byte aligned
BOARD_MALLOC_ALIGNMENT := 16
TARGET_EXTRA_CFLAGS := $(call cc-option,-mtune=cortex-a9) $(call cc-option,-mcpu=cortex-a9)

# Kernel   
TARGET_KERNEL_SOURCE := kernel/notionink/adam
#TARGET_KERNEL_CONFIG := tegra_adam_defconfig
#TARGET_KERNEL_VARIANT_CONFIG := tegra_adam_defconfig
#TARGET_KERNEL_SELINUX_CONFIG := tegra_adam_defconfig
TARGET_KERNEL_CONFIG := tegra_smba1006_defconfig
TARGET_KERNEL_VARIANT_CONFIG := tegra_smba1006_defconfig
TARGET_KERNEL_SELINUX_CONFIG := tegra_smba1006_defconfig
# kernel fallback - if kernel source is not present use prebuilt
#TARGET_PREBUILT_KERNEL := device/notionink/adam_common/kernel
#kernel/notionink/adam/arch/arm/boot/zImage

BOARD_KERNEL_BASE := 0x10000000
BOARD_PAGE_SIZE := 0x00000800
#Stock CMDLINE
#BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive
#BOARD_KERNEL_CMDLINE := tegra_fbmem=8192000@0x1e018000 video=tegrafb console=tty0,115200n8 androidboot.console=tty0 mem=1024M@0M lp0_vec=8192@0x1e7f1020 lcd_manfid=AUO usbcore.old_scheme_first=1 tegraboot=nand mtdparts=tegra_nand:16384K@9984K(misc),16384K@26880K(recovery),16384K@43904K(boot),204800K@60928K(system),781824K@266240K(cache)
#MRDEAD CMDLINE
#BOARD_KERNEL_CMDLINE := tegra_fbmem=8192000@0x1e018000 video=tegrafb console=tty0,115200n8 androidboot.console=tty0 mem=1024M@0M lp0_vec=8192@0x1e7f1020 lcd_manfid=AUO usbcore.old_scheme_first=1 tegraboot=nand mtdparts=tegra_nand:16384K@9984K(misc),16384K@26880K(recovery),32768K@43776K(boot),204800K@77056K(system),765696K@282368K(cache)
#androidboot.carrier=wifi-only product_type=w
#BOARD_KERNEL_CMDLINE := console=tty0,115200n8 androidboot.console=tty0

# Wifi related defines
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE           := bcmdhd
#WIFI_DRIVER_MODULE_PATH     := "/system/lib/hw/dhd.ko"
#WIFI_DRIVER_MODULE_NAME     := "dhd"
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_STA     := "/system/vendor/firmware/fw_bcmdhd.bin"
#WIFI_DRIVER_FW_PATH_P2P     := "/system/vendor/firmware/fw_bcmdhd_p2p.bin"
WIFI_DRIVER_FW_PATH_AP      := "/system/vendor/firmware/fw_bcmdhd_apsta.bin"
CONFIG_CTRL_IFACE           := true

# Wi-Fi AP
BOARD_LEGACY_NL80211_STA_EVENTS := true
BOARD_NO_APSME_ATTR := true

CONFIG_ANDROID_LOG := true
CONFIG_DEBUG_LINUX_TRACING := true
CONFIG_DEBUG_SYSLOG := true

# bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUEDROID_VENDOR_CONF := device/notionink/adam_common/bluetooth/libbt_vndcfg.txt
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/notionink/adam_common/bluetooth

# graphics
BOARD_NEEDS_OLD_HWC_API := true
# Netflix fix
BOARD_USES_PROPRIETARY_OMX := TF101
TARGET_DISABLE_TRIPLE_BUFFERING := true
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
#XX BOARD_USES_LEGACY_OVERLAY := true
BOARD_USE_LEGACY_UI := true

#MAX_EGL_CACHE_KEY_SIZE := 4096
#MAX_EGL_CACHE_SIZE := 2146304
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# display
# Use nicer font rendering
BOARD_USE_SKIA_LCDTEXT := true
BOARD_NO_ALLOW_DEQUEUE_CURRENT_BUFFER := true
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true
TARGET_SUPPORT_HDMI_PRIMARY := true
TARGET_32_BIT_SURFACEFLINGER := true

#TARGET_BOARD_INFO_FILE := device/notionink/adam_common/board-info.txt

# Tegra2 EGL support
BOARD_USES_OVERLAY := true
BOARD_USES_HGL := true
USE_OPENGL_RENDERER := true
BOARD_EGL_CFG := device/notionink/adam_common/files/egl.cfg
BOARD_HDMI_MIRROR_MODE := Scale
BOARD_USE_MHEAP_SCREENSHOT := true
BOARD_EGL_SKIP_FIRST_DEQUEUE := true
BOARD_USES_HWCOMPOSER := true
BOARD_EGL_WORKAROUND_BUG_10194508 := true
BOARD_EGL_NEEDS_FNW := true
SKIP_SET_METADATA := true
BOARD_EGL_NEEDS_LEGACY_FB := true
EGL_NEEDS_FNW := true
BOARD_ADRENO_DECIDE_TEXTURE_TARGET := true

# Enable WEBGL in WebKit
ENABLE_WEBGL := true

# Green Screen Fix
#COMMON_GLOBAL_CFLAGS += -DMISSING_EGL_EXTERNAL_IMAGE -DMISSING_GRALLOC_BUFFERS
#COMMON_GLOBAL_CFLAGS += -DMISSING_EGL_PIXEL_FORMAT_YV12
#COMMON_GLOBAL_CFLAGS += -DBOARD_GL_OES_EGL_IMG_EXTERNAL_HACK
 
PRODUCT_CHARACTERISTICS := tablet
BOARD_USES_SECURE_SERVICES := true

#GPS
BOARD_HAVE_GPS := true

# Camera options
USE_CAMERA_STUB := false
BOARD_USES_PROPRIETARY_LIBCAMERA := true
BOARD_SECOND_CAMERA_DEVICE := false
BOARD_CAMERA_HAVE_ISO := true
ICS_CAMERA_BLOB := true
BOARD_VENDOR_USE_NV_CAMERA := true

# Audio
BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_AUDIO_LEGACY := false
BOARD_USES_ALSA_AUDIO := false
BOARD_OMX_NEEDS_LEGACY_AUDIO := true
# OMNIROM flag
BOARD_NEED_OMX_COMPAT := true

BOARD_USES_GENERIC_INVENSENSE := false

# Sensors
TARGET_USES_OLD_LIBSENSORS_HAL := false
BOARD_HAVE_MAGNETIC_SENSOR := true
BOARD_USE_LEGACY_TOUCHSCREEN := true

# Compatibility with pre-kitkat Sensor HALs
SENSORS_NEED_SETRATE_ON_ENABLE := true

# Misc flags
COMMON_GLOBAL_CFLAGS += -DNEEDS_VECTORIMPL_SYMBOLS

# Override healthd HAL
BOARD_HAL_STATIC_LIBRARIES := libhealthd.harmony

# Javascript, Browser and Webkit
WITH_JIT                := true
ENABLE_JSC_JIT          := true
JS_ENGINE               := v8
HTTP                    := chrome
TARGET_FORCE_CPU_UPLOAD := true

# ClamAV "ramdisk-recovery.img: Andr.Exploit.Ratc FOUND"
TW_EXCLUDE_SUPERSU      := true

# Preload bootanimation in to memory
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := false
TARGET_BOOTANIMATION_USE_RGB565 := true
TARGET_SCREEN_WIDTH := 1024
TARGET_SCREEN_HEIGHT := 600

# Recovery
RECOVERY_NAME := Adam Tablet CWM-based Recovery
RECOVERY_FSTAB_VERSION := 2
TARGET_RECOVERY_INITRC := device/notionink/adam_common/recovery/init.rc
TARGET_RECOVERY_FSTAB := device/notionink/adam_common/files/fstab.harmony
# Small fonts
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_10x18.h\"
TARGET_RECOVERY_PIXEL_FORMAT := "RGB_565"
BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/notionink/adam_common/recovery/recovery_keys.c
BOARD_RECOVERY_SWIPE := true

# Compatibility with pre-kitkat Sensor HALs
SENSORS_NEED_SETRATE_ON_ENABLE := true

#define to use all of the Linaro Cortex-A9 optimized string funcs,
#instead of subset known to work on all machines
USE_ALL_OPTIMIZED_STRING_FUNCS := true

# SELinux policies
HAVE_SELINUX := true


ifeq ($(HAVE_SELINUX),true)

	#POLICYVERS := 24
	
	BOARD_SEPOLICY_DIRS += \
	device/notionink/adam_common/sepolicy

BOARD_SEPOLICY_UNION := \
	file_contexts \
	app.te \
	boot_anim.te \
	device.te \
	drmserver.te \
	file.te \
	genfs_contexts \
	healthd.te \
	init.te \
	init_shell.te \
	isolated_app.te \
	media_app.te \
	release_app.te \
	mediaserver.te \
	netd.te \
	platform_app.te \
	rild.te \
	sensors_config.te \
	shared_app.te \
	surfaceflinger.te \
	system_app.te \
	ueventd.te \
	untrusted_app.te \
	vold.te \
	wpa_socket.te \
	wpa.te \
	zygote.te

endif

# TWRP Settings
DEVICE_RESOLUTION := 1024x600
RECOVERY_SDCARD_ON_DATA := true
TW_INTERNAL_STORAGE_PATH := "/storage/sdcard1"
TW_INTERNAL_STORAGE_MOUNT_POINT := "sdcard1"
TW_EXTERNAL_STORAGE_PATH := "/storage/sdcard2"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "sdcard2"
TW_NO_REBOOT_BOOTLOADER := false
TW_NO_REBOOT_RECOVERY := false
TW_FLASH_FROM_STORAGE := true
BOARD_HAS_NO_REAL_SDCARD := false
TW_INCLUDE_JB_CRYPTO := true
TW_CRYPTO_FS_TYPE := "ext4"
TW_CRYPTO_REAL_BLKDEV := "/dev/block/mmcblk0p2"
TW_CRYPTO_MNT_POINT := "/data"
TW_CRYPTO_FS_OPTIONS := "data=ordered,delalloc"
TW_CRYPTO_FS_FLAGS := "0x00000406"
TW_CRYPTO_KEY_LOC := "footer"

