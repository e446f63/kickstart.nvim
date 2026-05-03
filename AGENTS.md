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
4. manually port relevant changes into `main`

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

## Key References

- `UPSTREAM_MAPPING.md`: maps upstream Kickstart sections into this repo
- `UPSTREAM_UPDATE_WORKFLOW.md`: workflow for incorporating future upstream changes
- `MIGRATION_PLAN.md`: historical migration notes and deferred follow-up items
