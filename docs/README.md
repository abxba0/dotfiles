# Dotfiles Documentation

This documentation covers all keyboard shortcuts and configuration instructions for each tool in this dotfiles repository.

## Tools Included

| Tool | Description | Documentation |
|------|-------------|---------------|
| [Alacritty](ALACRITTY.md) | GPU-accelerated terminal emulator | Keyboard shortcuts, configuration |
| [Tmux](TMUX.md) | Terminal multiplexer | Keybindings, plugins, session management |
| [Zsh](ZSH.md) | Z shell with Oh-My-Zsh | Aliases, key bindings, functions |
| [Neovim](NVIM.md) | Modern Vim-based editor | Keymaps, LSP, plugins |

## Quick Start

### Install Everything

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install each tool (in order)
./zsh/zsh-enhanced-setup.sh        # Zsh + Oh-My-Zsh
./tmux/tmux-setup.sh               # Tmux + plugins
./alacritty/alacritty-setup.sh     # Alacritty terminal
./nvim/install_plugins.sh          # Neovim configuration
```

### Install Individual Tools

See each tool's documentation for specific installation instructions.

## Directory Structure

```
dotfiles/
├── alacritty/
│   ├── alacritty.toml          # Alacritty configuration
│   ├── alacritty-setup.sh      # Installation script
│   └── README.md
├── tmux/
│   ├── .tmux.conf              # Tmux configuration
│   ├── tmux-setup.sh           # Installation script
│   └── README.md
├── zsh/
│   ├── .zshrc                  # Zsh configuration
│   ├── zsh-enhanced-setup.sh   # Installation script
│   └── README.md
├── nvim/
│   ├── init.lua                # Neovim entry point
│   ├── lua/                    # Lua configuration files
│   ├── install_plugins.sh      # Installation script
│   └── README.md
└── docs/                       # This documentation
    ├── README.md               # Overview (this file)
    ├── ALACRITTY.md            # Alacritty documentation
    ├── TMUX.md                 # Tmux documentation
    ├── ZSH.md                  # Zsh documentation
    └── NVIM.md                 # Neovim documentation
```

## Tool Integration

These tools are designed to work together seamlessly:

```
Alacritty (Terminal)
    └── Launches Tmux automatically
            └── Uses Zsh as default shell
                    └── Neovim as the editor
```

### Integration Features

- **Alacritty + Tmux**: Alacritty auto-starts tmux sessions
- **Tmux + Neovim**: Seamless navigation with `vim-tmux-navigator` (Ctrl+h/j/k/l)
- **Zsh + Neovim**: Shared environment variables, consistent theming
- **All Tools**: Consistent Catppuccin/Tokyo Night color schemes

## Updating

### Update All Components

```bash
# Zsh (Oh-My-Zsh + plugins)
./zsh/zsh-enhanced-setup.sh update

# Tmux (TPM + plugins)
./tmux/tmux-setup.sh update

# Neovim (Lazy.nvim)
nvim -c "Lazy sync" -c "qa"
```

## Requirements

### Minimum Requirements

- Git
- curl
- A terminal that supports 256 colors

### Recommended

- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- ripgrep (`rg`) - Fast grep
- fd - Fast file finder
- fzf - Fuzzy finder
- bat - Better cat
- eza/exa - Better ls

### Install Recommended Tools

**Ubuntu/Debian:**
```bash
sudo apt install ripgrep fd-find fzf bat
# Note: fd is 'fdfind' on Debian, create alias: alias fd=fdfind
```

**macOS:**
```bash
brew install ripgrep fd fzf bat eza
```

**Arch Linux:**
```bash
sudo pacman -S ripgrep fd fzf bat eza
```

## Troubleshooting

### Icons Not Showing

Install a Nerd Font and configure your terminal to use it:
1. Download from [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
2. Install the font on your system
3. Set your terminal font to the Nerd Font variant

### Colors Look Wrong

Ensure your terminal supports true color:
```bash
echo $TERM  # Should be xterm-256color or similar
```

### Tmux Not Starting

Check if tmux is installed:
```bash
which tmux
tmux -V
```

### Neovim Errors on Startup

Run health check:
```vim
:checkhealth
```
