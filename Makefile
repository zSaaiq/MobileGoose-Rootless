THEOS_DEVICE_IP = 192.168.0.198
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME=rootless
TARGET = iphone:15.6
ARCHS = arm64 arm64e
export TARGET ARCHS

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MobileGoose

MobileGoose_FRAMEWORKS = UIKit Foundation
MobileGoose_FILES = Tweak.xm $(wildcard Goose/*.mm)
MobileGoose_CFLAGS = -fobjc-arc -I. -include macros.h -ferror-limit=0

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
