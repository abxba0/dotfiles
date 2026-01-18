-- =============================================================================
-- Utility Functions
-- =============================================================================
-- Helper functions used throughout the configuration.

local M = {}

-- -----------------------------------------------------------------------------
-- General Utilities
-- -----------------------------------------------------------------------------

--- Check if a plugin is available
---@param name string Plugin name
---@return boolean
function M.has(name)
  return require("lazy.core.config").spec.plugins[name] ~= nil
end

--- Get plugin options from lazy.nvim spec
---@param name string Plugin name
---@return table
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

--- Execute callback when a plugin loads
---@param name string Plugin name
---@param fn fun(name: string)
function M.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

-- -----------------------------------------------------------------------------
-- Buffer Utilities
-- -----------------------------------------------------------------------------

--- Check if buffer is valid
---@param buf number|nil Buffer number
---@return boolean
function M.is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
end

--- Get list of valid buffers
---@return number[]
function M.get_bufs()
  return vim.tbl_filter(M.is_valid_buf, vim.api.nvim_list_bufs())
end

--- Delete buffer with confirmation if modified
---@param buf number|nil Buffer number (defaults to current)
function M.bufremove(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    local choice = vim.fn.confirm(
      ("Save changes to %q?"):format(vim.fn.bufname()),
      "&Yes\n&No\n&Cancel"
    )
    if choice == 0 or choice == 3 then
      return
    end
    if choice == 1 then
      vim.cmd.write()
    end
  end
  -- Delete the buffer
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end
      vim.cmd("enew")
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

-- -----------------------------------------------------------------------------
-- LSP Utilities
-- -----------------------------------------------------------------------------

--- Get active LSP clients for buffer
---@param bufnr number|nil Buffer number
---@return table[]
function M.get_clients(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return vim.lsp.get_clients({ bufnr = bufnr })
end

--- Check if any LSP client supports a method
---@param method string LSP method name
---@param bufnr number|nil Buffer number
---@return boolean
function M.has_capability(method, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  for _, client in ipairs(M.get_clients(bufnr)) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

-- -----------------------------------------------------------------------------
-- Telescope Utilities
-- -----------------------------------------------------------------------------

--- Find files with telescope, falling back to git_files if in a git repo
function M.find_files()
  local builtin = require("telescope.builtin")
  local ok = pcall(builtin.git_files, { show_untracked = true })
  if not ok then
    builtin.find_files()
  end
end

--- Search in config files
function M.config_files()
  local builtin = require("telescope.builtin")
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end

-- -----------------------------------------------------------------------------
-- Formatting Utilities
-- -----------------------------------------------------------------------------

--- Format buffer using conform.nvim or LSP
---@param opts table|nil Options
function M.format(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  -- Try conform.nvim first
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({
      bufnr = bufnr,
      async = opts.async,
      lsp_fallback = true,
    })
    return
  end

  -- Fallback to LSP formatting
  vim.lsp.buf.format({
    bufnr = bufnr,
    async = opts.async,
  })
end

-- -----------------------------------------------------------------------------
-- Keymap Utilities
-- -----------------------------------------------------------------------------

--- Set a keymap with default options
---@param mode string|table Mode(s)
---@param lhs string Left-hand side
---@param rhs string|function Right-hand side
---@param opts table|nil Options
function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

--- Create a toggle keymap
---@param lhs string Left-hand side
---@param option string Option name
---@param desc string Description
function M.toggle_map(lhs, option, desc)
  M.map("n", lhs, function()
    vim.o[option] = not vim.o[option]
    vim.notify(desc .. " " .. (vim.o[option] and "enabled" or "disabled"))
  end, { desc = "Toggle " .. desc })
end

-- -----------------------------------------------------------------------------
-- UI Utilities
-- -----------------------------------------------------------------------------

--- Get the foreground color of a highlight group
---@param name string Highlight group name
---@return string|nil
function M.fg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return hl.fg and string.format("#%06x", hl.fg)
end

--- Get the background color of a highlight group
---@param name string Highlight group name
---@return string|nil
function M.bg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  return hl.bg and string.format("#%06x", hl.bg)
end

-- -----------------------------------------------------------------------------
-- Table Utilities
-- -----------------------------------------------------------------------------

--- Deep merge tables
---@param t1 table First table
---@param t2 table Second table
---@return table Merged table
function M.merge(t1, t2)
  return vim.tbl_deep_extend("force", t1 or {}, t2 or {})
end

--- Check if table is empty
---@param t table
---@return boolean
function M.is_empty(t)
  return next(t) == nil
end

-- -----------------------------------------------------------------------------
-- Path Utilities
-- -----------------------------------------------------------------------------

--- Get the root directory for the current buffer
---@return string
function M.get_root()
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.uv.fs_realpath(path) or nil

  local roots = {}
  if path then
    for _, client in pairs(M.get_clients()) do
      local workspace = client.config.workspace_folders
      local paths = workspace
        and vim.tbl_map(function(ws)
          return vim.uri_to_fname(ws.uri)
        end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.uv.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end

  table.sort(roots, function(a, b)
    return #a > #b
  end)

  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.uv.cwd()
    root = vim.fs.find({ ".git", "lua" }, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.uv.cwd()
  end

  return root
end

-- -----------------------------------------------------------------------------
-- Debounce
-- -----------------------------------------------------------------------------

--- Create a debounced function
---@param fn function Function to debounce
---@param ms number Milliseconds to wait
---@return function
function M.debounce(fn, ms)
  local timer = vim.uv.new_timer()
  return function(...)
    local args = { ... }
    timer:stop()
    timer:start(
      ms,
      0,
      vim.schedule_wrap(function()
        fn(unpack(args))
      end)
    )
  end
end

return M
