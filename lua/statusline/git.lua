local M = {}

--- @return string  Statusline-formatted branch name + add/change/delete counts
function M.get()
  local dict = vim.b.gitsigns_status_dict
  if not dict then
    return ""
  end

  local branch = dict.head and ("%#StGitDelete#  %#StGitBranch#" .. dict.head .. " ") or ""
  local added = dict.added and dict.added > 0 and ("%#StGitAdd#+" .. dict.added .. " ") or ""
  local changed = dict.changed and dict.changed > 0 and ("%#StGitChange#~" .. dict.changed .. " ") or ""
  local removed = dict.removed and dict.removed > 0 and ("%#StGitDelete#-" .. dict.removed .. " ") or ""

  if branch == "" and added == "" and changed == "" and removed == "" then
    return ""
  end

  return branch .. added .. changed .. removed
end

return M
