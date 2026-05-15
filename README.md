# Furqan's Neovim Configuration

A personal Neovim configuration descended from
[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), with the original
single-file spirit separated into smaller, observable parts.

The aim is modest: keep `init.lua` lean, put general editor behavior in
`lua/config`, keep every plugin in its own file under `lua/plugins`, and leave
room for local preferences without turning the configuration into a black box.

## Shape of the Apparatus

```text
.
|-- init.lua              # leader keys and top-level require order
|-- lua/config/           # editor options, keymaps, autocmds, lazy.nvim setup
|-- lua/plugins/          # one plugin spec per file
|-- lsp/                  # per-server Neovim LSP configuration
|-- scripts/              # helper scripts used by the config
`-- lazy-lock.json        # pinned plugin revisions
```

`init.lua` is intentionally small. It sets the leader keys, records the Nerd
Font assumption, and then loads:

1. `config.options`
2. `config.keymaps`
3. `config.autocmds`
4. `config.lazy`

The plugin manager then imports all plugin specs from `lua/plugins`.

## Main Ingredients

- Plugin management with `lazy.nvim`
- Kanagawa colorscheme with transparent background
- LSP setup through `nvim-lspconfig`, `mason.nvim`, and `mason-lspconfig`
- Completion with `blink.cmp` and `LuaSnip`
- Formatting with `conform.nvim`
- Linting with `nvim-lint`
- Searching and picking with `telescope.nvim`
- File navigation with `oil.nvim` and `neo-tree.nvim`
- Git signs with `gitsigns.nvim`
- Syntax, textobjects, and context via Treesitter
- Testing with `neotest` for Python and Vitest
- Debugging with `nvim-dap`, `nvim-dap-ui`, `debugpy`, and `codelldb`
- Folding with `nvim-ufo`
- Database helpers through `vim-dadbod`
- Typst preview support

## Requirements

This configuration assumes a recent Neovim release and a terminal font with
Nerd Font glyphs available.

Useful external tools include:

- `git`
- `make`
- `ripgrep`
- `fd`
- `uv` for Python project execution
- language formatters, linters, and debuggers installed through Mason

Many LSP servers and command-line tools are installed automatically through the
Mason-related plugin configuration.

## Installation

Back up any existing Neovim config first:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
```

Clone this repository:

```sh
git clone <repo-url> ~/.config/nvim
```

Start Neovim:

```sh
nvim
```

On first launch, `lazy.nvim` bootstraps itself and installs the configured
plugins. Mason will then take care of the declared language servers and tools.

## Notes

This is a working laboratory notebook, not a general distribution. Some choices
are intentionally personal: leader-key conventions, Kanagawa styling,
`uv`-oriented Python testing/debugging, and a preference for modular plugin
files over a monolithic `init.lua`.

The lockfile is tracked so that a fresh machine can reproduce the same plugin
state with fewer surprises.
