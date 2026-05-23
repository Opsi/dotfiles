return {
  {
    -- this is used to automate the configuration of language
    -- servers (installed via mason)
    'williamboman/mason-lspconfig.nvim',
    opts = {
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
    },
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {
          ui = {
            icons = {
              package_installed = '✔',
              package_pending = '➜',
              package_uninstalled = '🗙',
            },
          },
        },
      },
      'neovim/nvim-lspconfig',
    },
  },
  {
    -- this one installs the non-LSP things (via mason)
    -- like formatters, DAPs and linters
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        'prettier', -- prettier formatter
        'stylua', -- lua formatter
        'isort', -- python formatter
        'black', -- python formatter
        'pylint',
        'eslint_d',
      },
    },
    dependencies = {
      'williamboman/mason.nvim',
    },
  },
}
