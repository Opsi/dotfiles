return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = 'make install_jsregexp',
      },
      'fang2hou/blink-copilot',
      'folke/lazydev.nvim',
      'rafamadriz/friendly-snippets',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        menu = { border = 'single' },
        documentation = { window = { border = 'single' }, auto_show = true, auto_show_delay_ms = 500 },
      },

      sources = {
        default = {
          'lsp',
          'snippets',
          'copilot',
          'path',
          'buffer',
        },
        providers = {
          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
          copilot = {
            name = 'Copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          },
        },
        per_filetype = {
          codecompanion = { 'codecompanion' },
          lua = { inherit_defaults = true, 'lazydev' },
        },
      },
      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },
      -- Shows a signature help window while you type arguments for a function
      signature = { window = { border = 'single' }, enabled = true },
    },
  },
}
