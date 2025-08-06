local lspConfig = require("lspconfig")
local cmpLsp = require("cmp_nvim_lsp")
local utilities = require("utilities.index")

local workspaceEnvFolder = os.getenv("WORKSPACE_ENV")
if workspaceEnvFolder == nil then
	workspaceEnvFolder = os.getenv("HOME") .. "/Workspace/env"
end

local defaultProps = {
	capabilities = cmpLsp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	flags = {
		debounce_text_changes = 150,
	},
	handlers = {
		["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			virtual_text = false,
			underline = true,
			update_in_insert = false,
		}),
	},
}

local lsps = {
	-- Typescript/Javascript
	ts_ls = defaultProps,

	-- SQL
	sqlls = defaultProps,

	-- Proto
	protols = defaultProps,

	-- Dart
	dartls = defaultProps,

	-- Bash/Shell
	bashls = defaultProps,

	-- Lua
	lua_ls = utilities.merge_tables({
		settings = {
			["Lua"] = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	}, defaultProps),

	-- Rust
	rust_analyzer = utilities.merge_tables({
		settings = {
			["rust_analyzer"] = {
				checkOnSave = {
					overrideCommand = {
						"cargo",
						"clippy",
						"--workspace",
						"--message-format=json",
						"--all-targets",
						"--all-features",
					},
				},
			},
		},
	}, defaultProps),

	-- Java
	jdtls = utilities.merge_tables({
		cmd = {
			"java",
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xms1g",
			"-jar",
			workspaceEnvFolder .. "/jdtls/latest/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
			"-configuration",
			workspaceEnvFolder .. "/jdtls/latest/config_linux",
			"-data",
			workspaceEnvFolder .. "/jdtls/latest/jdtls/workspace",
		},
		root_dir = vim.fs.dirname(vim.fs.find({
			"build.xml",
			"pom.xml",
			".gradlew",
			".gitignore",
			"mvnw",
			"build.grade",
			"build.grade.kts",
			"settings.grade",
			"settings.grade.kts",
		}, { upward = true })[1]),
		settings = {
			["java"] = {},
		},
	}, defaultProps),

	-- Lua
	yamlls = utilities.merge_tables({
		settings = {
			yaml = {
				schemas = {
					kubernetes = "*.yml,*.yaml", -- or a more specific pattern like "*.k8s.yaml"
				},
				-- Optional: configure schemaStore if you want to use a local or specific schema
				-- schemaStore = {
				--     enable = true,
				--     url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.20.5-standalone-strict/all.json",
				-- },
			},
		},
	}, defaultProps),
}

for name, confs in pairs(lsps) do
	lspConfig[name].setup(confs)
end
