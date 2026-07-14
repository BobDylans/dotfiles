-- 代码块缩进线：左侧绿色边框高亮当前 {} 块，联动行号
return {
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          style = {
            { fg = "#00a86b" },  -- 绿色边框
          },
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "╭",
            left_bottom = "╰",
            right_top = "╮",
            right_bottom = "╯",
          },
        },
        indent = {
          enable = true,
        },
        line_num = {
          enable = true,
          style = "#00a86b",
        },
      })
    end,
  },
}
