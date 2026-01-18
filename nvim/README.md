# Neovim Configuration

A modern, modular Neovim configuration using lazy.nvim as the plugin manager. Designed for productivity with intelligent defaults and extensive customization options.

## Features

- **Plugin Manager**: lazy.nvim for fast, lazy-loading plugin management
- **LSP Support**: Full LSP integration with mason.nvim for easy server installation
- **Completion**: Modern completion with blink.cmp and LuaSnip snippets
- **Fuzzy Finding**: Telescope with fzf-native for lightning-fast search
- **File Navigation**: Oil.nvim (buffer-based) and Neo-tree (tree-based) explorers
- **AI Integration**: CodeCompanion and Avante for AI-assisted coding
- **Git Integration**: Gitsigns, Fugitive, and LazyGit support
- **Debugging**: DAP support with UI for debugging
- **Beautiful UI**: Tokyo Night theme, Lualine, Bufferline, and Noice

## Requirements

### Required

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)

### Recommended

- [ripgrep](https://github.com/BurntSushi/ripgrep) - Fast grep for Telescope
- [fd](https://github.com/sharkdp/fd) - Fast file finder for Telescope
- Node.js - Required for some LSP servers
- Python 3 - Required for some features
- A C compiler (gcc/clang) - Required for Treesitter

## Installation

### Quick Install

```bash
# Clone this repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Run the install script
cd ~/dotfiles/nvim
chmod +x install_plugins.sh
./install_plugins.sh

# Start Neovim
nvim
```

### Manual Install

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Copy configuration
cp -r ~/dotfiles/nvim ~/.config/nvim

# Start Neovim (plugins will install automatically)
nvim
```

### First Launch

1. Start Neovim: `nvim`
2. lazy.nvim will automatically install all plugins
3. Run `:checkhealth` to verify setup
4. Run `:Mason` to install LSP servers

## Directory Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── config/
│   │   ├── options.lua     # Editor options
│   │   ├── keymaps.lua     # Global keybindings
│   │   └── autocmds.lua    # Autocommands
│   ├── plugins/
│   │   ├── init.lua        # Plugin initialization
│   │   ├── editor.lua      # Editor enhancement plugins
│   │   ├── lsp.lua         # LSP and completion
│   │   ├── ui.lua          # UI/theme plugins
│   │   ├── navigation.lua  # Navigation plugins
│   │   ├── ai.lua          # AI assistant plugins
│   │   └── misc.lua        # Miscellaneous plugins
│   └── utils/
│       └── helpers.lua     # Utility functions
├── after/plugin/           # After-load plugin configs
├── plugin/                 # Plugin bootstrap (optional)
├── plugins.json            # Plugin manifest
└── install_plugins.sh      # Installation script
```

## Keybindings

Leader key is `<Space>`.

### General

| Key | Description |
|-----|-------------|
| `jk` / `jj` | Exit insert mode |
| `<C-s>` | Save file |
| `<leader>qq` | Quit all |
| `<leader>fn` | New file |
| `<leader>l` | Open Lazy plugin manager |

### File Navigation

| Key | Description |
|-----|-------------|
| `<leader><space>` | Find files |
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fb` | Buffers |
| `<leader>fg` | Git files |
| `<leader>/` | Live grep |
| `<leader>sg` | Live grep |
| `-` | Open Oil file explorer |
| `<leader>e` | Open Oil file explorer |
| `<leader>E` | Toggle Neo-tree |

### Buffer Navigation

| Key | Description |
|-----|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bb` | Switch to other buffer |

### Window Navigation

| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate windows |
| `<leader>-` | Split horizontal |
| `<leader>\|` | Split vertical |
| `<leader>wd` | Close window |

### LSP

| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>cf` | Format |
| `<leader>cd` | Line diagnostics |

### Git

| Key | Description |
|-----|-------------|
| `<leader>gg` | Git status (Fugitive) |
| `<leader>gG` | LazyGit |
| `<leader>gc` | Git commits |
| `<leader>gs` | Git status (Telescope) |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `]h` / `[h` | Next/prev hunk |

### AI

| Key | Description |
|-----|-------------|
| `<leader>aa` | AI Actions |
| `<leader>ac` | AI Chat Toggle |
| `<leader>aC` | AI Chat (New) |
| `<leader>ap` | AI Prompt |
| `<leader>ae` | AI Explain (visual) |
| `<leader>af` | AI Fix (visual) |
| `<leader>ar` | AI Refactor (visual) |

### Debug

| Key | Description |
|-----|-------------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step out |
| `<leader>dO` | Step over |
| `<leader>du` | Toggle DAP UI |

### Search

| Key | Description |
|-----|-------------|
| `<leader>sh` | Help pages |
| `<leader>sk` | Keymaps |
| `<leader>sc` | Commands |
| `<leader>sr` | Registers |
| `<leader>ss` | Document symbols |
| `<leader>sS` | Workspace symbols |

### Diagnostics

| Key | Description |
|-----|-------------|
| `<leader>xx` | Diagnostics (Trouble) |
| `<leader>xX` | Buffer diagnostics |
| `<leader>xt` | Todo (Trouble) |
| `]d` / `[d` | Next/prev diagnostic |
| `]e` / `[e` | Next/prev error |

### Misc

| Key | Description |
|-----|-------------|
| `<leader>uz` | Zen mode |
| `<leader>ut` | Twilight |
| `<leader>cu` | Undo tree |
| `<C-/>` | Toggle terminal |
| `<leader>?` | Show keymaps (which-key) |

## Configuration

### AI Setup

For AI features, set environment variables:

```bash
# For Anthropic (Claude)
export ANTHROPIC_API_KEY='your-api-key'

# For OpenAI
export OPENAI_API_KEY='your-api-key'
```

### LSP Servers

Install LSP servers with Mason:

```vim
:Mason
```

Or add them to `lua/plugins/lsp.lua` in the `ensure_installed` list.

### Adding Plugins

Add new plugins to the appropriate file in `lua/plugins/`:

```lua
-- lua/plugins/misc.lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",  -- lazy loading
    opts = {
      -- plugin options
    },
  },
}
```

### Customizing Theme

Change the colorscheme in `lua/plugins/ui.lua`:

```lua
-- Use catppuccin instead of tokyonight
vim.cmd.colorscheme("catppuccin")
```

## Health Check

Run `:checkhealth` to verify your setup:

```vim
:checkhealth
```

## Troubleshooting

### Plugins not loading

1. Run `:Lazy` and press `S` to sync
2. Check for errors with `:Lazy log`

### LSP not working

1. Run `:LspInfo` to check LSP status
2. Run `:Mason` to verify server installation
3. Check `:checkhealth lsp`

### Treesitter errors

1. Run `:TSUpdate` to update parsers
2. Run `:checkhealth nvim-treesitter`

### Icons not showing

Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal to use it.

## Plugin List

### Core
- lazy.nvim - Plugin manager
- plenary.nvim - Utility library
- nvim-treesitter - Syntax highlighting

### LSP & Completion
- nvim-lspconfig - LSP configuration
- mason.nvim - LSP server installer
- blink.cmp - Completion engine
- LuaSnip - Snippet engine
- conform.nvim - Formatting
- nvim-lint - Linting

### UI
- tokyonight.nvim - Colorscheme
- lualine.nvim - Statusline
- bufferline.nvim - Buffer tabs
- which-key.nvim - Keybinding hints
- noice.nvim - UI enhancements

### Navigation
- telescope.nvim - Fuzzy finder
- oil.nvim - File explorer
- neo-tree.nvim - Tree explorer
- harpoon - Quick navigation

### Editor
- Comment.nvim - Commenting
- nvim-surround - Surround operations
- nvim-autopairs - Auto pairs
- flash.nvim - Navigation

### AI
- codecompanion.nvim - AI assistant
- avante.nvim - AI editor

### Git
- gitsigns.nvim - Git signs
- vim-fugitive - Git commands
- lazygit.nvim - LazyGit integration

### Debug
- nvim-dap - Debug adapter
- nvim-dap-ui - Debug UI

## Credits

This configuration is inspired by:
- [LazyVim](https://github.com/LazyVim/LazyVim)
- [AstroNvim](https://github.com/AstroNvim/AstroNvim)
- [NvChad](https://github.com/NvChad/NvChad)

## License

MIT License - feel free to use and modify as you wish.
