-- 自动保存：离开插入模式或切换缓冲区时静默保存
-- 使用原生 autocmd，零依赖
local autosave_group = vim.api.nvim_create_augroup("AutoSave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
  group = autosave_group,
  pattern = "*",
  callback = function()
    -- 只保存可修改、已修改、普通类型的缓冲区
    if vim.bo.modifiable and vim.bo.modified and vim.bo.buftype == "" then
      -- 排除不需要自动保存的文件类型
      local exclude = {
        "neo-tree",
        "neo-tree-popup",
        "notify",
        "lazy",
        "mason",
        "toggleterm",
        "checkhealth",
        "TelescopePrompt",
      }
      for _, ft in ipairs(exclude) do
        if vim.bo.filetype == ft then
          return
        end
      end
      vim.cmd("silent! write")
    end
  end,
  desc = "Auto save on InsertLeave and BufLeave",
})

return {}
