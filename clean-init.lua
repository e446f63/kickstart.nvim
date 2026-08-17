--[[ 
Clean 'init.lua' with minimal QoL settings for fast file editing.
This is aliased to `vim` in .bashrc (`alias vim='nvim -u clean-init.lua'`)
--]]

-------------------- INITAL SETTINGS -------------------------------------------

vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

if vim.g.vscode then
  require 'vscode-init'
  return
end

-------------------- OPTIONS ---------------------------------------------------

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

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 0

vim.o.confirm = true

-- enable experimental feature intended to replace the builtin message + cmdline presentation layer.
-- default options shown
require('vim._core.ui2').enable({
  enable = true, -- Whether to enable or disable the UI.
  msg = { -- Options related to the message module.
    ---@type 'cmd'|'msg' Default message target, either in the
    ---cmdline or in a separate ephemeral message window.
    ---@type string|table<string, 'cmd'|'msg'|'pager'> Default message target
    ---or table mapping |ui-messages| kinds and triggers to a target.
    targets = 'cmd',
    cmd = { -- Options related to messages in the cmdline window.
      height = 0.5 -- Maximum height while expanded for messages beyond 'cmdheight'.
    },
    dialog = { -- Options related to dialog window.
      height = 0.5, -- Maximum height.
    },
    msg = { -- Options related to msg window.
      height = 0.5, -- Maximum height.
      timeout = 4000, -- Time a message is visible in the message window.
    },
    pager = { -- Options related to message window.
      height = 1, -- Maximum height.
    },
  },
})

-------------------- KEYMAPS ---------------------------------------------------

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'quickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-------------------- AUTOCOMMANDS ----------------------------------------------

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-------------------- PLUGINS ---------------------------------------------------

vim.pack.add({
	{ src = 'https://github.com/folke/which-key.nvim', name = 'which-key' }
})

require('which-key').setup({
	preset = "helix",
	delay = 0,
	win = { border = "none" },
})

