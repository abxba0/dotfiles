#!/bin/bash
# Comprehensive Zsh Setup Script
# Combines: setup, update, and quick install functionality
# Usage: ./zsh-setup.sh [install|update|quick]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
PLUGINS_DIR="$ZSH_CUSTOM_DIR/plugins"
THEMES_DIR="$ZSH_CUSTOM_DIR/themes"

# ============================================
# Helper Functions
# ============================================

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo ""
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

clone_or_update() {
    local repo_url="$1"
    local target_dir="$2"
    local name
    name=$(basename "$target_dir")
    
    if [ -d "$target_dir/.git" ]; then
        print_info "Updating $name..."
        (cd "$target_dir" && git pull --quiet) || print_warn "Failed to update $name"
    elif [ -d "$target_dir" ]; then
        print_warn "$name directory exists but is not a git repo, skipping..."
    else
        print_info "Cloning $name..."
        git clone --depth=1 "$repo_url" "$target_dir" 2>/dev/null || print_warn "Failed to clone $name"
    fi
}

# ============================================
# Dependency Installation
# ============================================

install_dependencies() {
    local deps=("$@")

    if [ ${#deps[@]} -eq 0 ]; then
        return 0
    fi

    print_info "Installing missing dependencies: ${deps[*]}"

    # Detect package manager and install
    if command_exists apt-get; then
        print_info "Detected apt package manager (Debian/Ubuntu)"
        sudo apt update
        sudo apt install -y "${deps[@]}"
    elif command_exists dnf; then
        print_info "Detected dnf package manager (Fedora)"
        sudo dnf install -y "${deps[@]}"
    elif command_exists yum; then
        print_info "Detected yum package manager (CentOS/RHEL)"
        sudo yum install -y "${deps[@]}"
    elif command_exists pacman; then
        print_info "Detected pacman package manager (Arch)"
        sudo pacman -S --noconfirm "${deps[@]}"
    elif command_exists brew; then
        print_info "Detected Homebrew (macOS)"
        brew install "${deps[@]}"
    else
        print_error "Could not detect package manager. Please install manually: ${deps[*]}"
        exit 1
    fi

    # Verify installation
    local failed_deps=()
    for dep in "${deps[@]}"; do
        if ! command_exists "$dep"; then
            failed_deps+=("$dep")
        fi
    done

    if [ ${#failed_deps[@]} -ne 0 ]; then
        print_error "Failed to install: ${failed_deps[*]}"
        exit 1
    fi

    print_info "Dependencies installed successfully!"
}

# ============================================
# Dependency Checking
# ============================================

check_dependencies() {
    print_info "Checking dependencies..."

    local missing_deps=()

    for dep in git curl zsh; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_warn "Missing dependencies: ${missing_deps[*]}"
        print_info "Attempting to install automatically..."
        install_dependencies "${missing_deps[@]}"
    fi

    print_info "All dependencies satisfied!"
}

# ============================================
# Oh-My-Zsh Installation
# ============================================

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Oh-My-Zsh not found. Installing..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_info "Oh-My-Zsh installed successfully!"
    else
        print_info "Oh-My-Zsh already installed."
    fi
}

# ============================================
# Theme Installation
# ============================================

install_powerlevel10k() {
    local p10k_dir="$THEMES_DIR/powerlevel10k"
    clone_or_update "https://github.com/romkatv/powerlevel10k.git" "$p10k_dir"
}

# ============================================
# Plugin Installation
# ============================================

install_plugins() {
    mkdir -p "$PLUGINS_DIR"
    
    print_info "Installing/updating Zsh plugins..."
    
    # Core plugins from zsh-users
    clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" "$PLUGINS_DIR/zsh-autosuggestions"
    clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$PLUGINS_DIR/zsh-syntax-highlighting"
    clone_or_update "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "$PLUGINS_DIR/fast-syntax-highlighting"
    clone_or_update "https://github.com/zsh-users/zsh-completions.git" "$PLUGINS_DIR/zsh-completions"
    clone_or_update "https://github.com/zsh-users/zsh-history-substring-search.git" "$PLUGINS_DIR/zsh-history-substring-search"
    
    # Additional useful plugins
    clone_or_update "https://github.com/wting/autojump.git" "$PLUGINS_DIR/autojump"
    
    print_info "All plugins installed/updated successfully!"
}

install_fzf() {
    if [ -d "$HOME/.fzf/.git" ]; then
        print_info "Updating FZF..."
        (cd "$HOME/.fzf" && git pull --quiet)
    elif [ -d "$HOME/.fzf" ]; then
        print_warn "FZF directory exists but is not a git repo"
        return
    else
        print_info "Installing FZF..."
        git clone --depth=1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    fi
    
    print_info "Running FZF installation..."
    "$HOME/.fzf/install" --all --no-bash --no-fish --no-update-rc
    print_info "FZF installed/updated!"
}

# ============================================
# Configuration Creation
# ============================================

create_zshrc() {
    local use_p10k="${1:-no}"
    local use_fast_syntax="${2:-yes}"
    local zshrc_path="$HOME/.zshrc"

    # Backup existing .zshrc
    if [ -f "$zshrc_path" ]; then
        local backup_path="${zshrc_path}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing .zshrc to $backup_path"
        cp "$zshrc_path" "$backup_path"
    fi

    print_info "Creating enhanced .zshrc configuration..."

    # Determine syntax highlighting plugin
    local syntax_plugin
    if [ "$use_fast_syntax" = "yes" ]; then
        syntax_plugin="fast-syntax-highlighting"
    else
        syntax_plugin="zsh-syntax-highlighting"
    fi

    # Determine theme
    local theme_name
    if [ "$use_p10k" = "yes" ]; then
        theme_name="powerlevel10k/powerlevel10k"
    else
        theme_name="robbyrussell"
    fi

    cat > "$zshrc_path" << 'ZSHRC_EOF'
# ============================================================================
# Oh My Zsh Configuration
# ============================================================================
# Modern zsh setup with enhanced productivity features
# Compatible with: macOS, Linux, WSL
# Generated by zsh-enhanced-setup.sh
# ============================================================================

ZSHRC_EOF

    # Add Powerlevel10k instant prompt if using p10k
    if [ "$use_p10k" = "yes" ]; then
        cat >> "$zshrc_path" << 'ZSHRC_EOF'
# ============================================================================
# Powerlevel10k Instant Prompt
# ============================================================================
# Enable Powerlevel10k instant prompt (should stay close to the top of ~/.zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSHRC_EOF
    fi

    cat >> "$zshrc_path" << ZSHRC_EOF
# Path to Oh My Zsh installation
export ZSH="\$HOME/.oh-my-zsh"

# ============================================================================
# Theme Configuration
# ============================================================================
# Set name of the theme to load
ZSH_THEME="$theme_name"

# ============================================================================
# Oh My Zsh Update Configuration
# ============================================================================
# Update Oh My Zsh automatically without prompting
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

# ============================================================================
# History Configuration
# ============================================================================
# Save more command history
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# Append to history immediately (not when shell exits)
setopt INC_APPEND_HISTORY
# Share history between all sessions
setopt SHARE_HISTORY
# Remove duplicates from history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
# Don't save commands starting with space
setopt HIST_IGNORE_SPACE
# Remove extra blanks from commands
setopt HIST_REDUCE_BLANKS

# ============================================================================
# Oh My Zsh Plugins
# ============================================================================
# Standard plugins from \$ZSH/plugins/
# Custom plugins from \$ZSH_CUSTOM/plugins/
plugins=(
    # Core Git functionality
    git

    # Enhanced command suggestions and syntax
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    $syntax_plugin

    # Fuzzy finder integration
    fzf

    # Docker (useful for containerization)
    docker
    docker-compose

    # Common utilities
    command-not-found
    colored-man-pages
    extract

    # Directory navigation
    z

    # System-specific plugins
    # Uncomment based on your OS
    # macos      # macOS specific
    # ubuntu     # Ubuntu specific
)

# ============================================================================
# Load Oh My Zsh
# ============================================================================
source \$ZSH/oh-my-zsh.sh

# ============================================================================
# General Environment Variables
# ============================================================================
# Preferred editor for local and remote sessions
export EDITOR='vim'
export VISUAL='vim'

# Set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Add local bin to PATH
export PATH="\$HOME/.local/bin:\$PATH"

# ============================================================================
# fzf Configuration
# ============================================================================
# Use fd/rg for better performance if available
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="\$FZF_DEFAULT_COMMAND"
elif command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="\$FZF_DEFAULT_COMMAND"
fi

# fzf color scheme and options
export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --color=fg:#d0d0d0,bg:#121212,hl:#5f87af
    --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
    --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
    --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
'

# Add bat preview if available
if command -v bat &> /dev/null; then
    export FZF_DEFAULT_OPTS="\$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null'"
fi

# ============================================================================
# General Aliases
# ============================================================================
# Better ls with exa/eza (if available)
if command -v eza &> /dev/null; then
    alias ls='eza --icons'
    alias ll='eza -l --icons --git'
    alias la='eza -la --icons --git'
    alias lt='eza --tree --level=2 --icons'
elif command -v exa &> /dev/null; then
    alias ls='exa --icons'
    alias ll='exa -l --icons --git'
    alias la='exa -la --icons --git'
    alias lt='exa --tree --level=2 --icons'
else
    alias ll='ls -lh'
    alias la='ls -lah'
    alias lt='ls -lahtr'
fi

# Better cat with bat (if available)
if command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
    alias catt='bat'
fi

# Git shortcuts (in addition to Oh My Zsh git plugin)
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gds='git diff --staged'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gba='git branch -a'
alias glog='git log --oneline --graph --decorate'
alias gloga='git log --oneline --graph --decorate --all'
alias gst='git stash'
alias gstp='git stash pop'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Quick edit configs
alias zshrc='\${EDITOR:-vim} ~/.zshrc'
alias reload='source ~/.zshrc && echo "Zsh config reloaded!"'

# System utilities
alias h='history'
alias path='echo -e \${PATH//:/\\n}'
alias ports='netstat -tulanp 2>/dev/null || ss -tulanp'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ============================================================================
# Utility Functions
# ============================================================================

# Create directory and cd into it
mkcd() {
    mkdir -p "\$1" && cd "\$1"
}

# Extract any archive
extract() {
    if [ -f "\$1" ]; then
        case \$1 in
            *.tar.bz2)   tar xjf "\$1"    ;;
            *.tar.gz)    tar xzf "\$1"    ;;
            *.tar.xz)    tar xJf "\$1"    ;;
            *.bz2)       bunzip2 "\$1"    ;;
            *.rar)       unrar x "\$1"    ;;
            *.gz)        gunzip "\$1"     ;;
            *.tar)       tar xf "\$1"     ;;
            *.tbz2)      tar xjf "\$1"    ;;
            *.tgz)       tar xzf "\$1"    ;;
            *.zip)       unzip "\$1"      ;;
            *.Z)         uncompress "\$1" ;;
            *.7z)        7z x "\$1"       ;;
            *.xz)        xz -d "\$1"      ;;
            *)           echo "'\$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'\$1' is not a valid file"
    fi
}

# Search command history with fzf
fh() {
    print -z \$( ([ -n "\$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\\\/\\\\\\\\/g')
}

# Search and kill process
fkill() {
    local pid
    pid=\$(ps -ef | sed 1d | fzf -m | awk '{print \$2}')

    if [ "x\$pid" != "x" ]; then
        echo "\$pid" | xargs kill -"\${1:-9}"
    fi
}

# Find file by name
ff() {
    find . -type f -iname "*\$1*"
}

# Find directory by name (don't shadow fd command if installed)
fdir() {
    find . -type d -iname "*\$1*"
}

# Create a backup of a file
backup() {
    cp "\$1" "\$1.backup.\$(date +%Y%m%d_%H%M%S)"
}

# Get external IP
myip() {
    curl -s https://ipinfo.io/ip
    echo ""
}

# Quick HTTP server
serve() {
    local port=\${1:-8000}
    python3 -m http.server "\$port" 2>/dev/null || python -m SimpleHTTPServer "\$port"
}

# ============================================================================
# ripgrep Configuration
# ============================================================================
export RIPGREP_CONFIG_PATH="\$HOME/.ripgreprc"

# ============================================================================
# Auto-suggestions Configuration
# ============================================================================
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ============================================================================
# Completion Configuration
# ============================================================================
# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colored completion
zstyle ':completion:*' list-colors "\${(s.:.)LS_COLORS}"

# Menu-style completion
zstyle ':completion:*' menu select

# ============================================================================
# Key Bindings
# ============================================================================
# History substring search with arrow keys
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Ctrl+R for history search with fzf
bindkey '^R' fzf-history-widget

# Ctrl+T for file search with fzf
bindkey '^T' fzf-file-widget

# Alt+C for cd with fzf
bindkey '\ec' fzf-cd-widget

# Home/End keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Delete key
bindkey '^[[3~' delete-char

# Ctrl+Arrow for word navigation
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# ============================================================================
# Powerlevel10k Configuration
# ============================================================================
# To customize prompt, run \`p10k configure\` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# Load additional local customizations
# ============================================================================
# Source local customizations if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================================================
# End of Configuration
# ============================================================================
ZSHRC_EOF

    # Source fzf if installed
    if [ -f "$HOME/.fzf.zsh" ]; then
        echo "" >> "$zshrc_path"
        echo "[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh" >> "$zshrc_path"
    fi

    print_info ".zshrc created successfully!"
}

# ============================================
# Update Functions
# ============================================

update_all() {
    print_header "Updating Zsh Components"
    
    # Update Oh-My-Zsh
    if [ -d "$HOME/.oh-my-zsh/.git" ]; then
        print_info "Updating Oh-My-Zsh..."
        (cd "$HOME/.oh-my-zsh" && git pull --quiet) && print_info "Oh-My-Zsh updated!" || print_warn "Failed to update Oh-My-Zsh"
    else
        print_warn "Oh-My-Zsh not found or not a git repo"
    fi
    
    # Update custom plugins
    if [ -d "$PLUGINS_DIR" ]; then
        print_info "Updating custom plugins..."
        for plugin_dir in "$PLUGINS_DIR"/*/; do
            if [ -d "$plugin_dir/.git" ]; then
                local plugin_name
                plugin_name=$(basename "$plugin_dir")
                print_info "  Updating $plugin_name..."
                (cd "$plugin_dir" && git pull --quiet) || print_warn "  Failed to update $plugin_name"
            fi
        done
        print_info "Custom plugins updated!"
    else
        print_warn "Custom plugins directory not found"
    fi
    
    # Update Powerlevel10k theme
    local p10k_dir="$THEMES_DIR/powerlevel10k"
    if [ -d "$p10k_dir/.git" ]; then
        print_info "Updating Powerlevel10k theme..."
        (cd "$p10k_dir" && git pull --quiet) && print_info "Powerlevel10k updated!" || print_warn "Failed to update Powerlevel10k"
    fi
    
    # Update FZF
    if [ -d "$HOME/.fzf/.git" ]; then
        print_info "Updating FZF..."
        (cd "$HOME/.fzf" && git pull --quiet)
        "$HOME/.fzf/install" --all --no-bash --no-fish --no-update-rc 2>/dev/null
        print_info "FZF updated!"
    fi
    
    print_header "Update Complete!"
    print_info "Restart your shell to apply updates: exec zsh"
}

# ============================================
# Quick Install (Minimal)
# ============================================

quick_install() {
    print_header "Quick Zsh Setup"
    
    check_dependencies
    install_oh_my_zsh
    
    mkdir -p "$PLUGINS_DIR"
    
    print_info "Installing essential plugins..."
    clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" "$PLUGINS_DIR/zsh-autosuggestions"
    clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$PLUGINS_DIR/zsh-syntax-highlighting"
    clone_or_update "https://github.com/zsh-users/zsh-completions.git" "$PLUGINS_DIR/zsh-completions"
    clone_or_update "https://github.com/zsh-users/zsh-history-substring-search.git" "$PLUGINS_DIR/zsh-history-substring-search"
    
    create_zshrc "no" "no"
    
    print_header "Quick Setup Complete!"
    print_info "Run: exec zsh"
}

# ============================================
# Full Interactive Install
# ============================================

full_install() {
    print_header "Enhanced Zsh Setup Script"
    
    # Check dependencies
    check_dependencies
    
    # Install Oh-My-Zsh
    install_oh_my_zsh
    
    # Ask about Powerlevel10k
    echo ""
    local use_p10k="no"
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Install Powerlevel10k theme? (y/n): ")" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        use_p10k="yes"
        install_powerlevel10k
    fi
    
    # Ask about syntax highlighting
    echo ""
    local use_fast_syntax="yes"
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Use fast-syntax-highlighting (faster) instead of zsh-syntax-highlighting? (y/n): ")" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        use_fast_syntax="no"
    fi
    
    # Install plugins
    echo ""
    install_plugins
    
    # Install FZF
    echo ""
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Install FZF (fuzzy finder)? (y/n): ")" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_fzf
    fi
    
    # Create .zshrc
    echo ""
    create_zshrc "$use_p10k" "$use_fast_syntax"
    
    # Ask about default shell
    echo ""
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Set Zsh as default shell? (y/n): ")" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ "$SHELL" != "$(which zsh)" ]; then
            print_info "Setting Zsh as default shell..."
            local zsh_path
            zsh_path=$(which zsh)
            if grep -q "$zsh_path" /etc/shells; then
                chsh -s "$zsh_path"
                print_info "Default shell changed to Zsh!"
            else
                print_warn "$zsh_path is not in /etc/shells"
                print_info "You may need to add it manually: sudo sh -c 'echo $zsh_path >> /etc/shells'"
                print_info "Then run: chsh -s $zsh_path"
            fi
        else
            print_info "Zsh is already your default shell!"
        fi
    fi
    
    # Summary
    print_header "Installation Complete!"
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
    print_info "  $step_num. Update plugins anytime: $0 update"
    echo ""
    print_info "Enjoy your enhanced Zsh experience! 🚀"
    echo ""
}

# ============================================
# Usage Information
# ============================================

show_usage() {
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install   Full interactive installation (default)"
    echo "  update    Update Oh-My-Zsh, plugins, and themes"
    echo "  quick     Quick minimal installation (no prompts)"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Interactive full installation"
    echo "  $0 install      # Same as above"
    echo "  $0 update       # Update all components"
    echo "  $0 quick        # Quick setup with defaults"
    echo ""
}

# ============================================
# Main Entry Point
# ============================================

main() {
    local command="${1:-install}"
    
    case "$command" in
        install|setup)
            full_install
            ;;
        update|upgrade)
            update_all
            ;;
        quick|minimal)
            quick_install
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            print_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
