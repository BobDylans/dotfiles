# 环境工具指南

## ℹ️ 环境

- **OS**: Arch Linux (rolling), kernel 7.0.10-zen1-1-zen
- **Shell**: fish, terminal kitty (Wayland/niri), locale zh_CN.UTF-8
- **CPU/GPU**: AMD Cezanne (Radeon Vega)
- **Pi**: 0.78.0, provider deepseek-v4-flash (xhigh thinking)

## 🔧 工具速查

| 类别         | 首选                                                                    | 替代/说明                               |
| ------------ | ----------------------------------------------------------------------- | --------------------------------------- |
| 代码搜索     | rg                                                                      | ag / grep（备用）                       |
| 文件查找     | fd                                                                      | find（备用）                            |
| 文件查看     | bat                                                                     | less（大文件分页）                      |
| JSON 处理    | jq                                                                      | —                                       |
| 目录列表     | eza --icons                                                             | eza --tree（树形）                      |
| 目录导航     | zoxide                                                                  | zi（交互模式）                          |
| 版本控制     | git                                                                     | lazygit（复杂操作），delta（diff 高亮） |
| 资源监控     | btop                                                                    | htop（进程管理）                        |
| 磁盘分析     | ncdu                                                                    | —                                       |
| 包管理       | yay                                                                     | paru / pacman（备用）                   |
| 技术文档检索 | context7 MCP（`mcp_context7_query_docs`）                               | ketch_docs（备用）                      |
| 文本编辑     | nvim                                                                    | vim / code / nano                       |
| JS/TS 运行时 | bun（~/.bun/bin/bun）                                                   | node / deno                             |
| 文件管理     | yazi                                                                    | —                                       |
| 容器         | podman                                                                  | —                                       |
| 模糊搜索     | fzf（管道组合用）                                                       | —                                       |
| 流编辑       | sed                                                                     | awk（结构化文本）                       |
| OCR 文字识别 | RapidOCR                                                                | Tesseract（备用，中文乱码多）           |
| 其他         | tldr、curl、ssh、gpg、wl-paste/copy、brightnessctl、mangohud、fastfetch | —                                       |

## 🐟 fish 别名

| 别名      | 实际命令                 | 说明     |
| --------- | ------------------------ | -------- |
| tx        | tmux                     | 终端复用 |
| cat       | bat                      | 高亮显示 |
| ls / lt   | eza --icons / eza --tree | 目录列表 |
| zi        | zoxide 交互              | 路径跳转 |
| fa/ff     | fastfetch                | 系统信息 |
| 安装/卸载 | yay -S / yay -Rns        | 包管理   |
| reboot    | systemctl reboot         | 重启     |
| grub      | 更新 GRUB                | —        |
| 滚        | sysup                    | 系统更新 |
| raw       | 随机动漫壁纸             | —        |

## 🔑 环境变量

BUN_INSTALL, PI_OFFLINE=1（跳过网络检查）, JQ_USERNAME/JQ_PASSWORD（聚宽凭证）
PATH 含 ~/.bun/bin, ~/.cargo/bin, ~/.opencode/bin, ~/.local/bin
修改代码后不要提交,保留暂存状态即可

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
10. **技术文档检索**: context7 MCP（首选）→ ketch_docs → web_search
    - `mcp_context7_resolve_library_id` — 解析库 ID（格式 /org/project）
    - `mcp_context7_query_docs` — 查询库官方文档与代码示例（独立 MCP，streamable-http → https://mcp.context7.com/mcp，由 pi-mcp-extension 加载）
    - 查任何库/框架的 API 文档时优先用它，ketch_docs 不可用或需要全文时才备用
    - 开源实现对照用 ketch_code / ketch_scrape（如抓 guide-rpc-framework 源码）
11. **网络搜索**: ketch（走本地 SearXNG）→ rpiv-web-tools（serper）→ curl
    - `ketch_search` — 网页搜索（SearXNG，本地隐私优先）
    - `ketch_scrape` — 抓取网页
    - `ketch_code` — 搜开源代码
    - `ketch_docs` — 库文档
    - `web_search` — rpiv-web-tools（默认 serper，配置在 ~/.config/rpiv-web-tools/config.json，可用 /web-tools 切换）
    - `web_fetch` — 抓取页面（无需 key）
    - 优先级：ketch 不可用时才回退到 web_search/web_fetch
11. **OCR 文字识别**: RapidOCR → Tesseract
    - **首选 RapidOCR**（基于 PaddleOCR，中文准确率高）
    - 用法：`/home/ivan/.local/share/pipx/venvs/rapidocr/bin/python3 -c "from rapidocr import RapidOCR; ocr=RapidOCR(); [print(t) for t in ocr('图片.png').txts]"`
    - 命令行：`rapidocr -img 图片.png -word`（输出含数组，不如 Python 调用干净）
    - Tesseract 备用：`tesseract 图片.png stdout -l chi_sim+eng`（中文乱码多，不推荐）
