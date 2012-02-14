#!/sbin/sh

# enable ADB
echo msc_adb > /dev/usb_device_mode

# upload firmware to touch screen
sleep 3 #wait for /dev/block/mmcblk0p12 to appear

# stop warning about dvfs on dmesg
echo 0 > /proc/sys/kernel/hung_task_timeout_secs

# check for system sanity
e2fsck -n /dev/block/mmcblk0p12 > /dev/null 2>&1
SANE=$?

if [ "$SANE" = "0" ] ; then
    mount /dev/block/mmcblk0p12 /system
    cp -a /system/etc/touchpad /etc/
    /system/bin/touchpad -a
    umount /system
    rm /etc/touchpad -Rf
fi
