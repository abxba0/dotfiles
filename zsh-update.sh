#!/bin/bash
# Update all Zsh plugins and Oh-My-Zsh

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo ""
print_info "=========================================="
print_info "  Updating Zsh Components"
print_info "=========================================="
echo ""

# Update Oh-My-Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    print_info "Updating Oh-My-Zsh..."
    (cd "$HOME/.oh-my-zsh" && git pull --quiet)
    print_info "Oh-My-Zsh updated!"
else
    print_warn "Oh-My-Zsh not found at ~/.oh-my-zsh"
fi

# Update custom plugins
CUSTOM_PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
if [ -d "$CUSTOM_PLUGINS_DIR" ]; then
    print_info "Updating custom plugins..."
    (
        cd "$CUSTOM_PLUGINS_DIR" || { print_error "Failed to access plugins directory"; exit 1; }
        for plugin in */; do
            if [ -d "$plugin/.git" ]; then
                plugin_name=$(basename "$plugin")
                print_info "  Updating $plugin_name..."
                (cd "$plugin" && git pull --quiet)
            fi
        done
    ) || print_error "Plugin update failed"
    print_info "Custom plugins updated!"
else
    print_warn "Custom plugins directory not found"
fi

# Update Powerlevel10k theme if installed
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ -d "$P10K_DIR/.git" ]; then
    print_info "Updating Powerlevel10k theme..."
    (cd "$P10K_DIR" && git pull --quiet)
    print_info "Powerlevel10k updated!"
fi

# Update FZF
if [ -d "$HOME/.fzf/.git" ]; then
    print_info "Updating FZF..."
    (cd "$HOME/.fzf" && git pull --quiet)
    print_info "Running FZF installation..."
    "$HOME/.fzf/install" --all --no-bash --no-fish --no-update-rc
    print_info "FZF updated!"
else
    print_warn "FZF not found at ~/.fzf"
fi

echo ""
print_info "=========================================="
print_info "  Update Complete!"
print_info "=========================================="
echo ""
print_info "Restart your shell to apply updates: exec zsh"
echo ""
