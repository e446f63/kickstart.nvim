--[[
NOTE:
=====================================================================
==================== lualine                     ====================
=====================================================================
--]]

return {

  --NOTE: lualine
  {
    'nvim-lualine/lualine.nvim',
    cond = function()
      --Set this variable in 'init.lua'
      return vim.g.active_statusline == 'lualine'
    end,
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
          lualine_c = { { 'filename', path = 4 } },
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

}
