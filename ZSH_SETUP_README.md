# Zsh Setup Scripts

Two versions available for different needs:

## Quick Setup (Original)

**File**: `zsh-setup.sh`

- Minimal dependencies
- Fast installation
- Assumes Oh-My-Zsh is installed

**Usage**:
```bash
bash zsh-setup.sh
```

## Enhanced Setup (Recommended)

**File**: `zsh-setup-enhanced.sh`

- Full dependency checking
- Installs Oh-My-Zsh automatically
- Interactive theme selection
- Comprehensive .zshrc configuration
- Idempotent (safe to re-run)

**Usage**:
```bash
bash zsh-setup-enhanced.sh
```

**Features**:
- ✅ Dependency verification
- ✅ Oh-My-Zsh installation
- ✅ Plugin management (install/update)
- ✅ Optional Powerlevel10k theme
- ✅ Enhanced aliases and functions
- ✅ FZF with custom configuration
- ✅ Automatic backups
- ✅ Colored output

## Updating Plugins

**File**: `zsh-update.sh`

Update all plugins and Oh-My-Zsh:
```bash
bash zsh-update.sh
```

## Recommended Additional Tools

For the best experience, install these tools:

### macOS (Homebrew)
```bash
brew install bat exa ripgrep fd neovim
```

### Ubuntu/Debian
```bash
# Note: 'bat' is installed as 'batcat' on Ubuntu/Debian
sudo apt install bat exa ripgrep fd-find neovim
# Create symlinks for easier usage
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
ln -s /usr/bin/fdfind ~/.local/bin/fd
# Add ~/.local/bin to PATH if not already present
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

### Aliases for these tools

Add to your `~/.zshrc`:
```bash
alias cat='bat'
alias ls='exa'
alias find='fd'
alias grep='rg'
```

## Customization

After running the setup, customize `~/.zshrc`:

1. **Enable Docker/Kubernetes plugins** (if you use them):
   ```bash
   # Uncomment in the plugins array
   plugins=(... docker kubectl)
   ```

2. **Configure Powerlevel10k** (if installed):
   ```bash
   p10k configure
   ```

3. **Add custom aliases** at the bottom of .zshrc

## Troubleshooting

**Issue**: Plugins not loading
- Solution: Run `exec zsh` to restart shell

**Issue**: Permission denied when changing shell
- Solution: Make sure `/usr/bin/zsh` is in `/etc/shells`

**Issue**: Oh-My-Zsh installation fails
- Solution: Install manually: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
