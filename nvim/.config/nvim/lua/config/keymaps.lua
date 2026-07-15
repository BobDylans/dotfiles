-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Colorscheme picker via Snacks
vim.keymap.set("n", "<leader>uC", function()
  Snacks.picker.colorschemes()
end, { desc = "Colorscheme Picker" })

-- Ctrl+Alt+Left/Right as jump backward/forward (replaces <C-o> / <C-i>)
vim.keymap.set("n", "<C-A-Left>", "<C-o>", { desc = "Jump backward" })
vim.keymap.set("n", "<C-A-Right>", "<C-i>", { desc = "Jump forward" })

-- Ctrl+S 只保存不格式化（覆盖 LazyVim 默认的 :w，跳过格式化和 autocmd）
vim.keymap.set({"n", "i"}, "<C-s>", function()
  vim.cmd("noautocmd write")
end, { desc = "Save without format" })

-- Ctrl+方向键 替代 Ctrl+hjkl 窗口跳转
vim.keymap.set("n", "<C-Left>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-Down>", "<C-w>j", { desc = "Go to down window" })
vim.keymap.set("n", "<C-Up>", "<C-w>k", { desc = "Go to up window" })
vim.keymap.set("n", "<C-Right>", "<C-w>l", { desc = "Go to right window" })

-- Terminal 模式下也支持 Ctrl+方向键退出
vim.keymap.set("t", "<C-Left>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
vim.keymap.set("t", "<C-Down>", "<C-\\><C-n><C-w>j", { desc = "Go to down window" })
vim.keymap.set("t", "<C-Up>", "<C-\\><C-n><C-w>k", { desc = "Go to up window" })
vim.keymap.set("t", "<C-Right>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })
