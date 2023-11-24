local mod = require('Comment')
local xCs = require('ts_context_commentstring.integrations.comment_nvim')
require('ts_context_commentstring').setup({
  enable_autocmd = false,
})

mod.setup({
  pre_hook = xCs.create_pre_hook(),
})
