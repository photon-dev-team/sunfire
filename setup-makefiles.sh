DEVICE=sunfire
VENDOR=motorola

mkdir -p ../../../vendor/motorola/$DEVICE

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__VENDOR__/$VENDOR/g > ../../../vendor/motorola/$DEVICE/$DEVICE-vendor.mk

# Live wallpaper packages
PRODUCT_PACKAGES := \\
    LiveWallpapers \\
    LiveWallpapersPicker \\
    MagicSmokeWallpapers \\
    VisualizationWallpapers \\
    librs_jni

# Publish that we support the live wallpaper feature.
PRODUCT_COPY_FILES := \\
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml

# Pick up overlay for features that depend on non-open-source files
DEVICE_PACKAGE_OVERLAYS := vendor/motorola/__DEVICE__/overlay

\$(call inherit-product, vendor/motorola/__DEVICE__/__DEVICE__-vendor-blobs.mk)
EOF

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g > ../../../vendor/motorola/sunfire/BoardConfigVendor.mk


USE_CAMERA_STUB := false
EOF

(cat << EOF) | sed s/__DEVICE__/$DEVICE/g | sed s/__VENDOR__/$VENDOR/g > ../../../vendor/motorola/$DEVICE/$DEVICE-vendor-blobs.mk

# Needed as obj libraries
PRODUCT_COPY_FILES += \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvdispmgr_d.so:obj/lib/libnvdispmgr_d.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libaudio.so:obj/lib/libaudio.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libaudiopolicy.so:obj/lib/libaudiopolicy.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libcamera.so:obj/lib/libcamera.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libhwmediarecorder.so:obj/lib/libhwmediarecorder.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libhwmediaplugin.so:obj/lib/libhwmediaplugin.so
	#vendor/__VENDOR__/__DEVICE__/proprietary/lib/libwimax_jni.so:obj/lib/libwimax_jni.so \\


# System Libraries
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libaudio.so:system/lib/libaudio.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libaudiopolicy.so:system/lib/libaudiopolicy.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libbattd.so:system/lib/libbattd.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libcgdrv.so:system/lib/libcgdrv.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libctest.so:system/lib/libctest.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libmirror.so:system/lib/libmirror.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libmoto_ril.so:system/lib/libmoto_ril.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnmea.so:system/lib/libnmea.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libOpenSLES.so:system/lib/libOpenSLES.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/librds_util.so:system/lib/librds_util.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libril.so:system/lib/libril.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libril_rds.so:system/lib/libril_rds.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libtpa.so:system/lib/libtpa.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libtpa_core.so:system/lib/libtpa_core.so

# System Utilities
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/ap_gain.bin:system/bin/ap_gain.bin \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/mot_boot_mode:system/bin/mot_boot_mode \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/charge_only_mode:system/bin/charge_only_mode \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/tund:system/bin/tund \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/sdptool:system/bin/sdptool \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/Hostapd:system/bin/Hostapd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/battd:system/bin/battd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/remountpds:system/bin/remountpds \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/touchpad:system/bin/touchpad \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/mdm_panicd:system/bin/mdm_panicd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/rild:system/bin/rild \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/secclkd:system/bin/secclkd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/chat-ril:system/bin/chat-ril \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/ftmipcd:system/bin/ftmipcd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/usbd:system/bin/usbd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/akmd2:system/bin/akmd2 \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/whisperd:system/bin/whisperd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/memtest_mode:system/bin/memtest_mode \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/12m_files_copy.sh:system/etc/12m_files_copy.sh \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/slateipcd:system/bin/slateipcd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/tcmd:system/bin/tcmd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/vpnclientpm:system/bin/vpnclientpm

# Opencore configuration and libraries
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/pvplayer.cfg:system/etc/pvplayer.cfg \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_author.so:system/lib/libopencore_author.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_common.so:system/lib/libopencore_common.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_downloadreg.so:system/lib/libopencore_downloadreg.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_download.so:system/lib/libopencore_download.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_mp4localreg.so:system/lib/libopencore_mp4localreg.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_mp4local.so:system/lib/libopencore_mp4local.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_net_support.so:system/lib/libopencore_net_support.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_player.so:system/lib/libopencore_player.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_rtspreg.so:system/lib/libopencore_rtspreg.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libopencore_rtsp.so:system/lib/libopencore_rtsp.so

# OMX utilities
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/omx_tests:system/bin/omx_tests \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/omx_tests:system/bin/omx_tests

# OMX AV encoding and decoding
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvomx.so:system/lib/libnvomx.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvomxilclient.so:system/lib/libnvomxilclient.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libomx_aacdec_sharedlibrary.so:system/lib/libomx_aacdec_sharedlibrary.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libomx_amrenc_sharedlibrary.so:system/lib/libomx_amrenc_sharedlibrary.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libomx_amrdec_sharedlibrary.so:system/lib/libomx_amrdec_sharedlibrary.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libomx_avcdec_sharedlibrary.so:system/lib/libomx_avcdec_sharedlibrary.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libomx_m4vdec_sharedlibrary.so:system/lib/libomx_m4vdec_sharedlibrary.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libomx_mp3dec_sharedlibrary.so:system/lib/libomx_mp3dec_sharedlibrary.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libomx_sharedlibrary.so:system/lib/libomx_sharedlibrary.so

# nVidia Libraries
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvddk_2d.so:system/lib/libnvddk_2d.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvddk_2d_v2.so:system/lib/libnvddk_2d_v2.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvddk_aes_user.so:system/lib/libnvddk_aes_user.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvddk_audiofx.so:system/lib/libnvddk_audiofx.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvdispatch_helper.so:system/lib/libnvdispatch_helper.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvdispmgr_d.so:system/lib/libnvdispmgr_d.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvec.so:system/lib/libnvec.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvidia_display_jni.so:system/lib/libnvidia_display_jni.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm.so:system/lib/libnvmm.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_audio.so:system/lib/libnvmm_audio.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_contentpipe.so:system/lib/libnvmm_contentpipe.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_image.so:system/lib/libnvmm_image.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_manager.so:system/lib/libnvmm_manager.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_misc.so:system/lib/libnvmm_misc.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_parser.so:system/lib/libnvmm_parser.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_service.so:system/lib/libnvmm_service.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_tracklist.so:system/lib/libnvmm_tracklist.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_utils.so:system/lib/libnvmm_utils.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_video.so:system/lib/libnvmm_video.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_videorenderer.so:system/lib/libnvmm_videorenderer.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_vp6_video.so:system/lib/libnvmm_vp6_video.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_writer.so:system/lib/libnvmm_writer.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvodm_dtvtuner.so:system/lib/libnvodm_dtvtuner.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvodm_imager.so:system/lib/libnvodm_imager.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvodm_misc.so:system/lib/libnvodm_misc.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvodm_query.so:system/lib/libnvodm_query.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvos.so:system/lib/libnvos.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvrm.so:system/lib/libnvrm.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvrm_channel.so:system/lib/libnvrm_channel.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvrm_graphics.so:system/lib/libnvrm_graphics.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvsm.so:system/lib/libnvsm.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvwinsys.so:system/lib/libnvwinsys.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvwsi.so:system/lib/libnvwsi.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libhwmediarecorder.so:system/lib/libhwmediarecorder.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libhwmediaplugin.so:system/lib/libhwmediaplugin.so


# Motorola Hardware Libraries
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/hw/gps.sunfire.so:system/lib/hw/gps.sunfire.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/hw/gralloc.tegra.so:system/lib/hw/gralloc.tegra.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/hw/overlay.tegra.so:system/lib/hw/overlay.tegra.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/hw/lights.tegra.so:system/lib/hw/lights.tegra.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/hw/sensors.sunfire.so:system/lib/hw/sensors.sunfire.so

# Bluetooth utilities, libraries and configuration
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/liba2dp.so:system/lib/liba2dp.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/bt_init:system/bin/bt_init \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/bt_downloader:system/bin/bt_downloader \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/bt_init.config:system/etc/bt_init.config \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nv_hciattach:system/bin/nv_hciattach

# nVidia AXP binaries
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvddk_audiofx_core.axf:system/bin/nvddk_audiofx_core.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvddk_audiofx_transport.axf:system/bin/nvddk_audiofx_transport.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_aacdec.axf:system/bin/nvmm_aacdec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_adtsdec.axf:system/bin/nvmm_adtsdec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_audiomixer.axf:system/bin/nvmm_audiomixer.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_h264dec.axf:system/bin/nvmm_h264dec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_jpegdec.axf:system/bin/nvmm_jpegdec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_jpegenc.axf:system/bin/nvmm_jpegenc.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_manager.axf:system/bin/nvmm_manager.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_mp2dec.axf:system/bin/nvmm_mp2dec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_mp3dec.axf:system/bin/nvmm_mp3dec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_mpeg4dec.axf:system/bin/nvmm_mpeg4dec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_reference.axf:system/bin/nvmm_reference.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_service.axf:system/bin/nvmm_service.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_sorensondec.axf:system/bin/nvmm_sorensondec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_sw_mp3dec.axf:system/bin/nvmm_sw_mp3dec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_vc1dec.axf:system/bin/nvmm_vc1dec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_wavdec.axf:system/bin/nvmm_wavdec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_wmadec.axf:system/bin/nvmm_wmadec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvmm_wmaprodec.axf:system/bin/nvmm_wmaprodec.axf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvrm_avp.axf:system/bin/nvrm_avp.axf

# nVidia System Utilities
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/nvrm_daemon:system/bin/nvrm_daemon \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/tegrastats:system/bin/tegrastats

# nVidia EGL libraries and config
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/egl/libEGL_tegra.so:system/lib/egl/libEGL_tegra.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/egl/libGLESv1_CM_tegra.so:system/lib/egl/libGLESv1_CM_tegra.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/egl/libGLESv2_tegra.so:system/lib/egl/libGLESv2_tegra.so

# Broadcom userland components
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/BCM4329B1_002.002.023.0757.0782.hcd:system/etc/BCM4329B1_002.002.023.0757.0782.hcd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wl/nvram.txt:system/etc/wl/nvram.txt \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wl/sdio-ag-cdc-11n-mfgtest-roml-seqcmds.bin:system/etc/wl/sdio-ag-cdc-11n-mfgtest-roml-seqcmds.bin \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wl/sdio-ag-cdc-full11n-minioctl-roml-pno-wme-aoe-pktfilter-keepalive.bin:system/etc/wl/sdio-ag-cdc-full11n-minioctl-roml-pno-wme-aoe-pktfilter-keepalive.bin \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wl/sdio-g-cdc-roml-reclaim-wme-apsta-idauth-minioctl.bin:system/etc/wl/sdio-g-cdc-roml-reclaim-wme-apsta-idauth-minioctl.bin

# Camera
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libcamera.so:system/lib/libcamera.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libnvmm_camera.so:system/lib/libnvmm_camera.so

# Screen Digitizer
#PRODUCT_COPY_FILES +=  \\
#	vendor/__VENDOR__/__DEVICE__/proprietary/etc/touchpad/20/touchpad.cfg:system/etc/touchpad/20/touchpad.cfg \\
#	vendor/__VENDOR__/__DEVICE__/proprietary/etc/touchpad/21/touchpad.cfg:system/etc/touchpad/21/touchpad.cfg \\
#	vendor/__VENDOR__/__DEVICE__/proprietary/etc/touchpad/22/touchpad.cfg:system/etc/touchpad/22/touchpad.cfg
# Covered in sunfire.mk - 10-point fix from XDA


# PPP subsystem
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/ppp/peers/pppd-ril.options:system/etc/ppp/peers/pppd-ril.options \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libpppd_plugin-ril.so:system/lib/libpppd_plugin-ril.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libpppd_plugin.so:system/lib/libpppd_plugin.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/pppd-ril:system/bin/pppd-ril \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/pppd:system/bin/pppd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/testpppd:system/bin/testpppd

# Stage Fright
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libstagefrighthw.so:system/lib/libstagefrighthw.so

# WiMax
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/RemoteProxy.cfg:system/etc/wimax/RemoteProxy.cfg \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/:system/etc/wimax/certs \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/macxvi.cfg:system/etc/wimax/macxvi.cfg \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/macxvi350.bin:system/etc/wimax/macxvi350.bin \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/mfg/:system/etc/wimax/mfg \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/wimax_oma_dm.db:system/etc/wimax/wimax_oma_dm.db \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/wimaxd.conf:system/etc/wimax/wimaxd.conf \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/443b9c9f.0:system/etc/wimax/certs/443b9c9f.0 \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/4ef3ec0e.0:system/etc/wimax/certs/4ef3ec0e.0 \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/51023c8f.0:system/etc/wimax/certs/51023c8f.0 \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/Commercial_device.pem:system/etc/wimax/certs/Commercial_device.pem \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/Commercial_prv_plain_key.pem:system/etc/wimax/certs/Commercial_prv_plain_key.pem \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/TestCA.pem:system/etc/wimax/certs/TestCA.pem \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/e1c07118.0:system/etc/wimax/certs/e1c07118.0 \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/wimax_server_root.pem:system/etc/wimax/certs/wimax_server_root.pem \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/wimax_server_root_ca1.pem:system/etc/wimax/certs/wimax_server_root_ca1.pem \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/wimax_server_root_ca2.pem:system/etc/wimax/certs/wimax_server_root_ca2.pem \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/certs/wimax_server_root_ca3.pem:system/etc/wimax/certs/wimax_server_root_ca3.pem \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/mfg/macxvi.cfg:system/etc/wimax/mfg/macxvi.cfg \\
	vendor/__VENDOR__/__DEVICE__/proprietary/etc/wimax/mfg/macxvi350.bin:system/etc/wimax/mfg/macxvi350.bin \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/wimaxc:system/bin/wimaxc \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/wimaxd:system/bin/wimaxd \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libwimax_jni.so:system/lib/libwimax_jni.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libwimax_moto.so:system/lib/libwimax_moto.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/wimax_test.sh:system/bin/wimax_test.sh \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/bcmwimax.ko:system/lib/bcmwimax.ko


# FM Radio
PRODUCT_COPY_FILES +=  \\
	vendor/__VENDOR__/__DEVICE__/proprietary/bin/fmradioserver:system/bin/fmradioserver \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libfmradio_jni.so:system/lib/libfmradio_jni.so \\
	vendor/__VENDOR__/__DEVICE__/proprietary/lib/libfmradioplayer.so:system/lib/libfmradioplayer.so

EOF
