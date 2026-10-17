-- TypeScript / JavaScript (typescript-language-server)
local utilities = require("utilities.index")

return {
  cmd = function(dispatchers, config)
    local root = (config or {}).root_dir or vim.fn.getcwd()
    local bin = utilities.find_node_bin(root, "typescript-language-server") or "typescript-language-server"
    return vim.lsp.rpc.start({ bin, "--stdio" }, dispatchers, {
      cwd = (config or {}).cmd_cwd,
      env = (config or {}).cmd_env,
      detached = (config or {}).detached,
    })
  end,
  init_options = {
    hostInfo = "neovim",
    maxTsServerMemory = 4096,
    preferences = {
      includePackageJsonAutoImports = "on",
      preferTypeOnlyAutoImports = true,
    },
  },
}
