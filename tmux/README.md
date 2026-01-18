# Tmux Configuration

A modern tmux setup with plugin management, session persistence, and seamless vim integration.

## Features

- **TPM (Tmux Plugin Manager)** - Easy plugin management
- **Catppuccin Theme** - Beautiful Mocha color scheme
- **Session Persistence** - Sessions survive reboots (resurrect + continuum)
- **Vim Integration** - Seamless navigation between vim and tmux panes
- **Session Management** - Quick session switching with sessionx
- **Mouse Support** - Full mouse support enabled

## Quick Start

```bash
# Quick install (no prompts)
./tmux-setup.sh quick

# Or interactive install
./tmux-setup.sh install
```

## Installation

### Prerequisites

- `tmux` (version 3.0+ recommended)
- `git`

**Optional (enhances some plugins):**
- `fzf` - Fuzzy finder for sessionx
- `tree` - File tree for sidebar

### Install Dependencies

```bash
# Ubuntu/Debian
sudo apt install tmux git fzf tree

# macOS
brew install tmux git fzf tree

# Fedora
sudo dnf install tmux git fzf tree

# Arch
sudo pacman -S tmux git fzf tree
```

### Run Setup

```bash
cd ~/dotfiles/tmux
./tmux-setup.sh install
```

## Usage

```bash
./tmux-setup.sh [command]
```

| Command | Description |
|---------|-------------|
| `install` | Full interactive installation (default) |
| `update` | Update TPM and all plugins |
| `quick` | Quick installation without prompts |
| `uninstall` | Remove configuration and plugins |
| `keys` | Show keybindings reference |
| `help` | Show help message |

## Keybindings

### Prefix Key

The prefix key is changed from `Ctrl+b` to `Ctrl+a` for easier access.

### Basic Navigation

| Keybinding | Action |
|------------|--------|
| `prefix + \|` | Split pane horizontally |
| `prefix + -` | Split pane vertically |
| `prefix + c` | New window (in current path) |
| `prefix + r` | Reload configuration |
| `prefix + H/J/K/L` | Resize panes |

### Vim-Tmux Navigator

Navigate seamlessly between vim splits and tmux panes:

| Keybinding | Action |
|------------|--------|
| `Ctrl + h` | Move left |
| `Ctrl + j` | Move down |
| `Ctrl + k` | Move up |
| `Ctrl + l` | Move right |

> Requires [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) in your vim/neovim config.

### Session Management

| Keybinding | Action |
|------------|--------|
| `prefix + o` | Open sessionx (session manager) |
| `prefix + s` | List sessions (built-in) |
| `prefix + $` | Rename session |

### Plugins

| Keybinding | Action |
|------------|--------|
| `prefix + \` | Open tmux-menus |
| `prefix + Tab` | Toggle sidebar (file tree) |
| `prefix + I` | Install new plugins |
| `prefix + U` | Update plugins |
| `prefix + alt + u` | Uninstall removed plugins |

### Copy Mode (Vi keys)

| Keybinding | Action |
|------------|--------|
| `prefix + [` | Enter copy mode |
| `v` | Start selection |
| `y` | Copy selection |
| `prefix + ]` | Paste |

## Plugins

| Plugin | Description |
|--------|-------------|
| [tpm](https://github.com/tmux-plugins/tpm) | Tmux Plugin Manager |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible default settings |
| [catppuccin/tmux](https://github.com/catppuccin/tmux) | Catppuccin theme |
| [tmux-prefix-highlight](https://github.com/tmux-plugins/tmux-prefix-highlight) | Highlights prefix key in status bar |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Seamless vim/tmux navigation |
| [tmux-sessionx](https://github.com/omerxx/tmux-sessionx) | Session manager with fzf |
| [tmux-menus](https://github.com/jaclu/tmux-menus) | Popup menus for common actions |
| [tmux-sidebar](https://github.com/tmux-plugins/tmux-sidebar) | File tree sidebar |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank) | Enhanced copy to system clipboard |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save and restore sessions |
| [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Automatic session saving |

## Configuration

The configuration file is located at `~/.tmux.conf` (symlinked from this directory).

### Key Settings

```bash
# True color support
set -g default-terminal "tmux-256color"

# Mouse support
set -g mouse on

# Start windows/panes at 1
set -g base-index 1
setw -g pane-base-index 1

# Large scrollback buffer
set -g history-limit 50000

# Status bar at top
set -g status-position top
```

### Customization

Edit `.tmux.conf` to customize:

- **Theme**: Change `@catppuccin_flavor` to `latte`, `frappe`, `macchiato`, or `mocha`
- **Prefix**: Modify the prefix key binding
- **Plugins**: Add or remove plugins in the TPM section

After changes, reload with `prefix + r` or:

```bash
tmux source-file ~/.tmux.conf
```

## Vim Integration

For seamless navigation, add vim-tmux-navigator to your vim/neovim config:

**Vim (vim-plug):**
```vim
Plug 'christoomey/vim-tmux-navigator'
```

**Neovim (lazy.nvim):**
```lua
{ "christoomey/vim-tmux-navigator" }
```

## Session Persistence

Sessions are automatically saved every 15 minutes by tmux-continuum and restored on tmux start.

- Sessions saved to: `~/.tmux/resurrect/`
- Auto-restore enabled by default
- Pane contents are captured

### Manual Save/Restore

| Keybinding | Action |
|------------|--------|
| `prefix + Ctrl+s` | Save session |
| `prefix + Ctrl+r` | Restore session |

## Troubleshooting

### Plugins not loading

1. Ensure TPM is installed: `~/.tmux/plugins/tpm`
2. Press `prefix + I` to install plugins
3. Restart tmux: `tmux kill-server && tmux`

### Colors look wrong

Ensure your terminal supports true color and add to your shell config:

```bash
export TERM="xterm-256color"
```

### Vim navigation not working

1. Install vim-tmux-navigator in vim/neovim
2. Ensure `Ctrl+h/j/k/l` aren't overridden elsewhere

### Sessionx not finding sessions

Install fzf for full functionality:

```bash
# Ubuntu/Debian
sudo apt install fzf

# macOS
brew install fzf
```

## Updating

Update all components:

```bash
./tmux-setup.sh update
```

Or manually inside tmux: `prefix + U`

## Uninstalling

```bash
./tmux-setup.sh uninstall
```

This removes the config symlink and all plugins. Your backup configs are preserved.

## File Structure

```
tmux/
├── .tmux.conf      # Main tmux configuration
├── tmux-setup.sh   # Setup and management script
└── README.md       # This file
```

## License

MIT
