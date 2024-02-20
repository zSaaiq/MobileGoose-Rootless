# Theos optimisations

ARCHS = arm64 arm64e

ifeq ($(ROOTLESS),1)
	TARGET = iphone:clang:latest:15.0
endif

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

MobileGoose_FRAMEWORKS = UIKit
MobileGoose_LIBRARIES = substrate

BUNDLE_NAME = MobileGoose
$(BUNDLE_NAME)_INSTALL_PATH= $(wildcard *.m) $(wildcard *.mm)
$(BUNDLE_NAME)_INSTALL_PATH = var/jb/Library/PreferenceBundles
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/library.mk

# Rootless support? with a question mark

ifeq ($(ROOTLESS),1)
DYLIB_PATH = $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/$(LIBRARY_NAME).dylib

internal-stage::
 @$(PRINT_FORMAT_MAKING) "Patching load commands for $(LIBRARY_NAME)"

 $(ECHO_NOTHING)for fw in $($(LIBRARY_NAME)_EXTRA_FRAMEWORKS); do \
	 install_name_tool -change /Library/Frameworks/$$fw.framework/$$fw \
	 /var/jb/Library/Frameworks/$$fw.framework/$$fw \
	 "$(DYLIB_PATH)" > /dev/null 2>&1 ; \
 done$(ECHO_END)

 $(ECHO_NOTHING)for lib in $($(LIBRARY_NAME)_LIBRARIES); do \
	 install_name_tool -change /usr/lib/lib$$lib.dylib \
	 /var/jb/usr/lib/lib$$lib.dylib \
	 "$(DYLIB_PATH)" > /dev/null 2>&1 ; \
 done$(ECHO_END)

 @$(PRINT_FORMAT_MAKING) "Re-signing $(LIBRARY_NAME)"

 $(ECHO_NOTHING)ldid -S "$(DYLIB_PATH)"$(ECHO_END)
endif

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/var/jb/var/mobile/Library/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/var/jb/var/mobile/Library/Preferences/MobileGoose.plist$(ECHO_END)
