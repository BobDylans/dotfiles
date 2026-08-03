# 智谱 vision-mcp 安装指南

## 前提
- Node.js 18+（npm 可用）
- 智谱 API key：去 [open.bigmodel.cn](https://open.bigmodel.cn) → API Keys 申请（格式 `id.secret`）

## ① 全局安装（一次即可）
```bash
npm i -g @z_ai/mcp-server
# 验证：which zai-mcp-server
```

## ② 配置 API key（环境变量）
⚠️ **变量名是 `Z_AI_API_KEY`，不是 `ZHIPU_API_KEY`**

fish（~/.config/fish/conf.d/zai.fish）：
```fish
set -gx Z_AI_API_KEY "你的key"
```

bash/zsh：
```bash
export Z_AI_API_KEY="你的key"
```

## ③ 注册 MCP server

### Pi（~/.pi/agent/mcp.json）
```json
{
  "mcpServers": {
    "zai-vision": {
      "transport": "stdio",
      "command": "/home/ivan/.local/bin/zai-mcp-server",
      "env": { "Z_AI_API_KEY": "你的key" },
      "lifecycle": "eager"
    }
  }
}
```

### Reasonix（~/.reasonix/config.toml）
```toml
[[plugins]]
name    = "zai-vision"
command = "/home/ivan/.local/bin/zai-mcp-server"
env     = { Z_AI_API_KEY = "${Z_AI_API_KEY}" }
```

### Codex（~/.codex/config.toml）
```toml
[mcp_servers.zai-vision]
command = "/home/ivan/.local/bin/zai-mcp-server"
env = { Z_AI_API_KEY = "${Z_AI_API_KEY}" }
```

### Claude Desktop（claude_desktop_config.json）
```json
{
  "mcpServers": {
    "zai-vision": {
      "command": "zai-mcp-server",
      "env": { "Z_AI_API_KEY": "你的key" }
    }
  }
}
```

### 通用 npx 方式（不想全局装）
```json
{ "command": "npx", "args": ["-y", "@z_ai/mcp-server"] }
```

## ④ 验证
```bash
Z_AI_API_KEY="你的key" zai-mcp-server
# 看到 MCP server 启动日志即成功
```

## ⑤ 可用工具（GLM-4.6V）
| 工具 | 用途 |
|------|------|
| `analyze_image` | 通用图像分析 |
| `extract_text_from_screenshot` | 截图 OCR（代码/终端/文档） |
| `diagnose_error_screenshot` | 报错截图诊断 |
| `understand_technical_diagram` | 架构图/流程图/UML 理解 |
| `analyze_data_visualization` | 图表洞察 |
| `ui_to_artifact` | UI 截图 → 前端代码 |
| `ui_diff_check` | UI 视觉回归对比 |
| `analyze_video` | 视频分析 |

## 要点提醒
1. **改配置后要重启 agent 会话**才生效
2. 官方文档：[docs.bigmodel.cn/cn/coding-plan/mcp/vision-mcp-server](https://docs.bigmodel.cn/cn/coding-plan/mcp/vision-mcp-server)
3. key 建议只放环境变量文件（权限 600），配置文件里用 `${VAR}` 引用或写明文都行
