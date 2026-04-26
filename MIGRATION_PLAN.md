# Neovim 0.12 Migration Plan

## Scope

This plan is the working guide for migrating the current Neovim config from the local `master` branch to a Neovim `0.12.x`-ready configuration based on the refreshed upstream kickstart branch.

The plan assumes:

- day-to-day config stays in `~/.config/nvim` on `master` until the new config is stable
- migration work happens first in `~/.config/nvim-12` on `kickstart-refresh`
- upstream kickstart is the reference for modernized sections such as LSP and Treesitter
- general modular code should live under `lua/plugins/*` and `lua/config/*`
- `lua/local/*` should be reserved for truly local or machine-specific integrations such as the local OpenWRT plugin
- the local OpenWRT plugin should be optional and skipped silently when it does not exist on the machine

## Goals

1. Keep the current `master` config usable while building the replacement config separately.
2. Preserve important personal workflow choices from `master`.
3. Reduce the size and fragility of `init.lua` by moving larger, self-contained sections into modules.
4. Make machine-specific integrations optional, especially the local OpenWRT plugin.
5. End with a config that is easier to maintain than the current fork.

## Non-Goals

- Do not blindly merge the old `init.lua` into the refreshed config.
- Do not preserve old compatibility shims when upstream/core Neovim now provides a cleaner path.
- Do not make the OpenWRT integration mandatory on machines that do not have the local plugin checked out.

## High-Level Strategy

Use the refreshed kickstart branch as the base, then reapply customizations in layers.

Port order:

1. Core options and simple keymaps
2. Theme and statusline
3. Navigation and UI plugins
4. LSP customizations
5. Blink customizations
6. Sidekick and required Copilot integration
7. OpenWRT optional integration
8. Optional extras like lint, autopairs, DAP, and extra gitsigns mappings

## Target Structure

Keep `init.lua` as the entrypoint, but move larger sections into modules.

Planned structure:

- `init.lua`
  - keeps bootstrapping, basic options/keymaps, and `lazy.nvim` setup
  - imports normal plugin/config modules
- `lua/plugins/*.lua`
  - plugin specs for self-contained areas
  - examples: `colorschemes.lua`, `lsp.lua`, `completion.lua`, `sidekick.lua`, `treesitter.lua`, `navigation.lua`
- `lua/config/*.lua`
  - helper logic that is not itself a plugin spec
  - examples: shared keymap helpers, environment checks, local path detection helpers if needed
- `lua/local/plugins/*.lua`
  - machine-specific or truly custom plugin specs
  - examples: `openwrt.lua`
- `lua/local/config/*.lua`
  - helper logic used only by custom integrations
  - examples: OpenWRT path helpers or custom provider wiring

Rule of thumb:

- if the code is primarily a general Lazy plugin spec, it belongs in `lua/plugins`
- if the code is general reusable helper logic, it belongs in `lua/config`
- if the code is machine-specific or tied to a personal local plugin, it belongs in `lua/local/plugins` or `lua/local/config`

## Phase Plan

### Phase 0: Baseline and Safety

- Keep `~/.config/nvim` on `master` as the known-good config.
- Keep `~/.config/nvim-12` on `kickstart-refresh` as the migration workspace.
- Launch the migration config with `NVIM_APPNAME=nvim-12 nvim`.
- Before each major migration slice:
  - commit the current `nvim-12` state
  - verify startup and basic editing still work

Exit criteria:

- `nvim-12` starts cleanly enough to continue
- plugin installation and `:checkhealth` are not blocked by basic config errors

### Phase 1: Enable Modular Layout

- Turn on the `plugins` import in the refreshed config.
- Add the first custom plugin module file.
- Keep behavior unchanged at first; this phase is about structure, not feature changes.

Initial target:

- move one low-risk area first to prove the pattern
- recommended first module: theme/statusline or navigation/UI

Exit criteria:

- `init.lua` imports custom modules successfully
- at least one general module is loaded from `lua/plugins`

Status:

- Completed on `kickstart-refresh` in `~/.config/nvim-12`
- Commit: `9dc7674` (`Enable modular plugin imports`)

Notes:

- `init.lua` now imports `{ import = 'plugins' }`
- placeholder module exists at `lua/plugins/init.lua`
- startup remained clean enough to continue
- machine-specific modules will use `lua/local/*`, not `lua/custom/*`

### Phase 2: Port Core Preferences

Port from current `master`:

- `winborder`
- `relativenumber`
- spell toggle
- wrap toggle
- any other pure option/keymap changes that do not depend on plugin internals

Guideline:

- copy simple behavior
- do not copy large old surrounding comment blocks or stale compatibility notes

Exit criteria:

- `nvim-12` feels closer to the current editing experience without destabilizing startup

### Phase 3: Port Theme and UI

Port and modularize:

- Ayu colorscheme preference
- lualine customization
- indentation guides
- neo-tree
- render-markdown

Suggested modules:

- `lua/plugins/colorschemes.lua`
- `lua/plugins/navigation.lua`
- `lua/plugins/markdown.lua`

Status:

- In progress
- First low-risk module extraction completed on `kickstart-refresh`
- Commit: `5e59086` (`Move theme config into plugins module`)
- UI module split continued with statusline modularization
- Commit: `f17aed3` (`Move lualine and mini.nvim to dedicated modules`)
- Markdown rendering extraction completed
- Commit: `60ed337` (`Migrate render-markdown.nvim into its own module`)

Notes:

- `tokyonight` was moved out of `init.lua` into `lua/plugins/colorschemes.lua`
- behavior was intentionally kept the same for this step
- this confirmed the new module import path works for a real plugin spec
- `ayu-vim` was then added as an available option while keeping `tokyonight` active
- `github-theme` was intentionally not ported at this stage
- current commit for the colorscheme decision: `d85a835` (`Add ayu option to colorschemes module`)
- `mini.nvim` now lives in `lua/plugins/mini.lua`
- `lualine` now lives in `lua/plugins/lualine.lua`
- `render-markdown.nvim` now lives in `lua/plugins/render-markdown.lua`
- statusline selection is controlled in `init.lua` via `vim.g.active_statusline = 'lualine'`
- `lualine` is gated with Lazy `enabled = function() ... end`
- `mini.statusline` is only configured when `vim.g.active_statusline == 'mini.statusline'`
- startup and UI verification passed after the split
- `render-markdown` was ported after Treesitter was modularized and verified cleanly

Exit criteria:

- color/theme and main UI preferences match the current setup closely
- no startup regressions from visual/plugin changes

### Phase 4: Port LSP Customizations

Use the refreshed upstream LSP block as the base.

Reapply from `master`:

- `gopls`
- `pyright`
- `bashls`
- `copilot = {}`
- preferred diagnostic presentation if still desired

Do not revert to the old structure just because it is familiar.

Keep from refreshed upstream:

- capability checks around document highlighting
- capability checks around inlay hints
- updated `lua_ls` handling

Suggested module:

- `lua/plugins/lsp.lua`

Status:

- Baseline complete
- Structural extraction completed on `kickstart-refresh`
- Commit: `f13ddae` (`Modularize LSP config`)
- Server merge from `master` completed
- Commit: `c580f35` (`Migrated LSP servers (including copilot) from master/init.lua`)

Notes:

- plugin/dependency wrapper now lives in `lua/plugins/lsp.lua`
- LSP orchestration now lives in `lua/lsp/config.lua`
- refreshed `nvim-12` LSP behavior was preserved for the extraction step
- this creates a clean place to merge `master` server and diagnostics preferences next
- `gopls`, `pyright`, `bashls`, and `copilot` were added to the `servers` table
- `copilot` telemetry was set to `telemetryLevel = "none"`
- `stylua` was removed from the `servers` table
- `stylua` is now a string entry in `ensure_installed`
- decision: keep refreshed upstream diagnostics for now instead of porting the inherited older diagnostic styling from `master`
- result: startup, Mason, and language-server startup all verified after the merge

Exit criteria:

- desired servers attach cleanly
- Mason installation flow still works
- diagnostics and inlay hints behave as expected

### Phase 5: Port Blink Customizations

Use the refreshed upstream Blink block as the base.

Reapply only the customizations that are still wanted:

- `super-tab` preset if still preferred
- documentation auto-show behavior
- OpenWRT completion provider hooks if still needed

Suggested module:

- `lua/plugins/blink.lua`

Status:

- In progress
- Minimal general Blink preferences migrated on `kickstart-refresh`
- Commit: `1976047` (`Migrate baseline blink.cmp settings & fix 'stylua' syntax`)
- Structural extraction into its own module completed
- Commit: `4b65570` (`Move nvim-treesitter and blink to thier own modules`)

Notes:

- kept the refreshed upstream Blink base
- ported only the general preferences:
  - `preset = 'super-tab'`
  - `documentation = { auto_show = true }`
- Blink now lives in `lua/plugins/blink.lua`
- intentionally did not port:
  - Sidekick Blink `<Tab>` integration
  - OpenWRT-specific trigger settings
  - OpenWRT-specific providers/source entries
  - `lazydev` restoration
- observed issue: completion is functionally working but very slow, including delayed suggestions after typing `vim.`
- decision: defer Blink performance troubleshooting until after the broader migration is stable

Exit criteria:

- completion behavior matches expectations
- no regressions in snippet navigation or normal completion flow

### Phase 6: Port Sidekick

Treat Sidekick as a single migration unit because it depends on multiple pieces working together.

Port:

- which-key `[A]gents` group
- `folke/sidekick.nvim` plugin spec
- Blink `<Tab>` integration for edit suggestions
- required `copilot` LSP entry if not already carried over in Phase 4

Suggested module:

- `lua/plugins/sidekick.lua`

Status:

- In progress
- Safe Sidekick baseline migrated on `kickstart-refresh`
- Commit: `c486bc1` (`Migrate Sidekick plugin without Tab or Blink integration`)

Notes:

- `folke/sidekick.nvim` plugin wiring and non-Tab keymaps were restored
- which-key group for `<leader>a` was restored
- the plain `<Tab>` Sidekick key entry remains commented out
- Blink/Sidekick `<Tab>` integration remains intentionally disabled
- result: Sidekick commands are available again without reintroducing broken insert-mode tab behavior
- decision: keep all Sidekick Tab-path behavior deferred until after the Neovim `0.12.x` upgrade is complete and the migrated config is otherwise stable

Exit criteria:

- Sidekick commands and keymaps work
- Blink `<Tab>` flow still behaves correctly
- Copilot requirement is satisfied

### Phase 7: Move OpenWRT Integration Out of init.lua

Remove the inline local plugin block from `init.lua`.

Replace it with an optional module that:

- checks whether the local plugin path exists
- returns an empty plugin list when absent
- adds the local plugin spec only when present
- applies any OpenWRT-specific Blink customizations only when the local plugin exists

Target behavior:

- machines with `/home/eric/dev/openWRT` get the integration
- machines without it start normally and do not error

Suggested files:

- `lua/local/plugins/openwrt.lua`

Detailed migration shape:

1. Keep local plugin loading visible in `init.lua`.
   - Do not hide machine-specific loading behind a helper module.
   - Add a small explicit check in `init.lua` near the plugin import area to conditionally import local plugin specs only when the directory exists.
   - Recommended shape:
     - check for `vim.fn.stdpath('config') .. '/lua/local/plugins'`
     - if it exists, add `{ import = 'local.plugins' }`

2. Treat `lua/local/plugins/*` and `lua/local/config/*` differently.
   - `lua/local/plugins/*` is for Lazy plugin specs and should be discovered by the conditional `import = 'local.plugins'`.
   - `lua/local/config/*` is for ordinary Lua helpers and must be loaded with explicit `require(...)` calls from the relevant local plugin modules.
   - Status:
     - conditional local plugin import enabled in `nvim-12/init.lua`
     - placeholder root module added at `lua/local/plugins/init.lua`
   - Result:
     - `local.plugins` can now be imported safely even before any machine-specific plugin specs are added

3. Move the local OpenWRT plugin spec into `lua/local/plugins/openwrt.lua`.
   - If the local OpenWRT path does not exist, return `{}` immediately and do nothing else.
   - If it is true, return the local plugin spec using:
     - `dir = '/home/eric/dev/openWRT'`
     - `name = 'openwrt.nvim'`
   - Keep the existing `openwrt.setup({...})` router settings there.
   - Keep the `remote-sshfs.nvim` dependency there as part of the OpenWRT integration, not as a general plugin.
   - Status:
     - completed on `kickstart-refresh`
     - Commit: `a049207` (`Migrate Custom OpenWRT Plugin`)
   - Result:
     - the local OpenWRT plugin now loads from `lua/local/plugins/openwrt.lua`
     - `remote-sshfs.nvim` moved with it as an OpenWRT-only dependency
     - the path guard is working and startup remains clean

4. Add a second local Blink augmentation spec in the same file.
   - Return an additional spec for `'saghen/blink.cmp'`.
   - Use `opts = function(_, opts) ... end` to mutate the existing Blink config only when the local OpenWRT path exists.
   - This avoids polluting `lua/plugins/blink.lua` with machine-specific logic.
   - Status:
     - completed on `kickstart-refresh`
     - Commit: `8eed046` (`Migrated OpenWRT custom Blink config to local openwrt.lua plugin`)
   - Result:
     - OpenWRT-specific Blink trigger behavior now lives in the local OpenWRT module
     - the `openwrt` Blink provider is appended without replacing the general source list
     - the general Blink module remains machine-agnostic

5. Apply the OpenWRT-specific Blink trigger behavior only in that local augmentation.
   - Port these settings from `master`:
     - `completion.trigger.show_on_trigger_character = true`
     - `completion.trigger.show_on_accept_on_trigger_character = true`
     - `completion.trigger.show_on_blocked_trigger_characters = function() ... end`
   - Preserve the current special case for `openwrt-uci-terminal` so space is not blocked there.

6. Apply the OpenWRT-specific Blink source/provider wiring only in that local augmentation.
   - Append `'openwrt'` to `opts.sources.default`.
   - Add `opts.sources.providers.openwrt = { ... }` pointing at `openwrt.integrations.uci_terminal_blink`.
   - Do not reintroduce `lazydev` while doing this.
   - Keep the provider registration conditional on the local plugin existing.

7. Keep the OpenWRT integration silent on machines that do not have the plugin.
   - No warnings.
   - No notification spam.
   - No dummy providers registered.
   - No changes to general Blink behavior when the local plugin is absent.

8. Verify in two modes.
   - On the machine that has `/home/eric/dev/openWRT`:
     - startup is clean
     - `:Lazy` shows `openwrt.nvim` and `remote-sshfs.nvim`
     - OpenWRT commands/load path work
     - Blink still works in normal files
     - Blink behavior changes only where the OpenWRT filetypes/workflow need it
   - On a machine without the local plugin:
     - startup is identical to the general `nvim-12` config
     - no OpenWRT plugin entries are loaded
     - Blink behavior remains unchanged

Recommended behavior:

- skip silently by default
- do not load OpenWRT-specific Blink providers or source extensions unless the OpenWRT plugin exists

Status:

- Completed on `kickstart-refresh`
- Commits:
  - `a049207` (`Migrate Custom OpenWRT Plugin`)
  - `8eed046` (`Migrated OpenWRT custom Blink config to local openwrt.lua plugin`)

Notes:

- local plugin loading is now visible in `init.lua` via the `local.plugins` import
- `lua/local/plugins/init.lua` bootstraps that namespace safely
- `lua/local/plugins/openwrt.lua` now owns:
  - the local OpenWRT plugin spec
  - the `remote-sshfs.nvim` dependency
  - the OpenWRT-specific Blink augmentation
- result: the OpenWRT integration is no longer hardcoded into the main plugin list and remains silent when absent

Exit criteria:

- OpenWRT integration is no longer hardcoded into the main plugin list
- non-OpenWRT machines require no manual edits

### Phase 8: Port Optional Extras

Port only after the main config is stable:

- lint
- autopairs
- DAP/debug
- extra gitsigns mappings

These should become separate modules where it helps readability.

Suggested modules:

- `lua/plugins/lint.lua`
- `lua/plugins/editing.lua`
- `lua/plugins/debug.lua`
- `lua/plugins/git.lua`

Exit criteria:

- optional extras work without obscuring the core migration

Current progress note:

- additional low-risk general plugins migrated on `kickstart-refresh`
- Commit: `c85edf3` (`Migrate indent_line and neo-tree plugins`)
- `neo-tree` and `indent_line` now live under `lua/plugins/*`
- Telescope extraction completed on `kickstart-refresh`
- Commit: `f82a1b0` (`Move telescope into 'lua/plugins/telescope.lua' module`)
- Telescope-backed LSP picker mappings remain intentionally attached from the Telescope module
- OpenWRT migration is now complete

## Treesitter Direction

Do not copy the old `treesitter-modules.nvim` setup forward.

Plan:

- keep the refreshed kickstart Treesitter direction as the baseline
- keep that logic in a dedicated module and simplify later only if needed

Status:

- Structural extraction completed on `kickstart-refresh`
- Commit: `4b65570` (`Move nvim-treesitter and blink to thier own modules`)

Notes:

- refreshed Treesitter logic was moved out of `init.lua`
- Treesitter now lives in `lua/plugins/nvim-treesitter.lua`
- behavior was intentionally kept the same during the move
- this clears the path for `render-markdown` to be ported as the next dependent slice

Constraint:

- prioritize correct `0.12.x` behavior first
- prioritize elegance second

## Neovim 0.12 Alignment Follow-Ups

The current `nvim-12` config is broadly on the right architecture for Neovim `0.12.x`:

- LSP uses `vim.lsp.config()` / `vim.lsp.enable()`
- Treesitter follows the refreshed core-oriented setup instead of the old `treesitter-modules.nvim` pattern
- plugin management remains on `lazy.nvim`, which is still a valid choice even though `vim.pack` now exists in core

Recommended follow-ups after the main migration is stable:

1. Replace the deprecated diagnostics jump option.
   - Completed on `kickstart-refresh`.
   - Commit: `286725f` (`Fix deprecated diagnostic jump (\`]d\`) in \`lua/lsp/config.lua\``)
   - The config now uses `jump.on_jump` instead of the deprecated `jump.float`.
   - This was the main 0.12-specific pre-upgrade compatibility fix worth doing immediately.

2. Remove the remaining `vim.loop` fallbacks.
   - Current config still uses `vim.uv or vim.loop` in the lazy bootstrap and health check.
   - `vim.loop` is deprecated; Neovim `0.12` should use `vim.uv` directly.
   - Recommendation: update both the bootstrap path check and `lua/kickstart/health.lua` to use `vim.uv` only.

3. Get ahead of the `buffer` -> `buf` rename.
   - Current config still uses `{ buffer = ... }` in several keymap/autocmd option tables.
   - This is deprecated in newer Neovim and should be updated proactively.
   - Recommendation: change remaining `buffer =` usages to `buf =` in local code such as `lua/lsp/config.lua` and `lua/plugins/telescope.lua`.

4. Update the local health check baseline to `0.12`.
   - The bundled `kickstart` health check still treats `0.11` as the minimum and still reports system info using the old fallback pattern.
   - Recommendation: change the minimum version messaging to `0.12` and modernize that file to use `vim.uv`.

5. Make an explicit decision about Neovim `0.12` LSP defaults.
   - Neovim now creates built-in global LSP mappings for `gra`, `gri`, `grn`, `grr`, `grt`, `gO`, insert-mode `CTRL-S`, and visual/operator-pending `an` / `in`, and it also enables document colors by default.
   - The current config mostly coexists with those defaults, but some mappings are intentionally overridden by Telescope and others are duplicated explicitly in `LspAttach`.
   - Recommendation: after the migration is functionally complete, decide whether to:
     - lean into the Neovim defaults and remove redundant explicit mappings, or
     - keep the explicit mappings and Telescope overrides as the deliberate house style.
   - No immediate change is required, but this should be a conscious choice rather than an accident.

Current recommendation:

- safe to proceed with the Neovim `0.12.x` upgrade once the user is ready
- remaining items in this section are cleanups or design decisions, not known upgrade blockers

## Verification Checklist

Run after each major phase:

- startup with `NVIM_APPNAME=nvim-12 nvim`
- `:checkhealth`
- `:Lazy`
- open Lua, Go, Bash, Python, Markdown files as relevant
- verify:
  - LSP attaches
  - completion works
  - Treesitter highlighting works
  - Sidekick works once ported
  - OpenWRT path absence does not break startup

## Git Workflow

Working model:

- `~/.config/nvim` on `master` remains the stable current config
- `~/.config/nvim-12` on `kickstart-refresh` is the migration branch

Recommended habit:

1. make one migration slice
2. launch and test `nvim-12`
3. commit that slice
4. continue to the next slice

Do not wait until the entire migration is finished to create checkpoints.

## Open Questions

These do not block the plan, but should be decided as we go:

1. Should Treesitter remain in one dedicated module, or should parser/bootstrap helpers be split out further?
2. Should Sidekick stay tightly integrated with Blink `<Tab>`, or should that keypath become configurable per machine/workflow later?

## First Practical Steps

When work resumes, start here:

1. enable `custom.plugins` import in the refresh config
2. create the first custom module for a low-risk area
3. port core options and simple keymaps
4. test startup
5. commit

That creates the pattern the rest of the migration will follow.

## Next Session

Immediate next step:

1. keep OpenWRT for the final migration slice under `lua/local/*`
2. keep Sidekick Tab-path behavior deferred until after the Neovim `0.12.x` upgrade
3. clean up any remaining stale comments that still mention `lua/custom/*` if desired

Then:

4. return later for Blink performance troubleshooting once the migration is otherwise stable
5. re-check the latest `master` before porting each behavior slice, since it continues to move

Current note:

- core options/simple keymaps slice is complete on `kickstart-refresh`
- commits:
  - `9bf9266` (`Migrate basic settings and core options`)
  - `4317756` (`Migrate keymaps`)
- spell toggle and wrap toggle were added after the initial settings commit
- `vim.diagnostic.config(...)` was moved out of the keymaps section and placed with diagnostics/LSP-related code
- current diagnostic config in `nvim-12` intentionally still follows refreshed upstream rather than `master`
- LSP code now has a stable module split:
  - `lua/plugins/lsp.lua`
  - `lua/lsp/config.lua`
- current Blink baseline keeps only general settings; Sidekick/OpenWRT Blink hooks are intentionally deferred
- Blink now lives in `lua/plugins/blink.lua`
- current Sidekick baseline keeps CLI/keymap behavior but intentionally excludes Tab-path integrations
- Sidekick Tab-path behavior is intentionally deferred until after the upgrade
- Telescope now lives in `lua/plugins/telescope.lua`
- Treesitter now lives in `lua/plugins/nvim-treesitter.lua`
- Markdown rendering now lives in `lua/plugins/render-markdown.lua`
- remaining likely general-purpose work before OpenWRT:
  - optionally clean up stale comments that still mention `lua/custom/*` or `kickstart.plugins.*`
- `lazydev` remains intentionally omitted for now
- Blink completion is still notably slow, but that troubleshooting is intentionally deferred
- OpenWRT is intentionally scheduled last

## Drift Audit

This section tracks remaining drift between the current `master` config and the migrated `nvim-12` config after the functional migration was completed.

### Meaningful Drift

1. Statusline selection drift
   - `nvim-12` is currently using `mini.statusline`.
   - `master` is still using the custom `lualine` setup.
   - Action later:
     - decide whether `nvim-12` should switch back to `vim.g.active_statusline = 'lualine'`

2. `guess-indent.nvim` customization missing
   - `master` sets custom `on_tab_options`:
     - `expandtab = false`
     - `tabstop = 4`
   - `nvim-12` still uses plain `opts = {}`
   - Action later:
     - port the custom `guess-indent` opts into `nvim-12`

3. Telescope picker behavior drift
   - `master` has several Telescope customizations that were not carried over:
     - `defaults.initial_mode = 'normal'`
     - buffers picker mapping `dd = delete_buffer`
     - `live_grep`, `grep_string`, `help_tags`, and `current_buffer_fuzzy_find` default to insert mode
   - `nvim-12` keeps the keymaps and extensions, but not those picker behaviors
   - Action later:
     - decide which of those Telescope behaviors should be restored

4. Active colorscheme drift
   - `master` actively uses Ayu
   - `nvim-12` currently actively uses Tokyonight
   - `ayu-vim` is installed in `nvim-12`, but inactive
   - `github-theme` from `master` is not present in `nvim-12`
   - Action later:
     - add a visible colorscheme chooser in `init.lua`, similar to `vim.g.active_statusline`
     - recommended shape:
       - `vim.g.active_colorscheme = 'tokyonight-night'`
     - decide whether `nvim-12` should switch back to Ayu
     - decide whether `github-theme` should remain omitted

5. `lazydev` remains intentionally omitted
   - `master` still includes:
     - `folke/lazydev.nvim`
     - Blink `lazydev` source/provider wiring
   - `nvim-12` intentionally omits it for now
   - Action later:
     - decide whether the raw `lua_ls` setup is good enough long-term

6. `lua_ls` customization drift
   - `master` sets `Lua.completion.callSnippet = 'Replace'`
   - `nvim-12` uses the newer upstream `lua_ls` shape, but does not carry this setting over
   - Action later:
     - decide whether to restore `callSnippet = 'Replace'`

7. Diagnostic styling drift
   - `master` uses custom signs and formatted `virtual_text`
   - `nvim-12` intentionally still uses the refreshed upstream diagnostic styling
   - Action later:
     - decide whether the custom diagnostic presentation is still desired

8. Sidekick Tab-path behavior still omitted
   - `master` includes:
     - the Sidekick `<Tab>` key
     - the commented Blink/Sidekick `<Tab>` experiment
   - `nvim-12` intentionally leaves that path disabled
   - Action later:
     - revisit only after upgrade and only if the workflow benefit is worth the complexity

9. `vim-be-good` omitted
   - Present in `master`
   - Not present in `nvim-12`
   - Action later:
     - decide whether it belongs in the migrated config at all

10. VS Code launch guard still needs to be designed
   - Add a final post-upgrade guard for when Neovim is launched inside VS Code.
   - Options to evaluate later:
     - add a dedicated `vscode.lua` path/module
     - add an early VS Code check in `init.lua` that loads only VS Code-safe config and returns before the full config boots
   - Action later:
     - choose the structure
     - define the minimal VS Code-safe config surface
     - ensure the full Neovim config does not load in unsafe contexts

### Intentional / Probably Good Drift

- `mini.ai` mappings changed in `nvim-12` to avoid Neovim `0.12` incremental-selection conflicts
- Treesitter architecture changed from `treesitter-modules.nvim` to the refreshed direct `nvim-treesitter` setup
- Blink is now correctly split between:
  - general config in `lua/plugins/blink.lua`
  - OpenWRT-specific augmentation in `lua/local/plugins/openwrt.lua`

These are not currently considered regressions.

### No Meaningful Drift Found

- core options and simple keymaps
- yank highlight autocmd
- `neo-tree`
- `indent_line`
- `render-markdown`
- OpenWRT plugin loading and `remote-sshfs.nvim`
- Sidekick non-Tab keymaps
- `gopls`, `pyright`, `bashls`, and `copilot`

### Resume Priority

If parity work resumes later, the recommended order is:

1. switch `active_statusline` back to `lualine` if desired
2. port `guess-indent` custom opts
3. restore wanted Telescope picker behaviors
4. decide on `lazydev`
5. decide on `lua_ls.callSnippet`
6. decide on diagnostic styling
7. revisit Sidekick Tab-path behavior only if still wanted
8. add the VS Code launch guard as the final post-upgrade integration task
