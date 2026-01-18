-- =============================================================================
-- Autocommands
-- =============================================================================

local function augroup(name)
  return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- -----------------------------------------------------------------------------
-- Highlight on yank
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- -----------------------------------------------------------------------------
-- Resize splits on window resize
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- -----------------------------------------------------------------------------
-- Go to last location when opening a buffer
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc_set then
      return
    end
    vim.b[buf].last_loc_set = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- -----------------------------------------------------------------------------
-- Close some filetypes with <q>
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- -----------------------------------------------------------------------------
-- Wrap and spell check in text filetypes
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- -----------------------------------------------------------------------------
-- Auto create dir when saving a file
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- -----------------------------------------------------------------------------
-- Check if we need to reload the file when it changed
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- -----------------------------------------------------------------------------
-- Fix conceallevel for json files
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- -----------------------------------------------------------------------------
-- Set filetype for specific files
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("filetype_detect"),
  pattern = { "*.conf", "*.config" },
  callback = function()
    if vim.bo.filetype == "" then
      vim.bo.filetype = "conf"
    end
  end,
})

-- -----------------------------------------------------------------------------
-- Disable line numbers in terminal mode
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("term_no_numbers"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})

-- -----------------------------------------------------------------------------
-- Auto-save when leaving insert mode or text changed
-- -----------------------------------------------------------------------------
-- Uncomment if you want auto-save functionality
-- vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
--   group = augroup("auto_save"),
--   pattern = "*",
--   callback = function()
--     if vim.bo.modified and vim.bo.buftype == "" then
--       vim.cmd("silent! write")
--     end
--   end,
-- })

-- -----------------------------------------------------------------------------
-- Disable continuation of comments
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("disable_comment_continuation"),
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- -----------------------------------------------------------------------------
-- Large file handling
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufReadPre", {
  group = augroup("large_file"),
  callback = function(event)
    local file = event.match
    local size = vim.fn.getfsize(file)
    -- 1MB threshold
    if size > 1024 * 1024 then
      vim.opt_local.swapfile = false
      vim.opt_local.bufhidden = "unload"
      vim.opt_local.undolevels = -1
      vim.opt_local.syntax = "off"
      vim.cmd("syntax clear")
      vim.b.large_file = true
    end
  end,
})
