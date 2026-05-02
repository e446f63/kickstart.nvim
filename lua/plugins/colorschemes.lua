--[[
NOTE:
=====================================================================
==================== COLORSCHEMES                ====================
=====================================================================
--]]
-- The active default colorscheme (`vim.g.active_colorscheme`) is set in `init.lua`.

return {
  {
    'folke/tokyonight.nvim',
    -- Load before all other start plugins, if colorscheme is set as default.
    priority = vim.g.active_colorscheme == 'tokyonight-night' and 1000 or 0,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here, if colorscheme is set as default.
      if vim.g.active_colorscheme == 'tokyonight-night' then
        vim.cmd.colorscheme 'tokyonight-night'
      end
    end,
  },

  {
    'Luxed/ayu-vim',
    -- Load before all other start plugins, if colorscheme is set as default.
    priority = vim.g.active_colorscheme == 'ayu' and 1000 or 0,

    config = function()
      vim.g.ayu_sign_contrast = 0 -- default, but leaving in for reference
      vim.g.ayu_extended_palette = 1

      -- Load the colorscheme, if colorscheme is set as default.
      if vim.g.active_colorscheme == 'ayu' then
        vim.cmd.colorscheme 'ayu'
      end
    end,
  },
}
