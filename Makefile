ARCHS = armv7 armv7s arm64
TARGET = iphone::9.3:9.0
THEOS_DEVICE_IP = 192.168.1.100

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideStatusBarItemsPro
HideStatusBarItemsPro_FILES = Tweak.xm
HideStatusBarItemsPro_FRAMEWORKS = Foundation UIKit 
HideStatusBarItemsPro_PRIVATE_FRAMEWORKS = AppSupport 
HideStatusBarItemsPro_CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += hidestatusbaritemspro
include $(THEOS_MAKE_PATH)/aggregate.mk