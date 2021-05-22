local M = {}

-- Utility function to convert a string such as '<cr>' to '\n'
-- when passed to vimscript.
function M.t(str) return vim.api.nvim_replace_termcodes(str, true, true, true) end

-- Switches to one of the windows containing buf, or replaces the current
-- window's buffer with the given buffer if no such windows exist.
function M.switch_to_win_containing_buf_or_replace_current(buf)
  local windows = vim.fn.win_findbuf(buf)

  if #windows == 0 then
    vim.api.nvim_win_set_buf(0, buf)
  else
    vim.api.nvim_set_current_win(windows[1])
  end
end

function M.lpad(str, n, c)
  if #str > n then
    return str
  else
    return string.rep(c, n - #str) .. str
  end
end

function M.rpad(str, n, c)
  if #str > n then
    return str
  else
    return str .. string.rep(c, n - #str)
  end
end

-- For config development.
function M.reload(pkg_name)
  package.loaded[pkg_name] = nil
  require(pkg_name)
end

return M
