#!/bin/bash
# =============================================================================
# Neovim Configuration Installation Script
# =============================================================================
# This script sets up the Neovim configuration by:
# 1. Checking system requirements
# 2. Creating necessary directories
# 3. Copying configuration files
# 4. Generating a plugin manifest
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NVIM_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
UPDATE_MODE=false
VERBOSE=false

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

usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
    -h, --help          Show this help message
    -d, --dry-run       Show what would be done without making changes
    -u, --update        Update existing configuration
    -v, --verbose       Show verbose output
    -t, --target DIR    Specify target directory (default: ~/.config/nvim)

Examples:
    $(basename "$0")                  # Fresh install
    $(basename "$0") --dry-run        # Preview changes
    $(basename "$0") --update         # Update existing config
EOF
    exit 0
}

# -----------------------------------------------------------------------------
# Parse Arguments
# -----------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -u|--update)
            UPDATE_MODE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -t|--target)
            NVIM_CONFIG_DIR="$2"
            shift 2
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            ;;
    esac
done

# -----------------------------------------------------------------------------
# Check Requirements
# -----------------------------------------------------------------------------

check_requirements() {
    print_header "Checking system requirements"

    local missing_deps=()

    # Check Neovim
    if command -v nvim &> /dev/null; then
        local nvim_version=$(nvim --version | head -n1 | cut -d' ' -f2)
        print_success "Neovim found: $nvim_version"

        # Check minimum version (0.9.0)
        local major=$(echo "$nvim_version" | cut -d'.' -f1 | tr -d 'v')
        local minor=$(echo "$nvim_version" | cut -d'.' -f2)
        if [[ $major -lt 1 && $minor -lt 9 ]]; then
            print_warning "Neovim 0.9.0+ recommended (found $nvim_version)"
        fi
    else
        missing_deps+=("neovim")
        print_error "Neovim not found"
    fi

    # Check Git
    if command -v git &> /dev/null; then
        print_success "Git found: $(git --version | cut -d' ' -f3)"
    else
        missing_deps+=("git")
        print_error "Git not found"
    fi

    # Check optional dependencies
    if command -v rg &> /dev/null; then
        print_success "ripgrep found"
    else
        print_warning "ripgrep not found (recommended for telescope)"
    fi

    if command -v fd &> /dev/null; then
        print_success "fd found"
    else
        print_warning "fd not found (recommended for telescope)"
    fi

    if command -v node &> /dev/null; then
        print_success "Node.js found: $(node --version)"
    else
        print_warning "Node.js not found (required for some LSP servers)"
    fi

    if command -v python3 &> /dev/null; then
        print_success "Python3 found: $(python3 --version | cut -d' ' -f2)"
    else
        print_warning "Python3 not found (required for some features)"
    fi

    # Check C compiler (needed for treesitter)
    if command -v gcc &> /dev/null || command -v clang &> /dev/null; then
        print_success "C compiler found"
    else
        print_warning "C compiler not found (required for treesitter)"
    fi

    # Check make (needed for telescope-fzf-native)
    if command -v make &> /dev/null; then
        print_success "make found"
    else
        print_warning "make not found (required for telescope-fzf-native)"
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

# -----------------------------------------------------------------------------
# Backup Existing Configuration
# -----------------------------------------------------------------------------

backup_existing() {
    if [[ -d "$NVIM_CONFIG_DIR" ]]; then
        print_header "Backing up existing configuration"

        local backup_dir="${NVIM_CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"

        if [[ "$DRY_RUN" == true ]]; then
            print_info "Would backup $NVIM_CONFIG_DIR to $backup_dir"
        else
            mv "$NVIM_CONFIG_DIR" "$backup_dir"
            print_success "Backed up to $backup_dir"
        fi
    fi
}

# -----------------------------------------------------------------------------
# Create Directory Structure
# -----------------------------------------------------------------------------

create_directories() {
    print_header "Creating directory structure"

    local dirs=(
        "$NVIM_CONFIG_DIR"
        "$NVIM_CONFIG_DIR/lua/config"
        "$NVIM_CONFIG_DIR/lua/plugins"
        "$NVIM_CONFIG_DIR/lua/utils"
        "$NVIM_CONFIG_DIR/after/plugin"
        "$NVIM_CONFIG_DIR/plugin"
    )

    for dir in "${dirs[@]}"; do
        if [[ "$DRY_RUN" == true ]]; then
            print_info "Would create: $dir"
        else
            mkdir -p "$dir"
            [[ "$VERBOSE" == true ]] && print_info "Created: $dir"
        fi
    done

    print_success "Directory structure created"
}

# -----------------------------------------------------------------------------
# Copy Configuration Files
# -----------------------------------------------------------------------------

copy_config_files() {
    print_header "Copying configuration files"

    local files=(
        "init.lua"
        "lua/config/options.lua"
        "lua/config/keymaps.lua"
        "lua/config/autocmds.lua"
        "lua/plugins/init.lua"
        "lua/plugins/editor.lua"
        "lua/plugins/lsp.lua"
        "lua/plugins/ui.lua"
        "lua/plugins/navigation.lua"
        "lua/plugins/ai.lua"
        "lua/plugins/misc.lua"
        "lua/utils/helpers.lua"
    )

    for file in "${files[@]}"; do
        local src="$SCRIPT_DIR/$file"
        local dest="$NVIM_CONFIG_DIR/$file"

        if [[ -f "$src" ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                print_info "Would copy: $file"
            else
                cp "$src" "$dest"
                [[ "$VERBOSE" == true ]] && print_info "Copied: $file"
            fi
        else
            print_warning "Source file not found: $src"
        fi
    done

    print_success "Configuration files copied"
}

# -----------------------------------------------------------------------------
# Generate Plugin Manifest
# -----------------------------------------------------------------------------

generate_manifest() {
    print_header "Generating plugin manifest"

    local manifest_file="$NVIM_CONFIG_DIR/plugins.json"
    local timestamp=$(date -Iseconds)

    if [[ "$DRY_RUN" == true ]]; then
        print_info "Would generate: $manifest_file"
        return
    fi

    cat > "$manifest_file" << 'MANIFEST'
{
  "generated": "TIMESTAMP",
  "version": "1.0.0",
  "plugins": {
    "plugin_manager": [
      {
        "name": "lazy.nvim",
        "repo": "folke/lazy.nvim",
        "url": "https://github.com/folke/lazy.nvim",
        "description": "Modern plugin manager for Neovim",
        "status": "pending"
      }
    ],
    "core": [
      {
        "name": "plenary.nvim",
        "repo": "nvim-lua/plenary.nvim",
        "url": "https://github.com/nvim-lua/plenary.nvim",
        "description": "Lua utility functions",
        "status": "pending"
      },
      {
        "name": "nvim-treesitter",
        "repo": "nvim-treesitter/nvim-treesitter",
        "url": "https://github.com/nvim-treesitter/nvim-treesitter",
        "description": "Syntax highlighting and AST",
        "status": "pending"
      }
    ],
    "lsp": [
      {
        "name": "nvim-lspconfig",
        "repo": "neovim/nvim-lspconfig",
        "url": "https://github.com/neovim/nvim-lspconfig",
        "description": "LSP configuration",
        "status": "pending"
      },
      {
        "name": "mason.nvim",
        "repo": "williamboman/mason.nvim",
        "url": "https://github.com/williamboman/mason.nvim",
        "description": "Package manager for LSP servers",
        "status": "pending"
      },
      {
        "name": "blink.cmp",
        "repo": "saghen/blink.cmp",
        "url": "https://github.com/saghen/blink.cmp",
        "description": "Modern completion engine",
        "status": "pending"
      }
    ],
    "ui": [
      {
        "name": "tokyonight.nvim",
        "repo": "folke/tokyonight.nvim",
        "url": "https://github.com/folke/tokyonight.nvim",
        "description": "Colorscheme",
        "status": "pending"
      },
      {
        "name": "lualine.nvim",
        "repo": "nvim-lualine/lualine.nvim",
        "url": "https://github.com/nvim-lualine/lualine.nvim",
        "description": "Statusline",
        "status": "pending"
      },
      {
        "name": "bufferline.nvim",
        "repo": "akinsho/bufferline.nvim",
        "url": "https://github.com/akinsho/bufferline.nvim",
        "description": "Buffer tabs",
        "status": "pending"
      },
      {
        "name": "which-key.nvim",
        "repo": "folke/which-key.nvim",
        "url": "https://github.com/folke/which-key.nvim",
        "description": "Keybinding hints",
        "status": "pending"
      },
      {
        "name": "noice.nvim",
        "repo": "folke/noice.nvim",
        "url": "https://github.com/folke/noice.nvim",
        "description": "UI for messages and cmdline",
        "status": "pending"
      }
    ],
    "navigation": [
      {
        "name": "telescope.nvim",
        "repo": "nvim-telescope/telescope.nvim",
        "url": "https://github.com/nvim-telescope/telescope.nvim",
        "description": "Fuzzy finder",
        "status": "pending"
      },
      {
        "name": "oil.nvim",
        "repo": "stevearc/oil.nvim",
        "url": "https://github.com/stevearc/oil.nvim",
        "description": "File explorer as buffer",
        "status": "pending"
      },
      {
        "name": "neo-tree.nvim",
        "repo": "nvim-neo-tree/neo-tree.nvim",
        "url": "https://github.com/nvim-neo-tree/neo-tree.nvim",
        "description": "Tree file manager",
        "status": "pending"
      },
      {
        "name": "harpoon",
        "repo": "ThePrimeagen/harpoon",
        "url": "https://github.com/ThePrimeagen/harpoon",
        "description": "Quick file navigation",
        "status": "pending"
      }
    ],
    "editor": [
      {
        "name": "Comment.nvim",
        "repo": "numToStr/Comment.nvim",
        "url": "https://github.com/numToStr/Comment.nvim",
        "description": "Smart commenting",
        "status": "pending"
      },
      {
        "name": "nvim-surround",
        "repo": "kylechui/nvim-surround",
        "url": "https://github.com/kylechui/nvim-surround",
        "description": "Surrounding operations",
        "status": "pending"
      },
      {
        "name": "nvim-autopairs",
        "repo": "windwp/nvim-autopairs",
        "url": "https://github.com/windwp/nvim-autopairs",
        "description": "Automatic pair insertion",
        "status": "pending"
      },
      {
        "name": "flash.nvim",
        "repo": "folke/flash.nvim",
        "url": "https://github.com/folke/flash.nvim",
        "description": "Navigation/search",
        "status": "pending"
      }
    ],
    "ai": [
      {
        "name": "codecompanion.nvim",
        "repo": "olimorris/codecompanion.nvim",
        "url": "https://github.com/olimorris/codecompanion.nvim",
        "description": "Multi-provider AI assistant",
        "status": "pending"
      },
      {
        "name": "avante.nvim",
        "repo": "yetone/avante.nvim",
        "url": "https://github.com/yetone/avante.nvim",
        "description": "AI editor",
        "status": "pending"
      }
    ],
    "git": [
      {
        "name": "gitsigns.nvim",
        "repo": "lewis6991/gitsigns.nvim",
        "url": "https://github.com/lewis6991/gitsigns.nvim",
        "description": "Git signs in gutter",
        "status": "pending"
      },
      {
        "name": "vim-fugitive",
        "repo": "tpope/vim-fugitive",
        "url": "https://github.com/tpope/vim-fugitive",
        "description": "Git command wrapper",
        "status": "pending"
      },
      {
        "name": "lazygit.nvim",
        "repo": "kdheepak/lazygit.nvim",
        "url": "https://github.com/kdheepak/lazygit.nvim",
        "description": "LazyGit integration",
        "status": "pending"
      }
    ],
    "debugging": [
      {
        "name": "nvim-dap",
        "repo": "mfussenegger/nvim-dap",
        "url": "https://github.com/mfussenegger/nvim-dap",
        "description": "Debug Adapter Protocol",
        "status": "pending"
      },
      {
        "name": "nvim-dap-ui",
        "repo": "rcarriga/nvim-dap-ui",
        "url": "https://github.com/rcarriga/nvim-dap-ui",
        "description": "DAP UI",
        "status": "pending"
      }
    ],
    "misc": [
      {
        "name": "trouble.nvim",
        "repo": "folke/trouble.nvim",
        "url": "https://github.com/folke/trouble.nvim",
        "description": "Diagnostics viewer",
        "status": "pending"
      },
      {
        "name": "todo-comments.nvim",
        "repo": "folke/todo-comments.nvim",
        "url": "https://github.com/folke/todo-comments.nvim",
        "description": "Highlight and search TODOs",
        "status": "pending"
      },
      {
        "name": "toggleterm.nvim",
        "repo": "akinsho/toggleterm.nvim",
        "url": "https://github.com/akinsho/toggleterm.nvim",
        "description": "Terminal management",
        "status": "pending"
      }
    ]
  }
}
MANIFEST

    # Replace timestamp
    sed -i "s/TIMESTAMP/$timestamp/" "$manifest_file"

    print_success "Plugin manifest generated"
}

# -----------------------------------------------------------------------------
# Post-Installation Setup
# -----------------------------------------------------------------------------

post_install() {
    print_header "Post-installation information"

    echo ""
    echo -e "${GREEN}Installation complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Start Neovim: nvim"
    echo "  2. Wait for lazy.nvim to install plugins (first launch)"
    echo "  3. Run :checkhealth to verify setup"
    echo "  4. Run :Mason to install LSP servers"
    echo ""
    echo "Configuration location: $NVIM_CONFIG_DIR"
    echo ""
    echo "Key bindings:"
    echo "  <Space>       Leader key"
    echo "  <Space>ff     Find files"
    echo "  <Space>sg     Live grep"
    echo "  <Space>e      File explorer (Oil)"
    echo "  <Space>l      Lazy plugin manager"
    echo "  <Space>?      Show keymaps (which-key)"
    echo ""
    echo "For AI features, set environment variables:"
    echo "  export ANTHROPIC_API_KEY='your-key'"
    echo "  export OPENAI_API_KEY='your-key'"
    echo ""
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------

main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║          Neovim Configuration Installation Script          ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"

    if [[ "$DRY_RUN" == true ]]; then
        echo -e "${YELLOW}Running in dry-run mode - no changes will be made${NC}"
    fi

    check_requirements

    if [[ "$UPDATE_MODE" == false ]]; then
        backup_existing
    fi

    create_directories
    copy_config_files
    generate_manifest

    if [[ "$DRY_RUN" == false ]]; then
        post_install
    else
        echo ""
        print_info "Dry run complete. Run without --dry-run to apply changes."
    fi
}

main "$@"
