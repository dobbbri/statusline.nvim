local mode = require("statusline.mode")
local git = require("statusline.git")
local diagnostics = require("statusline.diagnostics")
local icons = require("statusline.icons")
local lsp = require("statusline.lsp")

local M = {}

--- Entry point called from 'statusline' via v:lua.
--- @return string
function M.render()
  local is_active = vim.g.statusline_winid == vim.fn.win_getid()
  local is_modified = vim.api.nvim_get_option_value("modified", { buf = 0 })
  local modified_icon = is_modified and "●" or ""
  local filename = "%t"
  local right_align = "%="

  if not is_active then
    return "%#StBase#" .. filename .. right_align
  end

  return "%#StBase#"
    .. mode.get()
    .. " "
    .. git.get()
    .. "%#StBase#"
    .. " "
    .. icons.get()
    .. "%#StFileName#"
    .. filename
    .. " "
    .. "%#StFileModifiedIcon#"
    .. modified_icon
    .. " "
    .. diagnostics.get()
    .. "%#StBase#"
    .. right_align
    .. "%#StGitChange#"
    .. lsp.get_clients()
    .. "  %#StInfo# "
    .. vim.bo.fileencoding
    .. " "
    .. vim.bo.fileformat
    .. " "
    .. "%#StHints#   "
    .. "%#StFileName# %l:%c"
    .. "%#StInfo# %p%% "
end

return M
