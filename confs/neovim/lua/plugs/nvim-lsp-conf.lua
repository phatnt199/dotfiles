local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-2), { 'i', 'c' }),
    ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(2), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'cmdline' }
  }, {
    { name = 'buffer' }
  })
})

-----------------------------------------------------------------------------------
local lspConfig = require('lspconfig')
local cmpLsp = require('cmp_nvim_lsp')
local utilities = require('utilities.index');

local defaultProps = {
  capabilities = cmpLsp.default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  flags = {
    debounce_text_changes = 150,
  },
  handlers = {
    ['textDocument/publishDiagnostics'] = vim.lsp.with(
      vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = true,
        update_in_insert = false,
      }
    ),
  },
}

local workspaceEnvFolder = os.getenv('WORKSPACE_ENV');
if workspaceEnvFolder == nil then
  workspaceEnvFolder = os.getenv('HOME') .. '/Workspace/env'
end

local lsps = {
  ts_ls = defaultProps,
  sqlls = defaultProps,
  protols = defaultProps,
  dartls = defaultProps,
  bashls = defaultProps,
  lua_ls = utilities.merge_tables({
    settings = {
      ['Lua'] = {
        diagnostics = {
          globals = { 'vim' },
        },
      },
    },
  }, defaultProps),
  rust_analyzer = utilities.merge_tables({
    settings = {
      ['rust_analyzer'] = {
        checkOnSave = {
          overrideCommand = {
            'cargo',
            'clippy',
            '--workspace',
            '--message-format=json',
            '--all-targets',
            '--all-features'
          },
        },
      },
    },
  }, defaultProps),
  jdtls = utilities.merge_tables({
    cmd = {
      'java',
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xms1g',
      '-jar', workspaceEnvFolder .. '/jdtls/latest/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar',
      '-configuration', workspaceEnvFolder .. '/jdtls/latest/config_linux',
      '-data', workspaceEnvFolder .. '/jdtls/latest/jdtls/workspace'
    },
    root_dir = vim.fs.dirname(
      vim.fs.find({
        'build.xml',
        'pom.xml',
        '.gradlew',
        '.gitignore',
        'mvnw',
        'build.grade',
        'build.grade.kts',
        'settings.grade',
        'settings.grade.kts',
      }, { upward = true })[1]
    ),
    settings = {
      ['java'] = {}
    }
  }, defaultProps),
}

for name, confs in pairs(lsps) do
  lspConfig[name].setup(confs)
end
