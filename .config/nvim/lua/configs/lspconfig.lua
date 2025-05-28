vim.lsp.config('*', {
  root_markers = { '.git', '.hg' },
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  }
})

vim.lsp.config('ts_ls', {
  cmd = { "typescript-language-server", "--stdio" },
  filetype = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }
});

vim.lsp.enable('ts_ls')

