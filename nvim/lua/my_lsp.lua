local autocmd = require 'autocmd'

local LSP_SIGN_PREFIX = 'LspDiagnosticsSign'
local LSP_NUMHL_PREFIX = 'LspDiagnosticsDefault'
local LSP_KINDS = {'Error', 'Warning', 'Information', 'Hint'}

for _, kind in pairs(LSP_KINDS) do
  vim.fn.sign_define(LSP_SIGN_PREFIX .. kind,
                     {text = "", numhl = LSP_NUMHL_PREFIX .. kind})
end

vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {underline = true})

autocmd.group('DiagnosticsOnHover', {
  autocmd.cmd({'CursorHold'}, 'lua vim.lsp.diagnostic.show_line_diagnostics()')
})

local function on_attach(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<c-]>',
                              ':lua vim.lsp.buf.definition()<cr>',
                              {noremap = true})
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', ':lua vim.lsp.buf.hover()<cr>',
                              {noremap = true})

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end

return {on_attach = on_attach}
