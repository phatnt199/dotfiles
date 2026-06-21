-- Completion engine. Replaces the previous nvim-cmp + hrsh7th + vsnip stack.
-- version = "1.*" pulls prebuilt fuzzy-matcher binaries (no Rust toolchain needed).
local mod = {
  "saghen/blink.cmp",
  version = "1.*",
  event = { "InsertEnter", "CmdlineEnter" },
  opts = {
    -- "none" so the bindings below mirror the old nvim-cmp habits exactly.
    keymap = {
      preset = "none",
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<C-j>"] = { "scroll_documentation_down", "fallback" },
      ["<C-k>"] = { "scroll_documentation_up", "fallback" },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        -- blink's documentation renderer has no inner-padding option, so wrap the
        -- default rendering and pad the *input* (one space each side per line +
        -- a blank top/bottom line). Padding the input rather than post-processing
        -- the buffer keeps treesitter highlight positions correct.
        window = {
          -- Soft visible frame (BlinkCmpDocBorder = dim line on the popup bg).
          border = "rounded",
          max_width = 80,
          max_height = 40,
          -- Shrink to the content instead of blink's default 50x10 floor, so the
          -- doc is a compact floating pane (no big empty background) sitting next
          -- to the menu rather than one large connected block.
          desired_min_width = 1,
          desired_min_height = 1,
        },
      },
      menu = {
        border = "rounded",
        scrollbar = true,
      },
    },
    signature = {
      enabled = true,
      window = { border = "padded" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    -- Native (vim.snippet) snippet expansion is the default in blink.cmp,
    -- which matches the engine the rest of the config already expects.
    fuzzy = {
      implementation = "prefer_rust_with_warning",
    },
  },
  opts_extend = { "sources.default" },
}

return mod
