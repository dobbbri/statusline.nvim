local M = {}

--- @return string  Statusline-formatted list of attached LSP client names for the current buffer
function M.get_clients()
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  if next(clients) == nil then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    names[#names + 1] = (client.name:gsub("^mini%.", ""))
  end

  return "   " .. table.concat(names, ", ")
end

return M
