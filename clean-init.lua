--[[ 
Clean 'init.lua' with minimal QoL settings for fast file editing.
In Linux, this is aliased to `vim` in .bashrc (`alias vim='nvim -u clean-init.lua'`)
--]]

---------- INITAL SETTINGS -----------------------------------------------------

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_winsize = 25

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

if vim.g.vscode then
  require 'vscode-init'
  return
end

---------- OPTIONS -------------------------------------------------------------

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'

vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.updatetime = 250

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.inccommand = 'split'

vim.o.cursorline = false

vim.o.scrolloff = 10

vim.o.expandtab = false
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.softtabstop = -1

vim.cmd('autocmd TermOpen * startinsert')

vim.o.confirm = true

---------- MARKDOWN HIGHLIGHTS -------------------------------------------------
-- Used to colorize markdown headers with the default colorscheme

---@param source string
---@return vim.api.keyset.highlight
-- Take in the colorscheme's named style and bold it.
local function markdown_heading_style(source)
  local source_style = vim.api.nvim_get_hl(0, { name = source, link = false, })

  return {
    fg = source_style.fg,
    ctermfg = source_style.ctermfg,
    bold = true,
    cterm = { bold = true },
  }
end

-- 'String' uses the default colorscheme's green color
local heading_green = markdown_heading_style('String')
-- 'Identifier' uses the default colorscheme's blue color
local heading_blue = markdown_heading_style('Identifier')

vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', heading_green)

for level = 2, 6 do
  vim.api.nvim_set_hl( 0, ('@markup.heading.%d.markdown'):format(level), heading_blue)
end

---------- KEYMAPS -------------------------------------------------------------

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'quickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '\\', '<cmd>Lexplore<CR>', { desc = 'File explorer (netrw)' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Open the Neovim config directory in Netrw
vim.keymap.set('n', '<leader>sn', function() vim.cmd.edit(vim.fn.stdpath 'config') end, { desc = 'neovim files' })

---------- AUTOCOMMANDS --------------------------------------------------------

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Auto-sync saved `clean-init.lua` to the Windows Neovim `init.lua`
-- 'pcall' to silently fail when running on Windows where the script doesn't exist
pcall(require, 'scripts.windows-init-sync')

---------- PLUGINS -------------------------------------------------------------

vim.pack.add({
	{ src = 'https://github.com/folke/which-key.nvim', name = 'which-key' }
})

require('which-key').setup({
	preset = "helix",
	delay = 0,
	win = { border = "none" },
  spec = {
    { '<leader>s', group = 'search (netrw)', mode = { 'n', 'v' } },
  },
})

