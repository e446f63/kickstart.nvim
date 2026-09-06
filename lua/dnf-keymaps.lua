--[[
NOTE:
=====================================================================
==================== DNF KEYMAPS                 ====================
=====================================================================
--]]
-- Keymaps for getting DNF package info and correct changlogs within Neovim terminal
-- No `return {}` needed since this code simply executes to register the keymaps

local dnf_buf

-- Create scratch buffer
local function preview(lines)
  -- If scratch buffer doesn't exist or has been wiped, create (or recreate) it.
  if not dnf_buf or not vim.api.nvim_buf_is_valid(dnf_buf) then
    dnf_buf = vim.api.nvim_create_buf(false, true)
    -- Wipe the buffer automatically when no longer displayed
    vim.bo[dnf_buf].bufhidden = 'wipe'
  end

  -- Set the buffer's text to be the passed-in DNF output
  -- Reuses buffer if it already exists from previous DNF output
  vim.api.nvim_buf_set_lines(dnf_buf, 0, -1, false, lines)
  -- Open a 'preview' window to display the buffer
  vim.cmd('pbuffer ' .. dnf_buf)
end

-- Get the DNF advisory info (changelogs) for highlighted text in Visual mode
vim.keymap.set('x', '<leader>da', function()
  vim.cmd [[normal! "zy]] -- yank highlighted text to 'z' register
  local pkg = vim.trim(vim.fn.getreg 'z')
  local out = vim.fn.systemlist('dnf advisory info --contains-pkgs=' .. vim.fn.shellescape(pkg))

  preview(out)
end, { silent = true, desc = 'advisories for selected package' })

-- Get the DNF info for highlighted text in Visual mode
vim.keymap.set('x', '<leader>di', function()
  vim.cmd [[normal! "zy]]
  local pkg = vim.trim(vim.fn.getreg 'z')
  local out = vim.fn.systemlist('dnf info ' .. vim.fn.shellescape(pkg))

  preview(out)
end, { silent = true, desc = 'info for selected package' })
