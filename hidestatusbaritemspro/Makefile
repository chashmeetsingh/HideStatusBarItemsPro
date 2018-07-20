ARCHS = armv7 armv7s arm64
TARGET = iphone::9.3:9.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HideStatusBarItemsPro
HideStatusBarItemsPro_FILES = hidestatusbaritems.m
HideStatusBarItemsPro_INSTALL_PATH = /Library/PreferenceBundles
HideStatusBarItemsPro_FRAMEWORKS = UIKit
HideStatusBarItemsPro_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/HideStatusBarItemsPro.plist$(ECHO_END)
