local M = {}

local mode_map = {
  n = { " Normal ", "StModeNormal" },
  i = { " Insert ", "StModeInsert" },
  v = { " Visual ", "StModeVisual" },
  V = { " V-line ", "StModeVisual" },
  ["\22"] = { " V-block ", "StModeVisual" }, -- CTRL-V
  c = { " Command ", "StModeOther" },
  r = { " R-pending ", "StModeOther" },
  R = { " Replace ", "StModeOther" },
  t = { " Terminal", "StModeOther" },
}

--- @return string  Statusline-formatted mode label
function M.get()
  local mode = vim.api.nvim_get_mode().mode
  local m = mode_map[mode] or { " " .. mode .. " ", "StModeOther" }
  return "%#" .. m[2] .. "#" .. m[1] .. "%#StBase#"
end

return M
