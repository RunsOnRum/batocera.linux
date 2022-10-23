################################################################################
#
# sway
#
################################################################################

SWAY_VERSION = 1.7
SWAY_SITE = $(call github,swaywm,sway,$(SWAY_VERSION))
SWAY_LICENSE = MIT
SWAY_LICENSE_FILES = LICENSE
SWAY_DEPENDENCIES = wlroots cairo pango libglib2

SWAY_CONF_OPTS = -Ddefault-wallpaper=false \
                -Dzsh-completions=false \
                -Dbash-completions=false \
                -Dfish-completions=false \
                -Dswaybar=false \
                -Dtray=disabled \
                -Dman-pages=disabled

ifeq ($(BR2_PACKAGE_WLROOTS_X11),y)
SWAY_CONF_OPTS += -Dxwayland=enabled
else
SWAY_CONF_OPTS += -Dxwayland=disabled
endif

# sway does not build without -Wno flags as all warnings being treated as errors
SWAY_CFLAGS = $(TARGET_CFLAGS) -Wno-unused-variable -Wno-unused-but-set-variable -Wno-unused-function -Wno-maybe-uninitialized -Wno-stringop-truncation -Wno-address

define SWAY_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/bin
    $(INSTALL) -D $(@D)/build/sway/sway         $(TARGET_DIR)/usr/bin
    $(INSTALL) -D $(@D)/build/swaymsg/swaymsg   $(TARGET_DIR)/usr/bin

    mkdir -p $(TARGET_DIR)/etc/sway
    $(INSTALL) -D $(BR2_EXTERNAL_BATOCERA_PATH)/package/batocera/gpu/sway/config \
        $(TARGET_DIR)/etc/sway
endef

$(eval $(meson-package))
