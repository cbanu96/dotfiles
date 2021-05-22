-- init.lua
require 'plugins'
require 'settings'
require 'keymaps'
require 'statusline'
local my_lsp = require 'my_lsp'

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained",
  ignore_install = {},
  highlight = {enable = true, disable = {}}
}

require'lspconfig'.rust_analyzer.setup {on_attach = my_lsp.on_attach}
