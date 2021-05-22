-- settings.lua
local function make(scoped, global)
  return setmetatable({}, {
    __index = function(_, index) return scoped[index] end,
    __newindex = function(_, index, value)
      scoped[index] = value
      if scoped ~= global then global[index] = value end
    end
  })
end

local o = make(vim.o, vim.o)
local bo = make(vim.bo, vim.o)
local wo = make(vim.wo, vim.o)

-- [[
--    Global Options
-- ]]
o.autoindent = true
o.hlsearch = false
o.incsearch = true
o.ignorecase = true
o.showcmd = true
o.showmode = false
o.showtabline = 2
o.ruler = true
o.termguicolors = true
o.backup = false
o.writebackup = false
o.hidden = true
o.mouse = 'a'
o.updatetime = 400
o.completeopt = 'menuone,noinsert,noselect'

-- [[
--    Window Options
-- ]]
wo.number = true
wo.signcolumn = 'yes'
wo.relativenumber = true
wo.wrap = false

-- [[
--    Buffer Options
-- ]]
bo.swapfile = false
bo.tabstop = 2
bo.softtabstop = 2
bo.shiftwidth = 2
bo.expandtab = true

-- [[
--    Syntax and filetypes
-- ]]
vim.cmd([[ syntax on ]])
vim.cmd([[ filetype plugin indent on ]])
vim.cmd([[ colorscheme tokyonight ]])
