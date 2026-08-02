local M = {}

-- Named palette so each color is defined once. Highlight groups below
-- reference these instead of repeating hex codes (e.g. red is reused by
-- StModeOther, StGitDelete, and StError; white by StModeInsert, StGitBranch,
-- and StFileName; yellow by StModeVisual, StGitChange, and StWarning; green
-- by StModeNormal, StGitAdd, and StFileModifiedIcon).
local colors = {
	green = "#83c092",
	red = "#e67e80",
	yellow = "#dbbc7f",
	blue = "#A5E9DD",
	gray = "#B0BA99",
	white = "#FFFFFF",
}

M.config = {
	highlights = {
		StModeNormal = { fg = colors.green, bold = true },
		StModeInsert = { fg = colors.white, bold = true },
		StModeVisual = { fg = colors.yellow, bold = true },
		StModeOther = { fg = colors.red, bold = true },
		StGitBranch = { fg = colors.white },
		StGitAdd = { fg = colors.green},
		StGitChange = { fg = colors.yellow},
		StGitDelete = { fg = colors.red},
		StFileName = { fg = colors.white},
		StFileModifiedIcon = { fg = colors.green },
		StError = { fg = colors.red },
		StWarning = { fg = colors.yellow },
		StHints = { fg = colors.blue},
		StInfo = { fg = colors.gray },
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
			vim.schedule(function()
				vim.cmd("redrawstatus")
			end)
		end,
	})

	-- Redraw when gitsigns updates its per-buffer status dict
	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "GitSignsUpdate",
		callback = function()
			vim.cmd("redrawstatus")
		end,
	})

	-- Re-apply highlights whenever the colorscheme changes
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = apply_highlights,
	})
end

return M
