#!/system/bin/sh
export PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

# are we currently on RNDIS mode?
IS_RNDIS=$(cat /data/usbd/current_state|grep rndis -c)

# if we're in RNDIS mode and we're switching to a non RNDIS mode
if [ "$IS_RNDIS" = "1" ] ; then
    if [ ! "$1" = "3" ] ; then
        logwrapper /system/bin/am broadcast -a com.motorola.intent.action.USB_TETHERING_TOGGLED --ei state 0
        netcfg usb1 down
    fi
fi

# if we're switching to RNDIS mode
if [ "$1" = "3" ] ; then
    netcfg usb1 up
    logwrapper /system/bin/am broadcast -a com.motorola.intent.action.USB_TETHERING_TOGGLED --ei state 1
else
    logwrapper /system/bin/am broadcast -a com.motorola.intent.action.USB_MODE_SWITCH_FROM_UI --ei USB_MODE_INDEX $1
fi

