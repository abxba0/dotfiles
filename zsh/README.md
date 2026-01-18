# Zsh Enhanced Setup Script

Comprehensive Zsh setup with Oh-My-Zsh, plugins, themes, and productivity features.

## Usage

```bash
./zsh-enhanced-setup.sh [command]
```

### Commands

| Command | Description |
|---------|-------------|
| `install` | Full interactive installation (default) |
| `update` | Update Oh-My-Zsh, plugins, and themes |
| `quick` | Quick minimal installation (no prompts) |
| `help` | Show help message |

### Examples

```bash
./zsh-enhanced-setup.sh           # Interactive full installation
./zsh-enhanced-setup.sh install   # Same as above
./zsh-enhanced-setup.sh update    # Update all components
./zsh-enhanced-setup.sh quick     # Quick setup with defaults
```

## Features

### Installation
- Dependency checking (git, curl, zsh)
- Automatic Oh-My-Zsh installation
- Interactive prompts for optional components
- Timestamped backups of existing `.zshrc`

### Plugins Installed
- zsh-autosuggestions
- zsh-syntax-highlighting / fast-syntax-highlighting
- zsh-completions
- zsh-history-substring-search
- autojump
- FZF (optional)

### Optional Themes
- Powerlevel10k (interactive prompt)

### .zshrc Configuration

**History** (50,000 entries):
- Shared between sessions
- Duplicate removal
- Ignore commands starting with space

**Aliases included**:
- Git shortcuts: `gs`, `ga`, `gaa`, `gc`, `gcm`, `gp`, `gpl`, `gd`, `gds`, `gco`, `gcb`, `gb`, `gba`, `glog`, `gloga`, `gst`, `gstp`
- Directory navigation: `..`, `...`, `....`, `.....`, `~`, `-`
- Config editing: `zshrc`, `reload`
- System utilities: `h`, `path`, `ports`, `now`, `week`
- Safety: `rm -i`, `cp -i`, `mv -i`
- Colored grep: `grep`, `fgrep`, `egrep`
- Better ls/cat (if eza/exa/bat installed)

**Utility functions**:
- `mkcd` - Create directory and cd into it
- `extract` - Extract any archive format
- `fh` - Search command history with fzf
- `fkill` - Search and kill process
- `ff` - Find file by name
- `fdir` - Find directory by name
- `backup` - Create timestamped backup of a file
- `myip` - Get external IP
- `serve` - Quick HTTP server

**FZF configuration**:
- Uses `fd` or `rg` if available
- Custom color scheme
- Preview with `bat` if available

**Key bindings**:
- `Up/Down` - History substring search
- `Ctrl+R` - FZF history search
- `Ctrl+T` - FZF file search
- `Alt+C` - FZF cd
- `Home/End` - Beginning/end of line
- `Ctrl+Arrow` - Word navigation

### Local Customizations

Add custom settings to `~/.zshrc.local` - it's automatically sourced if present.

## After Installation

1. Start a new shell: `exec zsh`
2. Configure Powerlevel10k (if installed): `p10k configure`
3. Customize `~/.zshrc` as needed

## Updating

Run anytime to update all components:
```bash
./zsh-enhanced-setup.sh update
```

## Troubleshooting

**Plugins not loading**: Run `exec zsh` to restart shell

**Permission denied changing shell**: Ensure zsh is in `/etc/shells`:
```bash
sudo sh -c 'echo $(which zsh) >> /etc/shells'
chsh -s $(which zsh)
```

**Oh-My-Zsh installation fails**: Install manually:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
