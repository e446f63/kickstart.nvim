--[[
NOTE:
=====================================================================
==================== COLORSCHEMES                ====================
=====================================================================
--]]

return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    -- Load before all other start plugins.
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

    { 'Luxed/ayu-vim',
      -- Load before all other start plugins.
      -- priority = 1000,

      config = function()
        vim.g.ayu_sign_contrast = 0 -- default, but leaving in for reference
        vim.g.ayu_extended_palette = 1

        -- Load default colorscheme.
        -- vim.cmd.colorscheme 'ayu'
      end,
    },

}
