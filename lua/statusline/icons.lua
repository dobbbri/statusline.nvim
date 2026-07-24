local M = {}

--- @return string  Statusline-formatted filetype icon, or "" if mini.icons isn't set up
function M.get()
local has, miniIcons = pcall(require, 'mini.icons')
  if not has then
    return ""
  end
  local icon, icon_hl = miniIcons.get("file", vim.fn.expand("%:t"))
  if not icon then
    return ""
  end
  return "%#" .. icon_hl .. "# " .. icon .. " %#StBase#"
end

return M
