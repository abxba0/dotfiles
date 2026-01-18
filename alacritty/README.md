# Alacritty Setup

A setup script for Alacritty terminal emulator with tmux and zsh integration.

## Overview

This script installs and configures:
- **Alacritty** - A fast, GPU-accelerated terminal emulator
- **tmux** - Terminal multiplexer (set as default program)
- **zsh** - Z shell (set as tmux's default shell)

## Prerequisites

- Ubuntu/Debian-based Linux distribution
- sudo privileges

## Dependencies

The script automatically installs these dependencies:

```bash
sudo apt install cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
```

## Installation

### Quick Start

```bash
# Clone or navigate to this directory
cd ~/dotfiles/alacritty

# Make the script executable
chmod +x alacritty-setup.sh

# Run the setup script
./alacritty-setup.sh
```

### Manual Installation

If you prefer to install manually:

```bash
# 1. Install dependencies
sudo apt update
sudo apt install cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

# 2. Install Alacritty
sudo apt install alacritty

# 3. Install tmux and zsh
sudo apt install tmux zsh

# 4. Copy configuration
mkdir -p ~/.config/alacritty
cp alacritty.toml ~/.config/alacritty/

# 5. Configure tmux to use zsh
echo 'set-option -g default-shell /usr/bin/zsh' >> ~/.tmux.conf
```

## Configuration

### Alacritty Config Location

The configuration file is placed at: `~/.config/alacritty/alacritty.toml`

### Key Features

- **tmux as default**: Alacritty launches tmux automatically
- **Session persistence**: Uses `tmux new-session -A -s main` to attach to existing session
- **zsh integration**: tmux is configured to use zsh as default shell
- **256 color support**: TERM set to `xterm-256color`

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+V` | Paste |
| `Ctrl+Shift+N` | New window |
| `Ctrl++` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size |

## Files

```
alacritty/
├── alacritty-setup.sh   # Main setup script
├── alacritty.toml       # Alacritty configuration
└── README.md            # This file
```

## Customization

### Change Default Font

Edit `alacritty.toml`:

```toml
[font]
size = 14.0

[font.normal]
family = "JetBrains Mono"
style = "Regular"
```

### Change Window Opacity

```toml
[window]
opacity = 0.90  # 0.0 (transparent) to 1.0 (opaque)
```

### Disable tmux Auto-Start

To use zsh directly without tmux, modify the shell section:

```toml
[shell]
program = "/usr/bin/zsh"
args = ["-l"]
```

## Troubleshooting

### Alacritty won't start
Check if all dependencies are installed:
```bash
alacritty --version
```

### tmux session issues
Kill existing sessions and restart:
```bash
tmux kill-server
alacritty
```

### Font rendering issues
Install additional fonts:
```bash
sudo apt install fonts-firacode fonts-jetbrains-mono
```

## Version Info

Check installed versions:
```bash
alacritty --version
tmux -V
zsh --version
```
