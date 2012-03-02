#
# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# This is the product configuration for a generic GSM sunfire,
# not specialized for any geography.
#

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

## (1) First, the most specific values, i.e. the aspects that are specific to GSM
PRODUCT_COPY_FILES += \
    device/moto/sunfire/init.sunfire.rc:root/init.sunfire.rc \
    device/moto/sunfire/init.sunfire.usb.rc:root/init.sunfire.usb.rc \
    device/moto/sunfire/ueventd.sunfire.rc:root/ueventd.sunfire.rc

## (2) Also get non-open-source GSM-specific aspects if available
$(call inherit-product-if-exists, vendor/moto/sunfire/sunfire-vendor.mk)

## (3)  Finally, the least specific parts, i.e. the non-GSM-specific aspects
PRODUCT_PROPERTY_OVERRIDES += \
    ro.telephony.sms_segment_size=160 \
    ro.telephony.call_ring.multiple=false \
    ro.setupwizard.enable_bypass=1 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \

# motorola helper scripts
PRODUCT_COPY_FILES += \
    device/moto/sunfire/scripts/pds_perm_fix.sh:system/bin/pds_perm_fix.sh \
    device/moto/sunfire/scripts/bt_init_wrapper.sh:system/bin/bt_init_wrapper.sh \
    device/moto/sunfire/scripts/usb_switch.sh:system/bin/usb_switch.sh

# sysctl conf
PRODUCT_COPY_FILES += \
    device/moto/sunfire/config/sysctl.conf:system/etc/sysctl.conf

## (3)  Finally, the least specific parts, i.e. the non-GSM-specific aspects

# Set en_US as default locale
PRODUCT_LOCALES := en_US

# sunfire uses high-density artwork where available
PRODUCT_LOCALES += hdpi

# better code for dalvik heap size since we have space
$(call inherit-product, frameworks/base/build/phone-xhdpi-1024-dalvik-heap.mk)

# copy all kernel modules under the "modules" directory to system/lib/modules
PRODUCT_COPY_FILES += $(shell \
    find device/moto/sunfire/modules -name '*.ko' \
    | sed -r 's/^\/?(.*\/)([^/ ]+)$$/\1\2:system\/lib\/modules\/\2/' \
    | tr '\n' ' ')

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/moto/sunfire/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

$(call inherit-product-if-exists, vendor/moto/sunfire/sunfire-vendor.mk)

$(call inherit-product, build/target/product/full_base_telephony.mk)

PRODUCT_PACKAGES += Usb \
			DockAudio \
			Torch \
			SunfireParts \
			hciconfig \
			hcitool \
			hwcomposer.default \
			rilwrap \
			camera.sunfire \
			audio.primary.sunfire \
			audio.a2dp.default

DEVICE_PACKAGE_OVERLAYS += device/moto/sunfire/overlay

# Board-specific init
PRODUCT_COPY_FILES += \
    device/moto/sunfire/config/vold.fstab:system/etc/vold.fstab \
    device/moto/sunfire/scripts/postrecoveryboot.sh:recovery/root/sbin/postrecoveryboot.sh \
    device/moto/sunfire/prebuilts/liba2dp.so:system/lib/liba2dp.so

#keyboard files
PRODUCT_COPY_FILES += \
    device/moto/sunfire/keylayout/qtouch-obp-ts.kl:system/usr/keylayout/qtouch-obp-ts.kl \
    device/moto/sunfire/config/qtouch-obp-ts.idc:system/usr/idc/qtouch-obp-ts.idc \
    device/moto/sunfire/keylayout/tegra-kbc.kl:system/usr/keylayout/tegra-kbc.kl \
    device/moto/sunfire/keychars/tegra-kbc.kcm.bin:system/usr/keychars/tegra-kbc.kcm.bin \
    device/moto/sunfire/keylayout/qwerty.kl:system/usr/keylayout/BTC_USB_Cordless_Mouse.kl \
    device/moto/sunfire/keylayout/qwerty.kl:system/usr/keylayout/qwerty.kl \
    device/moto/sunfire/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    device/moto/sunfire/keylayout/Motorola_Mobility_Motorola_HD_Dock.kl:system/usr/keylayout/Motorola_Mobility_Motorola_HD_Dock.kl \
    device/moto/sunfire/keylayout/cpcap-key.kl:system/usr/keylayout/cpcap-key.kl \
    device/moto/sunfire/keylayout/evfwd.kl:system/usr/keylayout/evfwd.kl \
    device/moto/sunfire/keychars/evfwd.kcm.bin:system/usr/keychars/evfwd.kcm.bin \
    device/moto/sunfire/keylayout/usb_keyboard_102_en_us.kl:system/usr/keylayout/usb_keyboard_102_en_us.kl \
    device/moto/sunfire/keychars/usb_keyboard_102_en_us.kcm.bin:system/usr/keychars/usb_keyboard_102_en_us.kcm.bin \
    device/moto/sunfire/keylayout/usb_keyboard_102_en_us.kl:system/usr/keylayout/Motorola_Bluetooth_Wireless_Keyboard.kl \
    device/moto/sunfire/keychars/usb_keyboard_102_en_us.kcm.bin:system/usr/keychars/Motorola_Bluetooth_Wireless_Keyboard.kcm.bin

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

PRODUCT_COPY_FILES += device/moto/sunfire/apns-conf.xml:system/etc/apns-conf.xml

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_NAME := generic_sunfire
PRODUCT_DEVICE := sunfire
PRODUCT_MODEL := MB855
