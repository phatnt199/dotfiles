-- oxlint (lint, type-aware through tsgolint).
-- A project that keeps its config in `.configs/oxlint.config.mts` gets that folder's parent as
-- root and the config passed explicitly. A project with a root config (`.oxlintrc.json`,
-- `oxlint.config.ts`) works as lspconfig ships it. The server starts only where an oxlint
-- binary exists, so a project without oxlint stays quiet.
local utilities = require("utilities.index")

local CONFIG_FILE = "oxlint.config.mts"
local CONFIG_PATH = ".configs/" .. CONFIG_FILE
local ROOT_CONFIGS = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }

-- Settings that only apply when the project keeps its config in `.configs/`.
local function dot_configs_settings(root)
  if not (root and vim.uv.fs_stat(vim.fs.joinpath(root, CONFIG_PATH))) then
    return {}
  end
  return {
    configPath = CONFIG_PATH,
    typeAware = utilities.find_node_bin(root, "tsgolint") and true or nil,
  }
end

return {
  cmd = function(dispatchers, config)
    config = config or {}
    local root = config.root_dir or vim.fn.getcwd()
    local bin = utilities.find_node_bin(root, "oxlint") or "oxlint"
    return vim.lsp.rpc.start({ bin, "--lsp" }, dispatchers, {
      cwd = root,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = utilities.dot_configs_root(fname, CONFIG_FILE) or vim.fs.root(fname, ROOT_CONFIGS)

    if root and utilities.find_node_bin(root, "oxlint") then
      on_dir(root)
    end
  end,

  before_init = function(init_params, config)
    config.settings = vim.tbl_deep_extend("force", config.settings or {}, dot_configs_settings(config.root_dir))

    local init_options = config.init_options or {}
    init_options.settings = vim.tbl_deep_extend("force", init_options.settings or {}, config.settings)
    init_params.initializationOptions = init_options
  end,
}
