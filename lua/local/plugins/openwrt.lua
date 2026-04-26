--[[
NOTE:
=====================================================================
==================== Custom OpenWRT Plugin       ====================
=====================================================================
--]]

if not vim.uv.fs_stat '/home/eric/dev/openWRT' then
  return {}
end

return {
  {
    dir = '/home/eric/dev/openWRT',
    name = 'openwrt.nvim',
    config = function()
      require('openwrt').setup {
        ssh_host = '192.168.31.1',
      }
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'nosduco/remote-sshfs.nvim',
        dependencies = {
          'nvim-telescope/telescope.nvim',
          'nvim-lua/plenary.nvim',
        },
        opts = {},
      },
    },
  },
}
