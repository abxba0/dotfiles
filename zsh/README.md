# Zsh Setup Script

A simple script to set up Zsh with useful plugins and configuration.

## Requirements

- Zsh installed
- Oh-My-Zsh installed
- Git

## Usage

```bash
bash zsh-enhanced-setup.sh
```

## What It Does

1. **Installs Plugins** to `~/.oh-my-zsh/custom/plugins/`:
   - zsh-autosuggestions
   - zsh-syntax-highlighting
   - zsh-completions
   - zsh-history-substring-search
   - fzf
   - autojump

2. **Creates `.zshrc`** with:
   - All plugins enabled
   - History configuration (10000 entries)
   - Key bindings for history substring search (up/down arrows)
   - Basic aliases:
     - `ll` → `ls -lah`
     - `gs` → `git status`
     - `ga` → `git add`
     - `gc` → `git commit`
     - `gp` → `git push`

3. **Backups** existing `.zshrc` to `.zshrc.backup`

## After Installation

Restart your shell:
```bash
exec zsh
```

## Idempotent

Safe to re-run. Existing plugins are skipped, and `.zshrc` is backed up before overwriting.

## Customization

After running the setup, you can customize `~/.zshrc`:

1. **Change theme**: Edit `ZSH_THEME="robbyrussell"` to your preferred theme
2. **Add more plugins**: Add to the `plugins=(...)` array
3. **Add custom aliases**: Append to the bottom of the file

## Troubleshooting

**Issue**: Plugins not loading
- Run `exec zsh` to restart shell

**Issue**: Oh-My-Zsh not found
- Install Oh-My-Zsh first: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
