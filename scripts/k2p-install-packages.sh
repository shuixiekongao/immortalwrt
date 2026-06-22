#!/bin/bash
# K2P 系统安装后配置脚本
# 用途: 在路由器上运行，配置 USB、ZRAM、Samba 等

echo "========================================"
echo "K2P 系统初始化配置脚本"
echo "========================================"
echo ""

# 检查root权限
if [ "$EUID" -ne 0 ]; then
   echo "❌ 此脚本需要 root 权限运行"
   exit 1
fi

# 更新包列表
echo "📦 更新包列表..."
opkg update

# 1. 安装额外的文件系统工具
echo ""
echo "📦 安装文件系统工具..."
opkg install kmod-fs-ext4 e2fsprogs

# 2. 启用 ZRAM swap
echo ""
echo "⚙️  配置 ZRAM 内存优化..."
opkg install zram-swap
/etc/init.d/zram-swap enable
/etc/init.d/zram-swap start

# 3. 配置 Samba
echo ""
echo "⚙️  启动 Samba 文件共享服务..."
opkg install samba4-server luci-app-samba4
/etc/init.d/samba4 enable
/etc/init.d/samba4 start

# 4. 创建 USB 挂载点
echo ""
echo "📁 创建 USB 挂载点..."
mkdir -p /mnt/usb
mkdir -p /mnt/usb-backup

# 5. 配置自动挂载 (可选)
echo ""
echo "🔧 配置 USB 自动挂载..."
cat > /etc/config/fstab.template << 'EOF'
config mount
	option target		/mnt/usb
	option device		/dev/sda1
	option fstype		ext4
	option options		defaults
	option enabled		1
EOF

# 6. 优化系统参数
echo ""
echo "⚙️  优化系统参数..."

# 增加 inotify 限制
echo "fs.inotify.max_user_watches=262144" >> /etc/sysctl.conf

# 优化网络性能
echo "net.ipv4.tcp_fin_timeout=30" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time=300" >> /etc/sysctl.conf
echo "net.core.somaxconn=65535" >> /etc/sysctl.conf

# 应用 sysctl 配置
sysctl -p

# 7. 显示系统信息
echo ""
echo "✅ 系统初始化完成!"
echo ""
echo "📊 系统信息:"
echo "========================================"
echo "内存使用:"
free -h
echo ""
echo "ZRAM 状态:"
zramctl || echo "(ZRAM 模块未加载)"
echo ""
echo "USB 设备:"
lsblk 2>/dev/null || echo "(未检测到 USB 设备)"
echo ""
echo "Samba 状态:"
/etc/init.d/samba4 status || /etc/init.d/samba4 running && echo "✅ Samba 运行中" || echo "❌ Samba 未运行"
echo "========================================"
echo ""
echo "后续配置:"
echo "1. Web 界面: http://192.168.1.1"
echo "2. Samba 配置: 系统 → 服务 → Samba"
echo "3. USB 挂载: 系统 → 挂载点"
echo "4. 内存监控: 系统 → 状态"
echo ""
