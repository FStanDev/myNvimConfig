# Update log

A record of what changed in this config, and *why*. Newest entry first.

---

## 2026-08-24 — Neovim 0.12 bug fixes and modernization

Branch: `modernize-nvim-0.12`. Verified against Neovim **0.12.2**.

**Context.** The two migrations that break most Neovim configs right now —
nvim-treesitter `master` → `main`, and `require("lspconfig").x.setup{}` →
`vim.lsp.config()`/`vim.lsp.enable()` — were already done here in earlier
commits. What remained were regressions introduced *by* the treesitter
migration, APIs Neovim has since deprecated, and a few pieces of dead code.

Everything below preserves existing behaviour. No keybinding was removed or
remapped except one that was a typo, and no plugin was added or dropped.

### Bugs fixed

#### 1. Treesitter highlighting was off for almost every language
`lua/configs/treesitter.lua`

`vim.treesitter.start()` was only called for `svelte` and `astro`. Neovim's own
runtime starts treesitter for just four bundled filetypes (`lua`, `markdown`,
`help`, `query` — see `$VIMRUNTIME/ftplugin/`), so **python, rust, go, ts/tsx,
c/cpp, html, css, json, yaml and bash were silently falling back to the old
regex syntax engine** even though their parsers were installed. This was a
regression from the `master` → `main` migration: the old `highlight = { enable
= true }` module used to do this globally, and nothing replaced it.

*Fix:* one unconditional `FileType` autocmd calling `pcall(vim.treesitter.start)`.
The `pcall` matters — `start()` throws when no parser exists, and filetypes we
have no parser for should just keep regex highlighting rather than error.

*Why it's better:* correct semantic highlighting, and it is what the `main`
branch expects you to do now that the plugin no longer owns highlighting.

*Measured before/after*, identical probe, same plugin set:

| file | before | after |
|---|---|---|
| `a.py` | `treesitter_highlight=false` | `true` |
| `a.rs` | `false` | `true` |
| `a.go` | `false` | `true` |
| `a.ts` | `false` | `true` |
| `a.html` | `false` | `true` |

#### 2. The `auto_install` replacement never installed anything
`lua/configs/treesitter.lua`

The check was `if not require("nvim-treesitter.parsers")[lang]`. On the `main`
branch that module is the **catalog of all parsers upstream ships** (`ada`,
`agda`, …), not the set installed locally. So the condition was inverted: for
any real language the catalog entry existed and installation was skipped, and
it only ever fired for languages that don't exist upstream — where `install()`
then fails.

*Fix:* check `require("nvim-treesitter").get_installed("parsers")`, which is the
actual installed set, and additionally skip languages `get_available()` doesn't
know about so we never call `install()` on something that cannot be built.
Also moved the autocmd into a named augroup with `clear = true` so reloading
the config doesn't stack duplicate handlers.

#### 3. `<leader>mp` (manual format) raised an error every time
`lua/configs/formating.lua`

The keymap was written *inside* the returned options table, as an expression
element. It ran as a side effect of building the table, and its callback
referenced a bare global `conform` that is never defined anywhere.

*Fix:* moved it out of the table into a real statement, and it now calls
`require("conform").format(...)`.

*Measured before/after:*

```
before: ERROR -> formating.lua:28: attempt to index global 'conform' (a nil value)
after:  OK (formatted, no error)
```

#### 4. clangd could never start under the ESP-IDF branch
`lua/configs/lsp.lua`

`root_dir` was a zero-argument function returning nothing. Under `vim.lsp.config`
the signature is `function(bufnr, on_dir)` and **the server only starts once
`on_dir` is called** — a return value is ignored. So whenever `IDF_PATH` was
set, clangd was configured and then never launched.

*Fix:* `root_dir = function(_, on_dir) on_dir(vim.fn.getcwd()) end`. This keeps
the original intent from the comment (don't let a global `~/.clangd` drag the
workspace root up to `$HOME`) while actually starting the server.

Note: `IDF_PATH` is not set in the current shell, so this path was dormant —
the fix is untested against a live ESP-IDF setup.

#### 5. `foldmethod` was set twice, with the losing value first
`lua/base/init.lua`

`vim.opt.foldmethod = "syntax"` was set in `base/init.lua`, then overwritten by
`foldmethod = "expr"` in `configs/treesitter.lua` a moment later (treesitter
loads *after* base). `foldlevelstart` was likewise set in both files.

*Fix:* removed both from `base/init.lua` and left folding owned by
`configs/treesitter.lua`. Behaviour is unchanged — this only removes a
misleading line that suggested syntax folding was in use when it never was.

#### 6. `<leader> dy` keymap typo
`lua/base/init.lua`

Written as `"<leader> dy"` — a literal space inside the left-hand side, so the
actual sequence was `<leader><Space>dy` — with a stray `3` count prefixed to the
command string.

*Fix:* now `<leader>dy`, bound directly to `vim.diagnostic.open_float` with a
`desc`.

### Deprecated APIs replaced

| Where | Was | Now | Why |
|---|---|---|---|
| `lua/configs/lsp.lua` | `vim.diagnostic.goto_prev` / `goto_next` | `vim.diagnostic.jump({ count = ∓1, float = true })` | **Scheduled for removal in Neovim 0.13.** Confirmed in the local runtime: `vim/diagnostic.lua:1566` and `:1723` both call `vim.deprecate(..., '0.13')`. `float = true` preserves the old pop-open-after-jump behaviour. |
| `lua/base/plugins/lazy.lua` | `vim.loop.fs_stat` | `vim.uv.fs_stat` | `vim.loop` is the deprecated alias for the libuv bindings. |
| `lua/configs/formating.lua` | `lsp_fallback = true` | `lsp_format = "fallback"` | `lsp_fallback` is conform's old spelling. It is also **not in conform's `allowed_default_opts`**, so it was not reliably honoured inside `format_on_save`. |
| `lua/configs/lazy.lua` | `williamboman/mason.nvim`, `williamboman/mason-lspconfig.nvim` | `mason-org/mason.nvim`, `mason-org/mason-lspconfig.nvim`, both pinned `version = "^2.0.0"` | Both projects moved org for v2. The old paths still redirect, but v2 docs and `:checkhealth` expect the new ones. The pin means a future v3 can't land silently the way the treesitter rewrite did. Lazy keys plugins by directory basename, so this does **not** force a re-clone. |
| `lua/configs/lazy.lua` | `automatic_installation = false` | *(removed)* | The option no longer exists in mason-lspconfig v2 — verified against the installed v2.1.0 settings schema. It was being silently ignored. `automatic_enable = false` is kept and is **required**, since servers are enabled explicitly in `lsp.lua`. |
| `lua/configs/lsp.lua` | manual `omnifunc` assignment on `LspAttach` | *(removed)* | Neovim has set this automatically on attach since 0.8. |
| `lua/configs/lsp.lua` | omnisharp `enable_roslyn_analyzers`, `organize_imports_on_format`, `enable_import_completion` | equivalent keys under `settings.FormattingOptions` / `settings.RoslynExtensionsOptions` | Those were top-level keys from the **nvim-lspconfig omnisharp extension** and are ignored by `vim.lsp.config`. Untested — omnisharp is not installed on this machine (it's commented out in `configs/mason.lua`). |

### Improved support

#### Completion capabilities are now actually advertised to servers
`lua/configs/lsp.lua`

`cmp-nvim-lsp` was installed and listed as a dependency, but
`default_capabilities()` was never called anywhere — and modern versions of that
plugin no longer patch lspconfig's defaults behind your back. The result: every
server was told Neovim had only stock capabilities, so snippet support,
`additionalTextEdits` resolve and friends were never negotiated.

*Fix:* `vim.lsp.config("*", { capabilities = cmp_nvim_lsp.default_capabilities() })`,
guarded with `pcall` so the config still loads if cmp is absent. `vim.lsp.config("*", …)`
is the 0.11+ way to set defaults shared by every server.

*Verified:* `textDocument.completion.completionItem.snippetSupport` is now `true`
on the global config (previously the global config had no `capabilities` at all).

### Dead code removed

| File | Why |
|---|---|
| `lua/configs/rust-tools.lua` | **Not valid Lua** (a `local` statement inside a table constructor). Never `require`d, so it never errored — but it would break any "load every config" refactor. rust-tools.nvim was archived upstream in January 2024; the config uses `rust-lang/rust.vim` instead. |
| `lua/configs/nvim-cmp.lua` | Dead near-duplicate of `lua/configs/cmp.lua`, missing the `nvim_lsp` source. Only `cmp.lua` was ever wired up. |
| `lua/base/plugins/init.lua` | Contained `require("lazy")`. Nothing requires `base.plugins`, and if anything did it would pull in lazy.nvim's runtime module rather than this config. |

### Annotated, not changed

Left working but documented in-file, because changing them would alter
behaviour or needs a decision:

- **`lua/configs/dap_js.lua`** — `debugger_path` points at
  `lazy/vscode-js-debug`, which is **not in the plugin spec and not installed**,
  so the JS debug adapter has nothing to launch. `nvim-dap-vscode-js` is also
  archived upstream. Removed the duplicated `"chrome"` entry and added a note.
  Needs a decision: add `vscode-js-debug` as a built spec, or drop JS debugging.
- **`lua/configs/mason.lua`** — `ensure_installed` is **not a mason.nvim option**;
  mason has no such setting. It works only because `lua/configs/lazy.lua`
  hand-rolls a `:MasonInstallAll` command that reads it. Documented so this
  isn't mistaken for a real mason feature.
- **`gr` → `vim.lsp.buf.references`** in `lsp.lua`. Neovim 0.11+ ships default
  LSP maps under the `gr` prefix (`grn` rename, `gra` code action, `grr`
  references, `gri` implementation, `grt` type definition). Mapping bare `gr`
  makes all of them wait `timeoutlen` before resolving. Kept as-is to preserve
  muscle memory — every one of those actions is already bound elsewhere in this
  config. Move `gr` if the lag becomes annoying.

### Recommended but not done

**Commit `lazy-lock.json`.** It is currently in `.gitignore`, so plugin versions
float freely and the two machines this config runs on have no shared pin. That
is exactly what produced the `Freeze on old dependencies…` → `Add support for
main brach of treesitter` cycle and the `Solve conflicts on local and remote
file` merge. Tracking the lockfile makes plugin upgrades a deliberate,
reviewable commit instead of a surprise. Left alone because it's a workflow
decision, not a code fix — to adopt it, drop the `lazy-lock.json` line from
`.gitignore` and commit the file.

### How this was verified

An isolated sandbox (`XDG_CONFIG_HOME` / `XDG_DATA_HOME` / `XDG_STATE_HOME` /
`XDG_CACHE_HOME` all redirected, with the plugin and parser directories copied
in) was booted headless against **both** the old `main` config and this branch,
running an identical probe script. The real `~/.config/nvim` and
`~/.local/share/nvim` were never touched.

Checks run: full config load with no errors; treesitter highlighter active per
filetype; `indentexpr` per filetype; `foldmethod` / `foldexpr`; `number` /
`relativenumber` set globally; `<leader>mp` present and invoking without error;
`[d` / `]d` triggering no deprecation warning; global LSP `capabilities`
present with `snippetSupport`; `get_installed("parsers")` returning the real
installed set (22 parsers).
