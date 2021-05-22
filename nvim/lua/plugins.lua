return require'packer'.startup(function()
  use 'wbthomason/packer.nvim'

  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'neovim/nvim-lspconfig'}

  use 'tjdevries/colorbuddy.nvim'
  use {'folke/tokyonight.nvim', requires = {'tjdevries/colorbuddy.nvim'}}

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
end)
