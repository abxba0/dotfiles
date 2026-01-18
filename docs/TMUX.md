# Tmux Documentation

Tmux is a terminal multiplexer that lets you run multiple terminal sessions within a single window. This configuration uses TPM (Tmux Plugin Manager) and includes several productivity plugins.

## Prefix Key

The prefix key is changed from the default `Ctrl+b` to:

```
Ctrl+a
```

All keybindings below assume you press `Ctrl+a` first, then the key.

## Keyboard Shortcuts

### Basic Navigation

| Shortcut | Action |
|----------|--------|
| `prefix + \|` | Split pane horizontally (side by side) |
| `prefix + -` | Split pane vertically (top/bottom) |
| `prefix + c` | Create new window |
| `prefix + r` | Reload tmux configuration |

### Pane Navigation

| Shortcut | Action |
|----------|--------|
| `Ctrl+h` | Move to left pane (vim-tmux-navigator) |
| `Ctrl+j` | Move to pane below (vim-tmux-navigator) |
| `Ctrl+k` | Move to pane above (vim-tmux-navigator) |
| `Ctrl+l` | Move to right pane (vim-tmux-navigator) |

### Pane Resizing

| Shortcut | Action |
|----------|--------|
| `prefix + H` | Resize pane left |
| `prefix + J` | Resize pane down |
| `prefix + K` | Resize pane up |
| `prefix + L` | Resize pane right |

### Window Navigation

| Shortcut | Action |
|----------|--------|
| `prefix + n` | Next window |
| `prefix + p` | Previous window |
| `prefix + 0-9` | Switch to window number |
| `prefix + w` | Window list (interactive) |

### Session Management

| Shortcut | Action |
|----------|--------|
| `prefix + o` | Open sessionx (session manager) |
| `prefix + d` | Detach from session |
| `prefix + s` | Session list |
| `prefix + $` | Rename session |

### Copy Mode (Vi Keys)

| Shortcut | Action |
|----------|--------|
| `prefix + [` | Enter copy mode |
| `v` | Start selection (in copy mode) |
| `y` | Copy selection (in copy mode) |
| `q` | Exit copy mode |

### Plugin Management

| Shortcut | Action |
|----------|--------|
| `prefix + I` | Install plugins |
| `prefix + U` | Update plugins |
| `prefix + Alt+u` | Uninstall unused plugins |

### Other Plugins

| Shortcut | Action |
|----------|--------|
| `prefix + \` | Open tmux-menus |
| `prefix + Tab` | Toggle sidebar (file tree) |

## Configuration

### Installation

```bash
cd ~/dotfiles/tmux
chmod +x tmux-setup.sh
./tmux-setup.sh
```

The setup script will:
1. Install TPM (Tmux Plugin Manager)
2. Create symlink to configuration
3. Install all plugins

### Manual Installation

```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Symlink configuration
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf

# Start tmux and install plugins
tmux
# Press prefix + I to install plugins
```

### Configuration File Location

```
~/.tmux.conf -> ~/dotfiles/tmux/.tmux.conf (symlink)
```

### Update Components

```bash
./tmux-setup.sh update
```

Or inside tmux: `prefix + U`

## Installed Plugins

| Plugin | Description |
|--------|-------------|
| tpm | Tmux Plugin Manager |
| tmux-sensible | Sensible default settings |
| catppuccin/tmux | Catppuccin theme |
| tmux-prefix-highlight | Shows when prefix is pressed |
| vim-tmux-navigator | Seamless vim/tmux navigation |
| tmux-sessionx | Session management with fzf |
| tmux-menus | Context menus |
| tmux-sidebar | File tree sidebar |
| tmux-yank | Clipboard support |
| tmux-resurrect | Session save/restore |
| tmux-continuum | Auto session save |

## Configuration Options

### General Settings

```bash
# True color support
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

# Mouse support
set -g mouse on

# Start window numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Scrollback buffer
set -g history-limit 50000
```

### Status Bar

The status bar uses the Catppuccin theme and displays:
- Session name
- Window list
- Date and time

```bash
# Status bar position
set -g status-position top

# Catppuccin flavor
set -g @catppuccin_flavor 'mocha'
```

### Session Persistence

Sessions are automatically saved and restored:

```bash
# Auto-save every 15 minutes
set -g @continuum-restore 'on'

# Save pane contents
set -g @resurrect-capture-pane-contents 'on'
```

## Common Operations

### Sessions

```bash
# Create new session
tmux new -s session-name

# Attach to session
tmux attach -t session-name

# List sessions
tmux ls

# Kill session
tmux kill-session -t session-name

# Rename session (inside tmux)
prefix + $
```

### Windows

```bash
# Create window
prefix + c

# Rename window
prefix + ,

# Close window
prefix + &

# Move window
prefix + .
```

### Panes

```bash
# Close pane
prefix + x

# Zoom/unzoom pane (fullscreen)
prefix + z

# Convert pane to window
prefix + !

# Swap panes
prefix + { or }
```

## Customization

### Changing the Prefix Key

Edit `~/.tmux.conf`:
```bash
# Change to Ctrl+Space
unbind C-a
set -g prefix C-Space
bind C-Space send-prefix
```

### Changing the Theme

```bash
# Use different Catppuccin flavor
set -g @catppuccin_flavor 'latte'    # Light theme
set -g @catppuccin_flavor 'frappe'   # Medium dark
set -g @catppuccin_flavor 'macchiato' # Dark
set -g @catppuccin_flavor 'mocha'    # Darkest (default)
```

### Adding Custom Keybindings

```bash
# Open specific directory in new window
bind D new-window -c "~/projects"

# Quick pane switch
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R

# Toggle synchronize-panes (type in all panes)
bind S setw synchronize-panes
```

## Troubleshooting

### Plugins Not Loading

1. Ensure TPM is installed:
   ```bash
   ls ~/.tmux/plugins/tpm
   ```

2. Install plugins: `prefix + I`

3. Check for errors:
   ```bash
   tmux source ~/.tmux.conf
   ```

### Colors Look Wrong

Ensure terminal supports true color:
```bash
# Test true color support
curl -s https://raw.githubusercontent.com/JohnMorales/dotfiles/master/colors/24-bit-color.sh | bash
```

Add to shell config:
```bash
export TERM="xterm-256color"
```

### Vim-Tmux Navigation Not Working

Ensure the vim plugin is also installed. In Neovim:
```vim
:Lazy sync
```

The plugin should be `christoomey/vim-tmux-navigator`.

### Session Not Restoring

Check tmux-resurrect:
```bash
# List saved sessions
ls ~/.tmux/resurrect/

# Manually restore
prefix + Ctrl+r

# Manually save
prefix + Ctrl+s
```

## Command Reference

```bash
# Common tmux commands
tmux                      # Start new session
tmux new -s name          # Start named session
tmux attach -t name       # Attach to session
tmux ls                   # List sessions
tmux kill-server          # Kill all sessions
tmux source ~/.tmux.conf  # Reload configuration

# Inside tmux
:new -s name              # Create new session
:rename-session name      # Rename current session
:list-keys                # List all keybindings
:show-options -g          # Show global options
```

## Resources

- [Tmux GitHub](https://github.com/tmux/tmux)
- [TPM - Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
- [Catppuccin for Tmux](https://github.com/catppuccin/tmux)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)
