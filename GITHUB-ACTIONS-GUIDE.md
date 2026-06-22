# GitHub Actions 在线编译完整教程

## 🎯 概述

在 GitHub Actions 云端自动编译 K2P 固件，无需本地 Linux 环境。编译完成后直接下载固件文件。

---

## 📋 前置要求

- ✅ GitHub 账户
- ✅ 网络连接
- ✅ **无需** 本地 Linux 环境

---

## 🚀 5分钟快速开始

### 第1步：Fork 仓库（1分钟）

打开这个链接：
👉 **https://github.com/shuixiekongao/immortalwrt/fork**

或者手动操作：
1. 进入 https://github.com/shuixiekongao/immortalwrt
2. 点击右上角 **Fork** 按钮
3. 确认分支选择：选择 `k2p-32m-512m-usb`
4. 点击 **Create fork**

**等待 30 秒，仓库被 Fork 到你的账户**

---

### 第2步：进入 Actions 页面（1分钟）

1. 进入你 Fork 后的仓库
2. 点击顶部 **Actions** 标签页
3. 左侧会看到 **Build K2P Firmware** 工作流

如果没看到，可能需要等待 GitHub 同步（通常 1-2 分钟）

---

### 第3步：手动触发编译（1分钟）

#### 方式 A：用 Web 界面（推荐）

1. 在 Actions 页面，点击左侧 **Build K2P Firmware**
2. 右侧点击 **Run workflow** 下拉菜单
3. 确认分支选择：`k2p-32m-512m-usb`
4. 点击绿色 **Run workflow** 按钮

**编译任务已提交！** 👍

#### 方式 B：修改配置文件自动触发

如果你要修改 `.config`：

```bash
# 在你 Fork 的仓库中
# 1. 打开 .config 文件
# 2. 修改任何配置项
# 3. 提交 (Commit)

# 自动触发编译！
```

---

### 第4步：监控编译进度（等待 1-2小时）

**实时查看编译日志：**

1. 进入 Actions 页面
2. 看到最新的 Run（通常在列表最上方）
3. 点击进去查看详情
4. 展开各个步骤查看日志

**关键步骤：**
```
✅ 签出代码
✅ 安装依赖 (5-10 分钟)
✅ 更新 Feeds (5-15 分钟)
✅ 应用配置
✅ 下载源代码 (10-30 分钟，取决于网络)
✅ 编译工具链 (15-30 分钟)
🔨 编译固件 (30-60 分钟) ← 最耗时
✅ 整理固件文件
✅ 编译完成总结
```

**预计总时间：60-120 分钟**

---

### 第5步：下载固件（2分钟）

#### 编译成功时：

1. 进入 Actions 页面
2. 点击最新完成的 Run（状态显示绿色 ✓）
3. **向下滚动**到页面底部
4. 找到 **Artifacts** 部分
5. 点击 **k2p-firmware-XXX** 下载

下载的是一个 `.zip` 文件，包含：
```
firmware-20260122-173000/
├── openwrt-ramips-mt7620-k2p-squashfs-factory.bin
├── openwrt-ramips-mt7620-k2p-squashfs-sysupgrade.bin
├── *.md5sum
└── SHA256SUMS
```

6. **解压 zip 文件**
7. 得到 `.bin` 固件文件

---

## 📍 详细步骤截图说明

### 步骤 1：Fork 页面

```
GitHub 右上角看到:
┌─────────────────┐
│ ... | Fork      │ ← 点击这里
└─────────────────┘

弹出窗口选择:
┌──────────────────────────┐
│ Create a new fork        │
│                          │
│ Owner: YOUR-USERNAME     │
│ Repository name: ...     │
│ Description:             │
│ [✓] Copy the k2p-...     │
│     branch only          │
│                          │
│ [Create fork]            │
└──────────────────────────┘
```

### 步骤 2：Actions 页面

```
你的 Fork 仓库中:

┌─ 仓库导航栏 ─────────────────────┐
│ Code | Issues | Pull requests    │
│ Discussions | Projects | Actions │ ← 点击这里
└───────────────────────────────────┘

进入 Actions 后看到:

┌─ 左侧栏 ──┐      ┌─ 右侧 ───────────────────┐
│ All       │      │ Build K2P Firmware      │
│ > Build   │      │                         │
│  K2P ...  │ ←    │ [Run workflow ▼]        │
│           │      │ [○ Disabled]            │
│ ○ Push    │      └─────────────────────────┘
│ ○ Pull    │
└───────────┘
```

### 步骤 3：Run Workflow

```
点击 [Run workflow ▼] 显示:

┌─────────────────────────┐
│ Branch                  │
│ [k2p-32m-512m-usb   ▼] │ ← 已自动选择
│                         │
│ [Run workflow]          │ ← 绿色按钮
└─────────────────────────┘

点击后看到:
✅ Workflow run created
   Workflow run #123 created
   
转到实时日志页面
```

### 步骤 4：监控编译

```
Action 运行页面:

【仓库名】/ Actions / Build K2P Firmware #123
┌─────────────────────────────┐
│ Status: ⏳ In progress       │
│ Run duration: 15 min 32 sec │
│                             │
│ ✅ 签出代码 (2s)            │
│ ✅ 安装依赖 (8m)            │
│ ✅ 配置缓存 (1m)            │
│ ⏳ 更新 Feeds (running)     │
│ ⧖ 应用配置 (waiting)       │
│ ⧖ 下载源代码 (waiting)     │
│ ...                         │
│                             │
│ 点击某个步骤展开详细日志    │
└─────────────────────────────┘
```

### 步骤 5：下载固件

```
编译完成后:

【仓库名】/ Actions / Build K2P Firmware #123
┌─────────────────────────────┐
│ Status: ✅ Completed        │
│ Run duration: 1h 23m 45s    │
│                             │
│ ✅ 所有步骤都显示 ✅        │
│                             │
│ ...                         │
│ ✅ 编译完成总结             │
│                             │
│ ┌───────────────────────┐   │
│ │ Artifacts (1)         │   │
│ │                       │   │
│ │ k2p-firmware-123      │   │
│ │ 📦 (ZIP, 28.5 MB)     │   │
│ │                       │   │
│ │ [Download]            │ ← 点击下载
│ └───────────────────────┘   │
└─────────────────────────────┘
```

---

## ✅ 编译成功标志

编译完成且**成功**时，你会看到：

```
✅ 签出代码
✅ 安装依赖
✅ 配置缓存
✅ 更新 Feeds
✅ 应用配置
✅ 下载源代码
✅ 编译内核和工具链
✅ 编译固件 (核心步骤)
✅ 整理固件文件
✅ 上传到 Artifacts
✅ 编译完成总结
```

**页面顶部状态显示：✅ Completed**

---

## ❌ 编译失败排查

如果看到 **❌ Failed** 或某个步骤显示 **✗**：

### 1️⃣ 查看失败步骤的日志

点击**红色** ✗ 标记的步骤，展开查看错误信息

### 2️⃣ 常见错误

| 错误信息 | 原因 | 解决方案 |
|---------|------|--------|
| `Timeout` | 编译超时 | 重新运行 (Actions 会重试) |
| `Out of disk space` | 磁盘满 | 通常不会发生 (GitHub 配额���够) |
| `Package download failed` | 网络问题 | 重新运行工作流 |
| `Permission denied` | Fork 配置问题 | 检查 `.github/workflows/` 是否存在 |

### 3️⃣ 重新运行

在 Run 详情页右上角：

```
┌──────────────────┐
│ ⋮ (三点菜单) ▼    │
├──────────────────┤
│ Re-run all jobs  │ ← 重新运行
│ Re-run failed    │ ← 仅重新运行失败的步骤
│ jobs             │
│ Delete workflow  │
│ run              │
└──────────────────┘
```

---

## 🔧 自定义编译配置

如果你要修改编译参数：

### 修改 `.config` 文件

1. 进入你 Fork 的仓库
2. 进入 **Code** 标签页
3. 找到 `.config` 文件
4. 点击 **Edit this file** (铅笔图标)
5. 修改配置 (例如启用/禁用某个包)
6. 在底部 **Commit changes** 输入说明
7. 点击 **Commit changes**

**自动触发编译！** 👍

---

## 📊 固件文件说明

下载的 zip 文件包含：

```
firmware-20260122-173000/
│
├── openwrt-ramips-mt7620-k2p-squashfs-factory.bin
│   ├─ 用途: 从原厂固件首次刷入
│   ├─ 大小: ~15-18 MB
│   └─ 刷机: Web 管理页面或 TFTP
│
├── openwrt-ramips-mt7620-k2p-squashfs-sysupgrade.bin
│   ├─ 用途: 从已有 OpenWrt 升级
│   ├─ 大小: ~15-18 MB
│   └─ 刷机: LuCI Web 或 SSH 命令
│
├── *.md5sum
│   └─ 用途: 验证文件完整性
│
└── SHA256SUMS
    └─ 用途: 额外的校验文件
```

---

## ✔️ 验证固件完整性

下载后验证固件是否完整：

```bash
# 进入固件所在目录
cd firmware-20260122-173000/

# 方式 1: 使用 MD5
md5sum -c *.md5sum

# 预期输出:
# openwrt-ramips-mt7620-k2p-squashfs-factory.bin: OK
# openwrt-ramips-mt7620-k2p-squashfs-sysupgrade.bin: OK

# 方式 2: 查看文件大小
ls -lh *.bin
# 应该都是 15-18 MB 左右
```

如果校验失败，**重新下载** Artifact

---

## 🎬 完整工作流时间线

```
时间       事件
────────────────────────────────────────────
T+0min    👉 点击 "Run workflow"
T+1min    ✅ 签出代码完成
T+2min    ⏳ 开始安装依赖...
T+10min   ✅ 依赖安装完成
T+11min   ⏳ 开始更新 Feeds...
T+20min   ✅ Feeds 更新完成
T+21min   ⏳ 开始下载源代码...
T+50min   ✅ 源代码下载完成
T+51min   ⏳ 开始编译工具链...
T+90min   ✅ 工具链完成
T+91min   🔨 开始编译固件 (最耗时)
T+150min  ✅ 固件编译完成
T+152min  ✅ 整理文件完成
T+155min  ✅ 上传 Artifacts 完成
T+160min  👉 可以下载！
```

**总耗时：约 2.5-3 小时**

---

## 🌐 网络问题排查

如果编译过程中网络出问题：

1. **GitHub 服务器状态**
   👉 https://www.githubstatus.com/

2. **编译失败通常是暂时的**
   点击 "Re-run all jobs" 重试即可

3. **如果持续失败**
   - 等待 1-2 小时后重试
   - 或尝试本地编译

---

## 💾 Artifacts 保留时间

GitHub Actions 中的 Artifacts（编译产物）默认保留：

```
✅ 正常保留期: 30 天
❌ 超过 30 天后自动删除
```

**建议：**
- 编译完成后立即下载
- 备份到本地磁盘
- 如需长期保存，手动创建 Release

---

## 🔗 快速跳转链接

| 操作 | 链接 |
|-----|------|
| Fork 仓库 | https://github.com/shuixiekongao/immortalwrt/fork |
| 我的仓库 | https://github.com/shuixiekongao/immortalwrt |
| Actions 工作流 | https://github.com/shuixiekongao/immortalwrt/actions |
| 编译配置 | https://github.com/shuixiekongao/immortalwrt/blob/k2p-32m-512m-usb/.config |
| 编译指南 | https://github.com/shuixiekongao/immortalwrt/blob/k2p-32m-512m-usb/COMPILE-GUIDE.md |
| 刷机指南 | https://github.com/shuixiekongao/immortalwrt/blob/k2p-32m-512m-usb/K2P-BUILD-GUIDE.md |

---

## ❓ 常见问题

### Q1: 为什么我的 Fork 没有 Actions?
**A:** 
- 确保 Fork 时勾选了 "Copy the k2p-32m-512m-usb branch only"
- 或者手动 Clone 分支

### Q2: 如何修改编译配置?
**A:** 
- 编辑 `.config` 文件并提交
- 自动触发新编译

### Q3: Artifacts 会自动删除吗?
**A:** 
- 是的，30 天后自动删除
- 建议立即下载和备份

### Q4: 编译需要付费吗?
**A:** 
- GitHub Actions 免费额度通常足够
- 每月 2000 分钟免费 (对个人账户)
- 本编译约消耗 100-150 分钟

### Q5: 可以同时运行多个编译吗?
**A:** 
- 可以，但会排队等待
- 建议一次一个

### Q6: 编译失败可以恢复吗?
**A:** 
- 不会影响 Fork 的代码
- 点击 "Re-run" 重新尝试

---

## 📞 获取帮助

遇到问题？

1. **查看完整日志**
   - Actions 页面 → Run 详情 → 展开各步骤

2. **检查本页面的故障排查部分**
   - 大多数问题都有解决方案

3. **提交 Issue**
   - https://github.com/shuixiekongao/immortalwrt/issues

4. **查看相关文档**
   - [COMPILE-GUIDE.md](./COMPILE-GUIDE.md) - 本地编译指南
   - [K2P-BUILD-GUIDE.md](./K2P-BUILD-GUIDE.md) - 刷机指南

---

## ✨ 总结

| 步骤 | 时间 | 说明 |
|-----|------|------|
| Fork 仓库 | 1 min | GitHub Web 操作 |
| 触发编译 | 1 min | 点击 Run Workflow |
| 等待编译 | 90-150 min | 自动进行，可离开 |
| 下载固件 | 5 min | Artifacts 中下载 |
| **总耗时** | **100-160 min** | 约 2-3 小时 |

**祝你固件编译顺利！** 🚀

---

如有任何疑问，请查看本文档或联系维护者。
