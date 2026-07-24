local M = {}

-- One entry per severity, in display order: icon glyph + highlight group.
local SEVERITIES = {
  { severity = vim.diagnostic.severity.ERROR, icon = "", hl = "StError" },
  { severity = vim.diagnostic.severity.WARN, icon = "", hl = "StWarning" },
  { severity = vim.diagnostic.severity.HINT, icon = "", hl = "StHints" },
  { severity = vim.diagnostic.severity.INFO, icon = "", hl = "StInfo" },
}

--- @return string  Statusline-formatted error/warning/hint/info counts for the current buffer
function M.get()
  local counts = vim.diagnostic.count(0)
  local parts = {}

  for _, s in ipairs(SEVERITIES) do
    local n = counts[s.severity] or 0
    if n > 0 then
      parts[#parts + 1] = "%#" .. s.hl .. "# " .. s.icon .. " " .. n
    end
  end

  return table.concat(parts)
end

return M
