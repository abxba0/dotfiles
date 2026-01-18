# Neovim Documentation

A modern Neovim configuration with lazy.nvim, LSP support, completion, fuzzy finding, file navigation, and AI integration.

## Leader Key

```
Space
```

The local leader is `\`.

## Keyboard Shortcuts

### General

| Shortcut | Mode | Description |
|----------|------|-------------|
| `jk` / `jj` | Insert | Exit insert mode |
| `Ctrl+S` | All | Save file |
| `<leader>qq` | Normal | Quit all |
| `<leader>fn` | Normal | New file |
| `<leader>l` | Normal | Open Lazy plugin manager |
| `Ctrl+A` | Normal | Select all |
| `Esc` | Normal/Insert | Clear search highlighting |

### Movement

| Shortcut | Mode | Description |
|----------|------|-------------|
| `Ctrl+H` | Normal | Go to left window |
| `Ctrl+J` | Normal | Go to lower window |
| `Ctrl+K` | Normal | Go to upper window |
| `Ctrl+L` | Normal | Go to right window |
| `Alt+J` | Normal/Insert/Visual | Move line(s) down |
| `Alt+K` | Normal/Insert/Visual | Move line(s) up |
| `j` / `k` | Normal/Visual | Smart movement (respects wrapped lines) |

### Buffers

| Shortcut | Mode | Description |
|----------|------|-------------|
| `Shift+H` | Normal | Previous buffer |
| `Shift+L` | Normal | Next buffer |
| `[b` / `]b` | Normal | Previous/Next buffer |
| `<leader>bb` | Normal | Switch to alternate buffer |
| `<leader>bd` | Normal | Delete buffer |
| `<leader>bD` | Normal | Force delete buffer |

### Windows

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>ww` | Normal | Other window |
| `<leader>wd` | Normal | Close window |
| `<leader>w-` / `<leader>-` | Normal | Split window below |
| `<leader>w\|` / `<leader>\|` | Normal | Split window right |
| `Ctrl+Up` | Normal | Increase window height |
| `Ctrl+Down` | Normal | Decrease window height |
| `Ctrl+Left` | Normal | Decrease window width |
| `Ctrl+Right` | Normal | Increase window width |

### Tabs

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader><tab><tab>` | Normal | New tab |
| `<leader><tab>d` | Normal | Close tab |
| `<leader><tab>]` | Normal | Next tab |
| `<leader><tab>[` | Normal | Previous tab |
| `<leader><tab>l` | Normal | Last tab |
| `<leader><tab>f` | Normal | First tab |

### File Navigation (Telescope)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader><space>` | Normal | Find files |
| `<leader>ff` | Normal | Find files |
| `<leader>fr` | Normal | Recent files |
| `<leader>fb` | Normal | Buffers |
| `<leader>fg` | Normal | Git files |
| `<leader>,` | Normal | Switch buffer |
| `<leader>/` | Normal | Live grep (search in files) |
| `<leader>:` | Normal | Command history |

### Search (Telescope)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>sg` | Normal | Grep (live search) |
| `<leader>sw` | Normal | Search word under cursor |
| `<leader>sb` | Normal | Search in current buffer |
| `<leader>sh` | Normal | Search help pages |
| `<leader>sm` | Normal | Search man pages |
| `<leader>sk` | Normal | Search keymaps |
| `<leader>sc` | Normal | Search commands |
| `<leader>sC` | Normal | Search command history |
| `<leader>sr` | Normal | Search registers |
| `<leader>sa` | Normal | Search autocommands |
| `<leader>sH` | Normal | Search highlights |
| `<leader>sd` | Normal | Document diagnostics |
| `<leader>sD` | Normal | Workspace diagnostics |
| `<leader>ss` | Normal | Document symbols |
| `<leader>sS` | Normal | Workspace symbols |
| `<leader>sR` | Normal | Resume last search |

### Telescope Inside Picker

| Shortcut | Mode | Description |
|----------|------|-------------|
| `Ctrl+J` / `Ctrl+K` | Insert | Move selection up/down |
| `Ctrl+N` / `Ctrl+P` | Insert | Cycle history |
| `Ctrl+C` / `Esc` | Insert/Normal | Close picker |
| `Enter` | Both | Select item |
| `Ctrl+X` | Insert | Open in horizontal split |
| `Ctrl+V` | Insert | Open in vertical split |
| `Ctrl+T` | Insert | Open in new tab |
| `Tab` | Both | Toggle selection |
| `Ctrl+Q` | Insert | Send to quickfix |
| `Ctrl+U` / `Ctrl+D` | Insert | Scroll preview up/down |

### File Explorer

| Shortcut | Mode | Description |
|----------|------|-------------|
| `-` | Normal | Open Oil (parent directory) |
| `<leader>e` | Normal | Open Oil file explorer |
| `<leader>E` | Normal | Toggle Neo-tree |
| `<leader>ge` | Normal | Git explorer (Neo-tree) |
| `<leader>be` | Normal | Buffer explorer (Neo-tree) |

### Oil (File Explorer)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `Enter` | Normal | Select/enter directory |
| `-` | Normal | Go to parent directory |
| `_` | Normal | Open current working directory |
| `g?` | Normal | Show help |
| `Ctrl+S` | Normal | Open in vertical split |
| `Ctrl+H` | Normal | Open in horizontal split |
| `Ctrl+T` | Normal | Open in new tab |
| `Ctrl+P` | Normal | Preview |
| `Ctrl+C` | Normal | Close |
| `Ctrl+L` | Normal | Refresh |
| `g.` | Normal | Toggle hidden files |
| `gs` | Normal | Change sort |
| `gx` | Normal | Open external |

### Harpoon (Quick Navigation)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>H` | Normal | Add file to Harpoon |
| `<leader>h` | Normal | Open Harpoon menu |
| `<leader>1-5` | Normal | Jump to Harpoon file 1-5 |

### LSP

| Shortcut | Mode | Description |
|----------|------|-------------|
| `gd` | Normal | Go to definition |
| `gr` | Normal | References |
| `gD` | Normal | Go to declaration |
| `gI` | Normal | Go to implementation |
| `gy` | Normal | Go to type definition |
| `K` | Normal | Hover documentation |
| `gK` | Normal | Signature help |
| `Ctrl+K` | Insert | Signature help |
| `<leader>ca` | Normal/Visual | Code action |
| `<leader>cc` | Normal/Visual | Run codelens |
| `<leader>cC` | Normal | Refresh codelens |
| `<leader>cr` | Normal | Rename symbol |
| `<leader>cf` | Normal | Format buffer |
| `<leader>cm` | Normal | Open Mason (LSP installer) |

### Diagnostics

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>cd` | Normal | Line diagnostics (float) |
| `]d` / `[d` | Normal | Next/Previous diagnostic |
| `]e` / `[e` | Normal | Next/Previous error |
| `]w` / `[w` | Normal | Next/Previous warning |
| `<leader>xx` | Normal | Diagnostics (Trouble) |
| `<leader>xX` | Normal | Buffer diagnostics (Trouble) |

### Completion (blink.cmp)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `Ctrl+Space` | Insert | Show completion/documentation |
| `Ctrl+E` | Insert | Hide completion |
| `Ctrl+Y` | Insert | Select and accept |
| `Enter` | Insert | Accept completion |
| `Tab` | Insert | Snippet forward / Select next |
| `Shift+Tab` | Insert | Snippet backward / Select prev |
| `Ctrl+N` / `Ctrl+P` | Insert | Select next/prev |
| `Ctrl+B` / `Ctrl+F` | Insert | Scroll documentation up/down |

### Comments

| Shortcut | Mode | Description |
|----------|------|-------------|
| `gcc` | Normal | Toggle line comment |
| `gbc` | Normal | Toggle block comment |
| `gc` | Visual | Toggle line comment |
| `gb` | Visual | Toggle block comment |
| `gco` | Normal | Add comment below |
| `gcO` | Normal | Add comment above |
| `gcA` | Normal | Add comment at end of line |

### Surround

| Shortcut | Mode | Description |
|----------|------|-------------|
| `ys{motion}{char}` | Normal | Add surround |
| `ds{char}` | Normal | Delete surround |
| `cs{old}{new}` | Normal | Change surround |
| `S{char}` | Visual | Surround selection |

Examples:
- `ysiw"` - Surround word with quotes
- `ds"` - Delete surrounding quotes
- `cs"'` - Change double quotes to single quotes

### Flash (Navigation)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `s` | Normal/Visual/Operator | Flash jump |
| `S` | Normal/Visual/Operator | Flash treesitter |
| `r` | Operator | Remote flash |
| `R` | Visual/Operator | Treesitter search |
| `Ctrl+S` | Command | Toggle flash search |

### Treesitter Text Objects

| Shortcut | Mode | Description |
|----------|------|-------------|
| `Ctrl+Space` | Normal | Increment selection |
| `Backspace` | Visual | Decrement selection |
| `]f` / `[f` | Normal | Next/Previous function start |
| `]F` / `[F` | Normal | Next/Previous function end |
| `]c` / `[c` | Normal | Next/Previous class start |
| `]C` / `[C` | Normal | Next/Previous class end |

### Todo Comments

| Shortcut | Mode | Description |
|----------|------|-------------|
| `]t` / `[t` | Normal | Next/Previous todo comment |
| `<leader>xt` | Normal | Todo list (Trouble) |
| `<leader>xT` | Normal | Todo/Fix/Fixme (Trouble) |
| `<leader>st` | Normal | Search todos (Telescope) |
| `<leader>sT` | Normal | Search Todo/Fix/Fixme |

### Git

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>gc` | Normal | Git commits (Telescope) |
| `<leader>gs` | Normal | Git status (Telescope) |
| `]h` / `[h` | Normal | Next/Previous hunk |
| `<leader>ghs` | Normal/Visual | Stage hunk |
| `<leader>ghr` | Normal/Visual | Reset hunk |
| `<leader>ghS` | Normal | Stage buffer |
| `<leader>ghR` | Normal | Reset buffer |
| `<leader>ghu` | Normal | Undo stage hunk |
| `<leader>ghp` | Normal | Preview hunk |
| `<leader>ghb` | Normal | Blame line |
| `<leader>ghd` | Normal | Diff this |

### Quickfix/Location List

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>xl` | Normal | Open location list |
| `<leader>xq` | Normal | Open quickfix list |
| `[q` / `]q` | Normal | Previous/Next quickfix item |
| `[l` / `]l` | Normal | Previous/Next location item |
| `<leader>xL` | Normal | Location list (Trouble) |
| `<leader>xQ` | Normal | Quickfix list (Trouble) |

### AI (CodeCompanion)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>aa` | Normal/Visual | AI Actions menu |
| `<leader>ac` | Normal/Visual | AI Chat toggle |
| `<leader>aC` | Normal/Visual | AI Chat (new) |
| `<leader>ap` | Normal/Visual | AI Prompt |
| `<leader>ae` | Visual | AI Explain selection |
| `<leader>af` | Visual | AI Fix selection |
| `<leader>ar` | Visual | AI Refactor selection |
| `<leader>at` | Visual | AI Generate tests |
| `<leader>ad` | Visual | AI Generate docs |

### AI (Avante)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>av` | Normal | Avante toggle |
| `<leader>aV` | Normal | Avante ask |
| `co` | Normal | Accept ours (diff) |
| `ct` | Normal | Accept theirs (diff) |
| `ca` | Normal | Accept all theirs |
| `cb` | Normal | Accept both |
| `]x` / `[x` | Normal | Next/Previous diff |
| `]]` / `[[` | Normal | Jump next/prev |

### AI (Ollama - gen.nvim)

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>ao` | Normal/Visual | AI with Ollama |

### Toggle Options

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>uw` | Normal | Toggle word wrap |
| `<leader>un` | Normal | Toggle line numbers |
| `<leader>ur` | Normal | Toggle relative numbers |
| `<leader>us` | Normal | Toggle spell check |
| `<leader>uc` | Normal | Toggle cursorline |
| `<leader>ul` | Normal | Toggle list characters |

### Session Management

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>qs` | Normal | Restore session |
| `<leader>ql` | Normal | Restore last session |
| `<leader>qd` | Normal | Don't save session |

### Terminal

| Shortcut | Mode | Description |
|----------|------|-------------|
| `Esc Esc` | Terminal | Exit terminal mode |
| `Ctrl+H/J/K/L` | Terminal | Navigate windows from terminal |

### Editing

| Shortcut | Mode | Description |
|----------|------|-------------|
| `p` | Visual | Paste without overwriting register |
| `<leader>d` | Normal/Visual | Delete without yank |
| `]<space>` | Normal | Add blank line below |
| `[<space>` | Normal | Add blank line above |
| `<` / `>` | Visual | Indent and reselect |

### Misc

| Shortcut | Mode | Description |
|----------|------|-------------|
| `<leader>xL` | Normal | Execute current line as Lua |
| `<leader>xL` | Visual | Execute selection as Lua |
| `gw` | Normal/Visual | Search word under cursor |
| `n` / `N` | Normal | Next/Prev search (centered) |

## Configuration

### Installation

```bash
cd ~/dotfiles/nvim
chmod +x install_plugins.sh
./install_plugins.sh
```

Or manually:
```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Copy configuration
cp -r ~/dotfiles/nvim ~/.config/nvim

# Start Neovim (plugins install automatically)
nvim
```

### First Launch

1. Start Neovim: `nvim`
2. Wait for lazy.nvim to install plugins
3. Run `:checkhealth` to verify setup
4. Run `:Mason` to install LSP servers

### Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Editor settings
│   │   ├── keymaps.lua      # Custom keybindings
│   │   └── autocmds.lua     # Autocommands
│   ├── plugins/
│   │   ├── init.lua         # Plugin initialization
│   │   ├── editor.lua       # Editor enhancements
│   │   ├── lsp.lua          # LSP & completion
│   │   ├── ui.lua           # UI & themes
│   │   ├── navigation.lua   # File navigation
│   │   ├── ai.lua           # AI assistants
│   │   └── misc.lua         # Other plugins
│   └── utils/
│       └── helpers.lua      # Utility functions
```

### AI Setup

Set environment variables for AI features:

```bash
# Anthropic (Claude)
export ANTHROPIC_API_KEY='your-api-key'

# OpenAI
export OPENAI_API_KEY='your-api-key'
```

### Install LSP Servers

Open Mason UI:
```vim
:Mason
```

Or add to `lua/plugins/lsp.lua` in `ensure_installed`.

### Adding Plugins

Add to appropriate file in `lua/plugins/`:

```lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",
    opts = {
      -- options
    },
  },
}
```

## Troubleshooting

### Plugins Not Loading

```vim
:Lazy
" Press S to sync
:Lazy log  " Check for errors
```

### LSP Not Working

```vim
:LspInfo           " Check LSP status
:Mason             " Verify server installation
:checkhealth lsp   " Health check
```

### Treesitter Errors

```vim
:TSUpdate           " Update parsers
:checkhealth nvim-treesitter
```

### Icons Not Showing

Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal.

### Health Check

```vim
:checkhealth
```

## Plugin List

### Core
- lazy.nvim, plenary.nvim, nvim-treesitter

### LSP & Completion
- nvim-lspconfig, mason.nvim, blink.cmp, LuaSnip, conform.nvim, nvim-lint

### UI
- tokyonight.nvim, lualine.nvim, bufferline.nvim, which-key.nvim, noice.nvim

### Navigation
- telescope.nvim, oil.nvim, neo-tree.nvim, harpoon

### Editor
- Comment.nvim, nvim-surround, nvim-autopairs, flash.nvim, indent-blankline

### AI
- codecompanion.nvim, avante.nvim, gen.nvim

### Git
- gitsigns.nvim, vim-fugitive, lazygit.nvim

### Debug
- nvim-dap, nvim-dap-ui

### Misc
- trouble.nvim, todo-comments.nvim, toggleterm.nvim

## Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [Mason.nvim](https://github.com/williamboman/mason.nvim)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
