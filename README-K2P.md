# K2P 32M/512M USB 固件改造项目

## 🎯 项目简介

这是一个为 PHICOMM K2P 路由器专门定制的 ImmortalWrt 固件改造项目，针对其有限的硬件资源（32MB Flash + 512MB RAM）进行深度优化。

## 📂 文件说明

```
.
├── .config                    # 编译配置文件 (核心配置)
├── feeds.conf.k2p             # K2P 专用 feeds 配置
├── build-k2p.sh               # 自动编译脚本
├── K2P-BUILD-GUIDE.md         # 详细编译指南
├── README-K2P.md             # 本文件 (快速开始)
└── scripts/
    └── k2p-install-packages.sh # 系统初始化脚本
```

## 🚀 5分钟快速开始

### 1. 克隆仓库

```bash
git clone -b k2p-32m-512m-usb https://github.com/shuixiekongao/immortalwrt.git
cd immortalwrt
```

### 2. 执行编译

```bash
# 使用提供的脚本 (推荐)
bash build-k2p.sh

# 或手动编译
./scripts/feeds update -a
./scripts/feeds install -a
cp .config .config
make -j$(nproc)
```

### 3. 刷机

编译完成后，在 `bin/targets/ramips/mt7620/` 目录找到固件：

```bash
# 工厂刷 (从原厂系统)
openwrt-ramips-mt7620-k2p-squashfs-factory.bin

# 升级刷 (从已有系统)
openwrt-ramips-mt7620-k2p-squashfs-sysupgrade.bin
```

## 💡 核心功能

| 功能 | 状态 | 说明 |
|-----|------|------|
| USB 存储 | ✅ | 完整支持 ext4/NTFS/exFAT |
| 文件共享 | ✅ | Samba4 网络共享 |
| 内存优化 | ✅ | ZRAM + Swap 虚拟扩展 |
| Web 管理 | ✅ | LuCI 精简版 |
| 网络功能 | ✅ | 标准 WiFi + 有线路由 |
| 科学上网 | ⚠️ | 默认禁用 (可选启用) |

## 🔧 自定义编译

### 启用更多功能

编辑 `.config` 文件，修改以下选项：

```bash
# Shadowsocks (科学上网)
CONFIG_PACKAGE_shadowsocks-libev=y
CONFIG_PACKAGE_luci-app-shadowsocks-libev=y

# WireGuard VPN
CONFIG_PACKAGE_wireguard-tools=y
CONFIG_PACKAGE_kmod-wireguard=y

# OpenVPN
CONFIG_PACKAGE_openvpn-openssl=y
```

然后重新编译：

```bash
make menuconfig
make -j$(nproc)
```

## 📊 固件规格

- **基础大小**: ~12 MB
- **推荐配置**: ~15-18 MB
- **剩余空间**: ~14-19 MB (opkg 软件包安装空间)
- **启动内存**: ~80-120 MB
- **可用内存**: ~250-350 MB (启用 ZRAM 后)

## 🎮 首次启动

```bash
# IP 地址
192.168.1.1

# 用户名
root

# 密码
(空白,直接登录)

# SSH 访问
ssh root@192.168.1.1
```

## 📋 系统配置清单

刷机后建议执行的配置：

- [ ] 修改 root 密码
- [ ] 配置 WiFi SSID 和密码
- [ ] 设置时区和 NTP 服务
- [ ] 启用 ZRAM swap (`/etc/init.d/zram-swap enable`)
- [ ] 配置 USB 自动挂载
- [ ] 配置 Samba 文件共享
- [ ] 设置防火墙规则
- [ ] 更新软件包列表 (`opkg update`)

## ⚠️ 重要提示

1. **备份重要数据**: 刷机会清除所有数据
2. **确保电源充足**: 刷机过程中不要断电
3. **选择正确文件**: 
   - 工厂系统用 `factory.bin`
   - 已有系统用 `sysupgrade.bin`
4. **空间限制**: 32MB Flash 有限，谨慎安装大型包

## 🐛 常见问题

**Q: 如何恢复原厂固件?**
A: 在原厂管理界面上传原厂 bin 文件即可恢复。

**Q: USB 无法识别?**
A: 检查 `/proc/bus/usb/devices`，确保已加载 USB 驱动。

**Q: 系统卡顿?**
A: 启用 ZRAM swap 或减少运行的服务。

**Q: 如何增加 opkg 空间?**
A: 将 opkg 配置指向 USB 存储。

## 📚 更多资源

- [完整编译指南](./K2P-BUILD-GUIDE.md)
- [ImmortalWrt 官方](https://github.com/immortalwrt/immortalwrt)
- [OpenWrt 文档](https://openwrt.org/docs)
- [K2P 硬件信息](https://openwrt.org/toh/phicomm/k2p)

## 📞 技术支持

遇到问题？

1. 检查 [K2P-BUILD-GUIDE.md](./K2P-BUILD-GUIDE.md) 中的故障排查
2. 查看编译日志获取错误信息
3. 提交 Issue: https://github.com/shuixiekongao/immortalwrt/issues

## 📄 许可证

GPL-2.0-only - 与 ImmortalWrt/OpenWrt 保持一致

---

**最后更新**: 2026-01-22  
**维护者**: shuixiekongao  
**版本**: v25.12.0
