---@module 'lazy'
---@type LazySpec
return {
  'stevearc/conform.nvim',

  cmd = { 'ConformInfo' },

  keys = {
    { '<leader>f',
      function()
        require('conform').format {
          async = true,
          lsp_format = 'never',
        }
      end,
      desc = 'format buffer',
    },
  },

  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
    },
  },
}
