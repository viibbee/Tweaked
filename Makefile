TARGET := iphone:clang:latest:12.0
THEOS := /theos
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MyTweak
MyTweak_FILES = Tweak.xm
MyTweak_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
