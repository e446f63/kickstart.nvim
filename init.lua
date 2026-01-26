--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||    e446f63.NVIM    ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:my kickstart.nvim  ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

TODO: Check out this repo for an updated kickstart.nvim file.
Should probably either move to it, or pull in some of the updates.
See: https://github.com/oriori1703/kickstart-modular.nvim/tree/maintained-upstream

This file was originally from Kickstart.nvim by T.J. DeVries

  Original at: https://github.com/nvim-lua/kickstart.nvim

  Most comments have removed, some kept for informational and/or eductational
  value.

  Learn more about a Lua at:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

  TODO: The very first thing is to remember how to make these cool comments.
  NOTE: They come from todo-comments.nvim plugin, which is loaded later in this file.
  NOTE: The url: https://github.com/folke/todo-comments.nvim
  NOTE: These work in any file edited with nvim and are highly configurable. They
  even work with multi-line comments like this one! See gh for defaults.
  To use these, the keyword must be in all caps followed by colon (`:`).
  The following are supported by default:
    FIX:
    TODO:
    HACK:
    WARN:
    PERF:
    NOTE:
    TEST:

  Remember to use :help!
    There's a built-in keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.
--]]

--NOTE:
--[[
=====================================================================
==================== INITAL SETTINGS             ====================
=====================================================================
--]]

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

--NOTE:
--[[
=====================================================================
==================== OPTIONS                     ====================
=====================================================================
--]]
--See `:help vim.o`. For more options, you can see `:help option-list`

-- Give pop-ups (like <S>-K) borders
vim.o.winborder = 'single'

-- Make relative line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

--NOTE:
--[[
=====================================================================
==================== KEYMAPS                     ====================
=====================================================================
--]]
--See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with <ESC><ESC>.
--
-- This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
--  If these don't work, see original kickstart.nvim file for different versions.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle spell checking
vim.keymap.set('n', '<leader>ts', '<cmd>lua vim.o.spell = not vim.o.spell<CR>', { desc = '[S]pellchecking' })

--NOTE:
--[[
=====================================================================
==================== AUTOCOMMANDS                ====================
=====================================================================
--]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

--NOTE:
--[[
=====================================================================
==================== INSTALL LAZY.NVIM           ====================
=====================================================================
--]]

--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

--NOTE:
--[[
=====================================================================
==================== CONFIGURE & INSTALL PLUGINS ====================
=====================================================================
--]]

--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: All plugins get installed inside this block (i.e. the rest of this file).
require('lazy').setup(
  {
    -- HACK: Testing my new openwrt.nvim plugin!
    --
    {
      dir = "/home/eric/dev/openWRT", -- The absolute path to this project
      name = "openwrt.nvim",
      config = function()
        require("openwrt").setup({
          -- Router connection settings
          ssh_host = "192.168.31.1",      -- IP or hostname of your router
          -- ssh_user = "root",           -- SSH username (optional, uses "root" if omitted)
          -- ssh_port = 22,               -- SSH port (optional, uses 22 if omitted)
          -- ssh_key = nil,               -- Path to private key (optional, uses ssh-agent if nil)
          -- speedtest_flags = nil,       -- Flags for `speedtest` command (optional, default is nil)
        })
      end,
      dependencies = {
        "MunifTanjim/nui.nvim",
        { 'nosduco/remote-sshfs.nvim', -- Required for OpenWrtConfig 
          dependencies = { 'nvim-telescope/telescope.nvim', "nvim-lua/plenary.nvim", },
          opts = {},
        }
      },
    },
    -- HACK: End of testing blocks

    -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

    { 'NMAC427/guess-indent.nvim', opts = {} },-- Detect tabstop and shiftwidth automatically

    -- NOTE: Use `opts = {}` to automatically pass options to a
    -- plugin's `setup()` function, forcing the plugin to be loaded.
    -- You must at least pass `opts = {}` to a plugin!
    -- For example, the 'guess-indent' plugin above was orignally just "'NMAC427/guess-indent.nvim'".
    -- It stopped working until I made it a table and added 'opts'.

    -- Alternatively, use `config = function() ... end` for full control over the configuration.
    -- Passing 'opts' is recommended, but plugins generally say what they need in help.
    --
    -- See `:help gitsigns` to understand what the configuration keys do
    { -- NOTE: Adds git related signs to the gutter, as well as utilities for managing changes
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },

    -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
    --
    -- This is often very useful to both group configuration, as well as handle
    -- lazy loading plugins that don't need to be loaded immediately at startup.
    --
    -- For example, in the following configuration, we use:
    --  event = 'VimEnter'
    -- This loads which-key before all the UI elements are loaded. Events can be
    -- normal autocommands events (`:help autocmd-events`).
    --
    -- Then, because we use the `opts` key (recommended), the configuration runs
    -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

    { -- NOTE: Useful plugin to show you pending keybinds.
      'folke/which-key.nvim',
      event = 'VimEnter', -- Sets the loading event to 'VimEnter'
      opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.o.timeoutlen
        delay = 0,
        icons = {
          -- set icon mappings to true if you have a Nerd Font
          mappings = vim.g.have_nerd_font,
          -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
          -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
          keys = vim.g.have_nerd_font and {} or {
            Up = '<Up> ',
            Down = '<Down> ',
            Left = '<Left> ',
            Right = '<Right> ',
            C = '<C-…> ',
            M = '<M-…> ',
            D = '<D-…> ',
            S = '<S-…> ',
            CR = '<CR> ',
            Esc = '<Esc> ',
            ScrollWheelDown = '<ScrollWheelDown> ',
            ScrollWheelUp = '<ScrollWheelUp> ',
            NL = '<NL> ',
            BS = '<BS> ',
            Space = '<Space> ',
            Tab = '<Tab> ',
            F1 = '<F1>',
            F2 = '<F2>',
            F3 = '<F3>',
            F4 = '<F4>',
            F5 = '<F5>',
            F6 = '<F6>',
            F7 = '<F7>',
            F8 = '<F8>',
            F9 = '<F9>',
            F10 = '<F10>',
            F11 = '<F11>',
            F12 = '<F12>',
          },
        },

        -- Document existing key chains
        spec = {
          { '<leader>s', group = '[S]earch' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        },
      },
    },

    -- Plugins can specify dependencies.
    --
    -- The dependencies are proper plugin specifications as well - anything
    -- you do for a plugin at the top level, you can do for a dependency.
    --
    -- Use the `dependencies` key to specify the dependencies of a particular plugin

    { -- NOTE: Fuzzy Finder (files, lsp, etc)
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',

      dependencies = {
        'nvim-lua/plenary.nvim',
        { -- If encountering errors, see telescope-fzf-native README for installation instructions
          'nvim-telescope/telescope-fzf-native.nvim',

          -- `build` is used to run some command when the plugin is installed/updated.
          -- This is only run then, not every time Neovim starts up.
          build = 'make',

          -- `cond` is a condition used to determine whether this plugin should be
          -- installed and loaded.
          cond = function()
            return vim.fn.executable 'make' == 1
          end,
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },

        -- Useful for getting pretty icons, but requires a Nerd Font.
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },

      config = function()
        -- Telescope is a fuzzy finder that comes with a lot of different things that
        -- it can fuzzy find! It's more than just a "file finder", it can search
        -- many different aspects of Neovim, your workspace, LSP, and more!
        --
        -- The easiest way to use Telescope, is to start by doing something like:
        --  :Telescope help_tags
        --
        -- After running this command, a window will open up and you're able to
        -- type in the prompt window. You'll see a list of `help_tags` options and
        -- a corresponding preview of the help.
        --
        -- Two important keymaps to use while in Telescope are:
        --  - Insert mode: <c-/>
        --  - Normal mode: ?
        --
        -- This opens a window that shows you all of the keymaps for the current
        -- Telescope picker. This is really useful to discover what Telescope can
        -- do as well as how to actually do it!

        -- [[ Configure Telescope ]]
        -- See `:help telescope` and `:help telescope.setup()`
        require('telescope').setup {
          -- You can put your default mappings / updates / etc. in here
          --  All the info you're looking for is in `:help telescope.setup()`
          --
          defaults = {
            initial_mode = 'normal',
            --   mappings = {
            --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
            --   },
          },
          -- NOTE: Set custom keymapping in buffers picker
          pickers = {
            -- the Telescope picker is called "buffers".
            buffers = {
              -- keymappings of "buffers".
              mappings = {
                -- "n" is for "Normal" mode.
                n = {
                  -- "delete_buffer" is the builtin name in Telescope.
                  -- This changes the default <M-d> to <dd>.
                  ['dd'] = 'delete_buffer',
                },
              },
            },
            -- Set the 'grep' pickers to insert mode by default
            live_grep = { initial_mode = 'insert' },
            grep_string = { initial_mode = 'insert' },
            help_tags = { initial_mode = 'insert' },
            current_buffer_fuzzy_find = { initial_mode = 'insert' },
          },
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown(),
            },
          },
        }

        -- Enable Telescope extensions if they are installed
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')

        -- See `:help telescope.builtin`
        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch [T]elescope Pickers' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

        -- Slightly advanced example of overriding default behavior and theme
        vim.keymap.set('n', '<leader>/', function()
          -- You can pass additional configuration to Telescope to change the theme, layout, etc.
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
          })
        end, { desc = '[/] Fuzzily search in current buffer' })

        -- It's also possible to pass additional configuration options.
        --  See `:help telescope.builtin.live_grep()` for information about particular keys
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep {
            grep_open_files = true,
            prompt_title = 'Live Grep in Open Files',
          }
        end, { desc = '[S]earch [/] in Open Files' })

        -- Shortcut for searching your Neovim configuration files
        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })
      end,
    },

--NOTE:
--[[
=====================================================================
==================== LSP CONFIGURATION           ====================
=====================================================================
--]]

    -- NOTE: LSP Plugins
    {
      -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },

    { -- NOTE: Main LSP Configuration
      'neovim/nvim-lspconfig',

      dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        -- Mason must be loaded before its dependents so we need to set it up here.
        -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
        { 'mason-org/mason.nvim', opts = {} },
        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Useful status updates for LSP.
        { 'j-hui/fidget.nvim', opts = {} },

        -- Allows extra capabilities provided by blink.cmp
        -- According to blink's website, this isn't needed anymore
        'saghen/blink.cmp',
      },

      config = function()
        -- Brief aside: **What is LSP?**
        --
        -- LSP is an initialism you've probably heard, but might not understand what it is.
        --
        -- LSP stands for Language Server Protocol. It's a protocol that helps editors
        -- and language tooling communicate in a standardized fashion.
        --
        -- In general, you have a "server" which is some tool built to understand a particular
        -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
        -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
        -- processes that communicate with some "client" - in this case, Neovim!
        --
        -- LSP provides Neovim with features like:
        --  - Go to definition
        --  - Find references
        --  - Autocompletion
        --  - Symbol Search
        --  - and more!
        --
        -- Thus, Language Servers are external tools that must be installed separately from
        -- Neovim. This is where `mason` and related plugins come into play.
        --
        -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
        -- and elegantly composed help section, `:help lsp-vs-treesitter`

        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
          callback = function(event)
            -- NOTE: Remember that Lua is a real programming language, and as such it is possible
            -- to define small helper and utility functions so you don't have to repeat yourself.
            --
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            -- TODO: Many of these keymaps are now in Neovim by default. Review the Neovim docs
            -- and delete any duplicates.
            local map = function(keys, func, desc, mode)
              mode = mode or 'n'
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end

            -- Rename the variable under your cursor.
            --  Most Language Servers support renaming across files, etc.
            map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

            -- Execute a code action, usually your cursor needs to be on top of an error
            -- or a suggestion from your LSP for this to activate.
            map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

            -- Find references for the word under your cursor.
            map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

            -- Jump to the implementation of the word under your cursor.
            --  Useful when your language has ways of declaring types without an actual implementation.
            map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

            -- Jump to the definition of the word under your cursor.
            --  This is where a variable was first declared, or where a function is defined, etc.
            --  To jump back, press <C-t>.
            map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

            -- WARN: Below is not Goto Definition, this is Goto Declaration.
            --  For example, in C this would take you to the header.
            map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

            -- Fuzzy find all the symbols in your current document.
            --  Symbols are things like variables, functions, types, etc.
            map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

            -- Fuzzy find all the symbols in your current workspace.
            --  Similar to document symbols, except searches over your entire project.
            map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

            -- Jump to the type of the word under your cursor.
            --  Useful when you're not sure what type a variable is and you want to see
            --  the definition of its *type*, not where it was *defined*.
            map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

            -- The following two autocommands are used to highlight references of the
            -- word under your cursor when your cursor rests there for a little while.
            --    See `:help CursorHold` for information about when this is executed
            --
            -- When you move your cursor, the highlights will be cleared (the second autocommand).
            -- TODO: Review the Neovim docs to see if this functionality is default now.
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })

            -- The following code creates a keymap to toggle inlay hints in your
            -- code, if the language server you are using supports them
            --
            -- This may be unwanted, since they displace some of your code
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end,
        })

        -- NOTE:Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config {
          severity_sort = true,
          float = { border = 'rounded', source = 'if_many' },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = '󰅚 ',
              [vim.diagnostic.severity.WARN] = '󰀪 ',
              [vim.diagnostic.severity.INFO] = '󰋽 ',
              [vim.diagnostic.severity.HINT] = '󰌶 ',
            },
          } or {},
          virtual_text = {
            source = 'if_many',
            spacing = 2,
            format = function(diagnostic)
              local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
              }
              return diagnostic_message[diagnostic.severity]
            end,
          },
        }

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
        --
        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/

        -- NOTE: LSP Servers
        -- NOTE: They **must** be listed in this table to work, even if installed with Mason first.
        -- NOTE: Mason will install automatically if they're added here first.
        -- NOTE: Process: Add LSP server below, restart nvim to install, restart again (or LspRestart) to enable on files.
        local servers = {
          -- clangd = {},
          gopls = {},
          -- rust_analyzer = {},

          -- **CUSTOM**
          -- kickstart's suggested Python LSP. Created by MS and very well supported.
          -- now using this instead of pylsp (see ./init.used-last-12262025.lua for previous pylsp config).
          pyright = {},
          bashls = {},  -- Bash LSP
          --
          -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
          --
          -- Some languages (like typescript) have entire language plugins that can be useful:
          --    https://github.com/pmizio/typescript-tools.nvim
          --
          -- But for many setups, the LSP (`ts_ls`) will work just fine
          -- ts_ls = {},

          lua_ls = {
            -- cmd = { ... },
            -- filetypes = { ... },
            -- capabilities = {},
            settings = {
              Lua = {
                completion = {
                  callSnippet = 'Replace',
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
                --
                -- HACK:
                -- This is a temp fix for lua_ls "Undefined global 'vim'" and not working with lazydev correctly.
                -- See: https://github.com/folke/lazydev.nvim/issues/136
                -- Remove once lazydev and/or lua_ls is updated.
                workspace = { library = vim.api.nvim_get_runtime_file("", true) }
              },
            },
          },
        }

        -- To check the current status of installed tools and/or manually install
        -- other tools, you can run
        --    :Mason
        --
        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
          'stylua', -- Used to format Lua code
        })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }

        -- The loop below is for overriding the default configuration of LSPs with the ones in the servers table
        for server_name, config in pairs(servers) do

          -- These 2 lines for sure work and are correct. They configure, then enable the servers listed above.
          vim.lsp.config(server_name, config)
          vim.lsp.enable(server_name)
        end
      end,
    },

    -- { -- NOTE: Autoformater  --Commented out for now because I don't like autoformatters.
    --   'stevearc/conform.nvim',
    --   event = { 'BufWritePre' },
    --   cmd = { 'ConformInfo' },
    --   keys = {
    --     {
    --       '<leader>f',
    --       function()
    --         require('conform').format { async = true, lsp_format = 'fallback' }
    --       end,
    --       mode = '',
    --       desc = '[F]ormat buffer',
    --     },
    --   },
    --   opts = {
    --     notify_on_error = false,
    --     format_on_save = function(bufnr)
    --       -- Disable "format_on_save lsp_fallback" for languages that don't
    --       -- have a well standardized coding style. You can add additional
    --       -- languages here or re-enable it for the disabled ones.
    --       local disable_filetypes = { c = true, cpp = true }
    --       if disable_filetypes[vim.bo[bufnr].filetype] then
    --         return nil
    --       else
    --         return {
    --           timeout_ms = 500,
    --           lsp_format = 'fallback',
    --         }
    --       end
    --     end,
    --     formatters_by_ft = {
    --       lua = { 'stylua' },
    --       -- Conform can also run multiple formatters sequentially
    --       -- python = { "isort", "black" },
    --       --
    --       -- You can use 'stop_after_first' to run the first available formatter from the list
    --       -- javascript = { "prettierd", "prettier", stop_after_first = true },
    --     },
    --   },
    -- },

    { -- NOTE: Blink Autocompletion
      'saghen/blink.cmp',
      event = 'VimEnter',
      version = '1.*',
      dependencies = {
        -- Snippet Engine
        {
          'L3MON4D3/LuaSnip',
          version = '2.*',
          build = (function()
            -- Build Step is needed for regex support in snippets.
            -- This step is not supported in many windows environments.
            -- Remove the below condition to re-enable on windows.
            if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
              return
            end
            return 'make install_jsregexp'
          end)(),
          dependencies = {
            -- `friendly-snippets` contains a variety of premade snippets.
            --    See the README about individual language/framework/plugin snippets:
            --    https://github.com/rafamadriz/friendly-snippets
            -- {
            --   'rafamadriz/friendly-snippets',
            --   config = function()
            --     require('luasnip.loaders.from_vscode').lazy_load()
            --   end,
            -- },
          },
          opts = {},
        },

        'folke/lazydev.nvim',
      },
      --- @module 'blink.cmp'
      --- @type blink.cmp.Config
      opts = {
        keymap = {
          -- 'default' (recommended) for mappings similar to built-in completions
          --   <c-y> to accept ([y]es) the completion.
          --    This will auto-import if your LSP supports it.
          --    This will expand snippets if the LSP sent a snippet.
          -- 'super-tab' for tab to accept
          -- 'enter' for enter to accept
          -- 'none' for no mappings
          -- **CUSTOM** I changed this to `super-tab` because <c-y> to accept is insane!
          preset = 'super-tab',

          -- For an understanding of why the 'default' preset is recommended,
          -- you will need to read `:help ins-completion`
          --
          -- No, but seriously. Please read `:help ins-completion`, it is really good!
          --
          -- All presets have the following mappings:
          -- <tab>/<s-tab>: move to right/left of your snippet expansion
          -- <c-space>: Open menu or open docs if already open
          -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
          -- <c-e>: Hide menu
          -- <c-k>: Toggle signature help
          --
          -- See :h blink-cmp-config-keymap for defining your own keymap

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono',
        },

        completion = {
          -- By default, you may press `<c-space>` to show the documentation.
          -- Optionally, set `auto_show = true` to show the documentation after a delay.
          documentation = { auto_show = true, auto_show_delay_ms = 500 },
        },

        sources = {
          --NOTE: Add 'buffer' at the end of this list to include autocomplete for all words in active buffer.
          default = { 'lazydev', 'lsp', 'path', 'snippets', },
          -- Tried to get UCI autocomplete to work with blink, but failed miserably so far.
          -- default = { 'lazydev', 'lsp', 'path', 'snippets', 'openwrt_uci' },
          providers = {
            lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
          -- Tried to get UCI autocomplete to work with blink, but failed miserably so far.
            -- openwrt_uci = { name = "OpenWrt UCI", module = "openwrt.integrations.uci_terminal_blink" },
          },
        },

        snippets = { preset = 'luasnip' },

        -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
        -- which automatically downloads a prebuilt binary when enabled.
        --
        -- By default, we use the Lua implementation instead, but you may enable
        -- the rust implementation via `'prefer_rust_with_warning'`
        --
        -- See :h blink-cmp-config-fuzzy for more information
        fuzzy = { implementation = 'lua' },

        -- Shows a signature help window while you type arguments for a function
        signature = { enabled = true },
      },
      opts_extend = { 'sources.default' },
    },

--NOTE:
--[[
=====================================================================
==================== COLORSCHEMES                ====================
=====================================================================
--]]

    -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

    { 'Luxed/ayu-vim',
      priority = 1000, -- Make sure to load this before all the other start plugins.

      config = function()
        vim.g.ayu_sign_contrast = 0 -- default, but leaving in for reference
        vim.g.ayu_extended_palette = 1

        -- Load the colorscheme (uncomment line below to make this colorscheme the default)
        vim.cmd.colorscheme 'ayu'
      end,
    },

    --TODO: Am I ever going to use this colorscheme? If not, delete this block.
    { 'projekt0n/github-nvim-theme',
      name = 'github-theme',
      -- priority = 1000, -- Make sure to load this before all the other start plugins.
      config = function()
        -- Load the colorscheme (uncomment line below to make this colorscheme the default)
        -- vim.cmd.colorscheme 'github_dark_default'
      end,
    },

    { 'folke/tokyonight.nvim',
      -- priority = 1000, -- Make sure to load this before all the other start plugins.
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('tokyonight').setup {
          styles = {
            comments = { italic = false }, -- Disable italics in comments
          },
        }
        -- Load the colorscheme (uncomment line below to make this colorscheme the default)
        -- vim.cmd.colorscheme 'tokyonight-night'
      end,
    },

--NOTE:
--[[
=====================================================================
==================== TODO-COMMENTS & MINI.NVIM   ====================
=====================================================================
--]]

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    { -- Collection of various small independent plugins/modules
      'nvim-mini/mini.nvim',
      config = function()
        -- Better Around/Inside textobjects
        --
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup { n_lines = 500 }

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        --
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require('mini.surround').setup()

--NOTE:
--[[
=====================================================================
==================== STATUSLINE                  ====================
=====================================================================
--]]

        -- Simple and easy statusline.
        --  You could remove this setup call if you don't like it,
        --  and try some other statusline plugin
        --
        --NOTE: Uncomment starting below to re-enable mini.statusline
        --
        -- local statusline = require 'mini.statusline'
        -- -- set use_icons to true if you have a Nerd Font
        -- statusline.setup { use_icons = vim.g.have_nerd_font }
        --
        -- -- You can configure sections in the statusline by overriding their
        -- -- default behavior. For example, here we set the section for
        -- -- cursor location to LINE:COLUMN
        -- ---@diagnostic disable-next-line: duplicate-set-field
        -- statusline.section_location = function()
        --   return '%2l:%-2v'
        -- end

        -- ... and there is more!
        --  Check out: https://github.com/nvim-mini/mini.nvim
      end,  -- This is the end of the mini.nvim `config = function ()` block.
    },

    --NOTE: Comment this entire block out if using the default mini.statusline
    {
      'nvim-lualine/lualine.nvim',
      config = function()
        -- NOTE: Customize inactive statusline and ayu_dark theme

        -- The defaults are at `~/.local/share/nvim/lazy/lualine.nvim/lua/lualine/themes`
        local custom_ayu_dark = require 'lualine.themes.ayu_dark'

        -- Change inactive window statusline for better separation and darker blue.
        custom_ayu_dark.inactive.a.bg = '#283d52'
        custom_ayu_dark.inactive.a.fg = '#36a3d9'
        custom_ayu_dark.inactive.a.gui = 'bold'
        custom_ayu_dark.inactive.b.fg = '#36a3d9'
        custom_ayu_dark.inactive.c.bg = '#283d52'
        custom_ayu_dark.inactive.c.fg = '#36a3d9'

        -- Change normal mode statusline to blue
        custom_ayu_dark.normal.c.bg = '#2f93c4'
        custom_ayu_dark.normal.c.fg = '#14191f'
        custom_ayu_dark.normal.b.fg = '#36a3d9'

        -- TODO: Someday, update colors of other modes for more consistency. See default theme file above.

        require('lualine').setup {

          -- NOTE: Change this when changing themes!
          -- Use ayu_dark with above customizations.
          options = { theme = custom_ayu_dark },

          -- Custom statusline for active sessions.
          sections = {
            lualine_a = { 'mode' },
            -- if no git branch info, insert placeholder text to keep statusline pretty.
            lualine_b = {
              {
                'branch',
                fmt = function(str)
                  if str == '' or str == nil then
                    return 'no git repo'
                  end
                  return str
                end,
              },
              'diff',
              'diagnostics',
            },
            lualine_c = { 'filename' },
            -- show buffer numbers, not names
            lualine_x = { { 'buffers', mode = 3 } },
            lualine_y = { 'fileformat', 'filetype', 'progress' },
            lualine_z = { 'location' },
          },

          -- Custom statusline for inactive sessions.
          -- Same as active, except bg colors.
          inactive_sections = {
            lualine_a = { 'mode' },
            -- if no git branch info, insert placeholder text to keep statusline pretty.
            lualine_b = {
              {
                'branch',
                fmt = function(str)
                  if str == '' or str == nil then
                    return 'no git repo'
                  end
                  return str
                end,
              },
              'diff',
              'diagnostics',
            },
            lualine_c = { 'filename' },
            -- show buffer numbers, not names
            lualine_x = { { 'buffers', mode = 3 } },
            lualine_y = { 'fileformat', 'filetype', 'progress' },
            lualine_z = { 'location' },
          },
        }
      end,
    },

--NOTE:
--[[
=====================================================================
==================== TREESITTER                  ====================
=====================================================================
--]]
    -- FIX: This nvim-treesitter config works. Commenting out to move to 'treesitter-modules.nvim'.
    -- Delete this if treesitter and completions work with no regressions.
    --
    -- { 'nvim-treesitter/nvim-treesitter',  -- Highlight, edit, and navigate code
    --   --FIX: Temporary workaround until I update this plugin. It now defaults to the "main" branch, which is very different!
    --   --It may be time to get rid of this plugin because the main dev is an asshole.
    --   --To fix 'nvim-treesitter' on the 'main' branch, use this: https://github.com/nvim-lua/kickstart.nvim/pull/1657
    --   --Perhaps better, a new plugin was created to sanely bridge the gap and recommended by Vhyrro on YT:
    --   --https://github.com/MeanderingProgrammer/treesitter-modules.nvim
    --   branch = "master",
    --   build = ':TSUpdate',
    --   main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    --   -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    --   opts = {
    --     ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    --     -- Autoinstall languages that are not installed
    --     auto_install = true,
    --     highlight = {
    --       enable = true,
    --       -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
    --       --  If you are experiencing weird indenting issues, add the language to
    --       --  the list of additional_vim_regex_highlighting and disabled languages for indent.
    --       additional_vim_regex_highlighting = { 'ruby' },
    --     },
    --     indent = { enable = true, disable = { 'ruby' } },
    --   },
    -- },
    {
    'MeanderingProgrammer/treesitter-modules.nvim',
    -- This plugin was created to sanely bridge the gap between 'nvim-treesitter' versions and recommended by Vhyrro on YT:
    -- See: https://github.com/MeanderingProgrammer/treesitter-modules.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ---@module 'treesitter-modules'
    ---@type ts.mod.UserConfig
      opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true },
      },
    },

--NOTE:
--[[
=====================================================================
==================== ADDITIONAL/CUSTOM PLUGINS   ====================
=====================================================================
--]]

    -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart

    'ThePrimeagen/vim-be-good', -- NOTE: vim game

    --  Here are some example plugins that I've included in the Kickstart repository.
    --  Uncomment any of the lines below to enable them (you will need to restart nvim).
    --
    -- require 'kickstart.plugins.debug',
    require 'kickstart.plugins.indent_line',  -- Vertical lines to denote indents.
    -- require 'kickstart.plugins.lint',
    -- require 'kickstart.plugins.autopairs',
    require 'kickstart.plugins.neo-tree',  -- File explorer
    -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

    -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
    --
    -- NOTE:  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
    --
    -- { import = 'custom.plugins' },
    --
    -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
    -- Or use telescope!
    -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
    -- you can continue same window with `<space>sr` which resumes last telescope search
  },

--NOTE:
--[[
=====================================================================
==================== UI STUFF - ICONS            ====================
=====================================================================
--]]

  {
    ui = {
      -- If you are using a Nerd Font: set icons to an empty table which will use the
      -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
      icons = vim.g.have_nerd_font and {} or {
        cmd = '⌘',
        config = '🛠',
        event = '📅',
        ft = '📂',
        init = '⚙',
        keys = '🗝',
        plugin = '🔌',
        runtime = '💻',
        require = '🌙',
        source = '📄',
        start = '🚀',
        task = '📌',
        lazy = '💤 ',
      },
    },
  }
)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
