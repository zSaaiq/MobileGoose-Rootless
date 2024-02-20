THEOS_DEVICE_IP = 192.168.178.116
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME=rootless
TARGET = iphone:16.5
ARCHS = arm64 arm64e

TWEAK_NAME = MobileGoose

$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation
$(TWEAK_NAME)_FILES = Tweak.xm $(wildcard Goose/*.mm)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -I. -include macros.h -ferror-limit=0

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/tweak.mk
export TARGET ARCHS THEOS_PACKAGE_SCHEME
export SYSROOT = $(THEOS)/sdks/iPhoneOS15.6.sdk/
export ROOTLESS = 1
SUBPROJECTS += Prefs
