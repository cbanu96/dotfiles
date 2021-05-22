-- Autocmd wrappers.
--
-- NOTE: Does not support filename blobs, should be easy to add though.
--
-- Designated usage:
--
-- group('SomeGroup', {
--   cmd({'BufEnter', 'BufLeave'}, 'some vimscript'}
-- })
local M = {}

function M.cmd(events, vimscript) return
    {events = events, vimscript = vimscript} end

function M.group(name, cmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  for _, cmd in ipairs(cmds) do
    local events_str = table.concat(cmd.events, ",")
    local autocmd_raw = 'autocmd ' .. events_str .. ' * ' .. cmd.vimscript
    vim.cmd(autocmd_raw)
  end
  vim.cmd('augroup END')
end

return M
