$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)


## (1) First, the most specific values, i.e. the aspects that are specific to this phone
PRODUCT_COPY_FILES += \
    device/motorola/sunfire/init.sunfire.rc:root/init.sunfire.rc \
    device/motorola/sunfire/ueventd.sunfire.rc:root/ueventd.sunfire.rc

## (2) Also get non-open-source phone-specific aspects if available
$(call inherit-product-if-exists, vendor/motorola/sunfire/sunfire-vendor.mk)


# motorola helper scripts
PRODUCT_COPY_FILES += \
    device/motorola/sunfire/scripts/pds_perm_fix.sh:system/bin/pds_perm_fix.sh \
    device/motorola/sunfire/scripts/bt_init_wrapper.sh:system/bin/bt_init_wrapper.sh \
    device/motorola/sunfire/scripts/hciattach_wrapper.sh:system/bin/hciattach_wrapper.sh

# sysctl conf
PRODUCT_COPY_FILES += \
    device/motorola/sunfire/config/sysctl.conf:system/etc/sysctl.conf

## (3)  Finally, the least specific parts, i.e. the non-GSM-specific aspects


# Telephony property for CDMA
PRODUCT_PROPERTY_OVERRIDES += \
    ro.ril.ntmodeglobal=true \
    ro.cdma.home.operator.numeric=310120 \
    ro.cdma.home.operator.alpha=Sprint \
    ro.cdma.homesystem=64,65,76,77,78,79,80,81,82,83 \
    ro.cdma.otaspnumschema=SELC,1,80,99 \
    ro.HorizontalVVM=false

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# copy all kernel modules under the "modules" directory to system/lib/modules
PRODUCT_COPY_FILES += $(shell \
    find device/motorola/sunfire/modules -name '*.ko' \
    | sed -r 's/^\/?(.*\/)([^/ ]+)$$/\1\2:system\/lib\/modules\/\2/' \
    | tr '\n' ' ')

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/motorola/sunfire/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel



$(call inherit-product, build/target/product/full_base.mk)

# sunfire uses high-density artwork where available
PRODUCT_LOCALES += hdpi

PRODUCT_PACKAGES += \
	Usb \
	FM \
	DockAudio \
	Torch

DEVICE_PACKAGE_OVERLAYS += device/motorola/sunfire/overlay

# Board-specific init
PRODUCT_COPY_FILES += \
    device/motorola/sunfire/config/vold.fstab:system/etc/vold.fstab \
    device/motorola/sunfire/scripts/postrecoveryboot.sh:recovery/root/sbin/postrecoveryboot.sh \
    device/motorola/sunfire/config/media_profiles.xml:system/etc/media_profiles.xml \
    device/motorola/sunfire/config/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf

# Digitizer files
# Pulled from http://forum.xda-developers.com/showthread.php?t=1238306
PRODUCT_COPY_FILES += \
    device/motorola/sunfire/config/touchpad/20/touchpad.cfg:system/etc/touchpad/20/touchpad.cfg \
    device/motorola/sunfire/config/touchpad/21/touchpad.cfg:system/etc/touchpad/21/touchpad.cfg \
    device/motorola/sunfire/config/touchpad/22/touchpad.cfg:system/etc/touchpad/22/touchpad.cfg

#keyboard files
PRODUCT_COPY_FILES += \
    device/motorola/sunfire/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/motorola/sunfire/keylayout/Motorola_Mobility_Motorola_HD_Dock.kl:system/usr/keylayout/Motorola_Mobility_Motorola_HD_Dock.kl \
    device/motorola/sunfire/keylayout/cpcap-key.kl:system/usr/keylayout/cpcap-key.kl \
    device/motorola/sunfire/keylayout/evfwd.kl:system/usr/keylayout/evfwd.kl \
    device/motorola/sunfire/keylayout/qwerty.kl:system/usr/keylayout/qwerty.kl \
    device/motorola/sunfire/keylayout/tegra-kbc.kl:system/usr/keylayout/tegra-kbc.kl \
    device/motorola/sunfire/keylayout/usb_keyboard_102_en_us.kl:system/usr/keylayout/usb_keyboard_102_en_us.kl \
    device/motorola/sunfire/keylayout/Motorola_Bluetooth_Wireless_Keyboard.kl:system/usr/keylayout/Motorola_Bluetooth_Wireless_Keyboard.kl \
    device/motorola/sunfire/keychars/usb_keyboard_102_en_us.kcm.bin:system/usr/keychars/usb_keyboard_102_en_us.kcm.bin \
    device/motorola/sunfire/keychars/tegra-kbc.kcm.bin:system/usr/keychars/tegra-kbc.kcm.bin \
    device/motorola/sunfire/keychars/evfwd.kcm.bin:system/usr/keychars/evfwd.kcm.bin \
    device/motorola/sunfire/keychars/qwerty.kcm.bin:system/usr/keychars/qwerty.kcm.bin \
    device/motorola/sunfire/keychars/qwerty2.kcm.bin:system/usr/keychars/qwerty2.kcm.bin \
    device/motorola/sunfire/keychars/Motorola_Bluetooth_Wireless_Keyboard.kcm.bin:system/usr/keychars/Motorola_Bluetooth_Wireless_Keyboard.kcm.bin

# Permission files
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/base/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml


PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_NAME := generic_sunfire
PRODUCT_DEVICE := sunfire
PRODUCT_MODEL := MB855
PRODUCT_BRAND := sprint
