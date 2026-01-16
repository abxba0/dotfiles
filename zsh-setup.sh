#!/bin/bash
# One-script Zsh + Plugins setup

set -e

PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

echo "=== Installing Zsh Plugins ==="
mkdir -p "$PLUGINS_DIR"

# Install plugins
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGINS_DIR/zsh-autosuggestions" 2>/dev/null || echo "zsh-autosuggestions already exists"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting" 2>/dev/null || echo "zsh-syntax-highlighting already exists"
git clone --depth=1 https://github.com/zsh-users/zsh-completions.git "$PLUGINS_DIR/zsh-completions" 2>/dev/null || echo "zsh-completions already exists"
git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search.git "$PLUGINS_DIR/zsh-history-substring-search" 2>/dev/null || echo "zsh-history-substring-search already exists"
git clone --depth=1 https://github.com/junegunn/fzf.git "$PLUGINS_DIR/fzf" 2>/dev/null || echo "fzf already exists"
git clone --depth=1 https://github.com/wting/autojump.git "$PLUGINS_DIR/autojump" 2>/dev/null || echo "autojump already exists"

echo "=== Creating .zshrc ==="
[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.backup"

cat > "$HOME/.zshrc" << 'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-history-substring-search
  fzf
  autojump
)

[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"

alias ll='ls -lah'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

autoload -Uz compinit && compinit -C

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
EOF

echo "=== Done! ==="
echo "Run: exec zsh"
