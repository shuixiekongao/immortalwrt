#!/bin/bash
# K2P 32M/512M USB 固件编译脚本
# 使用方法: bash build-k2p.sh

set -e

echo "========================================"
echo "K2P 32M/512M USB 固件编译脚本"
echo "========================================"
echo ""

# 检查环境
if [ ! -f "feeds.conf.default" ]; then
    echo "❌ 错误: 不在 ImmortalWrt 源码目录"
    exit 1
fi

# 配置源
echo "📋 配置 feeds..."
cp feeds.conf.default feeds.conf
grep -v "^#" feeds.conf.k2p >> feeds.conf

echo "🔄 更新 feeds..."
./scripts/feeds update -a
echo "📦 安装 feeds..."
./scripts/feeds install -a

# 应用配置
echo "⚙️  应用 .config 配置..."
cp .config .config.bak

echo "🔨 开始编译 (这可能需要很长时间)..."
echo "日志输出到: build_$(date +%Y%m%d_%H%M%S).log"

LOG_FILE="build_$(date +%Y%m%d_%H%M%S).log"
make -j$(nproc) V=s 2>&1 | tee "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 编译成功!"
    echo ""
    echo "固件位置:"
    find bin/targets/ramips/mt7620/ -name "*k2p*.bin" -o -name "*k2p*.img"
    echo ""
    echo "建议刷机文件:"
    echo "  - 工厂刷: xxx-factory.bin"
    echo "  - 升级刷: xxx-sysupgrade.bin"
else
    echo ""
    echo "❌ 编译失败!"
    echo "请检查日志文件: $LOG_FILE"
    exit 1
fi
