# ============================================================================
# Oh My Zsh Configuration
# ============================================================================
# Modern zsh setup with enhanced productivity features
# Compatible with: macOS, Linux, WSL
# ============================================================================

# ============================================================================
# Powerlevel10k Instant Prompt
# ============================================================================
# Enable Powerlevel10k instant prompt (should stay close to the top of ~/.zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# ============================================================================
# Theme Configuration
# ============================================================================
# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

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
# Standard plugins from $ZSH/plugins/
# Custom plugins from $ZSH_CUSTOM/plugins/
plugins=(
    # Core Git functionality
    git

    # Enhanced command suggestions and syntax
    zsh-autosuggestions
    zsh-completions
    zsh-history-substring-search
    fast-syntax-highlighting

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
source $ZSH/oh-my-zsh.sh

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
export PATH="$HOME/.local/bin:$PATH"

# ============================================================================
# fzf Configuration
# ============================================================================
# Use fd/rg for better performance if available
if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
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
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null'"
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
alias zshrc='${EDITOR:-vim} ~/.zshrc'
alias reload='source ~/.zshrc && echo "Zsh config reloaded!"'

# System utilities
alias h='history'
alias path='echo -e ${PATH//:/\\n}'
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
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"    ;;
            *.tar.gz)    tar xzf "$1"    ;;
            *.tar.xz)    tar xJf "$1"    ;;
            *.bz2)       bunzip2 "$1"    ;;
            *.rar)       unrar x "$1"    ;;
            *.gz)        gunzip "$1"     ;;
            *.tar)       tar xf "$1"     ;;
            *.tbz2)      tar xjf "$1"    ;;
            *.tgz)       tar xzf "$1"    ;;
            *.zip)       unzip "$1"      ;;
            *.Z)         uncompress "$1" ;;
            *.7z)        7z x "$1"       ;;
            *.xz)        xz -d "$1"      ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Search command history with fzf
fh() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# Search and kill process
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]; then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}

# Find file by name
ff() {
    find . -type f -iname "*$1*"
}

# Find directory by name
fd() {
    find . -type d -iname "*$1*"
}

# Create a backup of a file
backup() {
    cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
}

# Get external IP
myip() {
    curl -s https://ipinfo.io/ip
    echo ""
}

# Quick HTTP server
serve() {
    local port=${1:-8000}
    python3 -m http.server "$port" 2>/dev/null || python -m SimpleHTTPServer "$port"
}

# ============================================================================
# ripgrep Configuration
# ============================================================================
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

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
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

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
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# Load additional local customizations
# ============================================================================
# Source local customizations if they exist
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================================================
# End of Configuration
# ============================================================================

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
