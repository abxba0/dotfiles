#!/bin/bash
# Comprehensive Tmux Setup Script
# Installs TPM, plugins, and configures tmux
# Usage: ./tmux-setup.sh [install|update|quick]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TPM_DIR="$HOME/.tmux/plugins/tpm"
PLUGINS_DIR="$HOME/.tmux/plugins"
TMUX_CONF="$HOME/.tmux.conf"

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
# Dependency Checking
# ============================================

check_dependencies() {
    print_info "Checking dependencies..."

    local missing_deps=()

    for dep in git tmux; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -ne 0 ]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        print_info "Please install them first:"
        print_info "  Ubuntu/Debian: sudo apt install ${missing_deps[*]}"
        print_info "  macOS: brew install ${missing_deps[*]}"
        print_info "  Fedora: sudo dnf install ${missing_deps[*]}"
        print_info "  Arch: sudo pacman -S ${missing_deps[*]}"
        exit 1
    fi

    # Check tmux version
    local tmux_version
    tmux_version=$(tmux -V | cut -d' ' -f2 | sed 's/[^0-9.]//g')
    print_info "Tmux version: $tmux_version"

    print_info "All dependencies satisfied!"
}

# ============================================
# Optional Dependencies
# ============================================

check_optional_deps() {
    print_info "Checking optional dependencies..."

    local optional_deps=("fzf" "tree")
    local missing_optional=()

    for dep in "${optional_deps[@]}"; do
        if ! command_exists "$dep"; then
            missing_optional+=("$dep")
        fi
    done

    if [ ${#missing_optional[@]} -ne 0 ]; then
        print_warn "Optional dependencies not found: ${missing_optional[*]}"
        print_info "These enhance some plugins but are not required."
        print_info "Install with: sudo apt install ${missing_optional[*]}"
    else
        print_info "All optional dependencies found!"
    fi
}

# ============================================
# TPM Installation
# ============================================

install_tpm() {
    if [ -d "$TPM_DIR/.git" ]; then
        print_info "TPM already installed. Updating..."
        (cd "$TPM_DIR" && git pull --quiet) || print_warn "Failed to update TPM"
    elif [ -d "$TPM_DIR" ]; then
        print_warn "TPM directory exists but is not a git repo"
        print_info "Removing and reinstalling..."
        rm -rf "$TPM_DIR"
        git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    else
        print_info "Installing TPM (Tmux Plugin Manager)..."
        mkdir -p "$PLUGINS_DIR"
        git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi
    print_info "TPM installed successfully!"
}

# ============================================
# Configuration Installation
# ============================================

install_config() {
    local config_source="$SCRIPT_DIR/.tmux.conf"

    if [ ! -f "$config_source" ]; then
        print_error "Config file not found: $config_source"
        exit 1
    fi

    # Backup existing config
    if [ -f "$TMUX_CONF" ] && [ ! -L "$TMUX_CONF" ]; then
        local backup_path="${TMUX_CONF}.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing .tmux.conf to $backup_path"
        cp "$TMUX_CONF" "$backup_path"
    fi

    # Remove existing symlink or file
    if [ -L "$TMUX_CONF" ] || [ -f "$TMUX_CONF" ]; then
        rm -f "$TMUX_CONF"
    fi

    # Create symlink
    print_info "Creating symlink: $TMUX_CONF -> $config_source"
    ln -sf "$config_source" "$TMUX_CONF"
    print_info "Configuration installed!"
}

# ============================================
# Plugin Installation
# ============================================

install_plugins() {
    print_info "Installing tmux plugins via TPM..."

    if [ ! -f "$TPM_DIR/bin/install_plugins" ]; then
        print_error "TPM install script not found. Please install TPM first."
        exit 1
    fi

    # Install plugins using TPM
    "$TPM_DIR/bin/install_plugins"

    print_info "All plugins installed successfully!"
}

# ============================================
# Update Functions
# ============================================

update_all() {
    print_header "Updating Tmux Components"

    # Update TPM
    if [ -d "$TPM_DIR/.git" ]; then
        print_info "Updating TPM..."
        (cd "$TPM_DIR" && git pull --quiet) && print_info "TPM updated!" || print_warn "Failed to update TPM"
    else
        print_warn "TPM not found"
    fi

    # Update all plugins
    if [ -f "$TPM_DIR/bin/update_plugins" ]; then
        print_info "Updating all plugins..."
        "$TPM_DIR/bin/update_plugins" all
        print_info "All plugins updated!"
    else
        print_warn "TPM update script not found"
    fi

    print_header "Update Complete!"
    print_info "Reload tmux config: tmux source-file ~/.tmux.conf"
    print_info "Or press: prefix + r (if inside tmux)"
}

# ============================================
# Quick Install (No prompts)
# ============================================

quick_install() {
    print_header "Quick Tmux Setup"

    check_dependencies
    install_tpm
    install_config
    install_plugins

    print_header "Quick Setup Complete!"
    show_keybindings
}

# ============================================
# Full Interactive Install
# ============================================

full_install() {
    print_header "Tmux Setup Script"

    # Check dependencies
    check_dependencies
    check_optional_deps

    # Install TPM
    echo ""
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Install/Update TPM (Tmux Plugin Manager)? (y/n): ")" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_tpm
    fi

    # Install config
    echo ""
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Install tmux configuration? (y/n): ")" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_config
    fi

    # Install plugins
    echo ""
    read -p "$(echo -e "${GREEN}[PROMPT]${NC} Install tmux plugins? (y/n): ")" -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_plugins
    fi

    # Summary
    print_header "Installation Complete!"
    show_keybindings
}

# ============================================
# Show Keybindings
# ============================================

show_keybindings() {
    print_info "Installed Plugins & Keybindings:"
    echo ""
    echo -e "  ${BLUE}Prefix:${NC} Ctrl+a (changed from Ctrl+b)"
    echo ""
    echo -e "  ${BLUE}Basic Navigation:${NC}"
    echo "    prefix + |     Split pane horizontally"
    echo "    prefix + -     Split pane vertically"
    echo "    prefix + r     Reload config"
    echo "    prefix + H/J/K/L  Resize panes"
    echo ""
    echo -e "  ${BLUE}Vim-Tmux Navigator:${NC}"
    echo "    Ctrl + h/j/k/l    Navigate panes (works with vim)"
    echo ""
    echo -e "  ${BLUE}Session Management:${NC}"
    echo "    prefix + o     Open sessionx (session manager)"
    echo ""
    echo -e "  ${BLUE}Plugins:${NC}"
    echo "    prefix + \\     Open tmux-menus"
    echo "    prefix + Tab   Toggle sidebar (file tree)"
    echo "    prefix + I     Install new plugins"
    echo "    prefix + U     Update plugins"
    echo ""
    echo -e "  ${BLUE}Copy Mode (vi keys):${NC}"
    echo "    prefix + [     Enter copy mode"
    echo "    v              Start selection"
    echo "    y              Copy selection"
    echo ""
    print_info "Start tmux: tmux"
    print_info "Or if already running: tmux source-file ~/.tmux.conf"
    echo ""
}

# ============================================
# Uninstall
# ============================================

uninstall() {
    print_header "Uninstalling Tmux Configuration"

    read -p "$(echo -e "${YELLOW}[WARN]${NC} This will remove TPM and all plugins. Continue? (y/n): ")" -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Uninstall cancelled."
        exit 0
    fi

    # Remove symlink
    if [ -L "$TMUX_CONF" ]; then
        print_info "Removing config symlink..."
        rm -f "$TMUX_CONF"
    fi

    # Remove plugins directory
    if [ -d "$PLUGINS_DIR" ]; then
        print_info "Removing plugins directory..."
        rm -rf "$PLUGINS_DIR"
    fi

    print_info "Uninstall complete!"
    print_info "Your backup configs (if any) are still available."
}

# ============================================
# Usage Information
# ============================================

show_usage() {
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  install     Full interactive installation (default)"
    echo "  update      Update TPM and all plugins"
    echo "  quick       Quick installation (no prompts)"
    echo "  uninstall   Remove tmux configuration and plugins"
    echo "  keys        Show keybindings reference"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0              # Interactive full installation"
    echo "  $0 install      # Same as above"
    echo "  $0 update       # Update all components"
    echo "  $0 quick        # Quick setup with defaults"
    echo "  $0 keys         # Show keybindings"
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
        uninstall|remove)
            uninstall
            ;;
        keys|keybindings)
            show_keybindings
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
