THEOS_DEVICE_IP = 192.168.178.116
FINALPACKAGE = 1
PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
THEOS_PACKAGE_SCHEME=rootless
INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:15.6
ARCHS = arm64 arm64e
export TARGET ARCHS

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ColorfulGoose
ColorfulGoose_FILES = PXColorfulGoose.m
ColorfulGoose_CFLAGS = -fobjc-arc
ColorfulGoose_INSTALL_PATH = /MobileGoose/Mods
ColorfulGoose_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/bundle.mk
