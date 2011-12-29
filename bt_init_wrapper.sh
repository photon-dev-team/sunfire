#!/system/bin/sh
/system/bin/bt_init -stop
sleep 1
/system/bin/bt_init /system/etc/bt_init.config
/system/xbin/hciconfig hci0 down
killall -9 hciattach

