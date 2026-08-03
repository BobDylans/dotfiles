-- 扩展 LazyVim 默认的 blink.cmp 配置
return {
  {
    "Saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}
      -- 回车: 不采纳补全,直接用自己的输入(fallback)
      -- 想采纳就用方向键选,再按回车
      opts.keymap["<CR>"] = { "accept", "fallback" }
      -- <C-y> 同样: 取消补全保留自己的输入
      opts.keymap["<C-y>"] = { "cancel", "fallback" }

      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      -- preselect=false: 补全菜单弹出时不自动选中第一项
      -- 这样默认"选中"的就是你正在输入的内容,回车直接用自己的
      opts.completion.list.selection = { preselect = true, auto_insert = false }
    end,
  },
}
