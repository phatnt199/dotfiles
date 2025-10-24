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
		-- local lspConfig = require("lspconfig")
		local cmpLsp = require("cmp_nvim_lsp")
		local utilities = require("utilities.index")

		local workspaceEnvFolder = os.getenv("WORKSPACE_ENV")
		if workspaceEnvFolder == nil then
			workspaceEnvFolder = os.getenv("HOME") .. "/Workspace/env"
		end

		-- Get Java home and version dynamically
		local javaHome = os.getenv("JAVA_HOME")
		local javaVersion = nil
		if javaHome then
			local handle = io.popen("java -version 2>&1")
			if handle then
				local result = handle:read("*a")
				handle:close()
				javaVersion = result:match('version "(%d+)')
			end
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
			pyright = utilities.merge_tables({
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
							autoImportCompletions = true,
							typeCheckingMode = "standard",
						},
					},
				},
			}, defaultProps),

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
					"-Xmx2g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					vim.fn.glob(workspaceEnvFolder .. "/jdtls/latest/plugins/org.eclipse.equinox.launcher_*.jar"),
					"-configuration",
					workspaceEnvFolder .. "/jdtls/latest/config_linux",
					"-data",
					workspaceEnvFolder .. "/jdtls/workspaces/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
				},
				root_dir = vim.fs.dirname(vim.fs.find({
					"build.xml",
					"pom.xml",
					".gradlew",
					".gitignore",
					"mvnw",
					"build.gradle",
					"build.gradle.kts",
					"settings.gradle",
					"settings.gradle.kts",
				}, { upward = true })[1]),
				settings = {
					java = {
						eclipse = {
							downloadSources = true,
						},
						maven = {
							downloadSources = true,
						},
						imports = {
							gradle = {
								wrapper = {
									checksums = {
										{
											sha256 = "e68185c8c0f67873dcd98916621870266a71584dfb0a2861d87d7077ebc39837",
											allowed = true,
										},
									},
								},
							},
						},
						referencesCodeLens = {
							enabled = true,
						},
						references = {
							includeDecompiledSources = true,
						},
						format = {
							enabled = true,
							settings = {
								url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
								profile = "GoogleStyle",
							},
						},
						signatureHelp = {
							enabled = true,
						},
						contentProvider = {
							preferred = "fernflower",
						},
						completion = {
							favoriteStaticMembers = {
								"org.hamcrest.MatcherAssert.assertThat",
								"org.hamcrest.Matchers.*",
								"org.hamcrest.CoreMatchers.*",
								"org.junit.jupiter.api.Assertions.*",
								"java.util.Objects.requireNonNull",
								"java.util.Objects.requireNonNullElse",
								"org.mockito.Mockito.*",
							},
							filteredTypes = {
								"com.sun.*",
								"io.micrometer.shaded.*",
								"java.awt.*",
								"jdk.*",
								"sun.*",
							},
							importOrder = {
								"java",
								"javax",
								"com",
								"org",
							},
						},
						sources = {
							organizeImports = {
								starThreshold = 9999,
								staticStarThreshold = 9999,
							},
						},
						codeGeneration = {
							toString = {
								template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
							},
							hashCodeEquals = {
								useJava7Objects = true,
							},
							useBlocks = true,
						},
						configuration = {
							runtimes = javaHome and javaVersion and {
								{
									name = "JavaSE-" .. javaVersion,
									path = javaHome,
								},
							} or {},
						},
					},
				},
				init_options = {
					bundles = {},
					extendedClientCapabilities = {
						progressReportProvider = true,
						classFileContentsSupport = true,
						generateToStringPromptSupport = true,
						hashCodeEqualsPromptSupport = true,
						advancedExtractRefactoringSupport = true,
						advancedOrganizeImportsSupport = true,
						generateConstructorsPromptSupport = true,
						generateDelegateMethodsPromptSupport = true,
						moveRefactoringSupport = true,
						overrideMethodsPromptSupport = true,
						inferSelectionSupport = { "extractMethod", "extractVariable", "extractConstant" },
					},
				},
				on_attach = function(_, bufnr)
					-- Java-specific keybindings
					local opts = { buffer = bufnr, noremap = true, silent = true }
					vim.keymap.set("n", "<leader>jo", "<Cmd>lua require('jdtls').organize_imports()<CR>", opts)
					vim.keymap.set("n", "<leader>jv", "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
					vim.keymap.set("v", "<leader>jv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
					vim.keymap.set("n", "<leader>jc", "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
					vim.keymap.set("v", "<leader>jc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
					vim.keymap.set("v", "<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
					vim.keymap.set("n", "<leader>ju", "<Cmd>lua require('jdtls').update_project_config()<CR>", opts)
					vim.keymap.set("n", "<leader>jt", "<Cmd>lua require('jdtls').test_class()<CR>", opts)
					vim.keymap.set("n", "<leader>jn", "<Cmd>lua require('jdtls').test_nearest_method()<CR>", opts)
				end,
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
			-- lspConfig[name].setup(confs)
			vim.lsp.enable(name)
			vim.lsp.config(name, confs)
		end
	end,
}

return mod
