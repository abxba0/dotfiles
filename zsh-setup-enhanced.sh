#!/bin/bash
# Enhanced Zsh Setup Script with comprehensive features
# Includes: dependency checking, Oh-My-Zsh installation, plugin management,
# enhanced configuration, and interactive options

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Clone or update a git repository
clone_or_update() {
    local repo_url="$1"
    local target_dir="$2"
    
    if [ -d "$target_dir/.git" ]; then
        print_info "Updating $(basename "$target_dir")..."
        (cd "$target_dir" && git pull --quiet)
    else
        print_info "Cloning $(basename "$target_dir")..."
        git clone --depth=1 "$repo_url" "$target_dir"
    fi
}

# Check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    local missing_deps=()
    
    if ! command_exists git; then
        missing_deps+=("git")
    fi
    
    if ! command_exists curl; then
        missing_deps+=("curl")
    fi
    
    if ! command_exists zsh; then
        missing_deps+=("zsh")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install them first:"
        print_info "  Ubuntu/Debian: sudo apt install ${missing_deps[*]}"
        print_info "  macOS: brew install ${missing_deps[*]}"
        exit 1
    fi
    
    print_info "All dependencies satisfied!"
}

# Install Oh-My-Zsh if not present
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Oh-My-Zsh not found. Installing..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_info "Oh-My-Zsh installed successfully!"
    else
        print_info "Oh-My-Zsh already installed."
    fi
}

# Install Powerlevel10k theme
install_powerlevel10k() {
    local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    clone_or_update "https://github.com/romkatv/powerlevel10k.git" "$p10k_dir"
}

# Install plugins
install_plugins() {
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "$plugins_dir"
    
    print_info "Installing/updating Zsh plugins..."
    
    # Install custom plugins
    clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" "$plugins_dir/zsh-autosuggestions"
    clone_or_update "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "$plugins_dir/fast-syntax-highlighting"
    clone_or_update "https://github.com/zsh-users/zsh-completions.git" "$plugins_dir/zsh-completions"
    clone_or_update "https://github.com/zsh-users/zsh-history-substring-search.git" "$plugins_dir/zsh-history-substring-search"
    
    # Install FZF
    if [ -d "$HOME/.fzf/.git" ]; then
        print_info "Updating FZF..."
        (cd "$HOME/.fzf" && git pull --quiet)
    else
        print_info "Installing FZF..."
        git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    fi
    
    print_info "Running FZF installation..."
    "$HOME/.fzf/install" --all --no-bash --no-fish --no-update-rc
    
    print_info "All plugins installed/updated successfully!"
}

# Create enhanced .zshrc
create_zshrc() {
    local zshrc_path="$HOME/.zshrc"
    local use_p10k="$1"
    
    # Backup existing .zshrc
    if [ -f "$zshrc_path" ]; then
        local backup_path
        backup_path="${zshrc_path}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing .zshrc to $backup_path"
        cp "$zshrc_path" "$backup_path"
    fi
    
    print_info "Creating enhanced .zshrc configuration..."
    
    # Determine theme
    local theme_config
    if [ "$use_p10k" = "yes" ]; then
        theme_config='ZSH_THEME="powerlevel10k/powerlevel10k"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'
    else
        theme_config='ZSH_THEME="robbyrussell"'
    fi
    
    cat > "$zshrc_path" << EOF
# Path to Oh-My-Zsh installation
export ZSH="\$HOME/.oh-my-zsh"

# Theme configuration
$theme_config

# Plugins
# Add/remove plugins as needed
# For Docker/Kubernetes users, uncomment: docker kubectl
plugins=(
  git
  z
  colored-man-pages
  command-not-found
  zsh-autosuggestions
  fast-syntax-highlighting
  zsh-completions
  zsh-history-substring-search
  # docker
  # kubectl
)

# Load Oh-My-Zsh
source "\$ZSH/oh-my-zsh.sh"

# ============================================
# History Configuration
# ============================================
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="\$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

# ============================================
# Environment Variables
# ============================================
export EDITOR="\${EDITOR:-vim}"
export VISUAL="\${VISUAL:-vim}"
export PAGER="\${PAGER:-less}"
export LANG="\${LANG:-en_US.UTF-8}"

# ============================================
# Navigation Aliases
# ============================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ============================================
# List Aliases
# ============================================
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# ============================================
# Git Aliases
# ============================================
alias gaa='git add --all'
alias gcm='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# ============================================
# Utility Aliases
# ============================================
alias zshrc='\${EDITOR:-vim} ~/.zshrc'
alias reload='source ~/.zshrc'
alias update-zsh='~/.oh-my-zsh/tools/upgrade.sh'

# Safety aliases (interactive mode)
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ============================================
# Useful Functions
# ============================================

# Create directory and cd into it
mkcd() {
    mkdir -p "\$1" && cd "\$1"
}

# Extract any archive type
extract() {
    if [ -f "\$1" ]; then
        case "\$1" in
            *.tar.bz2)   tar xjf "\$1"     ;;
            *.tar.gz)    tar xzf "\$1"     ;;
            *.bz2)       bunzip2 "\$1"     ;;
            *.rar)       unrar x "\$1"     ;;
            *.gz)        gunzip "\$1"      ;;
            *.tar)       tar xf "\$1"      ;;
            *.tbz2)      tar xjf "\$1"     ;;
            *.tgz)       tar xzf "\$1"     ;;
            *.zip)       unzip "\$1"       ;;
            *.Z)         uncompress "\$1"  ;;
            *.7z)        7z x "\$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================
# Completion Configuration
# ============================================
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Faster completion cache
# Regenerate cache only if .zcompdump is older than 24 hours
autoload -Uz compinit
if [[ -n \${ZDOTDIR:-\$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# ============================================
# Key Bindings
# ============================================
# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ============================================
# FZF Configuration
# ============================================
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
    
    # Custom FZF configuration
    export FZF_DEFAULT_OPTS='
        --height 40%
        --layout=reverse
        --border
        --inline-info
        --color=fg:#d0d0d0,bg:#121212,hl:#5f87af
        --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
        --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
        --color=marker:#87ff00,spinner:#af5fff,header:#87afaf'
    
    # Use fd or ripgrep if available
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="\$FZF_DEFAULT_COMMAND"
    elif command -v rg >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
        export FZF_CTRL_T_COMMAND="\$FZF_DEFAULT_COMMAND"
    fi
fi

# ============================================
# Additional Tool Aliases (if installed)
# ============================================
# Uncomment if you have these tools installed
# command -v bat >/dev/null && alias cat='bat'
# command -v exa >/dev/null && alias ls='exa'
# command -v nvim >/dev/null && alias vim='nvim'

# ============================================
# Custom Configuration
# ============================================
# Add your custom configuration below this line
EOF

    print_info ".zshrc created successfully!"
}

# Main installation
main() {
    echo ""
    print_info "=========================================="
    print_info "  Enhanced Zsh Setup Script"
    print_info "=========================================="
    echo ""
    
    # Check dependencies
    check_dependencies
    
    # Install Oh-My-Zsh
    install_oh_my_zsh
    
    # Ask about Powerlevel10k
    echo ""
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Install Powerlevel10k theme? (y/n): ")" -n 1 -r
    echo ""
    use_p10k="no"
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        use_p10k="yes"
        install_powerlevel10k
    fi
    
    # Install plugins
    echo ""
    install_plugins
    
    # Create .zshrc
    echo ""
    create_zshrc "$use_p10k"
    
    # Ask about default shell
    echo ""
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Set Zsh as default shell? (y/n): ")" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$SHELL" != "$(which zsh)" ]; then
            print_info "Setting Zsh as default shell..."
            if grep -q "$(which zsh)" /etc/shells; then
                chsh -s "$(which zsh)"
                print_info "Default shell changed to Zsh!"
            else
                print_warn "$(which zsh) is not in /etc/shells"
                print_info "Please add it manually or contact your administrator"
            fi
        else
            print_info "Zsh is already your default shell!"
        fi
    fi
    
    # Summary
    echo ""
    print_info "=========================================="
    print_info "  Installation Complete!"
    print_info "=========================================="
    echo ""
    print_info "Next steps:"
    local step_num=1
    print_info "  $step_num. Start a new shell session: exec zsh"
    step_num=$((step_num + 1))
    if [ "$use_p10k" = "yes" ]; then
        print_info "  $step_num. Configure Powerlevel10k: p10k configure"
        step_num=$((step_num + 1))
    fi
    print_info "  $step_num. Customize ~/.zshrc as needed"
    step_num=$((step_num + 1))
    print_info "  $step_num. Update plugins anytime: bash zsh-update.sh"
    echo ""
    print_info "Enjoy your enhanced Zsh experience! 🚀"
    echo ""
}

# Run main function
main
