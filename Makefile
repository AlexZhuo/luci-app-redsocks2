include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-redsocks2
PKG_VERSION=1.5
PKG_RELEASE:=1
PKG_MAINTAINER:=Alex Zhuo <1886090@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=Network
	SUBMENU:=Luci
	TITLE:=luci for redsocks2 on OpenWrt
	PKGARCH:=all
	DEPENDS:=+redsocks2 +kmod-ipt-ipopt +iptables-mod-ipopt +ipset +ip +iptables-mod-tproxy +kmod-ipt-tproxy +iptables-mod-nat-extra
endef

define Package/$(PKG_NAME)/description
    A luci app for redsocks2
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
rm -rf /tmp/luci*
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
    $(CP) ./files/* $(1)/

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
