-- 光标停在变量上时，全文高亮同名单词
-- vim-illuminate 已在 lazy-lock 中安装，此处添加显式配置
return {
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        delay = 100,            -- 停留 100ms 后高亮
        large_file_overrides = {
          providers = { "lsp", "grep", "word" },
        },
        filetypes = {
          ["neo-tree"] = { enable = false },
          ["lazy"] = { enable = false },
          ["notify"] = { enable = false },
          ["toggleterm"] = { enable = false },
        },
      })
    end,
  },
}
