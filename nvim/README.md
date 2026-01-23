# Neovim Configuration (nvimdots)

This directory contains setup scripts for [nvimdots](https://github.com/ayamir/nvimdots), a modern and efficient Neovim configuration with startup times under 50ms. nvimdots is a pure Lua config using lazy.nvim as the plugin manager, designed for productivity with intelligent defaults.

## Features

- **Blazing Fast**: Startup times under 50ms
- **Pure Lua Config**: Modern, maintainable configuration
- **Plugin Manager**: lazy.nvim for fast, lazy-loading plugin management
- **LSP Support**: Full LSP integration with mason.nvim for easy server installation
- **Modern Completion**: Advanced completion engine with snippets support
- **Fuzzy Finding**: Telescope for lightning-fast file and content search
- **File Navigation**: Multiple file explorer options
- **Git Integration**: Gitsigns and LazyGit support
- **Debugging**: DAP support with UI for debugging
- **Beautiful UI**: Customizable themes and statusline
- **AI Integration**: Support for various AI coding assistants

> **Note**: This setup uses the nvimdots configuration. For full feature list and customization options, see the [nvimdots wiki](https://github.com/ayamir/nvimdots/wiki).

## Requirements

### Required (installed by install_prerequisites.sh)

- **Neovim** >= 0.11.0 (0.10+ for older branches)
- **Git** - Version control
- **Node.js** 18+ via nvm - For LSP servers and plugins
- **Python 3** with pip and venv - For Python-based plugins
- **Rust** - For rust-analyzer and Rust-dependent plugins
- **C compiler** (gcc/clang) - For Treesitter
- **Build tools** (cmake, make) - For native plugins
- **Nerd Font** - For icons (JetBrainsMono installed by script)

### Recommended Tools (installed by script)

- **ripgrep** - Fast grep for Telescope
- **fd** - Fast file finder for Telescope
- **lazygit** - Terminal UI for git
- **zoxide** - Smarter cd command
- **tree-sitter CLI** - For Treesitter operations
- **yarn** - Package manager for some plugins
- **lldb** - Debugger support

All of these are automatically installed by running `install_prerequisites.sh`.

## Installation

### Prerequisites Installation

First, install all required system dependencies:

```bash
# Clone this repository (if not already done)
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# Run the prerequisites installation script
cd ~/dotfiles/nvim
chmod +x install_prerequisites.sh
./install_prerequisites.sh
```

This script installs:
- Neovim (latest stable)
- Node.js 18+ via nvm
- Rust toolchain
- Python 3 with pip and venv
- Build tools (gcc, clang, cmake, etc.)
- CLI tools (ripgrep, fd, zoxide, lazygit)
- Nerd Fonts (JetBrainsMono)
- And more...

### nvimdots Installation

After prerequisites are installed, restart your shell and install nvimdots:

```bash
# Restart shell or source environment
source ~/.nvm/nvm.sh
source ~/.cargo/env

# Install nvimdots using official installer
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh)"

# Start Neovim
nvim
```

### First Launch

1. Start Neovim: `nvim`
2. lazy.nvim will automatically install all plugins
3. Run `:checkhealth` to verify setup
4. Run `:Mason` to install LSP servers

For more details, visit the [nvimdots repository](https://github.com/ayamir/nvimdots).

## What's Included

This directory contains:

```
nvim/
├── install_prerequisites.sh  # System dependencies installer
├── install_plugins.sh        # Legacy plugin installer (optional)
├── plugins.json              # Plugin manifest for reference
├── README.md                 # This file
└── lua/                      # Legacy config files (optional)
```

After installing nvimdots, your Neovim configuration will be at `~/.config/nvim/` with the full nvimdots structure. See the [nvimdots repository](https://github.com/ayamir/nvimdots) for details on the configuration structure.

## Keybindings

nvimdots uses `<Space>` as the leader key and comes with a comprehensive set of keybindings.

### Quick Reference

- Press `<Space>` to see available keybindings via which-key
- Common patterns:
  - `<Space>f` - Find/File operations
  - `<Space>g` - Git operations
  - `<Space>l` - LSP operations
  - `<Space>b` - Buffer operations
  - `<Space>s` - Search operations

For a complete list of keybindings, refer to:
- Press `<Space>` in Neovim to see interactive keybinding menu
- [nvimdots Keybindings Wiki](https://github.com/ayamir/nvimdots/wiki/Keybindings)
- Run `:Telescope keymaps` to search all keymaps

## Configuration

### LSP Servers

Install LSP servers with Mason:

```vim
:Mason
```

Browse and install language servers, formatters, and linters as needed.

### Customization

nvimdots is highly customizable. For customization guides, see:
- [nvimdots Wiki - Configuration](https://github.com/ayamir/nvimdots/wiki)
- [nvimdots Wiki - Plugins](https://github.com/ayamir/nvimdots/wiki/Plugins)

Configuration files are located at:
- `~/.config/nvim/lua/core/` - Core settings
- `~/.config/nvim/lua/keymap/` - Keybindings
- `~/.config/nvim/lua/modules/` - Plugin configurations

### Adding Plugins

Edit `~/.config/nvim/lua/modules/plugins.lua` to add new plugins. Refer to the [nvimdots plugin documentation](https://github.com/ayamir/nvimdots/wiki/Plugins) for examples.

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

nvimdots comes with a carefully curated set of plugins for various use cases:

- **Core**: lazy.nvim, plenary.nvim, nvim-treesitter
- **LSP**: nvim-lspconfig, mason.nvim, completion engine, formatters
- **UI**: Beautiful themes, statusline, bufferline, which-key
- **Navigation**: Telescope, file explorers, quick navigation
- **Editor**: Smart commenting, surround operations, auto-pairs
- **Git**: Gitsigns, LazyGit integration
- **Debug**: DAP support with UI

For a complete and up-to-date plugin list, see:
- The [nvimdots README](https://github.com/ayamir/nvimdots#-plugins)
- Run `:Lazy` in Neovim to see installed plugins

## Additional Resources

- **nvimdots Repository**: https://github.com/ayamir/nvimdots
- **nvimdots Wiki**: https://github.com/ayamir/nvimdots/wiki
- **Report Issues**: https://github.com/ayamir/nvimdots/issues

## Credits

This setup uses [nvimdots](https://github.com/ayamir/nvimdots) by [@ayamir](https://github.com/ayamir). All credit for the Neovim configuration goes to the nvimdots contributors.

## License

MIT License - The prerequisites installation script is provided as-is. nvimdots has its own license (see [nvimdots repository](https://github.com/ayamir/nvimdots)).
