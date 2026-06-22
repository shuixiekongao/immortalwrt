# K2P 32M/512M USB 固件改造指南

## 📋 项目概述

本项目基于 ImmortalWrt v25.12.0，为 PHICOMM K2P 路由器（32MB Flash + 512MB RAM + USB）进行固件优化和增强。

## 🎯 改造目标

| 目标 | 说明 |
|-----|------|
| **存储优化** | 使用 LZ4 压缩，精简不必要软件包 |
| **内存优化** | 集成 ZRAM 虚拟压缩内存和 swap |
| **USB 增强** | 完整 USB 存储和文件系统支持 |
| **文件共享** | Samba4 网络文件共享功能 |
| **轻量 Web 界面** | LuCI 精简版本管理 |
| **稳定可靠** | 移除不稳定的功能，保证系统稳定性 |

## 📦 核心组件

### 已启用组件

```
✅ USB 驱动
   - USB 2.0 主机驱动 (kmod-usb2)
   - USB 存储设备 (kmod-usb-storage)
   - 高级 SCSI 支持 (kmod-uas)

✅ 文件系统
   - ext4 (主要文件系统)
   - exFAT (USB 移动设备)
   - NTFS (Windows 文件系统)
   - VFAT (FAT32 兼容)

✅ 网络共享
   - Samba4 文件服务
   - Web 管理界面

✅ 内存优化
   - ZRAM 压缩内存 (50MB)
   - Swap 管理工具

✅ 系统工具
   - curl / wget (网络下载)
   - nano (文本编辑)
   - htop (系统监控)
   - ca-bundle (SSL 证书)
```

### 已禁用组件

```
❌ 过大/不需要的包
   - IPv6 隧道 (6to4)
   - 第三方固件库
   - 调试符号信息
   - 监控收集工具 (collectd)
   - 深层网络工具 (nmap, mtr)

❌ 科学上网 (可选启用)
   - Shadowsocks
   - OpenVPN
   - WireGuard

❌ 极限 VI 编辑器
   - 使用轻量 nano 替代
```

## 🚀 快速开始

### 1. 环境准备

```bash
# Ubuntu/Debian 系统依赖
sudo apt update
sudo apt install -y \
  build-essential git libncurses-dev zlib1g-dev \
  gawk flex quilt libssl-dev xsltproc rsync \
  wget unzip python3 python3-dev python3-pip \
  device-tree-compiler mkisofs ccache

# 克隆分支
git clone -b k2p-32m-512m-usb \
  https://github.com/shuixiekongao/immortalwrt.git \
  k2p-build
cd k2p-build
```

### 2. 配置编译

```bash
# 方法一：使用预配置 (推荐)
cp .config.k2p .config

# 方法二：手动配置
make menuconfig
# 选择:
#   Target System: MediaTek Ralink MIPS
#   Subtarget: MT7620
#   Target Profile: PHICOMM K2P
```

### 3. 编译固件

```bash
# 快速编译 (使用缓存)
make clean
make -j$(nproc) download
make -j$(nproc)

# 或使用提供的脚本
bash build-k2p.sh
```

### 4. 编译输出

编译完成后，固件位置：

```
bin/targets/ramips/mt7620/
├── openwrt-ramips-mt7620-k2p-squashfs-factory.bin    (工厂刷)
├── openwrt-ramips-mt7620-k2p-squashfs-sysupgrade.bin (升级刷)
└── ...
```

## 📱 刷机指南

### 工厂固件刷机（从原厂系统）

1. 访问 K2P Web 管理界面 (通常 192.168.0.1)
2. 找到"固件升级"选项
3. 选择 `*-factory.bin` 文件
4. 点击升级，等待重启

### 升级刷机（从已有 OpenWrt）

```bash
# 方法一：Web 界面
# LuCI → 系统 → 备份/升级 → 选择 *-sysupgrade.bin

# 方法二：命令行
scp openwrt-*-sysupgrade.bin root@192.168.1.1:/tmp/
ssh root@192.168.1.1 sysupgrade -v /tmp/*-sysupgrade.bin
```

## ⚙️ 配置指南

### 首次启动

```bash
# 默认 IP: 192.168.1.1
# 默认用户: root
# 默认密码: (无密码，直接登录)

# SSH 登录
ssh root@192.168.1.1
```

### USB 存储挂载

```bash
# 查看 USB 设备
lsblk
# 或
fdisk -l

# 手动挂载
mkdir -p /mnt/usb
mount /dev/sda1 /mnt/usb

# 自动挂载配置
# LuCI → 系统 → 挂载点
# 或编辑 /etc/config/fstab
```

### ZRAM 内存优化

```bash
# 查看 ZRAM 状态
zramctl

# 启用 ZRAM swap
/etc/init.d/zram-swap enable
/etc/init.d/zram-swap start

# 查看内存使用
free -h
cat /proc/meminfo
```

### Samba 文件共享

```bash
# Web 界面配置
# LuCI → 服务 → Samba

# 或编辑配置文件
# /etc/samba/smb.conf.template

# 重启 Samba 服务
/etc/init.d/samba4 restart
```

## 🔧 自定义改造

### 添加科学上网功能

```bash
# 编辑 .config
# 取消注释:
CONFIG_PACKAGE_shadowsocks-libev=y
CONFIG_PACKAGE_luci-app-shadowsocks-libev=y

# 或在 menuconfig 中选择
make menuconfig
```

### 增加 OpenVPN 支持

```bash
# 注意: 这会增加约 1MB 固件大小
# .config 中取消注释:
CONFIG_PACKAGE_openvpn-openssl=y
CONFIG_PACKAGE_luci-app-openvpn=y
```

### 启用 IPv6

```bash
# 默认已启用
# 若要禁用,编辑 .config:
# CONFIG_PACKAGE_kmod-ipv6=n
# CONFIG_PACKAGE_ip6tables=n
```

## 📊 性能指标

### 固件大小

- **基础固件**: ~8-12 MB
- **启用所有推荐包**: ~15-18 MB
- **剩余空间**: ~10-15 MB (可用于包管理)

### 内存使用

- **启动后**: ~80-100 MB
- **启用 ZRAM (50MB)**: 可压缩约 130MB 数据
- **可用**: ~200-250 MB

### 性能

- **CPU**: MT7620A @ 580 MHz
- **WiFi**: 802.11ac (理论最高 867Mbps)
- **网络**: 千兆以太网

## 🐛 故障排查

### 固件无法启动

```bash
# 1. 检查是否使用了错误的刷机文件
#    工厂固件: xxxxfactory.bin
#    升级固件: xxxsysupgrade.bin

# 2. 尝试恢复原厂固件后重新刷机
# 3. 使用 TFTP 刷机救砖
```

### USB 设备无法识别

```bash
# 检查内核日志
logread -f

# 检查 USB 模块
lsmod | grep usb

# 重新加载 USB 驱动
rmmod usb_storage
modprobe usb_storage
```

### 内存不足

```bash
# 启用 ZRAM
/etc/init.d/zram-swap enable
/etc/init.d/zram-swap start

# 查看进程占用
top

# 杀死占用内存的进程
kill -9 <PID>
```

### Web 界面卡顿

```bash
# 减少并发连接
# 编辑 /etc/config/uhttpd

# 或重启 Web 服务
/etc/init.d/uhttpd restart
```

## 📚 参考资源

- [ImmortalWrt 官方](https://github.com/immortalwrt/immortalwrt)
- [OpenWrt 文档](https://openwrt.org/docs)
- [K2P 硬件信息](https://openwrt.org/toh/phicomm/k2p)
- [LuCI 文档](https://github.com/openwrt/luci/wiki)

## 📝 更新日志

### v25.12.0-K2P-20260122

- ✨ 基础固件编译配置
- ✨ USB 存储完整支持
- ✨ ZRAM 内存优化
- ✨ Samba4 文件共享
- 🔧 精简 Web 界面
- 📦 预加载常用工具

## 💬 技术支持

- Issues: https://github.com/shuixiekongao/immortalwrt/issues
- Discussions: https://github.com/shuixiekongao/immortalwrt/discussions

## 📄 许可证

GPL-2.0-only (继承自 ImmortalWrt/OpenWrt)
