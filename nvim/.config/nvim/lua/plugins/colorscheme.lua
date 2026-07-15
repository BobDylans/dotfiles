-- 自动保存主题选择：用 :colorscheme 切换主题后自动写入文件，下次重启保持
local theme_file = vim.fn.stdpath("config") .. "/lua/config/theme.lua"
local theme_group = vim.api.nvim_create_augroup("PersistTheme", { clear = true })

-- 尝试从文件读取上次保存的主题
local function load_persisted_theme()
  local f = io.open(theme_file, "r")
  if f then
    local theme = f:read("*l")
    f:close()
    if theme and theme ~= "" then
      return theme
    end
  end
  return nil
end

-- 保存当前主题到文件
local function persist_theme(theme_name)
  local f = io.open(theme_file, "w")
  if f then
    f:write(theme_name)
    f:close()
  end
end

-- nvim 主题名 → kitty 主题名（kitty +kitten themes 格式）
local kitty_theme_map = {
  ["kanagawa"] = "Kanagawa_dragon",
  ["kanagawa-dragon"] = "Kanagawa_dragon",
  ["catppuccin"] = "Catppuccin_Mocha",
  ["catppuccin-frappe"] = "Catppuccin_Frappe",
  ["everforest"] = "Everforest_Dark_Hard",
  ["onedark"] = "One_Dark",
  ["dracula"] = "Dracula",
  ["cyberdream"] = "Cyberdream",
}

-- 同步 kitty 主题
local function sync_kitty_theme(nvim_theme)
  local kitty_theme = kitty_theme_map[nvim_theme]
  if not kitty_theme then return end
  -- 用 kitty +kitten themes 切换，会自动下载主题并重载所有 kitty 窗口
  vim.system({ "kitty", "+kitten", "themes", "--reload-in=all", kitty_theme }, { timeout = 5000 })
end

-- 监听 ColorScheme 事件，自动保存 + 同步 kitty
vim.api.nvim_create_autocmd("ColorScheme", {
  group = theme_group,
  callback = function(event)
    persist_theme(event.match)
    sync_kitty_theme(event.match)
  end,
  desc = "Auto save colorscheme choice and sync kitty theme",
})

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      flavour = "frappe",
      transparent_background = false,
      integrations = {
        blink_cmp = true,
        bufferline = true,
        flash = true,
        gitsigns = true,
        noice = true,
        notify = true,
        snacks = true,
        treesitter = true,
        trouble = true,
        which_key = true,
        mason = true,
        lsp_trouble = true,
        mini = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      theme = "lotus",
    },
  },
  {
    "sainnhe/everforest",
    lazy = true,
    priority = 1000,
    init = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_better_performance = 1
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      variant = "default",
      italic_comments = true,
      terminal_colors = true,
    },
  },
  {
    "navarasu/onedark.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "dark",
    },
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
    priority = 1000,
    opts = {},
  },
  -- 启动时加载上次保存的主题，没有则用 everforest
  {
    "LazyVim/LazyVim",
    opts = function()
      local persisted = load_persisted_theme()
      return { colorscheme = persisted or "everforest" }
    end,
  },
}
