--[[
NOTE:
=====================================================================
==================== DNF KEYMAPS                 ====================
=====================================================================
--]]
-- Keymaps for using DNF within Neovim terminal

return {
  -- Get the DNF advisory info (changelogs) for highlighted text in Visual mode
  vim.keymap.set('x', '<leader>da', function()
    vim.cmd [[normal! "zy]]
    local pkg = vim.trim(vim.fn.getreg 'z')
    local out = vim.fn.systemlist('dnf advisory info --contains-pkgs=' .. vim.fn.shellescape(pkg))

    vim.cmd 'new'
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.bo.swapfile = false
    vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
  end, { silent = true, desc = 'advisories for selected package' }),

  -- Get the DNF info for highlighted text in Visual mode
  vim.keymap.set('x', '<leader>di', function()
    vim.cmd [[normal! "zy]]
    local pkg = vim.trim(vim.fn.getreg 'z')
    local out = vim.fn.systemlist('dnf info ' .. vim.fn.shellescape(pkg))

    vim.cmd 'new'
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'wipe'
    vim.bo.swapfile = false
    vim.api.nvim_buf_set_lines(0, 0, -1, false, out)
  end, { silent = true, desc = 'info for selected package' }),
}
