#!/usr/bin/env bash
# =============================================================================
# System Prerequisites Installation Script for nvimdots
# =============================================================================
# This script installs all required system dependencies for nvimdots.
# Includes error handling, retry logic, and comprehensive dependency checks.
# Repository: https://github.com/ayamir/nvimdots
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MAX_RETRIES=4
RETRY_DELAY=2

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

print_header() {
    echo -e "\n${BLUE}==>${NC} ${1}"
}

print_success() {
    echo -e "${GREEN}✓${NC} ${1}"
}

print_warning() {
    echo -e "${YELLOW}!${NC} ${1}"
}

print_error() {
    echo -e "${RED}✗${NC} ${1}"
}

print_info() {
    echo -e "  ${1}"
}

# Retry function for network operations
retry_command() {
    local cmd="$1"
    local description="$2"
    local retries=0
    local delay=$RETRY_DELAY

    while [ $retries -lt $MAX_RETRIES ]; do
        if eval "$cmd"; then
            return 0
        else
            retries=$((retries + 1))
            if [ $retries -lt $MAX_RETRIES ]; then
                print_warning "$description failed. Retrying in ${delay}s... (Attempt $retries/$MAX_RETRIES)"
                sleep $delay
                delay=$((delay * 2))
            fi
        fi
    done

    print_error "$description failed after $MAX_RETRIES attempts"
    return 1
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Version comparison (returns 0 if version1 >= version2)
version_ge() {
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

# -----------------------------------------------------------------------------
# System Update
# -----------------------------------------------------------------------------

update_system() {
    print_header "Updating system packages..."

    if ! retry_command "sudo apt update" "System update"; then
        print_error "Failed to update package list. Please check your internet connection."
        exit 1
    fi

    if retry_command "sudo apt upgrade -y" "System upgrade"; then
        print_success "System updated successfully"
    else
        print_warning "System upgrade had issues, continuing anyway..."
    fi
}

# -----------------------------------------------------------------------------
# Core Dependencies
# -----------------------------------------------------------------------------

install_core_dependencies() {
    print_header "Installing core dependencies..."

    local core_packages=(
        git
        curl
        wget
        unzip
        tar
        gzip
        build-essential
        pkg-config
        cmake
        gcc
        g++
        clang
        make
        automake
        autoconf
        libtool
        ninja-build
    )

    if sudo apt install -y "${core_packages[@]}"; then
        print_success "Core dependencies installed"
    else
        print_error "Failed to install core dependencies"
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# Python Setup
# -----------------------------------------------------------------------------

install_python() {
    print_header "Installing Python and dependencies..."

    local python_packages=(
        python3
        python3-pip
        python3-venv
        python3-dev
    )

    if sudo apt install -y "${python_packages[@]}"; then
        print_success "Python packages installed"
    else
        print_error "Failed to install Python packages"
        exit 1
    fi

    # Install pynvim for Neovim Python support
    print_info "Installing pynvim..."
    if pip3 install --user pynvim; then
        print_success "pynvim installed"
    else
        print_warning "Failed to install pynvim, but continuing..."
    fi
}

# -----------------------------------------------------------------------------
# Neovim Installation
# -----------------------------------------------------------------------------

install_neovim() {
    print_header "Installing Neovim (latest stable)..."

    # Remove old neovim if it exists
    if command_exists nvim; then
        local current_version=$(nvim --version | head -n1 | cut -d' ' -f2 | tr -d 'v')
        print_info "Current Neovim version: $current_version"
        print_info "Removing old installation..."
        sudo apt remove -y neovim 2>/dev/null || true
    fi

    # Get latest Neovim version
    print_info "Fetching latest Neovim version..."
    local nvim_version
    nvim_version=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -Po '"tag_name": "v\K[^"]*')

    if [ -z "$nvim_version" ]; then
        print_warning "Failed to fetch latest version, using fallback version 0.11.5"
        nvim_version="0.11.5"
    else
        print_info "Latest version: v${nvim_version}"
    fi

    # Try tarball first (more reliable in containers/proxies)
    print_info "Downloading Neovim tarball v${nvim_version}..."
    local tarball_success=false

    if curl -fL --max-time 300 -o /tmp/nvim-linux-x86_64.tar.gz \
        "https://github.com/neovim/neovim/releases/download/v${nvim_version}/nvim-linux-x86_64.tar.gz"; then

        local file_size=$(stat -c%s /tmp/nvim-linux-x86_64.tar.gz 2>/dev/null || echo 0)
        if [ "$file_size" -gt 1000000 ]; then
            print_success "Tarball downloaded successfully (${file_size} bytes)"

            # Extract tarball
            print_info "Extracting Neovim..."
            sudo rm -rf /opt/nvim 2>/dev/null || true
            sudo mkdir -p /opt/nvim

            if sudo tar -C /opt/nvim -xzf /tmp/nvim-linux-x86_64.tar.gz --strip-components=1; then
                sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
                rm -f /tmp/nvim-linux-x86_64.tar.gz
                tarball_success=true
                print_success "Neovim v${nvim_version} installed successfully (tarball)"
            else
                print_warning "Failed to extract tarball"
                rm -f /tmp/nvim-linux-x86_64.tar.gz
            fi
        else
            print_warning "Downloaded tarball too small (${file_size} bytes)"
            rm -f /tmp/nvim-linux-x86_64.tar.gz
        fi
    fi

    # Fallback to AppImage if tarball failed
    if [ "$tarball_success" = false ]; then
        print_warning "Tarball installation failed, trying AppImage..."

        # Install FUSE for AppImage support
        print_info "Installing FUSE for AppImage support..."
        sudo apt install -y libfuse2 2>/dev/null || print_warning "FUSE install failed"

        print_info "Downloading Neovim AppImage v${nvim_version}..."
        local appimage_urls=(
            "https://github.com/neovim/neovim/releases/download/v${nvim_version}/nvim-linux-x86_64.appimage"
            "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
        )

        local appimage_success=false
        for url in "${appimage_urls[@]}"; do
            print_info "Trying: $url"
            if curl -fL --max-time 300 -o /tmp/nvim-linux-x86_64.appimage "$url"; then
                local file_size=$(stat -c%s /tmp/nvim-linux-x86_64.appimage 2>/dev/null || echo 0)
                if [ "$file_size" -gt 1000000 ]; then
                    print_success "AppImage downloaded (${file_size} bytes)"
                    chmod u+x /tmp/nvim-linux-x86_64.appimage

                    # Test if AppImage works
                    if /tmp/nvim-linux-x86_64.appimage --version &>/dev/null; then
                        sudo mv /tmp/nvim-linux-x86_64.appimage /usr/local/bin/nvim
                        appimage_success=true
                        print_success "Neovim v${nvim_version} installed (AppImage mode)"
                        break
                    else
                        print_info "AppImage not executable, extracting..."
                        if /tmp/nvim-linux-x86_64.appimage --appimage-extract &>/dev/null && [ -d squashfs-root ]; then
                            sudo rm -rf /opt/nvim 2>/dev/null || true
                            sudo mv squashfs-root /opt/nvim
                            sudo ln -sf /opt/nvim/usr/bin/nvim /usr/local/bin/nvim
                            rm -f /tmp/nvim-linux-x86_64.appimage
                            appimage_success=true
                            print_success "Neovim v${nvim_version} installed (extracted AppImage)"
                            break
                        fi
                    fi
                fi
                rm -f /tmp/nvim-linux-x86_64.appimage
            fi
        done

        if [ "$appimage_success" = false ]; then
            # Final fallback to PPA
            print_warning "AppImage failed, trying Ubuntu PPA..."
            if sudo add-apt-repository -y ppa:neovim-ppa/stable && \
               sudo apt update && \
               sudo apt install -y neovim; then
                print_success "Neovim installed from PPA"
            else
                print_error "All Neovim installation methods failed"
                exit 1
            fi
        fi
    fi

    # Verify installation
    if command_exists nvim; then
        print_success "Neovim verified: $(nvim --version | head -n1)"
    else
        print_error "Neovim installation verification failed"
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# Node.js Installation (via nvm for nvimdots)
# -----------------------------------------------------------------------------

install_nodejs() {
    print_header "Installing Node.js via nvm..."

    # Check if nvm is already installed
    if [ -f "$HOME/.nvm/nvm.sh" ]; then
        source "$HOME/.nvm/nvm.sh"
        print_success "nvm already installed"
    else
        print_info "Installing nvm (Node Version Manager)..."
        if curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash; then
            # Source nvm
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            print_success "nvm installed"
        else
            print_error "Failed to install nvm"
            exit 1
        fi
    fi

    # Source nvm to ensure it's available
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Check if Node.js 18+ is installed
    if command_exists node; then
        local node_version=$(node --version | tr -d 'v')
        print_info "Node.js already installed: v${node_version}"

        # Check if version is recent enough (>= 18)
        if version_ge "${node_version}" "18.0.0"; then
            print_success "Node.js version is sufficient"
        else
            print_warning "Node.js version is old, installing Node 18..."
            nvm install 18
            nvm use 18
            nvm alias default 18
        fi
    else
        print_info "Installing Node.js 18..."
        nvm install 18
        nvm use 18
        nvm alias default 18
        print_success "Node.js installed: $(node --version)"
    fi

    # Install yarn
    print_info "Installing yarn..."
    if npm install -g yarn; then
        print_success "yarn installed: $(yarn --version)"
    else
        print_warning "Failed to install yarn, trying apt..."
        sudo apt install -y yarn || print_warning "yarn installation failed"
    fi
}

# -----------------------------------------------------------------------------
# Rust Installation
# -----------------------------------------------------------------------------

install_rust() {
    print_header "Installing Rust toolchain..."

    if command_exists rustc; then
        print_info "Rust already installed: $(rustc --version)"
        print_success "Rust toolchain detected"
        return 0
    fi

    print_info "Downloading Rust installer..."
    if curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable; then
        # Source cargo environment
        if [ -f "$HOME/.cargo/env" ]; then
            source "$HOME/.cargo/env"
            print_success "Rust installed: $(rustc --version)"
        fi
    else
        print_error "Failed to install Rust"
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# CLI Tools Installation
# -----------------------------------------------------------------------------

install_cli_tools() {
    print_header "Installing CLI tools (ripgrep, fd, etc.)..."

    local cli_packages=(
        ripgrep
        fd-find
        xclip
        xsel
        lua5.1
        luarocks
    )

    if sudo apt install -y "${cli_packages[@]}"; then
        print_success "CLI tools installed"
    else
        print_warning "Some CLI tools failed to install, continuing..."
    fi

    # Fix fd command name (Ubuntu quirk)
    print_info "Setting up fd command..."
    if command_exists fdfind && ! command_exists fd; then
        if [ -L /usr/local/bin/fd ]; then
            print_info "fd symlink already exists"
        else
            sudo ln -s "$(which fdfind)" /usr/local/bin/fd
            print_success "Created fd symlink"
        fi
    elif command_exists fd; then
        print_success "fd command available"
    fi
}

# -----------------------------------------------------------------------------
# Zoxide Installation
# -----------------------------------------------------------------------------

install_zoxide() {
    print_header "Installing zoxide..."

    if command_exists zoxide; then
        print_success "zoxide already installed: $(zoxide --version)"
        return 0
    fi

    # Try from apt first
    if sudo apt install -y zoxide 2>/dev/null; then
        print_success "zoxide installed from apt"
        return 0
    fi

    # Fallback to installer script
    print_info "Installing zoxide from official installer..."
    if curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash; then
        print_success "zoxide installed"
    else
        print_warning "Failed to install zoxide, skipping..."
    fi
}

# -----------------------------------------------------------------------------
# LazyGit Installation
# -----------------------------------------------------------------------------

install_lazygit() {
    print_header "Installing lazygit..."

    if command_exists lazygit; then
        print_success "lazygit already installed: $(lazygit --version | head -n1)"
        return 0
    fi

    print_info "Fetching latest lazygit version..."
    local lazygit_version
    lazygit_version=$(curl -s 'https://api.github.com/repos/jesseduffield/lazygit/releases/latest' | grep -Po '"tag_name": "v\K[^"]*')

    if [ -z "$lazygit_version" ]; then
        print_warning "Failed to fetch lazygit version, skipping..."
        return 1
    fi

    print_info "Latest version: v${lazygit_version}"
    print_info "Downloading lazygit v${lazygit_version}..."

    if curl -fL --retry 3 --retry-delay 2 -o /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${lazygit_version}_Linux_x86_64.tar.gz"; then
        tar -C /tmp -xf /tmp/lazygit.tar.gz lazygit
        sudo install /tmp/lazygit /usr/local/bin
        rm -f /tmp/lazygit /tmp/lazygit.tar.gz
        print_success "lazygit installed: $(lazygit --version | head -n1)"
    else
        print_warning "Failed to install lazygit, skipping..."
    fi
}

# -----------------------------------------------------------------------------
# Tree-sitter CLI Installation
# -----------------------------------------------------------------------------

install_tree_sitter() {
    print_header "Installing tree-sitter CLI..."

    if command_exists tree-sitter; then
        print_success "tree-sitter already installed: $(tree-sitter --version)"
        return 0
    fi

    # Ensure cargo is available
    if ! command_exists cargo; then
        print_warning "Cargo not found, skipping tree-sitter installation"
        return 1
    fi

    print_info "Installing tree-sitter via cargo..."
    if cargo install tree-sitter-cli; then
        print_success "tree-sitter CLI installed"
    else
        print_warning "Failed to install tree-sitter CLI, but it's optional"
    fi
}

# -----------------------------------------------------------------------------
# LLDB Installation (for debugging)
# -----------------------------------------------------------------------------

install_lldb() {
    print_header "Installing LLDB debugger..."

    if sudo apt install -y lldb; then
        print_success "LLDB installed"
    else
        print_warning "Failed to install LLDB, but it's optional"
    fi
}

# -----------------------------------------------------------------------------
# Nerd Fonts Installation
# -----------------------------------------------------------------------------

install_nerd_fonts() {
    print_header "Installing Nerd Fonts..."

    # Install fonts-firacode (has some nerd font glyphs)
    if sudo apt install -y fonts-firacode; then
        print_success "FiraCode font installed"
    fi

    # Optionally install a proper Nerd Font
    local fonts_dir="$HOME/.local/share/fonts"
    local nerd_font_installed=false

    # Check if any nerd font is already installed
    if fc-list | grep -qi "nerd"; then
        print_success "Nerd Font already installed"
        return 0
    fi

    print_info "Installing JetBrainsMono Nerd Font..."
    mkdir -p "$fonts_dir"

    if curl -fL --retry 3 --retry-delay 2 -o /tmp/JetBrainsMono.zip 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip'; then
        unzip -qo /tmp/JetBrainsMono.zip -d "$fonts_dir/JetBrainsMono"
        rm -f /tmp/JetBrainsMono.zip
        fc-cache -fv &>/dev/null
        print_success "JetBrainsMono Nerd Font installed"
    else
        print_warning "Failed to install Nerd Font. Icons may not display correctly."
        print_info "You can manually install from: https://www.nerdfonts.com/"
    fi
}

# -----------------------------------------------------------------------------
# Verification
# -----------------------------------------------------------------------------

verify_installations() {
    print_header "Verifying installations..."

    local all_good=true

    # Required tools
    declare -A required_tools=(
        ["nvim"]="Neovim"
        ["git"]="Git"
        ["node"]="Node.js"
        ["python3"]="Python3"
    )

    for cmd in "${!required_tools[@]}"; do
        if command_exists "$cmd"; then
            local version=$($cmd --version 2>&1 | head -n1)
            print_success "${required_tools[$cmd]}: $version"
        else
            print_error "${required_tools[$cmd]} not found"
            all_good=false
        fi
    done

    # Optional tools
    declare -A optional_tools=(
        ["rg"]="ripgrep"
        ["fd"]="fd"
        ["lazygit"]="lazygit"
        ["cargo"]="Rust/Cargo"
        ["rustc"]="Rust compiler"
        ["zoxide"]="zoxide"
        ["tree-sitter"]="tree-sitter CLI"
    )

    for cmd in "${!optional_tools[@]}"; do
        if command_exists "$cmd"; then
            print_success "${optional_tools[$cmd]}: available"
        else
            print_warning "${optional_tools[$cmd]}: not installed (optional)"
        fi
    done

    if [ "$all_good" = true ]; then
        return 0
    else
        return 1
    fi
}

# -----------------------------------------------------------------------------
# Post-Installation Info
# -----------------------------------------------------------------------------

post_install_info() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     System Prerequisites Installation Complete!            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Restart your shell or source the following:"
    echo "     ${BLUE}source ~/.nvm/nvm.sh${NC} (for Node.js/nvm)"
    echo "     ${BLUE}source ~/.cargo/env${NC} (for Rust commands)"
    echo ""
    echo "  2. Install nvimdots configuration:"
    echo "     ${BLUE}bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/ayamir/nvimdots/HEAD/scripts/install.sh)\"${NC}"
    echo ""
    echo "  3. Start Neovim and let plugins install:"
    echo "     ${BLUE}nvim${NC}"
    echo ""
    echo "  4. Run health check:"
    echo "     ${BLUE}:checkhealth${NC} (inside Neovim)"
    echo ""
    echo "  5. Install LSP servers:"
    echo "     ${BLUE}:Mason${NC} (inside Neovim)"
    echo ""
    echo "For more information, visit:"
    echo "  ${BLUE}https://github.com/ayamir/nvimdots${NC}"
    echo ""

    if ! fc-list | grep -qi "nerd"; then
        echo -e "${YELLOW}NOTE:${NC} For proper icon display, configure your terminal to use a Nerd Font:"
        echo "  - JetBrainsMono Nerd Font (installed at ~/.local/share/fonts/JetBrainsMono)"
        echo "  - Or download from: https://www.nerdfonts.com/"
        echo ""
    fi
}

# -----------------------------------------------------------------------------
# Main Installation Flow
# -----------------------------------------------------------------------------

main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     System Prerequisites Installation for nvimdots         ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    # Check if running on a Debian/Ubuntu-based system
    if ! command_exists apt; then
        print_error "This script is designed for Debian/Ubuntu-based systems"
        exit 1
    fi

    # Check for sudo access
    if ! sudo -v; then
        print_error "This script requires sudo access"
        exit 1
    fi

    # Keep sudo alive
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Run installation steps
    update_system
    install_core_dependencies
    install_python
    install_neovim
    install_nodejs
    install_rust
    install_cli_tools
    install_zoxide
    install_lazygit
    install_tree_sitter
    install_lldb
    install_nerd_fonts

    # Verify everything
    echo ""
    if verify_installations; then
        post_install_info
        exit 0
    else
        echo ""
        print_error "Some required installations failed. Please review the errors above."
        exit 1
    fi
}

# Run main function
main "$@"
