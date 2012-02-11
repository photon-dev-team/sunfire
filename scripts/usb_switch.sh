#!/system/bin/sh
PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin

# are we currently on RNDIS mode?
IS_RNDIS=$(/system/xbin/cat /data/usbd/current_state|/system/xbin/grep rndis -c)

# if we're in RNDIS mode and we're switching to a non RNDIS mode
if [ "x$IS_RNDIS" = "x1" ] ; then
    if [ ! "x$1" = "x3" ] ; then
        /system/bin/logwrapper /system/bin/am broadcast -a com.motorola.intent.action.USB_TETHERING_TOGGLED --ei state 0
    fi
fi

# if we're switching to RNDIS mode
if [ "x$1" = "x3" ] ; then
    /system/bin/logwrapper /system/bin/am broadcast -a com.motorola.intent.action.USB_TETHERING_TOGGLED --ei state 1
else
    /system/bin/logwrapper /system/bin/am broadcast -a com.motorola.intent.action.USB_MODE_SWITCH_FROM_UI --ei USB_MODE_INDEX $1
fi

