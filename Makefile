include $(TOPDIR)/rules.mk

PKG_NAME:=oscam
PKG_VERSION:=1.20+git-20231120
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/hehe1323/oscam.git
PKG_SOURCE_DATE:=2025-02-01
PKG_SOURCE_VERSION:=0de3fba81fba430dae5464a4c9075cd9cd97d0df # 替换为实际commit
PKG_MIRROR_HASH:=skip

PKG_MAINTAINER:=Your Name <your@email.com>
PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/oscam/config
  source "$(SOURCE)/Config.in"
endef

define Package/oscam
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=OSCam Conditional Access Module
  URL:=https://github.com/hehe1323/oscam
  DEPENDS:=+libopenssl +libusb-1.0 +libpcsc +kmod-usb-serial \
           +kmod-usb-serial-ch341 +kmod-usb-serial-pl2303 \
           +zlib +libpthread
  MENU:=1
endef

define Package/oscam/description
  OSCam with UCI integration and modern dependencies.
  Supports USB serial readers and PC/SC devices.
endef

CMAKE_OPTIONS += \
    -DWEBIF=1 \
    -DWITH_SSL=1 \
    -DHAVE_LIBUSB=1 \
    -DHAVE_PCSC=1 \
    -DCLOCKFIX=1 \
    -DCS_ANTICASC=1 \
    $(if $(CONFIG_OSCAM_IPV6SUPPORT),-DIPV6SUPPORT=1) \
    $(if $(CONFIG_OSCAM_MODULE_CAMD35),-DMODULE_CAMD35=1)

define Package/oscam/conffiles
/etc/oscam/
/etc/config/oscam
endef

define Package/oscam/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/oscam $(1)/usr/bin/
	
	$(INSTALL_DIR) $(1)/etc/oscam
	$(INSTALL_CONF) ./files/oscam.* $(1)/etc/oscam/
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/oscam.init $(1)/etc/init.d/oscam
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/oscam.conf $(1)/etc/config/oscam
endef

$(eval $(call BuildPackage,oscam))
