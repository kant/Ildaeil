#!/usr/bin/make -f
# Makefile for DISTRHO Plugins #
# ---------------------------- #
# Created by falkTX
#

# NOTE This file MUST be imported after setting `NAME`

# --------------------------------------------------------------
# Files to build

FILES_DSP = \
	IldaeilPlugin.cpp

FILES_UI = \
	IldaeilUI.cpp \
	../Common/PluginHostWindow.cpp \
	../../dpf-widgets/opengl/DearImGui.cpp

# --------------------------------------------------------------
# Carla stuff

ifneq ($(DEBUG),true)
EXTERNAL_PLUGINS = true
endif

CWD = ../../carla/source
include $(CWD)/Makefile.deps.mk

CARLA_BUILD_DIR = ../../carla/build
ifeq ($(DEBUG),true)
CARLA_BUILD_TYPE = Debug
else
CARLA_BUILD_TYPE = Release
endif

CARLA_EXTRA_LIBS  = $(CARLA_BUILD_DIR)/plugin/$(CARLA_BUILD_TYPE)/carla-host-plugin.cpp.o
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/carla_engine_plugin.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/carla_plugin.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/native-plugins.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/audio_decoder.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/jackbridge.min.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/lilv.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/rtmempool.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/sfzero.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/water.a
CARLA_EXTRA_LIBS += $(CARLA_BUILD_DIR)/modules/$(CARLA_BUILD_TYPE)/zita-resampler.a

EXTRA_DEPENDENCIES = $(CARLA_EXTRA_LIBS)
EXTRA_LIBS = $(CARLA_EXTRA_LIBS) $(STATIC_CARLA_PLUGIN_LIBS)

# --------------------------------------------------------------
# Do some more magic

USE_VST2_BUNDLE = true
include ../../dpf/Makefile.plugins.mk

BUILD_CXX_FLAGS += -pthread
BUILD_CXX_FLAGS += -I../Common
BUILD_CXX_FLAGS += -I../../dpf-widgets/generic
BUILD_CXX_FLAGS += -I../../dpf-widgets/opengl

BUILD_CXX_FLAGS += -DCARLA_BACKEND_NAMESPACE=Ildaeil
BUILD_CXX_FLAGS += -DREAL_BUILD
BUILD_CXX_FLAGS += -DSTATIC_PLUGIN_TARGET
BUILD_CXX_FLAGS += -I../../carla/source/backend
BUILD_CXX_FLAGS += -I../../carla/source/includes
BUILD_CXX_FLAGS += -I../../carla/source/modules
BUILD_CXX_FLAGS += -I../../carla/source/utils

ifeq ($(MACOS),true)
$(BUILD_DIR)/../Common/PluginHostWindow.cpp.o: BUILD_CXX_FLAGS += -ObjC++
$(BUILD_DIR)/../Common/SizeUtils.cpp.o: BUILD_CXX_FLAGS += -ObjC++
endif

# --------------------------------------------------------------
# Enable all possible plugin types

all: jack lv2 vst2 vst3 carlabins

# --------------------------------------------------------------
# special step for carla binaries

CARLA_BINARIES  = $(CURDIR)/../../carla/bin/carla-bridge-native$(APP_EXT)
CARLA_BINARIES += $(CURDIR)/../../carla/bin/carla-bridge-lv2-gtk2$(APP_EXT)
CARLA_BINARIES += $(CURDIR)/../../carla/bin/carla-bridge-lv2-gtk3$(APP_EXT)

carlabins: lv2 vst2 vst3
	install -m 755 $(CARLA_BINARIES) $(shell dirname $(lv2))
	install -m 755 $(CARLA_BINARIES) $(shell dirname $(vst2))
	install -m 755 $(CARLA_BINARIES) $(shell dirname $(vst3))

# --------------------------------------------------------------
