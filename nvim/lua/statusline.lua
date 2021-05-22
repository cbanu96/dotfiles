-- My own statusline, this should be pretty fun.
local u = require 'utils'
local viml = require 'viml'
local autocmd = require 'autocmd'

local MODE_MAP = {
  ['n'] = 'normal',
  ['no'] = 'normal',
  ['nov'] = 'normal',
  ['noV'] = 'normal',
  ['no'] = 'normal',
  ['niI'] = 'normal',
  ['niR'] = 'normal',
  ['niV'] = 'normal',
  ['v'] = 'visual',
  ['V'] = 'v·line',
  [''] = 'v·block',
  ['i'] = 'insert',
  ['ic'] = 'i·completion',
  ['ix'] = 'i·completion',
  ['R'] = 'replace',
  ['Rv'] = 'replace',
  ['Rc'] = 'r·completion',
  ['Rc'] = 'r·completion',
  ['c'] = 'command',
  ['cv'] = 'command',
  ['cv'] = 'command',
  ['r'] = 'prompt',
  ['rm'] = 'p·more',
  ['r?'] = 'p·confirm',
  ['!'] = 'shell',
  ['t'] = 'term',

  -- Unhandled modes, I never expect to see those in practice anyway
  -- Maybe I should just unmap 'gh' and co.
  ['s'] = 'unhandled: s',
  ['S'] = 'unhandled: S',
  [''] = 'unhandled: ^S'
}

local TO_THE_RIGHT = '%='
local SECTION_OPEN = ''
local SECTION_CLOSE = ''

local HI_O_NORMAL = 'StatuslineModeNormalFg'
local HI_O_VISUAL = 'StatuslineModeVisualFg'
local HI_O_INSERT = 'StatuslineModeInsertFg'
local HI_O_REPLACE = 'StatuslineModeReplaceFg'
local HI_O_COMMAND = 'StatuslineModeCommandFg'
local HI_O_INACTIVE = 'StatuslineModeInactiveFg'
local HI_C_NORMAL = 'StatuslineModeNormal'
local HI_C_VISUAL = 'StatuslineModeVisual'
local HI_C_INSERT = 'StatuslineModeInsert'
local HI_C_REPLACE = 'StatuslineModeReplace'
local HI_C_INACTIVE = 'StatuslineModeInactive'
local HI_C_COMMAND = 'StatuslineModeCommand'

local MODE_HIGHLIGHTS = {
  ['normal'] = 'StatuslineModeNormal',
  ['visual'] = 'StatuslineModeVisual',
  ['v·line'] = 'StatuslineModeVisual',
  ['v·block'] = 'StatuslineModeVisual',
  ['insert'] = 'StatuslineModeInsert',
  ['i·completion'] = 'StatuslineModeInsert',
  ['replace'] = 'StatuslineModeReplace',
  ['r·completion'] = 'StatuslineModeReplace',
  ['prompt'] = 'StatuslineModeNormal',
  ['p·more'] = 'StatuslineModeNormal',
  ['p·confirm'] = 'StatuslineModeNormal',
  ['shell'] = 'StatuslineModeVisual',
  ['term'] = 'StatuslineModeNormal',
  ['command'] = 'StatuslineModeCommand'
}

--[[
--   Hook into the colorscheme (tokyonight).
--
--   TODO: Make this more generic.
--   FIXME: Be non-termguicolors-friendly.
--]]
local function highlights()
  local sc = require'tokyonight.colors'.setup(require 'tokyonight.config')

  local function def(name, rname, fg, bg)
    vim.api.nvim_exec('hi def ' .. name .. ' guifg=' .. fg .. ' guibg=' .. bg,
                      false)
    vim.api.nvim_exec('hi def ' .. rname .. ' guifg=' .. bg .. ' guibg=' .. fg,
                      false)
  end

  def(HI_C_NORMAL, HI_O_NORMAL, sc.blue, sc.black)
  def(HI_C_INSERT, HI_O_INSERT, sc.green, sc.black)
  def(HI_C_VISUAL, HI_O_VISUAL, sc.magenta, sc.black)
  def(HI_C_REPLACE, HI_O_REPLACE, sc.red, sc.black)
  def(HI_C_COMMAND, HI_O_COMMAND, sc.yellow, sc.black)

  def(HI_C_INACTIVE, HI_O_INACTIVE, sc.fg_gutter, sc.black)
end

--[[
--   Utility functions.
--]]
local function mode()
  local m = vim.api.nvim_get_mode().mode
  if MODE_MAP[m] == nil then return m end
  return MODE_MAP[m]
end

local function mode_highlight(mode)
  if MODE_HIGHLIGHTS[mode] == nil then return 'StatuslineModeInactive' end
  return MODE_HIGHLIGHTS[mode]
end

local function hi_o(mode) return '%#' .. mode_highlight(mode) .. 'Fg#' end

local function hi_c(mode) return '%#' .. mode_highlight(mode) .. '#' end

--[[
--   Formatting and highlighting.
--]]

local function section_mode()
  local mode = mode()
  return mode
end

local function section_bufname() return [[%F]] end

local function section_permissions(true_if_active)
  local m = vim.bo.modifiable and 'M' or ''
  local r = vim.bo.readonly and 'R' or ''
  return true_if_active and m .. r or ''
end

local function section_location() return [[%3l:%-2c]] end

--[[
--   Active and inactive status line specs.
--]]

local function make(true_if_active)
  local mode = true_if_active and section_mode() or 'inactive'
  local c = hi_c(mode)
  local o = hi_o(mode)

  return table.concat({
    -- |--<mode>-->
    o, '  ', u.lpad(mode, 8, ' '), c, SECTION_CLOSE, '   ', -- <--<filename>-->
    SECTION_OPEN, o, section_bufname(), c, SECTION_CLOSE, TO_THE_RIGHT,
    -- modifiable or readonly flags
    section_permissions(true_if_active), -- <--row:col|
    SECTION_OPEN, o, section_location()
  })
end

--[[
--   Finally, hooks.
--]]

function _G.statusline_as_str() return make(true) end

function _G.statusline_inactive_as_str() return make(false) end

-- Go live:

highlights()

autocmd.group('StatusLine', {
  autocmd.cmd({'BufEnter', 'WinEnter'},
              [[ setlocal statusline=%!v:lua.statusline_as_str() ]]),
  autocmd.cmd({'BufLeave', 'WinLeave'},
              [[ setlocal statusline=%!v:lua.statusline_inactive_as_str() ]])
})
