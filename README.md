# openwrt_oscam


部署说明
将上述文件按结构放入 package/network/oscam

在 make menuconfig 中选择：


Network → Web Servers/Proxies → oscam
编译后通过 opkg 安装，配置路径：

主配置：/etc/oscam/

UCI 配置：/etc/config/oscam

此版本已适配最新 OpenWrt 构建系统，并通过 GitHub Actions 验证。
