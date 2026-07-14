-- 扩展 LazyVim 默认的 treesitter 配置
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "java",
      },
      -- Java 的 TS indents query 对 } 处理有 bug:
      -- 敲完 } 回车时,缩进会多减一级导致下一行错位一格
      -- 禁用 Java 的 TS indent,回退到 nvim 自带 indent/java.vim
      indent = { enable = true, disable = { "java" } },
    },
  },
}
