local M = {}

--- @return string  Statusline-formatted filetype icon, or "" if mini.icons isn't set up
function M.get()
  if not vim.g.miniIcons then
    return ""
  end
  local icon, icon_hl = vim.g.miniIcons.get("file", vim.fn.expand("%:t"))
  if not icon then
    return ""
  end
  return "%#" .. icon_hl .. "# " .. icon .. " %#StBase#"
end

return M
