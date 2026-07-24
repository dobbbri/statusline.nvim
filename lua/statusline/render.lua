local mode = require("statusline.mode")
local git = require("statusline.git")
local diagnostics = require("statusline.diagnostics")
-- local icons = require("statusline.icons")
-- local lsp = require("statusline.lsp")

local M = {}

--- Entry point called from 'statusline' via v:lua.
--- @return string
function M.render()
  local is_active = vim.g.statusline_winid == vim.fn.win_getid()

  if not is_active then
    return "%#StBase#%t%="
  end

  local is_modified = vim.api.nvim_get_option_value("modified", { buf = 0 })

  local left = {
    "%#StBase#",
    mode.get(),
    " ",
    git.get(),
    "%#StBase# ",
    -- icons.get(),
    "%#StFileName#%t ",
    "%#StFileModifiedIcon#",
    is_modified and "●" or "",
    " ",
    diagnostics.get(),
  }

  local right = {
    "%#StBase#%=",
    "%#StGitChange#",
    -- lsp.get_clients(),
    "  %#StInfo# ",
    vim.bo.fileencoding,
    " ",
    vim.bo.fileformat,
    " %#StHints#  ",
    "%#StFileName# %l:%c",
    "%#StInfo# %p%% ",
  }

  return table.concat(left) .. table.concat(right)
end

return M
