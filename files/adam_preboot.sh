#!/system/bin/sh

#echo 1 > /sys/devices/platform/pwm-backlight/PQiModeOn

su -ad &

rm /data/aplog
/system/bin/logcat -f /data/aplog &
dmesg > /data/dmsg &
