TOP_LOCAL_PATH:= $(call my-dir)

# Build activity

LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-subdir-java-files)

LOCAL_PACKAGE_NAME := HwaSettings
LOCAL_MODULE_TAGS  := optional

LOCAL_CERTIFICATE  := platform
LOCAL_PROGUARD_FLAG_FILES := proguard.flags

# LOCAL_REQUIRED_MODULES := jni stuff

include $(BUILD_PACKAGE)

# ============================================================

# Also build all of the sub-targets under this one: the shared library.
# include $(call all-makefiles-under,$(LOCAL_PATH))
