-- Allows the clients of this library to inject some VimL code that calls back into
-- the lua code. Useful for keymapping back to a lua function.
local M = {}

_G['viml_handlers'] = {}
function make_get_token()
  local token = 0

  return function()
    token = token + 1
    return token
  end
end

local get_token = make_get_token()

local function set_thunk(thunk)
  local token = get_token()
  _G['viml_handlers'][token] = thunk

  return token
end

local function fn_iden(token) return 'viml_handlers[' .. token .. ']()' end

function M.v_lua(thunk) return ':lua ' .. fn_iden(set_thunk(thunk)) .. '<cr>' end

function M.luaeval(thunk)
  return 'call luaeval("' .. fn_iden(set_thunk(thunk)) .. '")'
end

return M
