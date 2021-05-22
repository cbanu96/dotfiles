-- keymaps.lua
local utils = require 'utils'
local repl = require 'repl'
local viml = require 'viml'

-- TODO: Somehow inject locals from the file being evaluated into the repl
-- commands.  Currently it's not worth trying to alias vim.api calls to locals,
-- as [,,x] would not work, and it's nice to quickly test a new bind without
-- restarting or reloading the entire config.

--[[
--   Globals
--]]
vim.g.mapleader = ','

--[[
--   Config REPL.
--
--   Idea taken from tjdevries and expanded upon to allow inspecting return
--   values instead of executing blindly.
--
--   Note: the repl.vimscript ones are specifically not `viml.v_lua`-ed. If
--   anything goes wrong with the lua config, having these essentially as
--   raw vimscripts that don't call back into our lua is pretty nice.
--]]
vim.api.nvim_set_keymap('n', '<leader><leader>x', repl.vimscript(false, false),
                        {noremap = true})
vim.api.nvim_set_keymap('v', '<leader><leader>x', repl.vimscript(false, true),
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><leader>i', repl.vimscript(true, false),
                        {noremap = true})
vim.api.nvim_set_keymap('v', '<leader><leader>i', repl.vimscript(true, true),
                        {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><leader>s',
                        viml.v_lua(repl.lua_scratchpad), {noremap = true})
vim.api.nvim_set_keymap('n', '<leader><leader>r', viml.v_lua(function()
  local bufname = vim.fn.expand("%:p:t:r")
  utils.reload(bufname)
end), {noremap = true})

--[[
--   Easy-mode tabbing via ^P and ^N.
--]]
vim.api.nvim_set_keymap('n', '<C-p>', ':tabp<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-n>', ':tabn<cr>', {noremap = true})

--[[
--   Tabbing in visual mode does not drop selection.
--]]
vim.api.nvim_set_keymap('v', '<', '<gv', {noremap = true})
vim.api.nvim_set_keymap('v', '>', '>gv', {noremap = true})

--[[
--   No arrows.
--]]
for _, key in pairs({'<up>', '<down>', '<left>', '<right>'}) do
  vim.api.nvim_set_keymap('n', key, '<nop>', {noremap = true})
  vim.api.nvim_set_keymap('v', key, '<nop>', {noremap = true})
end

--[[
--   Misc ease of use.
--]]
vim.api.nvim_set_keymap('n', '<tab>', '%', {noremap = true})
vim.api.nvim_set_keymap('v', '<tab>', '%', {noremap = true})
vim.api.nvim_set_keymap('n', ';', ':', {noremap = true})
vim.api.nvim_set_keymap('v', ';', ':', {noremap = true})

--[[
--   telescope
--]]
for key, lens in pairs({
  f = 'git_files',
  b = 'buffers',
  g = 'live_grep',
  t = '',
  a = 'treesitter'
}) do
  vim.api.nvim_set_keymap('n', '<leader>t' .. key,
                          ':Telescope ' .. lens .. '<cr>', {noremap = true})
end

--[[
--   window/split
--]]
vim.api.nvim_set_keymap('n', '<leader>s', ':sp<cr>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>v', ':vs<cr>', {noremap = true})
