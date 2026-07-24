# statusline.nvim

A small, dependency-light custom statusline for Neovim, extracted from a personal `statusline.lua` config into an installable plugin.

Shows: mode, git branch + diff counts (via `gitsigns`), a file icon (via `mini.icons`), filename + modified marker, LSP diagnostic counts, attached LSP client names, file encoding/format, and cursor position.

## Requirements

- Neovim >= 0.10 (uses `vim.diagnostic.count` and `vim.lsp.get_clients`)
- Optional, for full functionality:
  - [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) — git branch/diff segment
  - [mini.icons](https://github.com/echasnovski/mini.icons) — file icon segment
  - A patched Nerd Font — several segments use icon glyphs

All optional dependencies degrade gracefully: if they aren't installed, their segment is simply omitted.

## Installation

### lazy.nvim

```lua
{
  "yourname/statusline.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim", -- optional
    "echasnovski/mini.icons",  -- optional
  },
  config = function()
    require("statusline").setup()
  end,
}
```

### packer.nvim

```lua
use({
  "yourname/statusline.nvim",
  requires = { "lewis6991/gitsigns.nvim", "echasnovski/mini.icons" },
  config = function()
    require("statusline").setup()
  end,
})
```

## Usage

```lua
require("statusline").setup()
```

`setup()` sets `vim.opt.statusline`, defines highlight groups, and registers the autocommands that redraw the statusline on mode changes and gitsigns updates.

## Configuration

`setup()` accepts an optional table to override the default highlight colors:

```lua
require("statusline").setup({
  highlights = {
    StModeNormal = { fg = "#83c092", bold = true },
    StModeInsert = { fg = "#F7F1DE", bold = true },
    StGitAdd = { fg = "#a7c080" },
    -- any other group listed below can be overridden the same way
  },
})
```

Highlight groups used, with their defaults:

| Group | Purpose | Default fg |
|---|---|---|
| `StModeNormal` | Normal mode label | `#83c092` |
| `StModeInsert` | Insert mode label | `#F7F1DE` |
| `StModeVisual` | Visual/V-line/V-block label | `#d699b6` |
| `StModeOther` | Command/Replace/Terminal/etc. label | `#e67e80` |
| `StGitBranch` | Git branch name text | `#F7F1DE` |
| `StGitAdd` | Added lines count | `#a7c080` |
| `StGitChange` | Changed lines count (also used for LSP client list) | `#dbbc7f` |
| `StGitDelete` | Removed lines count / branch icon | `#e67e80` |
| `StFileName` | Filename text | `#FFFFFF` |
| `StFileModifiedIcon` | Modified-buffer dot | `#8DC07C` |
| `StError` | Diagnostic error count | `#e67e80` |
| `StWarning` | Diagnostic warning count | `#dbbc7f` |
| `StHints` | Diagnostic hint count | `#A5E9DD` |
| `StInfo` | Diagnostic info count / encoding / position | `#B0BA99` |
| `StBase` | Transparent background base | — |

Highlights are re-applied automatically on `ColorScheme` change.

## Project layout

```
statusline.nvim/
├── lua/
│   └── statusline/
│       ├── init.lua         -- setup(), config, highlights, autocmds
│       ├── render.lua       -- assembles the final statusline string
│       ├── mode.lua         -- mode label segment
│       ├── git.lua          -- gitsigns branch/diff segment
│       ├── diagnostics.lua  -- LSP diagnostic counts segment
│       ├── icons.lua        -- mini.icons file icon segment
│       └── lsp.lua          -- attached LSP client names segment
├── README.md
└── LICENSE
```

## Notes on the conversion from a single script

The original `statusline.lua` was a single file meant to be `require`d (or sourced) directly from an `init.lua`. To turn it into a proper plugin:

- Highlight group names were namespaced (`FileName` → `StFileName`, `FileModifiedIcon` → `StFileModifiedIcon`) to avoid clashing with common/generic group names other plugins or colorschemes might define.
- Logic was split into one module per segment under `lua/statusline/`, each returning a small table with a `get()` function, so segments can be tested, reused, or disabled independently.
- `vim.g.CustomStatusLine` (a global function) was replaced with `require('statusline.render').render()`, called via `v:lua.require(...)`, so nothing leaks into the global namespace.
- Setup was wrapped in `M.setup(opts)` instead of running unconditionally at require-time, and now accepts a `highlights` config table.
- Icon lookups use `pcall(require, "mini.icons")` before calling into it, rather than assuming it's always present. (An earlier draft read from `vim.g.miniIcons`, but `vim.g` can't reliably hold a Lua table containing functions and would sometimes collapse it to a boolean, causing an "attempt to index a boolean value" error.)
- The stray `vim.cmd("redrawstatus")` that ran once at load time was removed, since `setup()` runs before the window is drawn and Neovim will draw the statusline on its own; the autocommands handle redraws after that.

## License

MIT
