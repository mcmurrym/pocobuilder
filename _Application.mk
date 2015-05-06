
APP_ABI := armeabi armeabi-v7a x86

APP_OPTUM := release
APP_PLATFORM := android-15
APP_STL := gnustl_shared

NDK_TOOLCHAIN_VERSION := 4.9
APP_CPPFLAGS += -std=c++14

APP_CPPFLAGS += -fexceptions
APP_CPPFLAGS += -fpermissive
APP_CPPFLAGS += -frtti