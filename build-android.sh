#!/bin/bash
# Script for cross-compiling lookbusy
# 1. Specify the toolchain to use with environment variables
# 2. Cross-compile lookbusy for Android

# Only choose one of these, depending on your build machine...
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/darwin-x86_64
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
# Only choose one of these, depending on your device...
export TARGET=aarch64-linux-android
export TARGET=armv7a-linux-androideabi
export TARGET=i686-linux-android
export TARGET=x86_64-linux-android
# Set this to your minSdkVersion
export API=21
# Configure
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip
./configure --host $TARGET
# Comment two lines in config.h
sed -i 's/#define malloc rpl_malloc/\/\/ &/' config.h
sed -i 's/#define realloc rpl_realloc/\/\/ &/' config.h
# Build
make
