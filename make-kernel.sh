#!/bin/bash

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabi-
make clean
<<<<<<< HEAD
make joker_defconfig
make menuconfig
KBUILD_BUILD_VERSION="joker-ext4-newoc"
export KBUILD_BUILD_VERSION
make -o3 modules
make -o3 zImage
export ANDROID_BUILD_TOP=~/Mopho-/Photon-blur-kernel
cd open-src/src/dhd/linux
make -o3 dhd-cdc-sdstd
make joker_newoc_defconfig
make menuconfig
KBUILD_BUILD_VERSION="joker-newoc-highpro"
export KBUILD_BUILD_VERSION
make -o3 zImage
