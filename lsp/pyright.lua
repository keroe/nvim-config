local Lsp = require "utils.lsp"
-- uv tool install pyright@latest
return {
  cmd = { "pyright-langserver", "--stdio" },
  on_attach = Lsp.on_attach,
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
  },
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}
