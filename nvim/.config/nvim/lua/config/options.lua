-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy --type text/plain",
    ["*"] = "wl-copy --type text/plain",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline",
  },
  cache_enabled = 0,
}
vim.opt.clipboard = "unnamedplus"

vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.undofile = true

-- 输入法预编辑区域高亮（中文输入时的拼音字母）
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- 预编辑文字用亮色显示
    vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#9fcbf8", bold = true })
    -- 补全菜单中匹配的文字
    vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#7cf88c", bold = true })
  end,
})

-- Ctrl+S 只保存不格式化
vim.keymap.set({"n", "i"}, "<C-s>", function()
  vim.cmd("noautocmd write")
end, { desc = "Save without format" })
