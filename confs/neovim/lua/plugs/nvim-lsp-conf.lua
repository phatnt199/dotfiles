local cmp = require('cmp')
local lspConfig = require('lspconfig')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
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
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
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
  ["textDocument/publishDiagnostics"] = vim.lsp.with(
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
  settings = {
    ['rust-analyzer'] = {
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
    },
    ['diagnosticls'] = {
    },
  },
}

local diagnosticProps = defaultProps
diagnosticProps['init_options'] = {
  filetypes = {
    javascript = "eslint",
    typescript = "eslint",
    javascriptreact = "eslint",
    typescriptreact = "eslint"
  },
  linters = {
    eslint = {
      sourceName = "eslint",
      command = "./node_modules/.bin/eslint",
      rootPatterns = {
        ".eslintrc.js",
        ".eslintrc.cjs",
        ".eslintrc",
        ".eslintrc.json",
        "package.json"
      },
      debounce = 100,
      args = {
        "--cache",
        "--stdin",
        "--stdin-filename",
        "%filepath",
        "--format",
        "json"
      },
      parseJson = {
        errorsRoot = "[0].messages",
        line = "line",
        column = "column",
        endLine = "endLine",
        endColumn = "endColumn",
        message = "${message} [${ruleId}]",
        security = "severity"
      },
      securities = {
        [2] = "error",
        [1] = "warning"
      }
    }
  }
}

local lsps = {}
lsps['dartls'] = defaultProps
lsps['tsserver'] = defaultProps
lsps['rust_analyzer'] = defaultProps
lsps['sqlls'] = defaultProps
lsps['diagnosticls'] = diagnosticProps

for lsp,confs in pairs(lsps) do
  -- print(lsp, confs)
  lspConfig[lsp].setup(confs)
end
