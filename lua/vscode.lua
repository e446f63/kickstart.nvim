--[[
NOTE:
=====================================================================
==================== VS Code Specific Config     ====================
=====================================================================
--]]
-- Only load plugins that can work when running inside VS Code

local mini_path = vim.fn.stdpath 'data' .. '/lazy/mini.nvim'

if vim.uv.fs_stat(mini_path) then
  vim.opt.rtp:prepend(mini_path)

  require('mini.ai').setup()
  require('mini.surround').setup()
end

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank-vscode', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

return {}
