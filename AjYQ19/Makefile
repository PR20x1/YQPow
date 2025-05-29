THEOS_DEVICE_IP = 192.168.1.54 -p 2222 
ROOTLESS = 1
ifeq ($(ROOTLESS), 1)
THEOS_PACKAGE_SCHEME = rootless
endif
ifeq ($(ROOTLESS), 2)
THEOS_PACKAGE_SCHEME = roothide
endif
TARGET = iphone:clang:latest:10.0
ARCHS  = arm64
_NO_SUBSTRATE = 0
INSTALL_TARGET_PROCESSES = codmvn
_IGNORE_WARNINGS = 1
TWEAK_NAME = lunite
PROJ_COMMON_FRAMEWORKS = UIKit Foundation MetalKit Metal ModelIO Security QuartzCore CoreGraphics CoreText AudioToolbox Security CoreGraphics AVFoundation Accelerate
KITTYMEMORY_SRC = $(wildcard KittyMemory/*.cpp)
IMGUI_SRC = $(wildcard imgui/*.cpp)
HOSTS_SRC = $(wildcard Hosts/*.m)
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Werror -Wno-deprecated-declarations -Wno-unused-variable -Wno-unused-value -Wno-enum-conversion
$(TWEAK_NAME)_CCFLAGS = -std=c++17 -fno-rtti -fno-exceptions -DNDEBUG
ADDITIONAL_CFLAGS += -DOBFUSCATE_STRINGS
ADDITIONAL_CFLAGS += -D_FORTIFY_SOURCE=2 -fstack-protector-all
$(TWEAK_NAME)_FILES = Tweak.xm $(IMGUI_SRC) $(HOSTS_SRC) $(KITTYMEMORY_SRC) ModController.mm CheatState/CheatState.cpp Stream/HeeeNoScreenShotView.m imgui/imgui_impl_metal.mm
$(TWEAK_NAME)_OBJ_FILES = KittyMemory/Deps/Keystone/libs-ios/arm64/libkeystone.a
$(TWEAK_NAME)_LIBRARIES += substrate
$(TWEAK_NAME)_FRAMEWORKS = $(PROJ_COMMON_FRAMEWORKS)
include $(THEOS)/makefiles/common.mk
ifeq ($(IGNORE_WARNINGS),1)
  $(TWEAK_NAME)_CFLAGS += -w
  $(TWEAK_NAME)_CCFLAGS += -w
endif
ifeq ($(_NO_SUBSTRATE), 1)
$(TWEAK_NAME)_CCFLAGS += -DkNO_SUBSTRATE
endif
include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
  install.exec "killall -9 codm || :"
