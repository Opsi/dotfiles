return {
  {
    'mason-org/mason.nvim',
    dependencies = {
      'mason-org/mason-lspconfig.nvim',
    },
    config = function()
      local mason = require 'mason'
      local mason_lspconfig = require 'mason-lspconfig'

      mason.setup {
        ui = {
          icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
          },
        },
      }

      mason_lspconfig.setup {
        ensure_installed = {
          'bashls',
          'dockerls',
          'yamlls',
          'astro-language-server',
          'basedpyright',
          'biome',
          'emmet-language-server',
          'gdtoolkit',
          'gopls',
          'lua-language-server',
          'node-debug2-adapter',
          'oxlint',
          'pyproject-fmt',
          'ruff',
          'rust-analyzer',
          'stylua',
          'tailwindcss-language-server',
          'zls',
        },
      }
    end,
  },
}
