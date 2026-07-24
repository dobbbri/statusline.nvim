local M = {}

--- @return string  Statusline-formatted list of attached LSP client names for the current buffer
function M.get_clients()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return ""
  end
  local client_names = {}
  for _, client in ipairs(clients) do
    local alt_text = string.gsub(client.name, "mini.", "")
    table.insert(client_names, alt_text)
  end
  return "   " .. table.concat(client_names, ", ")
end

return M
