-- [[
--
--    Lua vim config repl.
--
--    These are pure vimscript with interleaved lua calls to actually execute the commands.
--    The "P" of the repl is done by :lua print().
-- ]]
local u = require('utils')
local M = {}

local function cmd(str, prefix, wrapper_start, wrapper_end)
  return ':' .. prefix .. 'echo ' .. 'execute(printf(":lua ' .. wrapper_start ..
             '%s' .. wrapper_end .. '", ' .. str .. '))' .. '<cr>'
end

local function single_line(wrapper_start, wrapper_end)
  return cmd('getline(".")', '', wrapper_start, wrapper_end)
end

local function multi_line(wrapper_start, wrapper_end)
  local lt = u.t "'<"
  local gt = u.t "'>"

  return cmd('join(getline("' .. lt .. '", "' .. gt .. '"), " ")', u.t '<C-w>',
             wrapper_start, wrapper_end)
end

-- Computes the vimscript that will take the current line (in normal mode), or
-- the current selection (in visual mode), and execute it.
--
-- If inspect_output is true, the output is not discarded, but rather printed.
function M.vimscript(inspect_output, visual_mode)
  local wrapper_start, wrapper_end
  local fn

  if inspect_output then
    wrapper_start, wrapper_end = 'print(vim.inspect(', '))'
  else
    wrapper_start, wrapper_end = '', ''
  end

  if visual_mode then
    fn = multi_line
  else
    fn = single_line
  end

  return fn(wrapper_start, wrapper_end)
end

-- Creates a new buffer and replaces the buffer in the selected window with a
-- lua scratchpad to try things out.
function make_lua_scratchpad()
  local buf

  return function()
    if not buf then
      buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(buf, 'filetype', 'lua')
      vim.api.nvim_buf_set_name(buf, '[Lua Scratchpad]')
    end

    u.switch_to_win_containing_buf_or_replace_current(buf)
  end
end

M.lua_scratchpad = make_lua_scratchpad()

return M
