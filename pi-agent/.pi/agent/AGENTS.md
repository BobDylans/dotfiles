# pi 全局环境指南

为所有项目会话提供稳定的行为约束与工作流框架。项目特定规则放各仓库自己的 AGENTS.md（就近优先覆盖，用户显式指令最高）。

## 行为约束

- 代码改动保留在工作区或暂存区，不执行 git commit / push（提交由人类决定）

## 工作流：Superpowers

已装 obra/superpowers（会话启动自动注入 using-superpowers bootstrap，压缩后重新注入）：

- 任何任务开始前先检查适用 skill——包括提问前、探索代码前、进入 plan 模式前；只要觉得有 1% 可能适用就必须调用，宣布 "Using [skill] to [purpose]" 后按其执行
- 流程 skill（brainstorming / systematic-debugging）先定方法，实现 skill 再干活
- skill 具体内容按需加载，遵循对应 SKILL.md，本文件不重复

## 编码准则（Karpathy 风格）

写代码/审查/重构时遵循本地 skill `karpathy-guidelines`（与 braindump 项目级引用一致）：

1. **Think Before Coding** — 不假设，不确定就问，呈现权衡
2. **Simplicity First** — 最简方案，不做投机性抽象
3. **Surgical Changes** — 只动必须动的，不顺手改无关内容
4. **Goal-Driven Execution** — 定义可验证的成功标准

细节按需加载（SKILL.md），本文件不重复。

## OCR（图片文字提取）

上传图片需要提取文字时：

- **首选 RapidOCR**（中文准确率高）：
  `~/.local/share/pipx/venvs/rapidocr/bin/python3 -c "from rapidocr import RapidOCR; ocr=RapidOCR(); [print(t) for t in ocr('图片.png').txts]"`
- 备用：`rapidocr -img 图片.png -word`（输出含数组）；Tesseract `tesseract 图片.png stdout -l chi_sim+eng`（中文乱码多，不推荐）
