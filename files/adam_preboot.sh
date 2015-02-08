#!/system/bin/sh

# Enable PixelQi mode on boot
    echo 1 > /sys/devices/platform/pwm-backlight/PQiModeOn

# Disable TCP/IP v6
#sysctl -w net.ipv6.conf.default.disable_ipv6=1

mv /data/aplog /data/last_aplog
/system/bin/logcat -f /data/aplog &
dmesg > /data/dmsg &
#mv /data/kmsg /data/last_kmsg
#cat /proc/kmsg > /data/kmsg &

# Sleep freeze workaround (makes usb unstable, but suspend power usage less)
    #echo 1 > /sys/module/cpuidle/parameters/lp2_in_idle

# Alternate sleep freeze workaround to keep cpu awake (doesn't affect usb, but more power usage)
    #echo keepawake > /sys/power/wake_lock # some Adams cannot deep sleep

# Interactive Governor Settings   (write cpufreq before cpu0,cpu1)
    echo 100000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq # Minimum clock speed
    echo 1500000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq # ** Set 1.6Ghz nax clock speed **
    echo interactive > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor # Set governor
    echo 100000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq # Minimum clock speed for second core
    echo 1500000 >/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq # Max clock speed for second core
    echo interactive > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor # Set governor for second core
    echo 80 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
    echo 1 > /sys/devices/system/cpu/cpufreq/interactive/input_boost

# Default Read Ahead value for sdcards
    echo 256 > /sys/block/mmcblk0/queue/read_ahead_kb
    echo 256 > /sys/block/mmcblk1/queue/read_ahead_kb
    echo 256 > /sys/block/mtdblock3/queue/read_ahead_kb
    echo 256 > /sys/block/mtdblock4/queue/read_ahead_kb

# Set I/O scheduler noop deadline cfq sio bfq row
    echo noop > /sys/block/mmcblk0/queue/scheduler
    echo noop > /sys/block/mmcblk1/queue/scheduler
    echo noop > /sys/block/mtdblock3/queue/scheduler
    echo noop > /sys/block/mtdblock4/queue/scheduler

