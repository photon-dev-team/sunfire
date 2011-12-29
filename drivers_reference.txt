
#vpndriver.ko:
make -j1 -C $KERNEL_SRC O=$KERNEL_BUILD_OUT DEPMOD=$PLATFORM_DIR/out/host/linux-x86/bin/depmod INSTALL_MOD_PATH=$KERNEL_BUILD_OUT M=$PLATFORM_DIR/device/motorola/sunfire/modules_src/vpndriver modules 

#DHD.ko:
 make -C /Depot/devel/android/cm/device/motorola/sunfire/modules_src/dhd_from_moto_sourceforge/src/dhd/linux ANDROID_BUILD_TOP=$PLATFORM_DIR LINUXVER=2.6.32.9 -I/Depot/devel/android/cm/kernel/tegra O=$KERNEL_BUILD_OUT DEPMOD=$PLATFORM_DIR/out/host/linux-x86/bin/depmod

#bcmsdio.ko:
make -j1 -C $KERNEL_SRC O=$KERNEL_BUILD_OUT DEPMOD=$PLATFORM_DIR/out/host/linux-x86/bin/depmod INSTALL_MOD_PATH=$KERNEL_BUILD_OUT M=$PLATFORM_DIR/device/motorola/sunfire/modules_src/bcm_sdio_wrapper modules


/Depot/devel/android/cm/kernel/broadcom/src/dhd/linux
