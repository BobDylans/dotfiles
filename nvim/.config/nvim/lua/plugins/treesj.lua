-- 代码重构：gS 展开单行为多行，gJ 合并多行为单行
return {
  {
    "Wansmer/treesj",
    keys = {
      { "gJ", "<cmd>TSJToggle<cr>", desc = "Toggle split/join" },
      { "gS", "<cmd>TSJSplit<cr>", desc = "Split to multi-line" },
    },
    config = function()
      require("treesj").setup({
        use_default_keymaps = false,
      })
    end,
  },
}
