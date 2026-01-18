-- =============================================================================
-- Editor Options
-- =============================================================================

local opt = vim.opt

-- -----------------------------------------------------------------------------
-- General
-- -----------------------------------------------------------------------------
opt.backup = false                          -- Don't create backup files
opt.writebackup = false                     -- Don't create backup before overwriting
opt.swapfile = false                        -- Don't use swapfile
opt.undofile = true                         -- Enable persistent undo
opt.undolevels = 10000                      -- Maximum undo levels
opt.autowrite = true                        -- Auto write buffer on certain events
opt.clipboard = "unnamedplus"               -- Use system clipboard
opt.confirm = true                          -- Confirm to save changes before exiting
opt.mouse = "a"                             -- Enable mouse support
opt.timeoutlen = 300                        -- Time to wait for mapped sequence (ms)
opt.updatetime = 200                        -- Faster completion and swap file write
opt.virtualedit = "block"                   -- Allow cursor beyond end of line in visual block

-- -----------------------------------------------------------------------------
-- UI
-- -----------------------------------------------------------------------------
opt.number = true                           -- Show line numbers
opt.relativenumber = true                   -- Show relative line numbers
opt.cursorline = true                       -- Highlight current line
opt.signcolumn = "yes"                      -- Always show sign column
opt.termguicolors = true                    -- Enable 24-bit RGB colors
opt.showmode = false                        -- Don't show mode (shown in statusline)
opt.showcmd = false                         -- Don't show command in last line
opt.ruler = false                           -- Don't show cursor position (shown in statusline)
opt.laststatus = 3                          -- Global statusline
opt.cmdheight = 1                           -- Command line height
opt.pumheight = 10                          -- Max items in popup menu
opt.pumblend = 10                           -- Popup menu transparency
opt.winblend = 10                           -- Floating window transparency
opt.splitbelow = true                       -- Horizontal splits go below
opt.splitright = true                       -- Vertical splits go right
opt.splitkeep = "screen"                    -- Keep text on same screen line when splitting
opt.scrolloff = 8                           -- Minimum lines above/below cursor
opt.sidescrolloff = 8                       -- Minimum columns left/right of cursor
opt.list = true                             -- Show invisible characters
opt.listchars = {                           -- Define invisible characters
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "❯",
  precedes = "❮",
}
opt.fillchars = {                           -- Characters for UI elements
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.conceallevel = 2                        -- Hide markup for bold/italic (useful for markdown)

-- -----------------------------------------------------------------------------
-- Search
-- -----------------------------------------------------------------------------
opt.ignorecase = true                       -- Ignore case in search
opt.smartcase = true                        -- Override ignorecase if pattern has uppercase
opt.hlsearch = true                         -- Highlight search results
opt.incsearch = true                        -- Show matches while typing
opt.inccommand = "nosplit"                  -- Preview substitutions incrementally

-- -----------------------------------------------------------------------------
-- Indentation
-- -----------------------------------------------------------------------------
opt.expandtab = true                        -- Use spaces instead of tabs
opt.shiftwidth = 2                          -- Spaces for each indent level
opt.tabstop = 2                             -- Spaces for a tab character
opt.softtabstop = 2                         -- Spaces for <Tab> in editing operations
opt.shiftround = true                       -- Round indent to multiple of shiftwidth
opt.smartindent = true                      -- Smart autoindenting for new lines
opt.autoindent = true                       -- Copy indent from current line

-- -----------------------------------------------------------------------------
-- Text
-- -----------------------------------------------------------------------------
opt.wrap = false                            -- Don't wrap lines
opt.linebreak = true                        -- Wrap at word boundaries (if wrap enabled)
opt.breakindent = true                      -- Preserve indentation in wrapped lines
opt.formatoptions = "jcroqlnt"              -- Text formatting options
opt.textwidth = 0                           -- Don't auto-wrap text

-- -----------------------------------------------------------------------------
-- Folding
-- -----------------------------------------------------------------------------
opt.foldcolumn = "1"                        -- Show fold column
opt.foldlevel = 99                          -- Start with all folds open
opt.foldlevelstart = 99                     -- Default fold level when opening file
opt.foldenable = true                       -- Enable folding
opt.foldmethod = "expr"                     -- Use expression for folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"  -- Treesitter-based folding

-- -----------------------------------------------------------------------------
-- Completion
-- -----------------------------------------------------------------------------
opt.completeopt = "menu,menuone,noselect"   -- Completion options
opt.wildmode = "longest:full,full"          -- Command-line completion mode
opt.wildignorecase = true                   -- Case insensitive completion

-- -----------------------------------------------------------------------------
-- Grep
-- -----------------------------------------------------------------------------
opt.grepformat = "%f:%l:%c:%m"              -- Grep output format
opt.grepprg = "rg --vimgrep"                -- Use ripgrep for grep

-- -----------------------------------------------------------------------------
-- Session
-- -----------------------------------------------------------------------------
opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

-- -----------------------------------------------------------------------------
-- Spelling
-- -----------------------------------------------------------------------------
opt.spelllang = { "en" }                    -- Spell check language
opt.spelloptions:append("camel")            -- Treat CamelCase as separate words

-- -----------------------------------------------------------------------------
-- Diff
-- -----------------------------------------------------------------------------
opt.diffopt:append({
  "linematch:60",
  "algorithm:histogram",
  "indent-heuristic",
})

-- -----------------------------------------------------------------------------
-- Shell
-- -----------------------------------------------------------------------------
if vim.fn.executable("fish") == 1 then
  opt.shell = "fish"
elseif vim.fn.executable("zsh") == 1 then
  opt.shell = "zsh"
end

-- -----------------------------------------------------------------------------
-- Providers
-- -----------------------------------------------------------------------------
-- Disable providers we don't need
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Set Python3 path if available
if vim.fn.executable("python3") == 1 then
  vim.g.python3_host_prog = vim.fn.exepath("python3")
end

-- Set Node.js path if available
if vim.fn.executable("node") == 1 then
  vim.g.node_host_prog = vim.fn.exepath("neovim-node-host")
end

-- -----------------------------------------------------------------------------
-- Netrw (disable in favor of other file explorers)
-- -----------------------------------------------------------------------------
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
