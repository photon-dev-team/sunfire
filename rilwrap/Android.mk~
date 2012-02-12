LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= rilwrap.c

LOCAL_SHARED_LIBRARIES:= libdl libutils libcutils liblog

LOCAL_CFLAGS += -DRIL_SHLIB

LOCAL_MODULE := rilwrap
LOCAL_MODULE_TAGS := optional
LOCAL_PRELINK_MODULE := false

include $(BUILD_SHARED_LIBRARY)

