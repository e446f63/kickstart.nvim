# kickstart/plugins
In the original kickstart.nvim file, you installed the plugins in this directory by requiring them:
```lua
require 'kickstart.plugins.debug'
```

When I modularized my Neovim configuration, I changed how this works.

## Enabling kickstart plugins
Now, to install the plugins in this folder, simply move them to `lua/plugins/`.
Lazy will automatically install them.
See this line in init.lua:
```lua
  { import = 'plugins' },
```

## Original kickstart plugins
This is the orignal list of plugins in this directory.
The ones I've installed have been moved to `lua/plugins/`

    autopairs.lua
    debug.lua
    gitsigns.lua
    indent_line.lua
    lint.lua
    neo-tree.lua

