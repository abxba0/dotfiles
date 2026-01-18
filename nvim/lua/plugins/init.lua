-- =============================================================================
-- Plugin Initialization
-- =============================================================================
-- This file imports all plugin specs from the plugins directory.
-- lazy.nvim will automatically load all returned tables.

return {
  -- Import plugin specs from separate files
  { import = "plugins.editor" },
  { import = "plugins.lsp" },
  { import = "plugins.ui" },
  { import = "plugins.navigation" },
  { import = "plugins.ai" },
  { import = "plugins.misc" },
}
