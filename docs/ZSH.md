# Zsh Documentation

Zsh (Z shell) configuration with Oh-My-Zsh, Powerlevel10k theme, and productivity plugins for an enhanced command-line experience.

## Key Bindings

### Navigation

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Search command history (fzf) |
| `Ctrl+T` | Search files (fzf) |
| `Alt+C` | Change directory (fzf) |
| `Up Arrow` | Previous command (history substring search) |
| `Down Arrow` | Next command (history substring search) |

### Line Editing

| Shortcut | Action |
|----------|--------|
| `Ctrl+A` / `Home` | Beginning of line |
| `Ctrl+E` / `End` | End of line |
| `Ctrl+Left` | Move word backward |
| `Ctrl+Right` | Move word forward |
| `Ctrl+W` | Delete word backward |
| `Delete` | Delete character |

### Auto-suggestions

| Shortcut | Action |
|----------|--------|
| `Right Arrow` | Accept suggestion |
| `Ctrl+Space` | Accept suggestion |

## Aliases

### File Listing (with eza/exa)

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | List with icons |
| `ll` | `eza -l --icons --git` | Long list with git status |
| `la` | `eza -la --icons --git` | Long list including hidden |
| `lt` | `eza --tree --level=2 --icons` | Tree view (2 levels) |

*Falls back to standard `ls` if eza/exa not installed.*

### Better cat (with bat)

| Alias | Command | Description |
|-------|---------|-------------|
| `cat` | `bat --style=plain --paging=never` | Cat with syntax highlighting |
| `catt` | `bat` | Full bat with line numbers |

### Git Shortcuts

| Alias | Command | Description |
|-------|---------|-------------|
| `gs` | `git status` | Show status |
| `ga` | `git add` | Add files |
| `gaa` | `git add --all` | Add all files |
| `gc` | `git commit` | Commit |
| `gcm` | `git commit -m` | Commit with message |
| `gp` | `git push` | Push |
| `gpl` | `git pull` | Pull |
| `gd` | `git diff` | Show diff |
| `gds` | `git diff --staged` | Show staged diff |
| `gco` | `git checkout` | Checkout |
| `gcb` | `git checkout -b` | Create and checkout branch |
| `gb` | `git branch` | List branches |
| `gba` | `git branch -a` | List all branches |
| `glog` | `git log --oneline --graph --decorate` | Pretty log |
| `gloga` | `git log --oneline --graph --decorate --all` | Pretty log (all branches) |
| `gst` | `git stash` | Stash changes |
| `gstp` | `git stash pop` | Pop stash |

### Directory Navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `.....` | `cd ../../../..` | Go up four directories |
| `~` | `cd ~` | Go to home |
| `-` | `cd -` | Go to previous directory |

### System Utilities

| Alias | Command | Description |
|-------|---------|-------------|
| `h` | `history` | Show history |
| `path` | `echo ${PATH//:/\n}` | Print PATH (one per line) |
| `ports` | `netstat -tulanp` / `ss -tulanp` | Show open ports |
| `now` | `date +"%Y-%m-%d %H:%M:%S"` | Current date/time |
| `week` | `date +%V` | Current week number |

### Configuration

| Alias | Command | Description |
|-------|---------|-------------|
| `zshrc` | `${EDITOR} ~/.zshrc` | Edit zsh config |
| `reload` | `source ~/.zshrc` | Reload zsh config |

### Safety Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `rm` | `rm -i` | Confirm before removing |
| `cp` | `cp -i` | Confirm before overwriting |
| `mv` | `mv -i` | Confirm before overwriting |

## Utility Functions

### mkcd - Create and enter directory

```bash
mkcd myproject
# Creates ~/myproject and cd into it
```

### extract - Extract any archive

```bash
extract archive.tar.gz
extract file.zip
extract package.7z
```

Supports: `.tar.bz2`, `.tar.gz`, `.tar.xz`, `.bz2`, `.rar`, `.gz`, `.tar`, `.tbz2`, `.tgz`, `.zip`, `.Z`, `.7z`, `.xz`

### fh - Search command history with fzf

```bash
fh
# Interactive fuzzy search through history
```

### fkill - Interactive process killer

```bash
fkill
# Select process(es) to kill with fzf
```

### ff - Find file by name

```bash
ff readme
# Finds all files containing "readme" in the name
```

### fdir - Find directory by name

```bash
fdir config
# Finds all directories containing "config" in the name
```

### backup - Create timestamped backup

```bash
backup important-file.txt
# Creates important-file.txt.backup.20240118_143022
```

### myip - Get external IP address

```bash
myip
# Returns your public IP address
```

### serve - Quick HTTP server

```bash
serve          # Serves current directory on port 8000
serve 3000     # Serves on port 3000
```

## Configuration

### Installation

```bash
cd ~/dotfiles/zsh
chmod +x zsh-enhanced-setup.sh
./zsh-enhanced-setup.sh
```

Installation options:
- `./zsh-enhanced-setup.sh install` - Full interactive installation
- `./zsh-enhanced-setup.sh quick` - Quick minimal installation
- `./zsh-enhanced-setup.sh update` - Update all components

### Manual Installation

```bash
# Install Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Copy configuration
cp ~/dotfiles/zsh/.zshrc ~/.zshrc

# Install plugins manually (see Plugins section)
```

### Configuration File Location

```
~/.zshrc
```

## Installed Plugins

### From Oh-My-Zsh

| Plugin | Description |
|--------|-------------|
| git | Git aliases and functions |
| fzf | Fuzzy finder integration |
| docker | Docker aliases and completion |
| docker-compose | Docker Compose aliases |
| command-not-found | Suggests packages for unknown commands |
| colored-man-pages | Colorized man pages |
| extract | Extract any archive with `extract` |
| z | Jump to frequently used directories |

### Custom Plugins

| Plugin | Description |
|--------|-------------|
| zsh-autosuggestions | Fish-like auto-suggestions |
| zsh-completions | Additional completions |
| zsh-history-substring-search | Search history by substring |
| fast-syntax-highlighting | Syntax highlighting |

### Theme

**Powerlevel10k** - A fast, highly customizable prompt.

Configure with:
```bash
p10k configure
```

## Configuration Options

### History Settings

```bash
HISTSIZE=50000           # Commands in memory
SAVEHIST=50000           # Commands in history file
HISTFILE=~/.zsh_history  # History file location

setopt INC_APPEND_HISTORY    # Append immediately
setopt SHARE_HISTORY         # Share between sessions
setopt HIST_IGNORE_ALL_DUPS  # No duplicates
setopt HIST_IGNORE_SPACE     # Ignore commands starting with space
```

### FZF Configuration

```bash
# Use fd for file search if available
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Default options
export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
'
```

### Auto-suggestions

```bash
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
```

## Customization

### Adding Local Configuration

Create `~/.zshrc.local` for machine-specific settings:

```bash
# ~/.zshrc.local
export MY_CUSTOM_VAR="value"
alias myalias='my-command'

# Work-specific settings
export WORK_API_KEY="xxx"
```

This file is automatically sourced if it exists.

### Changing the Theme

Edit `~/.zshrc`:
```bash
# Use different theme
ZSH_THEME="robbyrussell"      # Simple default
ZSH_THEME="agnoster"          # Popular powerline theme
ZSH_THEME="powerlevel10k/powerlevel10k"  # Current
```

### Adding Plugins

Add to the plugins array in `~/.zshrc`:
```bash
plugins=(
    git
    zsh-autosuggestions
    your-new-plugin    # Add here
)
```

For custom plugins, clone to `$ZSH_CUSTOM/plugins/`:
```bash
git clone https://github.com/user/plugin.git ${ZSH_CUSTOM}/plugins/plugin-name
```

### Environment Variables

```bash
# Default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Add to PATH
export PATH="$HOME/.local/bin:$PATH"
```

## Troubleshooting

### Slow Startup

Profile zsh startup:
```bash
time zsh -i -c exit
```

Disable unused plugins to speed up startup.

### Auto-suggestions Not Working

Ensure the plugin is installed:
```bash
ls $ZSH_CUSTOM/plugins/zsh-autosuggestions
```

Reinstall if needed:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
```

### FZF Not Working

Ensure fzf is installed:
```bash
which fzf

# Install if missing
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Powerlevel10k Icons Missing

Install a Nerd Font:
1. Download from [Nerd Fonts](https://www.nerdfonts.com/)
2. Install the font
3. Configure terminal to use it
4. Run `p10k configure`

### History Not Saving

Check history file permissions:
```bash
ls -la ~/.zsh_history
touch ~/.zsh_history
chmod 600 ~/.zsh_history
```

## Update All Components

```bash
./zsh-enhanced-setup.sh update
```

Or manually:
```bash
# Update Oh-My-Zsh
omz update

# Update custom plugins
cd ${ZSH_CUSTOM}/plugins/zsh-autosuggestions && git pull
cd ${ZSH_CUSTOM}/plugins/zsh-completions && git pull
# ... repeat for other plugins

# Update Powerlevel10k
cd ${ZSH_CUSTOM}/themes/powerlevel10k && git pull
```

## Resources

- [Oh-My-Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Zsh Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Fast Syntax Highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)
- [FZF](https://github.com/junegunn/fzf)
