# 环境工具指南

## ℹ️ 环境
- **OS**: Arch Linux (rolling), kernel 7.0.10-zen1-1-zen
- **Shell**: fish, terminal kitty (Wayland/niri), locale zh_CN.UTF-8
- **CPU/GPU**: AMD Cezanne (Radeon Vega)
- **Pi**: 0.78.0, provider deepseek-v4-flash (xhigh thinking)

## 🔧 工具速查
| 类别 | 首选 | 替代/说明 |
|------|------|-----------|
| 代码搜索 | rg | ag / grep（备用） |
| 文件查找 | fd | find（备用） |
| 文件查看 | bat | less（大文件分页） |
| JSON 处理 | jq | — |
| 目录列表 | eza --icons | eza --tree（树形） |
| 目录导航 | zoxide | zi（交互模式） |
| 版本控制 | git | lazygit（复杂操作），delta（diff 高亮） |
| 资源监控 | btop | htop（进程管理） |
| 磁盘分析 | ncdu | — |
| 包管理 | yay | paru / pacman（备用） |
| 文本编辑 | nvim | vim / code / nano |
| JS/TS 运行时 | bun（~/.bun/bin/bun） | node / deno |
| 文件管理 | yazi | — |
| 容器 | podman | — |
| 模糊搜索 | fzf（管道组合用） | — |
| 流编辑 | sed | awk（结构化文本） |
| 其他 | tldr、curl、ssh、gpg、wl-paste/copy、brightnessctl、mangohud、fastfetch | — |

## 🐟 fish 别名
| 别名 | 实际命令 | 说明 |
|------|---------|------|
| tx | tmux | 终端复用 |
| cat | bat | 高亮显示 |
| ls / lt | eza --icons / eza --tree | 目录列表 |
| zi | zoxide 交互 | 路径跳转 |
| fa/ff | fastfetch | 系统信息 |
| 安装/卸载 | yay -S / yay -Rns | 包管理 |
| reboot | systemctl reboot | 重启 |
| grub | 更新 GRUB | — |
| 滚 | sysup | 系统更新 |
| raw | 随机动漫壁纸 | — |

## 🔑 环境变量
BUN_INSTALL, PI_OFFLINE=1（跳过网络检查）, JQ_USERNAME/JQ_PASSWORD（聚宽凭证）
PATH 含 ~/.bun/bin, ~/.cargo/bin, ~/.opencode/bin, ~/.local/bin

## 🎯 工具选择优先级
1. **代码搜索**: rg → grep
2. **文件查找**: fd → find
3. **文件查看**: bat → less → cat
4. **目录列表**: eza → ls
5. **JSON**: jq
6. **目录导航**: zoxide → cd
7. **磁盘**: ncdu → du -sh
8. **进程监控**: btop → htop → top
9. **包管理**: yay → paru → pacman
10. **网络搜索**: ketch（走本地 SearXNG）→ web_search → curl
    - `ketch_search` — 网页搜索
    - `ketch_scrape` — 抓取网页
    - `ketch_code` — 搜开源代码
    - `ketch_docs` — 库文档
    - 只有 ketch 不可用时才回退到 web_search
