local M = {}

--- @return string  Statusline-formatted error/warning/hint/info counts for the current buffer
function M.get()
  local counts = vim.diagnostic.count(0)

  local errors = counts[vim.diagnostic.severity.ERROR] or 0
  local warnings = counts[vim.diagnostic.severity.WARN] or 0
  local hints = counts[vim.diagnostic.severity.HINT] or 0
  local info = counts[vim.diagnostic.severity.INFO] or 0

  local error_icon = errors > 0 and "  " .. errors or ""
  local warnings_icon = warnings > 0 and "  " .. warnings or ""
  local hints_icon = hints > 0 and "  " .. hints or ""
  local info_icon = info > 0 and "  " .. info or ""

  return "%#StError#"
    .. error_icon
    .. "%#StWarning#"
    .. warnings_icon
    .. "%#StHints#"
    .. hints_icon
    .. "%#StInfo#"
    .. info_icon
end

return M
