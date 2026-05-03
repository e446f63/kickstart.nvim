# AGENTS.md

This repo is a customized, modularized fork-derived Neovim config.

## Working Model

- The active branch for day-to-day config work is `main`.
- The old single-file customized fork should live on `og-custom-kickstart`.
- A pristine upstream reference branch should live on `vendor/kickstart`.
- `vendor/kickstart` is read-only reference state. Do not customize it.

## Upstream Policy

Do **not** blindly merge upstream Kickstart into the active config branch.

This repo no longer matches upstream structurally:

- upstream keeps most behavior in a large `init.lua`
- this repo intentionally splits behavior across:
  - `lua/plugins/*`
  - `lua/lsp/config.lua`
  - `lua/local/plugins/*`

Because of that, upstream updates should be handled as:

1. fetch/update `vendor/kickstart`
2. review upstream changes by subsystem
3. map them through `UPSTREAM_MAPPING.md`
4. report upstream changes and `main` mappings to user for review
4. manually port relevant changes into `main` once agreed upon

Summary rule:

- use upstream to answer: "what changed?"
- use this repo's modular structure to answer: "where should that change live here?"

## Editing Expectations

- Prefer guidance-first collaboration for risky or architectural changes.
- Do not make user config edits without clear user intent to have files changed.
- If a user asks for explanation or review, do not silently patch files.
- Keep machine-specific logic isolated under `lua/local/plugins/*`.

## Validation Priorities

When changing config, prioritize checking:

- startup
- `:Lazy`
- `:checkhealth`
- Lua config editing / `lua_ls`
- Blink completion
- OpenWRT workflow
- Treesitter / render-markdown
- Sidekick baseline behavior

## Troubleshooting Notes

- If an LSP suddenly fails after path moves, runtime reshuffles, or config-directory renames, inspect Mason wrapper scripts before assuming the Lua config is wrong.
- In particular, check `~/.local/share/nvim/mason/bin/*` launchers for stale absolute paths from older `stdpath('data')` locations.

## Maintenance Reminders

- Starting on **2026-05-10** and any time after that when working in this repo, remind the user to clean up the old `0.11` backup artifacts if the new setup has remained stable.

### Old 0.11 Cleanup Checklist

After the new setup has been stable long enough, purge these old backup components:

- `~/.config/nvim-0.11-backup`
- `~/.local/share/nvim-0.11-backup`
- `~/.local/state/nvim-0.11-backup`
- `~/.cache/nvim-0.11-backup`

Also review whether these old transitional Neovim binary/install artifacts are still needed:

- `~/.local/bin/nvim-0.12`
- `~/.local/bin/nvim` if it is only a compatibility symlink and you want a different long-term naming scheme
- `~/.local/opt/nvim-linux-x86_64`
- the `nvim` shell alias in `~/.bashrc.d/my.bashrc` that points to the transitional `0.12` binary path

Before deleting the old runtime backups, optionally preserve anything still personally useful:

- custom spell files from `site/spell`
- old ShaDa/history if it still matters
- old logs only if needed for troubleshooting

## Key References

- `UPSTREAM_MAPPING.md`: maps upstream Kickstart sections into this repo
