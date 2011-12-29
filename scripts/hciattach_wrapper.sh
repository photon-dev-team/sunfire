#!/system/bin/sh
/system/bin/hciattach -s 3500000 /dev/ttyHS2 any 3500000 flow
/system/bin/hciconfig dev down
sleep 1
/system/bin/hciconfig dev up
