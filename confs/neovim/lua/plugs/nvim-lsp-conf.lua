local mod = {
	"neovim/nvim-lspconfig",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",

		"hrsh7th/cmp-vsnip",
		"hrsh7th/vim-vsnip",
	},
	config = function()
		------------------------------------------------------------------------------------------------------------
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			mapping = {
				["<C-k>"] = cmp.mapping(cmp.mapping.scroll_docs(-2), { "i", "c" }),
				["<C-j>"] = cmp.mapping(cmp.mapping.scroll_docs(2), { "i", "c" }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
				{ name = "path" },
				{ name = "vsnip" },
			}, {
				{ name = "buffer" },
			}),
		})

		------------------------------------------------------------------------------------------------------------
		local lspConfig = require("lspconfig")
		local cmpLsp = require("cmp_nvim_lsp")
		local utilities = require("utilities.index")

		local workspaceEnvFolder = os.getenv("WORKSPACE_ENV")
		if workspaceEnvFolder == nil then
			workspaceEnvFolder = os.getenv("HOME") .. "/Workspace/env"
		end

		local defaultProps = {
			capabilities = cmpLsp.default_capabilities(vim.lsp.protocol.make_client_capabilities()),
			flags = { debounce_text_changes = 250 },
			handlers = {
				["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
					virtual_text = false,
					underline = true,
					update_in_insert = false,
				}),
			},
		}

		vim.diagnostic.config({
			float = { focusable = false },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅙",
					[vim.diagnostic.severity.WARN] = "◼",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "󰌶",
				},
				texthl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
				},
			},
		})

		local lsps = {
			-- Typescript/Javascript
			ts_ls = defaultProps,

			-- SQL
			sqlls = defaultProps,

			-- Proto
			protols = defaultProps,

			-- Dart
			dartls = defaultProps,

			-- Python
			pyright = defaultProps,

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
					workspaceEnvFolder
						.. "/jdtls/latest/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar",
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
							kubernetes = "*.yml,*.yaml",
						},
					},
				},
			}, defaultProps),
		}

		for name, confs in pairs(lsps) do
			lspConfig[name].setup(confs)
		end
	end,
}

return mod
