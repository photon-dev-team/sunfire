ifneq ($(TARGET_WIFI),false)
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := dhd.ko
LOCAL_MODULE := dhd.ko
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := user eng debug
include $(BUILD_PREBUILT)

# Any prebuilt files with default TAGS can use the below:
prebuilt_files :=

$(call add-prebuilt-files, SHARED_LIBRARIES, $(prebuilt_files))
endif
