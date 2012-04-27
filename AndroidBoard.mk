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
# AndroidBoard.mk is a legacy mechanism to deal with a few
# edge-cases that can't be managed otherwise. No new rules
# should be added to this file.
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)


#file := $(TARGET_RECOVERY_ROOT_OUT)/sbin/postrecoveryboot.sh
#ALL_PREBUILT += $(file)
#$(file) : $(LOCAL_PATH)/postrecoveryboot.sh | $(ACP)
#	$(transform-prebuilt-to-target)

TARGET_KERNEL_CONFIG := tegra_sunfire_cyanogenmod_defconfig
TARGET_PREBUILT_KERNEL := device/moto/sunfire/kernel

SUNFIRE_WIFI_MODULE:
	make -C kernel/moto/olympus/wifi-module/wlan/osrc/open-src/src/dhd/linux/ \
	ARCH="arm" CROSS_COMPILE="arm-eabi-" LINUXSRCDIR=~/cm9/kernel/moto/sunfire/ \
	LINUXBUILDDIR=$(KERNEL_OUT) PLATFORM_DIR=~/cm9 \
	KERNEL_SRC=$PLATFORM_DIR/kernel/moto/sunfire ANDROID_BUILD_TOP=/$PLATFORM_DIR \
	BCM_INSTALLDIR="$(ANDROID_BUILD_TOP)/$(KERNEL_MODULES_OUT)"

TARGET_KERNEL_MODULES := SUNFIRE_WIFI_MODULE


# include the non-open-source counterpart to this file
-include vendor/moto/sunfire/AndroidBoardVendor.mk
