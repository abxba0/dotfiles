#!/bin/bash

# Alacritty Setup Script
# This script installs Alacritty terminal emulator with tmux and zsh configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[x]${NC} $1"
}

# Check if running as root
check_sudo() {
    if ! command -v sudo &> /dev/null; then
        print_error "sudo is not installed. Please install sudo first."
        exit 1
    fi
}

# Install dependencies
install_dependencies() {
    print_status "Installing Alacritty dependencies..."
    sudo apt update
    sudo apt install -y cmake g++ pkg-config libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
    print_status "Dependencies installed successfully!"
}

# Install Alacritty
install_alacritty() {
    if command -v alacritty &> /dev/null; then
        print_warning "Alacritty is already installed: $(alacritty --version)"
        read -p "Do you want to reinstall? (y/N): " reinstall
        if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
            print_status "Skipping Alacritty installation."
            return
        fi
    fi

    print_status "Installing Alacritty..."
    sudo apt install -y alacritty
    print_status "Alacritty installed successfully!"
}

# Install tmux if not present
install_tmux() {
    if command -v tmux &> /dev/null; then
        print_status "tmux is already installed: $(tmux -V)"
    else
        print_status "Installing tmux..."
        sudo apt install -y tmux
        print_status "tmux installed successfully!"
    fi
}

# Install zsh if not present
install_zsh() {
    if command -v zsh &> /dev/null; then
        print_status "zsh is already installed: $(zsh --version)"
    else
        print_status "Installing zsh..."
        sudo apt install -y zsh
        print_status "zsh installed successfully!"
    fi
}

# Setup Alacritty configuration
setup_config() {
    print_status "Setting up Alacritty configuration..."

    # Create config directory
    ALACRITTY_CONFIG_DIR="$HOME/.config/alacritty"
    mkdir -p "$ALACRITTY_CONFIG_DIR"

    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Copy configuration file
    if [[ -f "$SCRIPT_DIR/alacritty.toml" ]]; then
        cp "$SCRIPT_DIR/alacritty.toml" "$ALACRITTY_CONFIG_DIR/alacritty.toml"
        print_status "Configuration copied to $ALACRITTY_CONFIG_DIR/alacritty.toml"
    else
        print_warning "alacritty.toml not found in $SCRIPT_DIR"
        print_status "Creating default configuration with tmux and zsh..."
        cat > "$ALACRITTY_CONFIG_DIR/alacritty.toml" << 'EOF'
# Alacritty Configuration
# Default shell: tmux with zsh

[shell]
program = "/usr/bin/tmux"
args = ["new-session", "-A", "-s", "main"]

[env]
TERM = "xterm-256color"

[window]
padding = { x = 10, y = 10 }
decorations = "full"
opacity = 0.95
title = "Alacritty"
dynamic_title = true

[font]
size = 12.0

[font.normal]
family = "monospace"
style = "Regular"

[font.bold]
family = "monospace"
style = "Bold"

[font.italic]
family = "monospace"
style = "Italic"

[cursor]
style = { shape = "Block", blinking = "On" }
blink_interval = 750

[selection]
save_to_clipboard = true
EOF
        print_status "Default configuration created."
    fi
}

# Setup tmux to use zsh
setup_tmux_zsh() {
    print_status "Configuring tmux to use zsh..."

    TMUX_CONF="$HOME/.tmux.conf"
    ZSH_PATH=$(which zsh)

    # Check if default-shell is already set
    if [[ -f "$TMUX_CONF" ]] && grep -q "default-shell" "$TMUX_CONF"; then
        print_warning "tmux default-shell already configured in $TMUX_CONF"
    else
        echo "" >> "$TMUX_CONF"
        echo "# Set zsh as default shell" >> "$TMUX_CONF"
        echo "set-option -g default-shell $ZSH_PATH" >> "$TMUX_CONF"
        print_status "tmux configured to use zsh as default shell."
    fi
}

# Main installation
main() {
    echo "========================================"
    echo "   Alacritty Setup Script"
    echo "   (with tmux and zsh integration)"
    echo "========================================"
    echo ""

    check_sudo

    print_status "Starting installation..."
    echo ""

    install_dependencies
    echo ""

    install_alacritty
    echo ""

    install_tmux
    echo ""

    install_zsh
    echo ""

    setup_config
    echo ""

    setup_tmux_zsh
    echo ""

    echo "========================================"
    print_status "Installation complete!"
    echo ""
    echo "Alacritty version: $(alacritty --version 2>/dev/null || echo 'Not found')"
    echo "tmux version: $(tmux -V 2>/dev/null || echo 'Not found')"
    echo "zsh version: $(zsh --version 2>/dev/null || echo 'Not found')"
    echo ""
    echo "Configuration file: ~/.config/alacritty/alacritty.toml"
    echo ""
    print_status "Launch Alacritty to start using it with tmux and zsh!"
    echo "========================================"
}

main "$@"
