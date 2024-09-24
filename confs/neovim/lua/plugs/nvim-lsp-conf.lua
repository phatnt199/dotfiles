local cmp = require('cmp')
local lspConfig = require('lspconfig')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-2), { 'i', 'c' }),
    ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(2), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'path' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)
local flags = { debounce_text_changes = 150 }

local handlers = {
  ['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = false,
      underline = true,
      update_in_insert = false,
    }
  ),
}

local defaultProps = {
  capabilities = capabilities,
  flags = flags,
  handlers = handlers,
  settings = {},
}

local lsps = {
  ts_ls = defaultProps,
  sqlls = defaultProps,
  protols = defaultProps,
  lua_ls = defaultProps,
  dartls = defaultProps,
  rust_analyzer = defaultProps,
}

for lspName, confs in pairs(lsps) do
  if lspName == 'rust_analyzer' then
    confs['settings']['rust_analyzer'] = {
      checkOnSave = {
        overrideCommand = {
          'cargo',
          'clippy',
          '--workspace',
          '--message-format=json',
          '--all-targets',
          '--all-features'
        }
      }
    }
  elseif lspName == 'jdtls' then
    confs['settings']['java'] = {

    }
  elseif lspName == 'lua_ls' then
    confs['settings']['Lua'] = {
      diagnostics = {
        globals = { 'vim' },
      },
    }
  end

  lspConfig[lspName].setup(confs)
end
