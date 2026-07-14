-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-read file when changed externally (e.g. by AI assistant, git pull, etc.)
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  desc = "Check for external file changes",
  callback = function()
    vim.cmd("checktime")
  end,
})

-- 启动后覆盖 DMS 主题，用自己保存的主题
vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Load persisted colorscheme, override DMS theme",
  callback = function()
    local theme_file = vim.fn.stdpath("config") .. "/lua/config/theme.lua"
    local f = io.open(theme_file, "r")
    if f then
      local theme = f:read("*l")
      f:close()
      if theme and theme ~= "" then
        -- 延迟执行，确保在 DMS 主题加载之后覆盖
        vim.defer_fn(function()
          pcall(function()
            vim.cmd("colorscheme " .. theme)
          end)
        end, 50)
      end
    end
  end,
})
