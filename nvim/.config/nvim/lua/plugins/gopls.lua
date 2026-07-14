return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Neovim >= 0.12 下，"*" server config 的 capabilities 只包含
      -- workspace.fileOperations，缺少 textDocument。LazyVim go.lua:60
      -- 访问 client.config.capabilities.textDocument.semanticTokens 会崩。
      -- 这里显式补齐 textDocument capabilities。
      opts.servers = opts.servers or {}
      opts.servers["*"] = vim.tbl_deep_extend("force", opts.servers["*"] or {}, {
        capabilities = {
          textDocument = vim.deepcopy(vim.lsp.protocol.make_client_capabilities().textDocument),
        },
      })

      -- 移除 LazyVim go.lua 中 gopls 的 semantic tokens workaround
      -- 它用客户端能力拼凑 server_capabilities.semanticTokensProvider.legend，
      -- 导致 tokenModifiers 数组比 gopls v0.22.0 实际使用的短，
      -- 解码语义令牌时触发 "table index is nil"。
      -- 这个 workaround 针对 go#54531，已在 gopls v0.12.0+ 修复。
      opts.setup = opts.setup or {}
      opts.setup.gopls = function(_, _)
        -- 空实现：跳过 LazyVim 的语义令牌 workaround
      end
    end,
  },
}
