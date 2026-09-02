-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,

  keys = {
    { '\\', ':Neotree toggle reveal<CR>', desc = 'NeoTree reveal', silent = true },
    -- My custom keymap for the hell of it
    -- 'show' opens the window but does not move focus to it.
    { '<leader>tn', ':Neotree toggle show<CR>', desc = 'Neo-tree' },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      filtered_items = {
        visible = true,
        -- hide_dotfiles = true,
        -- hide_hidden = true,
      },
      -- Not needed because key is mapped to 'toggle'
      -- If key is mapped to 'focus' or 'show', this keymap is used to close window.
      -- window = {
      --   mappings = {
      --     -- ['\\'] = 'close_window',
      --   },
      -- },
    },
  },
}
