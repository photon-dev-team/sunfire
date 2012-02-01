#!/sbin/sh

# enable ADB
echo msc_adb > /dev/usb_device_mode

# upload firmware to touch screen
sleep 5 #wait for /dev/block/mmcblk0p12 to appear
mount /dev/block/mmcblk0p12 /system
cp -a /system/etc/touchpad /etc/
/system/bin/touchpad -a
umount /system
rm /etc/touchpad -Rf
