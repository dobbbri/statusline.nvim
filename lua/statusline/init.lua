local M = {}

M.config = {
  highlights = {
    StModeNormal = { bg = "NONE", fg = "#83c092", bold = true },
    StModeInsert = { bg = "NONE", fg = "#F7F1DE", bold = true },
    StModeVisual = { bg = "NONE", fg = "#d699b6", bold = true },
    StModeOther = { bg = "NONE", fg = "#e67e80", bold = true },
    StGitBranch = { fg = "#F7F1DE", bg = "NONE" },
    StFileName = { fg = "#FFFFFF", bg = "NONE" },
    StGitAdd = { fg = "#a7c080", bg = "NONE" },
    StGitChange = { fg = "#dbbc7f", bg = "NONE" },
    StGitDelete = { fg = "#e67e80", bg = "NONE" },
    StFileModifiedIcon = { fg = "#8DC07C", bg = "NONE" },
    StError = { fg = "#e67e80", bg = "NONE" },
    StWarning = { fg = "#dbbc7f", bg = "NONE" },
    StHints = { fg = "#A5E9DD", bg = "NONE" },
    StInfo = { fg = "#B0BA99", bg = "NONE" },
    StBase = { bg = "NONE" },
  },
}

local function apply_highlights()
  for name, val in pairs(M.config.highlights) do
    vim.api.nvim_set_hl(0, name, val)
  end
  -- Keep the built-in Statusline group from adding its own reverse-video styling
  vim.api.nvim_set_hl(0, "Statusline", { reverse = false })
end

--- Set up the statusline. Safe to call multiple times (e.g. re-run on config reload).
--- @param opts table|nil  Optional overrides, e.g. { highlights = { StModeNormal = { fg = "#ffffff" } } }
function M.setup(opts)
  opts = opts or {}
  M.config = vim.tbl_deep_extend("force", M.config, opts)

  apply_highlights()

  vim.opt.statusline = "%!v:lua.require('statusline.render').render()"

  local group = vim.api.nvim_create_augroup("StatuslineNvim", { clear = true })

  -- Redraw on mode changes so the mode label / colors update immediately
  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "CmdlineLeave" }, {
    group = group,
    callback = function()
      vim.schedule(function() vim.cmd("redrawstatus") end)
    end,
  })

  -- Redraw when gitsigns updates its per-buffer status dict
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "GitSignsUpdate",
    callback = function() vim.cmd("redrawstatus") end,
  })

  -- Re-apply highlights whenever the colorscheme changes
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = apply_highlights,
  })
end

return M
