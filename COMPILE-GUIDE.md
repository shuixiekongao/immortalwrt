# K2P 固件编译完整指南

## 📋 前置要求

### 系统要求
- **操作系统**: Ubuntu 20.04/22.04 LTS 或 Debian 11+
- **CPU**: 双核 Intel/AMD 64位处理器
- **内存**: 至少 4GB (推荐 8GB+)
- **磁盘**: 至少 50GB 可用空间
- **网络**: 稳定的国际网络连接

### 不支持的系统
- ❌ Windows (原生)
- ❌ macOS (虽然技术上可行，但不推荐)
- ❌ 虚拟机中编译 (性能差)

---

## 🔧 环境准备 (3 步)

### 方式一: 自动脚本 (推荐)

```bash
# 下载并运行自动安装脚本
bash <(curl -s https://raw.githubusercontent.com/immortalwrt/immortalwrt/master/scripts/build-setup.sh)
```

### 方式二: 手动安装依赖

#### Ubuntu/Debian 用户

```bash
# 更新包管理器
sudo apt update
sudo apt full-upgrade -y

# 安装编译依赖 (一行命令)
sudo apt install -y \
  build-essential libncurses-dev zlib1g-dev gawk git flex quilt \
  libssl-dev xsltproc rsync wget unzip python3 python3-dev python3-pip \
  device-tree-compiler mkisofs ccache libfuse-dev

# 创建编译目录
mkdir -p ~/openwrt-build
cd ~/openwrt-build

# 配置 ccache (加速编译)
echo 'export PATH="/usr/lib/ccache:$PATH"' >> ~/.bashrc
source ~/.bashrc
ccache -M 10G  # 设置缓存大小为 10GB
```

#### CentOS/RHEL 用户

```bash
sudo yum groupinstall -y "Development Tools"
sudo yum install -y \
  ncurses-devel zlib-devel gawk flex quilt openssl-devel \
  xsltproc rsync wget unzip python3-devel device-tree-compiler \
  mkisofs ccache
```

---

## 🚀 编译步骤 (5 步)

### 第 1 步: 克隆仓库

```bash
# 克隆分支 (节省空间)
git clone -b k2p-32m-512m-usb --depth=1 \
  https://github.com/shuixiekongao/immortalwrt.git k2p-build

cd k2p-build

# 显示分支信息
git branch -v
```

**预期输出:**
```
* k2p-32m-512m-usb  9a98463 feat: K2P 32M/512M USB固件改造配置
```

---

### 第 2 步: 更新 Feeds

Feeds 是软件包源，需要更新以获取最新的包。

```bash
# 复制 feeds 配置
cp feeds.conf.default feeds.conf

# 追加 K2P 专用 feeds
cat feeds.conf.k2p >> feeds.conf

# 显示当前 feeds
echo "📦 当前 Feeds 配置:"
cat feeds.conf
```

**然后更新:**

```bash
# 更新所有 feeds (首次需要时间)
echo "⏳ 更新 feeds (这需要 5-15 分钟)..."
./scripts/feeds update -a

# 安装所有 feeds
echo "📥 安装 feeds..."
./scripts/feeds install -a

# 验证安装
echo "✅ Feeds 安装完成"
ls -la package/feeds/ | head -20
```

**进度参考:**
- 初次更新: 5-15 分钟 (取决于网络)
- 后续更新: 2-3 分钟

---

### 第 3 步: 应用配置

K2P 编译配置已预先准备：

```bash
# 方式一: 使用预设配置 (快速)
echo "⚙️ 应用 K2P 预设配置..."
cp .config .config.bak  # 备份
make defconfig

# 验证配置
echo "📋 验证配置..."
grep "CONFIG_TARGET_ramips_mt7620_DEVICE_k2p" .config
```

**预期输出:**
```
CONFIG_TARGET_ramips_mt7620_DEVICE_k2p=y
```

#### 方式二: 手动配置 (如需调整)

```bash
# 启动菜单式配置
make menuconfig
```

**导航方式:**
```
↓ 上下移动    ← → 左右移动    Space 选择/取消    Esc 返回    Enter 确认
```

**配置路径:**
```
Target System → MediaTek Ralink MIPS
    ↓
Subtarget → MT7620
    ↓
Target Profile → PHICOMM K2P
    ↓
(其他选项自动配置)
```

**保存配置:**
```
Exit → Yes → Enter
```

---

### 第 4 步: 下载源代码

在正式编译前，需要下载所有源代码：

```bash
# 下载源代码 (首次 10-30 分钟)
echo "📥 下载源代码..."
make -j$(nproc) download V=s

# 检查下载状态
if [ $? -eq 0 ]; then
  echo "✅ 下载完成"
else
  echo "⚠️ 部分文件下载失败，重试..."
  make -j1 download V=s
fi
```

---

### 第 5 步: 编译固件 (核心步骤)

```bash
# 清理之前的编译 (可选)
# make clean

# 开始编译 (这是最耗时的步骤)
echo "🔨 开始编译 K2P 固件..."
echo "⏱️ 预计时间: 30-120 分钟 (取决于 CPU)"
echo ""

make -j$(nproc) V=s

# 显示编译返回值
if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 ===== 编译成功! ====="
else
    echo ""
    echo "❌ ===== 编译失败! ====="
    echo "查看完整日志: tail -100 build.log"
    exit 1
fi
```

---

## 📦 获取固件文件

编译完成后，固件位于：

```bash
# 查找所有 K2P 固件
find bin/targets/ramips/mt7620/ -name "*k2p*" -type f

# 或者直接进入目录
cd bin/targets/ramips/mt7620/
ls -lh *.bin
```

**文件说明:**

```
📄 固件文件:
├── openwrt-ramips-mt7620-k2p-squashfs-factory.bin   (工厂固件, ~15-18MB)
│   └─ 用途: 从原厂系统首次刷入
│
├── openwrt-ramips-mt7620-k2p-squashfs-sysupgrade.bin (升级固件, ~15-18MB)
│   └─ 用途: 从已有系统升级
│
└── openwrt-ramips-mt7620-k2p-squashfs-rootfs.tar.gz (根文件系统, 可选)
    └─ 用途: 高级用户调试
```

---

## ⏱️ 编译时间参考

| 配置 | 编译时间 | 说明 |
|-----|--------|------|
| 单核编译 | 2-4 小时 | 不推荐 |
| 双核 | 1-2 小时 | 最小配置 |
| 4 核 | 30-60 分钟 | 中等配置 |
| 8 核+ | 15-30 分钟 | 高端配置 (推荐) |
| + ccache | -50% | 启用编译缓存 |

**查看 CPU 核心数:**
```bash
nproc  # 显示可用核心数
lscpu  # 显示详细 CPU 信息
```

---

## 🔍 实时编译脚本

将以下脚本保存为 `compile.sh` 并执行，可自动完成全部步骤：

```bash
#!/bin/bash
set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${YELLOW}[!]${NC} $1"; }

# 1. 检查环境
print_status "检查编译环境..."
if ! command -v git &> /dev/null; then
    print_error "未找到 git，请先安装"
    exit 1
fi

# 2. 更新 Feeds
print_status "更新 Feeds..."
cp feeds.conf.default feeds.conf
cat feeds.conf.k2p >> feeds.conf
./scripts/feeds update -a > /dev/null 2>&1
./scripts/feeds install -a > /dev/null 2>&1

# 3. 应用配置
print_status "应用 K2P 配置..."
cp .config .config.bak

# 4. 下载源代码
print_status "下载源代码 (这需要时间)..."
make -j$(nproc) download V=s 2>&1 | tail -20

# 5. 开始编译
print_status "开始编译 K2P 固件..."
print_info "这将需要 $(nproc) 个核心，预计 $(( 120 / $(nproc) ))-$(( 240 / $(nproc) )) 分钟"

START_TIME=$(date +%s)
if make -j$(nproc) V=s; then
    END_TIME=$(date +%s)
    ELAPSED=$((END_TIME - START_TIME))
    
    print_status "编译成功! (耗时: $((ELAPSED / 60)) 分 $((ELAPSED % 60)) 秒)"
    echo ""
    echo "📦 固件位置:"
    find bin/targets/ramips/mt7620/ -name "*k2p*.bin" -exec ls -lh {} \;
else
    print_error "编译失败!"
    exit 1
fi
```

**使用方法:**
```bash
# 保存脚本
cat > compile.sh << 'EOF'
(上面的脚本内容)
EOF

# 赋予执行权限
chmod +x compile.sh

# 执行编译
./compile.sh
```

---

## 🛠️ 故障排查

### 问题 1: 磁盘空间不足

```bash
# 检查磁盘空间
df -h

# 清理编译文件 (保留源码)
make clean
make dirclean  # 更彻底的清理
```

### 问题 2: 内存不足导致编译失败

```bash
# 减少并行编译数
make -j2 V=s  # 使用 2 核编译

# 或启用 swap
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

### 问题 3: 网络下载失败

```bash
# 重新下载失败的文件
make -j1 download V=s

# 或指定代理
export http_proxy=http://proxy.example.com:8080
make -j$(nproc) download
```

### 问题 4: 编译过程中卡住

```bash
# 查看编译进度
top -p $(pgrep -f "make")

# 如需停止编译
Ctrl + C

# 恢复编译 (从中断处继续)
make -j$(nproc) V=s
```

### 问题 5: 验证配置是否正确

```bash
# 检查关键配置项
grep -E "^CONFIG_TARGET|^CONFIG_PACKAGE_kmod-usb|^CONFIG_PACKAGE_samba" .config

# 预期输出:
# CONFIG_TARGET_ramips=y
# CONFIG_TARGET_ramips_mt7620=y
# CONFIG_TARGET_ramips_mt7620_DEVICE_k2p=y
# CONFIG_PACKAGE_kmod-usb2=y
# CONFIG_PACKAGE_samba4-server=y
```

---

## 📊 编译输出分析

### 正常编译输出示例

```
...
Compiling libubox
Compiling libnl-tiny
Compiling libuci
Compiling libblobmsg-json
Compiling mtd-utils
Compiling uci
Compiling mtk-wifi
...
Creating filesystem images
Checking filesystem integrity
Building kernel image
Creating squashfs filesystem
...
Image: bin/targets/ramips/mt7620/openwrt-ramips-mt7620-k2p-squashfs-factory.bin
Image: bin/targets/ramips/mt7620/openwrt-ramips-mt7620-k2p-squashfs-sysupgrade.bin
```

### 常见错误信息

```
Error: Missing package 'xxx'
→ 解决: make clean && ./scripts/feeds install -a

Error: Build failed with exit code 1
→ 解决: 增加磁盘空间或内存

Error: Unable to download from repository
→ 解决: 检查网络连接或更换源
```

---

## ✨ 优化编译速度

### 1. 启用 ccache

```bash
# 启用 ccache (推荐)
export PATH="/usr/lib/ccache:$PATH"
ccache -M 20G  # 设置 20GB 缓存

# 验证启用
ccache -s
```

### 2. 使用分布式编译 (distcc)

```bash
# 安装 distcc
sudo apt install distcc

# 配置多机编译 (高级)
export CC="distcc gcc"
export CXX="distcc g++"
make -j16 V=s
```

### 3. 使用 tmpfs 加速

```bash
# 将编译目录放到内存中 (需要 16GB+ RAM)
sudo mount -t tmpfs -o size=16G tmpfs /tmp/openwrt
cd /tmp/openwrt
git clone ... (克隆到内存中)
```

---

## 📝 编译日志记录

```bash
# 保存完整编译日志
make -j$(nproc) V=s 2>&1 | tee build-$(date +%Y%m%d-%H%M%S).log

# 查看特定错误
grep -i error build-*.log

# 显示编译统计
wc -l build-*.log
grep -c "Compiling" build-*.log
```

---

## ✅ 编译完成检查清单

- [ ] 固件文件大小在 15-18MB 范围
- [ ] 同时生成了 factory 和 sysupgrade 两个文件
- [ ] 没有 error 级别的日志
- [ ] 编译日志最后显示 "Image:" 信息
- [ ] MD5 校验和已生成

```bash
# 验证固件完整性
cd bin/targets/ramips/mt7620/
md5sum -c *.md5sum
ls -lh *.bin
```

---

## 🎯 下一步

编译完成后:
1. 备份固件文件到安全位置
2. 准备刷机工具 (TFTP 或 Web 界面)
3. 确保 K2P 设备电源充足
4. 按照 [刷机指南](./FLASH-GUIDE.md) 刷入固件

---

**祝你编译顺利！** 🚀
