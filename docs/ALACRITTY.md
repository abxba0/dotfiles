# Alacritty Documentation

Alacritty is a fast, GPU-accelerated terminal emulator. This configuration integrates it with tmux and zsh for a seamless terminal experience.

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+Shift+C` | Copy selection to clipboard |
| `Ctrl+Shift+V` | Paste from clipboard |
| `Ctrl+Shift+N` | Open new Alacritty window |
| `Ctrl++` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size |

## Configuration

### Installation

```bash
cd ~/dotfiles/alacritty
chmod +x alacritty-setup.sh
./alacritty-setup.sh
```

The setup script will:
1. Install Alacritty (if not installed)
2. Install tmux and zsh (if not installed)
3. Copy configuration to `~/.config/alacritty/alacritty.toml`
4. Configure tmux to use zsh as the default shell

### Manual Configuration

Copy the configuration manually:
```bash
mkdir -p ~/.config/alacritty
cp ~/dotfiles/alacritty/alacritty.toml ~/.config/alacritty/
```

### Configuration File Location

```
~/.config/alacritty/alacritty.toml
```

## Configuration Options

### Shell Configuration

Alacritty is configured to launch tmux automatically:

```toml
[shell]
program = "/usr/bin/tmux"
args = ["new-session", "-A", "-s", "main"]
```

This creates or attaches to a session named "main".

**To disable tmux auto-start:**
```toml
[shell]
program = "/usr/bin/zsh"
```

### Window Settings

```toml
[window]
padding = { x = 10, y = 10 }   # Padding around content
decorations = "full"            # Window decorations (full/none/transparent)
opacity = 0.95                  # Window transparency (0.0-1.0)
title = "Alacritty"             # Default window title
dynamic_title = true            # Allow programs to change title
startup_mode = "Windowed"       # Windowed/Maximized/Fullscreen
```

### Font Configuration

```toml
[font]
size = 12.0

[font.normal]
family = "monospace"   # Change to your preferred font
style = "Regular"

[font.bold]
family = "monospace"
style = "Bold"

[font.italic]
family = "monospace"
style = "Italic"
```

**Recommended: Use a Nerd Font for icons:**
```toml
[font.normal]
family = "JetBrainsMono Nerd Font"
style = "Regular"
```

### Cursor Settings

```toml
[cursor]
style = { shape = "Block", blinking = "On" }
blink_interval = 750         # Blink interval in milliseconds
unfocused_hollow = true      # Hollow cursor when unfocused
```

**Cursor shapes:** `Block`, `Underline`, `Beam`

### Scrolling

```toml
[scrolling]
history = 10000    # Lines of scrollback
multiplier = 3     # Scroll speed multiplier
```

### Selection

```toml
[selection]
save_to_clipboard = true   # Auto-copy selection to clipboard
```

### Mouse Settings

```toml
[mouse]
hide_when_typing = true    # Hide cursor while typing
```

## Customization

### Adding Custom Keybindings

Add to `alacritty.toml`:

```toml
[[keyboard.bindings]]
key = "F11"
action = "ToggleFullscreen"

[[keyboard.bindings]]
key = "Return"
mods = "Control|Shift"
action = "SpawnNewInstance"
```

### Color Schemes

**Catppuccin Mocha (dark):**
```toml
[colors.primary]
background = "#1e1e2e"
foreground = "#cdd6f4"

[colors.normal]
black = "#45475a"
red = "#f38ba8"
green = "#a6e3a1"
yellow = "#f9e2af"
blue = "#89b4fa"
magenta = "#f5c2e7"
cyan = "#94e2d5"
white = "#bac2de"
```

**Tokyo Night:**
```toml
[colors.primary]
background = "#1a1b26"
foreground = "#c0caf5"

[colors.normal]
black = "#15161e"
red = "#f7768e"
green = "#9ece6a"
yellow = "#e0af68"
blue = "#7aa2f7"
magenta = "#bb9af7"
cyan = "#7dcfff"
white = "#a9b1d6"
```

### Live Reload

Alacritty automatically reloads configuration when the file changes. No restart needed.

## Troubleshooting

### Alacritty Won't Start

Check for configuration errors:
```bash
alacritty --print-events
```

### Font Not Found

List available fonts:
```bash
fc-list | grep -i "your font name"
```

### Colors Look Wrong

Ensure TERM is set correctly:
```bash
echo $TERM  # Should be xterm-256color
```

Add to configuration if needed:
```toml
[env]
TERM = "xterm-256color"
```

### High CPU Usage

Disable VSync (not recommended for most users):
```toml
[window]
vsync = false
```

## Useful Commands

```bash
# Check Alacritty version
alacritty --version

# Validate configuration
alacritty --config-file ~/.config/alacritty/alacritty.toml --print-events

# Open with different config
alacritty --config-file /path/to/config.toml
```

## Resources

- [Alacritty GitHub](https://github.com/alacritty/alacritty)
- [Configuration Reference](https://alacritty.org/config-alacritty.html)
- [Nerd Fonts](https://www.nerdfonts.com/)
