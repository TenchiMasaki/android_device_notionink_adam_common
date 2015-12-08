#!/system/bin/sh
echo 1 > /sys/block/zram0/reset
# zram size 500 mb
echo 500000000 > /sys/block/zram0/disksize
mkswap /dev/block/zram0
swapon /dev/block/zram0
