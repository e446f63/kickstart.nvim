-- Auto-sync clean-init.lua to Windows Neovim
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*/clean-init.lua', -- Matches whenever this specific file is saved
  callback = function(opts)
    -- Define the Windows AppData directory from WSL
    local windows_nvim_dir = '/mnt/c/Users/EGravett/AppData/Local/nvim/'
    local target_file = windows_nvim_dir .. 'init.lua'

    -- Check if the directory exists (this ensures it only runs in WSL, not your Linux machine)
    if vim.fn.isdirectory(windows_nvim_dir) == 1 then

      -- opts.match contains the full path of the file that was just saved
      local success, err = vim.uv.fs_copyfile(opts.match, target_file)

      if success then
        vim.notify('Synced clean-init to Windows Neovim!', vim.log.levels.INFO)
      else
        vim.notify("Failed to sync clean-init to Windows: " .. tostring(err), vim.log.levels.ERROR)
      end
    end
  end,
  desc = 'Copy clean-init.lua to Windows AppData on save',
})
