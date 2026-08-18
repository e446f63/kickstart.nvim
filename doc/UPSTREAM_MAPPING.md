# Upstream Mapping

This document maps major upstream Kickstart areas into this repo's modular structure.

Use it when reviewing upstream changes so the question becomes:

> "Where does this behavior live in *this* repo?"

instead of:

> "How do I merge this upstream hunk directly?"

## Top-Level Structure

- Upstream `init.lua`
  - this repo splits that behavior across modules
- Machine-specific integrations
  - upstream usually has none
  - this repo keeps them under `lua/local/plugins/*`

## Mapping By Area

### Core editor settings / globals / simple keymaps

Upstream location:
- `init.lua`

Local location:
- `init.lua`

Notes:
- Keep obvious top-level editor identity here.
- Examples:
  - leaders
  - statusline chooser
  - colorscheme chooser
  - basic options
  - simple non-plugin keymaps

### Plugin import structure

Upstream location:
- inline plugin specs in `init.lua`

Local location:
- `lua/plugins/*`
- `lua/local/plugins/*`

Notes:
- General reusable plugin config belongs in `lua/plugins/*`.
- Machine-specific plugin specs belong in `lua/local/plugins/*`.

### LSP plugin wiring

Upstream location:
- `init.lua` LSP plugin block

Local location:
- `lua/plugins/lsp.lua`

Notes:
- This file owns plugin/dependency wiring only.

### LSP behavior / server config / diagnostics

Upstream location:
- `init.lua` LSP section

Local location:
- `lua/lsp/config.lua`

Notes:
- This file owns:
  - `LspAttach`
  - diagnostics config
  - server table
  - `vim.lsp.config()`
  - `vim.lsp.enable()`

### Telescope

Upstream location:
- `init.lua` Telescope block

Local location:
- `lua/plugins/telescope.lua`

Notes:
- Keep Telescope-backed LSP pickers here, not in `lua/lsp/config.lua`.

### Treesitter

Upstream location:
- `init.lua` Treesitter block

Local location:
- `lua/plugins/nvim-treesitter.lua`

Notes:
- This repo uses the newer direct Treesitter setup, not the old module shim pattern.

### Completion / Blink

Upstream location:
- `init.lua` Blink block

Local location:
- `lua/plugins/blink.lua`

Notes:
- Only general completion behavior belongs here.
- OpenWRT-specific completion changes belong in `lua/local/plugins/openwrt.lua`.

### Mini.nvim

Upstream location:
- `init.lua` mini.nvim block

Local location:
- `lua/plugins/mini.lua`

Notes:
- This file owns:
  - `mini.ai`
  - `mini.surround`
  - optional `mini.statusline`

### Lualine

Upstream location:
- upstream may not include it, or it may be absent entirely

Local location:
- `lua/plugins/lualine.lua`

Notes:
- This repo keeps `lualine` installed but conditionally disabled via `cond`.

### Colorschemes

Upstream location:
- `init.lua` colorscheme plugin block

Local location:
- `lua/plugins/colorschemes.lua`

Notes:
- Actual active theme is selected from `init.lua` via `vim.g.active_colorscheme`.

### Markdown rendering

Upstream location:
- `init.lua` render-markdown block

Local location:
- `lua/plugins/render-markdown.lua`

### Neo-tree

Upstream location:
- optional example plugin / local customization

Local location:
- `lua/plugins/neo-tree.lua`

### Indent guides

Upstream location:
- optional example plugin / local customization

Local location:
- `lua/plugins/indent_line.lua`

### Sidekick

Upstream location:
- not part of standard Kickstart

Local location:
- `lua/plugins/sidekick.lua`

Notes:
- Tab-path behavior is intentionally deferred/separate from the baseline plugin wiring.

### OpenWRT

Upstream location:
- none

Local location:
- `lua/local/plugins/openwrt.lua`

Notes:
- This file owns both:
  - local plugin loading
  - OpenWRT-specific Blink augmentation

## How To Use This Document

When upstream changes:

1. identify the upstream area that changed
2. find the corresponding local file here
3. port the behavior semantically, not line-for-line
4. keep local architectural decisions intact unless there is a strong reason to change them
