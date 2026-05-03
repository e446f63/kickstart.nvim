# Upstream Update Workflow

This repo started from Kickstart, but it is no longer structured like upstream.

That means upstream should now be treated as a **reference source**, not as something to merge blindly into the live config branch.

## Branch Model

Use this branch model:

- `main`
  - your active Neovim config
  - modularized
  - this is where real config work happens

- `og-custom-kickstart`
  - your old customized single-file Kickstart branch
  - archival/reference only

- `vendor/kickstart`
  - pristine upstream-tracking reference branch
  - never customize this branch
  - only fast-forward it to match upstream

## One-Time Setup

### 1. Add the original Kickstart repo as `upstream`

```bash
git remote add upstream https://github.com/nvim-lua/kickstart.nvim.git
git fetch upstream
```

### 2. Make sure the branch model exists

Expected branches:

- `main`
- `og-custom-kickstart`
- `vendor/kickstart`

`vendor/kickstart` should be created from upstream:

```bash
git switch -c vendor/kickstart upstream/master
```

After that, do not make custom commits on `vendor/kickstart`.

## Ongoing Update Model

Do **not** do this anymore:

```bash
git merge upstream/master
```

into your active config branch.

Instead:

1. update the pristine upstream reference branch
2. inspect what changed upstream
3. manually port relevant behavior into `main`

This is necessary because:

- upstream is still largely single-file
- your repo is now modular
- Git can merge file history, but it cannot understand architectural mapping decisions

## Recommended Workflow

### 1. Fetch upstream

```bash
git fetch upstream
```

### 2. Update the pristine vendor branch

```bash
git switch vendor/kickstart
git merge --ff-only upstream/master
```

This branch should remain an exact local mirror of upstream.

### 3. Review what changed upstream

Compare the previous state and the new upstream state however you prefer:

```bash
git log --oneline HEAD@{1}..HEAD
```

or inspect specific files/commits directly.

### 4. Translate upstream changes into your modular layout

Use:

- `UPSTREAM_MAPPING.md`
- `AGENTS.md`

to answer:

- what changed upstream?
- where does that behavior live in this repo?
- should that upstream change be adopted at all?

### 5. Port changes into `main`

Switch back to your real config branch:

```bash
git switch main
```

Then manually apply only the changes you actually want.

### 6. Validate

After porting, test at minimum:

- startup
- `:Lazy`
- `:checkhealth`
- Lua config editing / `lua_ls`
- Blink completion
- OpenWRT workflow
- Treesitter / render-markdown
- Sidekick baseline behavior

## Why This Workflow Is Better

This repo has structurally diverged from upstream.

Examples:

- upstream LSP section -> `lua/plugins/lsp.lua` + `lua/lsp/config.lua`
- upstream Telescope block -> `lua/plugins/telescope.lua`
- upstream Treesitter block -> `lua/plugins/nvim-treesitter.lua`
- machine-specific behavior -> `lua/local/plugins/*`

Because of that, future maintenance is now a **semantic porting** problem, not a direct merge problem.

## Summary Rule

Use upstream to answer:

> "What changed?"

Use this repo's structure to answer:

> "Where should that change live here?"

That is the maintenance model going forward.

## Current Remote Note

If `main` was created by renaming the old local `kickstart-refresh` branch, it may still temporarily track:

- `origin/kickstart-refresh`

That is fine locally. When you are ready, clean up the remote branch names manually, for example:

```bash
git push origin main
git push origin --delete kickstart-refresh
git branch --set-upstream-to=origin/main main
```

Do the same kind of cleanup for `og-custom-kickstart` only if you want that branch published on your fork.
