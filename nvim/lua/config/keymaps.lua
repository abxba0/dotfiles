-- =============================================================================
-- Keymaps
-- =============================================================================

local map = vim.keymap.set

-- -----------------------------------------------------------------------------
-- General
-- -----------------------------------------------------------------------------
-- Better escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- New file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- -----------------------------------------------------------------------------
-- Better movement
-- -----------------------------------------------------------------------------
-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move lines up/down
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Better up/down (handle wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- -----------------------------------------------------------------------------
-- Buffers
-- -----------------------------------------------------------------------------
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete buffer (force)" })

-- -----------------------------------------------------------------------------
-- Windows
-- -----------------------------------------------------------------------------
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- Resize windows with <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- -----------------------------------------------------------------------------
-- Tabs
-- -----------------------------------------------------------------------------
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-- -----------------------------------------------------------------------------
-- Search
-- -----------------------------------------------------------------------------
-- Clear search highlighting with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Search word under cursor
map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Center search results
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "N", "Nzzzv", { desc = "Prev search result" })

-- -----------------------------------------------------------------------------
-- Better indenting
-- -----------------------------------------------------------------------------
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- -----------------------------------------------------------------------------
-- Comments (fallback if Comment.nvim not loaded)
-- -----------------------------------------------------------------------------
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })

-- -----------------------------------------------------------------------------
-- Quickfix and Location list
-- -----------------------------------------------------------------------------
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location list" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix list" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
map("n", "[l", vim.cmd.lprev, { desc = "Previous location" })
map("n", "]l", vim.cmd.lnext, { desc = "Next location" })

-- -----------------------------------------------------------------------------
-- Diagnostics
-- -----------------------------------------------------------------------------
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev warning" })

-- -----------------------------------------------------------------------------
-- Terminal
-- -----------------------------------------------------------------------------
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter normal mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- -----------------------------------------------------------------------------
-- Lazy
-- -----------------------------------------------------------------------------
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- -----------------------------------------------------------------------------
-- Editing
-- -----------------------------------------------------------------------------
-- Better paste (don't overwrite register with deleted text)
map("x", "p", [["_dP]], { desc = "Paste without overwriting register" })

-- Delete without yanking
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without yank" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- Add blank lines
map("n", "]<space>", "o<esc>k", { desc = "Add blank line below" })
map("n", "[<space>", "O<esc>j", { desc = "Add blank line above" })

-- Undo breakpoints in insert mode
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- -----------------------------------------------------------------------------
-- Toggle options
-- -----------------------------------------------------------------------------
map("n", "<leader>uw", function()
  vim.o.wrap = not vim.o.wrap
  vim.notify("Wrap " .. (vim.o.wrap and "enabled" or "disabled"))
end, { desc = "Toggle word wrap" })

map("n", "<leader>un", function()
  vim.o.number = not vim.o.number
  vim.notify("Line numbers " .. (vim.o.number and "enabled" or "disabled"))
end, { desc = "Toggle line numbers" })

map("n", "<leader>ur", function()
  vim.o.relativenumber = not vim.o.relativenumber
  vim.notify("Relative numbers " .. (vim.o.relativenumber and "enabled" or "disabled"))
end, { desc = "Toggle relative numbers" })

map("n", "<leader>us", function()
  vim.o.spell = not vim.o.spell
  vim.notify("Spell check " .. (vim.o.spell and "enabled" or "disabled"))
end, { desc = "Toggle spell check" })

map("n", "<leader>uc", function()
  vim.o.cursorline = not vim.o.cursorline
  vim.notify("Cursorline " .. (vim.o.cursorline and "enabled" or "disabled"))
end, { desc = "Toggle cursorline" })

map("n", "<leader>ul", function()
  vim.o.list = not vim.o.list
  vim.notify("List chars " .. (vim.o.list and "enabled" or "disabled"))
end, { desc = "Toggle list chars" })

-- -----------------------------------------------------------------------------
-- Misc
-- -----------------------------------------------------------------------------
-- Execute current line as Lua
map("n", "<leader>xL", "<cmd>.lua<cr>", { desc = "Execute current line as Lua" })

-- Execute selection as Lua
map("v", "<leader>xL", ":lua<cr>", { desc = "Execute selection as Lua" })
