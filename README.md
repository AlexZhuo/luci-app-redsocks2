# luci-app-redsocks2
为OpenWRT上Redsocks2开发的luci配置页面，支持Redsocks2 v0.66的几乎全部功能

简介
---
为编译[此固件][N]所需依赖包而写的Makefile,部分界面的翻译请下载该[i18n ipk][3]

软件包只包含OpenWrt的luci配置页面，编译Redsocks2可执行文件的ipk请参考此项目[openwrt-redsocks2][1]

主要功能

1、支持Socks5,Socks4,HTTP和Shadowsocks的透明代理

2、支持Shadowsocks的UDP转发功能

3、支持UDP over TCP并转发DNS请求至代理服务器，可远程解析DNS防污染

4、支持类似ss-tunnel的功能远程DNS解析

5、支持VPN共享功能

6、支持使用透明代理实现NAT，并能修改出入路由数据包的TTL达到突破路由封锁的效果

7、支持目标IP地址白名单功能（国内路由表）

8、支持指定局域网主机不经过代理

依赖
---
+redsocks2  redsocks主程序，应放置在/usr/sbin下

+kmod-ipt-ipopt 用于修改TTL 

+iptables-mod-ipopt 用于修改TTL

+ipset 用于IP白名单功能 

+ip-full 用于Shadowsocks UDP转发功能

+iptables-mod-tproxy 用于Shadowsocks UDP转发功能

+kmod-ipt-tproxy 用于Shadowsocks UDP转发功能

+iptables-mod-nat-extra 用于Shadowsocks UDP转发功能

编译
---

 - 从 OpenWrt 的 [SDK][S] 编译  

   ```bash
   # 以 ar71xx 平台为例
   tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
   cd OpenWrt-SDK-ar71xx-*
   # 获取 Makefile
   git clone https://github.com/AlexZhuo/luci-app-redsocks2.git package/luci-app-redsocks2
   # 选择要编译的包 Luci -> Network -> luci-app-redsocks2
   make menuconfig
   # 开始编译
   make package/luci-app-redsocks2/compile V=99
   ```

----------

使用说明
---
1、Socks5代理，一般用于SSH代理
![demo](https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-3.png)

2、ShadowSocks代理
![demo](https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-1.png)

3、Socks5代理服务器解析DNS，在配置好Redsocks2之后，还需要修改dnsmasq将Redsocks2作为上游DNS服务器，你还可以使用GFWList配合ipset实现更有效率的DNS解析策略
![demo](https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-2.png)

4、Shadowsocks代理服务器解析DNS，用法同上
![demo](https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-6.png)

5、修改dnsmasq的上游服务器为Redsocks2

DNS转发填Redsocks2的UDP监听端口，并勾选“忽略解析文件”
![demo](https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-7.png)
![demo](https://github.com/AlexZhuo/BreakwallOpenWrt/raw/master/screenshots/luci-redsocks2-8.png)

6、获取并更新国内路由表

国内路由表可以直接下载[该文件][2],并放置到/etc目录下，然后按照第一张图上的“启用白名单”项进行配置，可节省代理服务器的流量并加快中国大陆网站的访问速度


[1]: https://github.com/AlexZhuo/openwrt-redsocks2
[S]: http://wiki.openwrt.org/doc/howto/obtain.firmware.sdk
[2]: https://github.com/AlexZhuo/BlockedDomains/blob/master/china_route
[N]: http://www.right.com.cn/forum/thread-198649-1-1.html
[3]: https://github.com/AlexZhuo/BreakwallOpenWrt/blob/master/ar71xx/ImageBuilder/packages/base/luci-i18n-redsocks2-zh-cn_git-15.111.32254-5ecd256-1_all.ipk
