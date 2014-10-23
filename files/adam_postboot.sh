#!/system/bin/sh
#                                     # RCmod: 24/8/14
# /sbin/adam_postboot.sh
# reset vendorID to correct value for adb.
echo 0955 > /sys/class/android_usb/android0/f_rndis/vendorID

# reconfigure adb on persist-property changes, but only after boot completed.
# also lets wait 2 secs and try again..
for i in 1 2 3 ;do
  if [ `getprop sys.boot_completed` == "1" ] ;then
    abc=`getprop sys.usb.config`
    xyz=`getprop persist.sys.usb.config`
    if ! [ "$abc" == "$xyz" ] ;then
      newargs="/system/bin/setprop sys.usb.config $xyz"
      ($newargs)
    fi
  fi
sleep 2
done

