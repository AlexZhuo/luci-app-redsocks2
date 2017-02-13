local state_msg = "" --alex:添加运行状态指示
local listen_port = luci.sys.exec("uci get redsocks2.@redsocks2_udprelay[0].local_port")
local udp_tcp_on = string.len(luci.sys.exec("netstat -nlp | grep " .. listen_port))>0
if udp_tcp_on then	
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m=Map("redsocks2",translate("Redsocks2 - UDP OVER TCP"),
translatef("将UDP协议的请求转化为TCP协议并发送至代理服务器进行代理请求，适合SSH ,socks5代理环境下的DNS请求转发。功能类似于ss-tunnel,注意只能向固定一个IP一个端口进行转发，相当于将远程端口映射到路由器本地") .. "<br><br>状态 - " .. state_msg)
s=m:section(TypedSection,"redsocks2_udprelay",translate("UDP OVER TCP"))
s.anonymous=true
s.addremove=false
o=s:option(Flag,"enabled",translate("启用UDP over TCP"),translate("启用后请手动修改【DHCP/DNS】的【DNS转发】为下面设置的监听地址"))
o=s:option(Value,"local_ip",translate("监听IP"))
o.datatype="ip4addr"
o=s:option(Value,"local_port",translate("监听端口"))
o.datatype="uinteger"
o=s:option(ListValue,"proxy_type",translate("Proxy Server Type"))
o:value("shadowsocks",translate("Shadowsocks端口隧道"))
o:value("overtcp",translate("UDP转TCP"))
o=s:option(Value,"ip",translate("Proxy Server IP"))
o:depends({proxy_type="shadowsocks"})
o.datatype="ip4addr"
o=s:option(Value,"port",translate("Proxy Server Port"))
o:depends({proxy_type="shadowsocks"})
o.datatype="uinteger"
o=s:option(ListValue,"enc_type",translate("Cipher Method"))
o:depends({proxy_type="shadowsocks"})
o:value("table")
o:value("rc4")
o:value("rc4-md5")
o:value("aes-128-cfb")
o:value("aes-192-cfb")
o:value("aes-256-cfb")
o:value("bf-cfb")
o:value("cast5-cfb")
o:value("des-cfb")
o:value("camellia-128-cfb")
o:value("camellia-192-cfb")
o:value("camellia-256-cfb")
o:value("idea-cfb")
o:value("rc2-cfb")
o:value("seed-cfb")
o=s:option(Value,"password",translate("Password"))
o:depends({proxy_type="shadowsocks"})
o.password=true
o=s:option(Value,"udp_timeout",translate("UDP Timeout"))
o:depends({proxy_type="shadowsocks"})
o.placeholder = "10"
o=s:option(Value,"tcp_timeout",translate("TCP DNS  超时时间"))
o:depends({proxy_type="overtcp"})
o.placeholder = "10"
o.datatype="uinteger"
o=s:option(Value,"dest_ip",translate("Destination IP"))
o.datatype="ip4addr"
o.placeholder = "8.8.8.8"
o=s:option(Value,"dest_ip2",translate("备用DNS服务器IP"))
o.datatype="ip4addr"
o.placeholder = "8.8.4.4"
o:depends({proxy_type="overtcp"})
o=s:option(Value,"dest_port",translate("Destination Port"))
o:depends({proxy_type="shadowsocks"})
o.datatype="uinteger"
o.placeholder = "53"
o=s:option(Flag, "tcp_proxy", translate("转发至代理服务器"))
o:depends({proxy_type="overtcp"})
o=s:option(Value,"red_port",translate("iptables转发端口"),translate("【基本设置】中的redsocks监听端口或SS/SSR透明代理端口"))
o:depends("tcp_proxy","1")
o.datatype="uinteger"
o.placeholder = "11111"
o=s:option(Flag, "set_dnsmasq", translate("自动修改dnsmasq全局配置"))
o.rmempty=true
-- ---------------------------------------------------
local apply = luci.http.formvalue("cbi.apply")
if apply then
	os.execute("/etc/init.d/redsocks2 restart >/dev/null 2>&1 &")
end
return m
